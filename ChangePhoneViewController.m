//
//  ChangePhoneViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

//***修改手机号码***//

#import "ChangePhoneViewController.h"
#import "StoreInformationViewController.h"

@interface ChangePhoneViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHight;

- (IBAction)confirmBtnClick:(id)sender;
- (IBAction)blackBtnClick:(id)sender;

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    _textView.scrollEnabled = YES;
    _textView.delegate = self;
    _textView.keyboardType = UIKeyboardTypeNumberPad;
    
    _textView.text = _phoneNum;
    
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.borderWidth = 1;
    _confirmBtn.layer.borderColor = [NAV_COLOR CGColor];
    
    _blackBtn.layer.cornerRadius = 5;
    _blackBtn.layer.borderWidth = 1;
    _blackBtn.layer.borderColor = [[UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1] CGColor];
    _blackBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}



- (IBAction)confirmBtnClick:(id)sender {
    if (_textView.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入手机号码"];
        return ;
    }
    if (![Util valiMobile:_textView.text]) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入有效的手机号码或者固定电话号码"];
        return ;
    }
    [_textView resignFirstResponder];
    self.block(_textView.text);
    [self postSetPhone:_textView.text];
}


- (IBAction)blackBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}


-(void)textViewDidChange:(UITextView *)textView{
    _textViewHight.constant = [Util countTextHeight:_textView.text];
    
}

//设置手机号码
-(void)postSetPhone:(NSString *)shopTel{
    NSString *url = [API stringByAppendingString:@"AdminShop/setTel"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"shopTel":shopTel};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"设置公告%@", responseObject);
        
        if (responseObject != nil) {
            if (responseObject[@"success"] != nil && ![responseObject[@"success"] isKindOfClass:[NSNull class]]) {
                if ([responseObject[@"success"] isEqualToString:@"success"]) {
                    [Util toastWithView:self.navigationController.view AndText:@"电话设置成功"];
                    self.block(_textView.text);
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[StoreInformationViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                        }
                    }
                }
                else
                    [Util toastWithView:self.navigationController.view AndText:@"电话设置失败"];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"电话设置失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"电话设置失败"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"电话公告失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



@end
