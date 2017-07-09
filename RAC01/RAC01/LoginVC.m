//
//  LoginVC.m
//  RAC01
//
//  Created by wangzhen on 2017/7/7.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "LoginVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *userTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    [self.userTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"text is : [%@]", x);
    }];
     */
    
    /*
    
    RACSignal *enableSignal = [self.userTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length>0);
    }];
    
     */
    
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.userTextField.rac_textSignal, self.pwdTextField.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        
        return @([value[0] length] >0 && [value[1] length] > 6);
        
    }];

    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
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
