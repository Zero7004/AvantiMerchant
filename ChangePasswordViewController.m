//
//  ChangePasswordViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/2.
//  Copyright © 2017年 Mac. All rights reserved.
//


//***修改密码***//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *changePassword;

@property (weak, nonatomic) IBOutlet UIButton *checkOldBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkChangeBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    _confirmBtn.layer.cornerRadius = 7;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //查看密码
    [_checkOldBtn addTarget:self action:@selector(checkOldBtnIn) forControlEvents:UIControlEventTouchUpInside];
    
    //查看密码
    [_checkChangeBtn addTarget:self action:@selector(checkChangeBtnIn) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//查看密码
-(void)checkOldBtnIn{
    _checkOldBtn.selected = !_checkOldBtn.selected;
    if (_checkOldBtn.selected) {
        _oldPassword.secureTextEntry = NO;
        [_checkOldBtn setImage:[UIImage imageNamed:@"查看密码1"] forState:UIControlStateNormal];
    }
    else{
        _oldPassword.secureTextEntry = YES;
        [_checkOldBtn setImage:[UIImage imageNamed:@"查看密码0"] forState:UIControlStateNormal];
    }
}


-(void)checkChangeBtnIn{
    _checkChangeBtn.selected = !_checkChangeBtn.selected;
    if (_checkChangeBtn.selected) {
        _changePassword.secureTextEntry = NO;
        [_checkChangeBtn setImage:[UIImage imageNamed:@"查看密码1"] forState:UIControlStateNormal];
    }
    else{
        _changePassword.secureTextEntry = YES;
        [_checkChangeBtn setImage:[UIImage imageNamed:@"查看密码0"] forState:UIControlStateNormal];
    }
}

//-(void)checkChangeBtnOut{
//    _changePassword.secureTextEntry = YES;
//}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_changePassword resignFirstResponder];
    [_oldPassword resignFirstResponder];
}


//确认修改
-(void)confirmBtnClick{
    [_changePassword resignFirstResponder];
    [_oldPassword resignFirstResponder];

    if (!(_oldPassword.text.length > 0)) {
        [Util toastWithView:self.view AndText:@"请输入原密码"];
        return ;
    }
    if (!(_changePassword.text.length > 0)) {
        [Util toastWithView:self.view AndText:@"请输入新密码"];
        return ;
    }
    if (_changePassword.text.length < 6) {
        [Util toastWithView:self.view AndText:@"新密码太短"];
        return ;
    }
    if (_changePassword.text.length > 16) {
        [Util toastWithView:self.view AndText:@"新密码过长"];
        return ;
    }
    
    NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/updPassword"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId, @"pvdPassword":_oldPassword.text, @"newPassword":_changePassword.text};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"修改密码信息 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if([res isEqualToString:@"2"]){
                [Util toastWithView:self.navigationController.view AndText:@"修改失败，原密码与新密码相同"];
            }
            else if([res isEqualToString:@"3"]){
                [Util toastWithView:self.navigationController.view AndText:@"修改失败，原密码不正确"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"修改失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"修改密码失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


@end









