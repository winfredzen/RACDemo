//
//  ViewController.m
//  RAC01
//
//  Created by wangzhen on 2017/7/6.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"dispose");
        }];
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    RACSignal *viewDidAppear = [self rac_signalForSelector:@selector(viewDidAppear:)];
    
    [viewDidAppear subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        NSLog(@"%s", __func__);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setRac_command:[[RACCommand alloc] initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           
           NSLog(@"button clicked");
           
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [subscriber sendNext:[[NSDate date] description]];
               [subscriber sendCompleted];
           });
           
           return [RACDisposable disposableWithBlock:^{
               
           }];
       }];
    }]];
    
    [button setTitle:@"RACButton" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 100, 200)];
    [self.view addSubview:button];
    
    [[[button rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
       [x subscribeNext:^(id  _Nullable x) {
           NSLog(@"button rac_command:  %@", x);
       }];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
