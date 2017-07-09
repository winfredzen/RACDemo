//
//  CreateSignalVC.m
//  RAC01
//
//  Created by wangzhen on 2017/7/9.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "CreateSignalVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface CreateSignalVC ()

@end

@implementation CreateSignalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //同时也可以将error订阅 订阅完成状态
    
    NSString *url = @"https://jsonplaceholder.typicode.com/posts";
    [[self signalFromJson:url] subscribeNext:^(id  _Nullable x) {
        NSLog(@"jsonDic [==%@==]", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    } completed:^{
        NSLog(@"完成");
    }];
    
}

- (RACSignal *)signalFromJson:(NSString *)url
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionConfiguration *configration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configration];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                [subscriber sendError:error];
            }
            else{
                NSError *e;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                if (e) {
                    [subscriber sendError:e];
                }else{
                    [subscriber sendNext:jsonDic];
                    [subscriber sendCompleted];
                }
            }
            
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
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
