//
//  ColorSelectVC.m
//  RAC01
//
//  Created by wangzhen on 2017/7/7.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "ColorSelectVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ColorSelectVC ()

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UITextField *redInput;
@property (weak, nonatomic) IBOutlet UITextField *blueInput;
@property (weak, nonatomic) IBOutlet UITextField *greenInput;
@property (weak, nonatomic) IBOutlet UIView *showView;

@property (nonatomic, assign) CGFloat a;
@property (nonatomic, assign) CGFloat b;
@property (nonatomic, assign) CGFloat c;

@end

@implementation ColorSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _redInput.text = _blueInput.text = _greenInput.text = @"0.5";
    
    /*
    [self bindSlider:_redSlider textField:_redInput];
    [self bindSlider:_blueSlider textField:_blueInput];
    [self bindSlider:_greenSlider textField:_greenInput];
    */
    
    RACSignal *redSignal = [self bindSlider:_redSlider textField:_redInput];
    RACSignal *blueSignal = [self bindSlider:_blueSlider textField:_blueInput];
    RACSignal *greenSignal = [self bindSlider:_greenSlider textField:_greenInput];
    //combineLatest信号量必须是3个信号量都有新的值传过来
    
    /*
    
    [[[RACSignal combineLatest:@[redSignal, blueSignal, greenSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue]
                               green:[value[2] floatValue]
                                blue:[value[1] floatValue]
                               alpha:1.0f];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"current thread is [%@]", NSThread.currentThread);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _showView.backgroundColor = x;

        });
        
    }];
     
     */
    
    RACSignal *changeValueSignal =  [[RACSignal combineLatest:@[redSignal, blueSignal, greenSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue]
                               green:[value[2] floatValue]
                                blue:[value[1] floatValue]
                               alpha:1.0f];
    }];
    
    RAC(_showView, backgroundColor) = changeValueSignal;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)bindSlider:(UISlider *)slider textField:(UITextField *)textField
{
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    [signalText subscribe:signalSlider];
    //[signalSlider subscribe:signalText];
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f", [value floatValue]];
    }] subscribe:signalText];
}
 */

- (RACSignal *)bindSlider:(UISlider *)slider textField:(UITextField *)textField
{
    //开始触发一次
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    [signalText subscribe:signalSlider];
    //[signalSlider subscribe:signalText];
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f", [value floatValue]];
    }] subscribe:signalText];
    return [[signalText merge:signalSlider] merge:textSignal];
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
