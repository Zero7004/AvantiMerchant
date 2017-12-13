//
//  forgetViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/18.
//  Copyright © 2017年 Mac. All rights reserved.
//

//忘记密码//


#import "forgetViewController.h"
#import "ChangePasswordVC.h"

@interface forgetViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *back;

- (IBAction)nextBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;
@end

@implementation forgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _topView.backgroundColor = NAV_COLOR;
    _next.layer.cornerRadius = 7;
    _back.layer.cornerRadius = 7;
    _next.backgroundColor = NAV_COLOR;
    _back.backgroundColor = NAV_COLOR;
    _name.text = _userName;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name resignFirstResponder];
    [_back resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)nextBtnClick:(id)sender {
    UIApplication *ap = [UIApplication sharedApplication];

    if (!(_name.text.length > 0)) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入账户名"];
        return ;
    }
    if (!(_phone.text.length > 0)) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入手机号码"];
        return ;
    }
    
    [self authentication];
}

-(void)authentication{
    UIApplication *ap = [UIApplication sharedApplication];

    NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/checkUser"];
    NSDictionary *dic = @{@"loginName":_name.text, @"userPhone":_phone.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取验证信息 %@", responseObject);
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
                ChangePasswordVC *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
                vc.userId = responseObject[@"userId"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else{
                [Util toastWithView:ap.keyWindow AndText:@"验证失败"];
            }
        }
        else{
            [Util toastWithView:ap.keyWindow AndText:@"验证失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"验证失败 %@", error);
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
    }];
    
}

- (IBAction)backBtnClick:(id)sender {
    [_name resignFirstResponder];
    [_back resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
