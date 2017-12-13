//
//  ChangePasswordVC.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

///***设置新密码***///

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *againPwd;
@property (weak, nonatomic) IBOutlet UIButton *confirm;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _topView.backgroundColor = NAV_COLOR;
    _confirm.layer.cornerRadius = 7;
    _back.layer.cornerRadius = 7;
    _confirm.backgroundColor = NAV_COLOR;
    _back.backgroundColor = NAV_COLOR;
    
    [_confirm addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_back addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_confirm resignFirstResponder];
    [_back resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)confirmBtnClick{
    [_confirm resignFirstResponder];
    [_back resignFirstResponder];

    UIApplication *ap = [UIApplication sharedApplication];
    
    if (_pwd.text.length < 6 && _pwd.text.length > 16) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入有效长度"];
        return ;
    }
    if (![_againPwd.text isEqualToString:_pwd.text]) {
        [Util toastWithView:ap.keyWindow AndText:@"两次输入密码不相同"];
        return ;
    }
    
    
    [self postChangePassword];
}

//重置密码
-(void)postChangePassword{
    UIApplication *ap = [UIApplication sharedApplication];
    
    NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/updPwd"];
    NSDictionary *dic = @{@"userId":_userId, @"pwd":_pwd.text, @"againPwd":_againPwd.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"重置密码 %@", responseObject);
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重置成功" message:@"是否返回登录界面" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[AppDelegate APP] rootLoginView];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else{
                [Util toastWithView:ap.keyWindow AndText:@"重置失败"];
            }
        }
        else{
            [Util toastWithView:ap.keyWindow AndText:@"重置失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"验证失败 %@", error);
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
    }];

}

-(void)backBtnClick{
    [_confirm resignFirstResponder];
    [_back resignFirstResponder];

    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
