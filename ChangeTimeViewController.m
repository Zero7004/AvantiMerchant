//
//  ChangeTimeViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*改变营业时间*//

#import "ChangeTimeViewController.h"
#import "THDatePickerView3.h"
#import "StoreInformationViewController.h"
#import "WXZPickTimeView.h"

@interface ChangeTimeViewController ()<PickTimeViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UILabel *distributionTime;        //配送时间

//@property (strong, nonatomic) THDatePickerView3 *dateView;
@property (strong, nonatomic) WXZPickTimeView *pickerArea;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property NSInteger BtnTag;

- (IBAction)startBtnClick:(id)sender;
- (IBAction)endBtnClick:(id)sender;
- (IBAction)confirmBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@end

@implementation ChangeTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _BtnTag = 0;
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.borderWidth = 1;
    _confirmBtn.layer.borderColor = [NAV_COLOR CGColor];

    _backBtn.layer.cornerRadius = 5;
    _backBtn.layer.borderWidth = 1;
    _backBtn.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    _backBtn.layer.masksToBounds = YES;
    [_startBtn setTitle:_startTime forState:UIControlStateNormal];
    [_endBtn setTitle:_endTime forState:UIControlStateNormal];
    
    [self initDateView];

}

-(void)initDateView{
    
    _pickerArea = [[WXZPickTimeView alloc] init];
    
    [_pickerArea setDelegate:self];
    
    [_pickerArea setDefaultHour:14 defaultMinute:20];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)startBtnClick:(id)sender {
    _BtnTag = 1;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
//        [self.dateView show];
//    }];
    [_pickerArea show];

}

- (IBAction)endBtnClick:(id)sender {
    _BtnTag = 2;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
//        [self.dateView show];
//    }];
    [_pickerArea show];


}

- (IBAction)confirmBtnClick:(id)sender {
    if ([_startBtn.titleLabel.text isEqualToString:@"---"] || [_endBtn.titleLabel.text isEqualToString:@"---"]) {
        [Util toastWithView:self.navigationController.view AndText:@"请设置好时间"];
        return ;
    }
    
    [self postSetTime:_startBtn.titleLabel.text endTime:_endBtn.titleLabel.text];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//设置营业时间
-(void)postSetTime:(NSString *)start endTime:(NSString *)end{
    NSString *url = [API stringByAppendingString:@"AdminShop/setTime"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"start":start, @"end":end};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"设置时间%@", responseObject);
        
        if (responseObject != nil) {
            if (responseObject[@"success"] != nil && ![responseObject[@"success"] isKindOfClass:[NSNull class]]) {
                if ([responseObject[@"success"] isEqualToString:@"success"]) {
                    [Util toastWithView:self.navigationController.view AndText:@"时间设置成功"];
                    self.block(_startBtn.titleLabel.text, _endBtn.titleLabel.text);
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[StoreInformationViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                    
                }
                else
                    [Util toastWithView:self.navigationController.view AndText:@"时间设置失败"];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"时间设置失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"时间设置失败"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"时间设置失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



#pragma mark - DatePickerViewDelegate
-(void)pickerTimeView:(WXZPickTimeView *)pickerTimeView selectHour:(NSInteger)hour selectMinute:(NSInteger)minute{
    NSLog(@"选择的时间：%ld %ld",hour,minute);
    if (_BtnTag == 1) {
        if (hour<10&minute<10) {
            [_startBtn setTitle:[NSString stringWithFormat:@"0%ld:0%ld",hour,minute] forState:UIControlStateNormal];
        }else if (hour<10){
            [_startBtn setTitle:[NSString stringWithFormat:@"0%ld:%ld",hour,minute] forState:UIControlStateNormal];
        }else if (minute<10){
            [_startBtn setTitle:[NSString stringWithFormat:@"%ld:0%ld",hour,minute] forState:UIControlStateNormal];
        }else{
            [_startBtn setTitle:[NSString stringWithFormat:@"%ld:%ld",hour,minute] forState:UIControlStateNormal];
        }

    }
    else{
        if (hour<10&minute<10) {
            [_endBtn setTitle:[NSString stringWithFormat:@"0%ld:0%ld",hour,minute] forState:UIControlStateNormal];
        }else if (hour<10){
            [_endBtn setTitle:[NSString stringWithFormat:@"0%ld:%ld",hour,minute] forState:UIControlStateNormal];
        }else if (minute<10){
            [_endBtn setTitle:[NSString stringWithFormat:@"%ld:0%ld",hour,minute] forState:UIControlStateNormal];
        }else{
            [_endBtn setTitle:[NSString stringWithFormat:@"%ld:%ld",hour,minute] forState:UIControlStateNormal];
        }

    }
}



@end
