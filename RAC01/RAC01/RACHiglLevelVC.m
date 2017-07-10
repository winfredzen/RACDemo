//
//  RACHiglLevelVC.m
//  RAC01
//
//  Created by wangzhen on 2017/7/9.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "RACHiglLevelVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RACHiglLevelVC ()<CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *placeLabel;

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation RACHiglLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //pull-driven push-driven
    
    __block int a = 10;
    
    RACSignal *s = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"1");
        a += 5;
        [subscriber sendNext:@(a)];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] replayLast];

    
    //side effect副作用
    //在每次订阅信号量的时候，会导致信号量里的代码重复的执行，这些重复执行的过程中可能会产生我们所不需要的东西
    [s subscribeNext:^(id  _Nullable x) {
        NSLog(@"2 [a is %@]", x);
    }];
    
    [s subscribeNext:^(id  _Nullable x) {
        NSLog(@"3 [a is %@]", x);
    }];
    
    //RACSequence
    RACSequence *sequence = [s sequence];
    
    [[[[[self authorizationSignal] filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }] then:^RACSignal * _Nonnull{
        return [[[[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return value[1];
        }] merge:[[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return [RACSignal error:value[1]];
        }]] take:1] initially:^{
            [self.manager startUpdatingLocation];
        }] finally:^{
            [self.manager stopUpdatingLocation];
        }] ;
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        CLLocation *location = [value firstObject];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                if (error) {
                    [subscriber sendError:error];
                }else{
                    [subscriber sendNext:[placemarks firstObject]];
                    [subscriber sendCompleted];
                }
            }];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        self.placeLabel.text = [x addressDictionary];
    }];
    
}


- (CLLocationManager *)manager
{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (RACSignal *)authorizationSignal
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.manager requestAlwaysAuthorization];
        
        return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] map:^id _Nullable(RACTuple * _Nullable value) {
            return @([value[1] integerValue] == kCLAuthorizationStatusAuthorizedAlways);
        }];
    }
    return [RACSignal return:@([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
