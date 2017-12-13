//
//  AddWaiterViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "AddWaiterViewController.h"

@interface AddWaiterViewController (){
    NSString *loginName;
}
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;    //确定按钮
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;     //取消按钮
@property (weak, nonatomic) IBOutlet UITextField *name;       //姓名
@property (weak, nonatomic) IBOutlet UITextField *number;     //编号
@property (weak, nonatomic) IBOutlet UILabel *account;        //账号lable
@property (weak, nonatomic) IBOutlet UITextField *password;   //密码

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction)returnBtnClick:(id)sender;

@end

@implementation AddWaiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    _titleLable.text = _titlelable;
    
    [self initBtn];
    [self addInfor];
}

-(void)initBtn{
    _confirmBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    _confirmBtn.layer.masksToBounds = YES;//设为NO去试试
    _returnBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
//    _returnBtn.layer.masksToBounds = YES;//设为NO去试试

    _name.layer.borderColor= NAV_COLOR.CGColor;
    _name.layer.borderWidth= 2.0f;
    _number.layer.borderColor= NAV_COLOR.CGColor;
    _number.layer.borderWidth= 2.0f;
    _password.layer.borderColor= NAV_COLOR.CGColor;
    _password.layer.borderWidth= 2.0f;
    
    _name.layer.cornerRadius = 5;
//    _name.layer.masksToBounds = YES;
    _number.layer.cornerRadius = 5;
//    _number.layer.masksToBounds = YES;
    _password.layer.cornerRadius = 5;
}

-(void)addInfor{
    if ([_titleLable.text isEqualToString:@"编辑"]) {
        if (_waiterInfo[@"waiterName"] != nil && ![_waiterInfo[@"waiterName"] isKindOfClass:[NSNull class]]) {
            _name.text = [NSString stringWithFormat:@"%@",_waiterInfo[@"waiterName"]];
        }
        else
            _name.text = [NSString stringWithFormat:@"%@", @""];
        
        if (_waiterInfo[@"waiterNum"] != nil && ![_waiterInfo[@"waiterNum"] isKindOfClass:[NSNull class]]) {
            _number.text = [NSString stringWithFormat:@"%@",_waiterInfo[@"waiterNum"]];
        }
        else
            _number.text = [NSString stringWithFormat:@"%@", @""];
        
//        if (_waiterInfo[@"loginName"] != nil && ![_waiterInfo[@"loginName"] isKindOfClass:[NSNull class]]) {
//            _account.text = [NSString stringWithFormat:@"%@%@", @"点菜宝登录账号：",_waiterInfo[@"loginName"]];
//        }
//        else
//            _account.text = [NSString stringWithFormat:@"%@", @"点菜宝登录账号："];
    }
    else{
        int x = arc4random() % 1000000;
        loginName = [NSString stringWithFormat:@"%@%d", @"aftdc_", x];
        _account.text = [NSString stringWithFormat:@"%@%@", @"点菜宝登录账号：", loginName];
    }
    


}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name resignFirstResponder];
    [_number resignFirstResponder];
    [_password resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)confirmBtnClick{
    [_name resignFirstResponder];
    [_number resignFirstResponder];
    
    if ([_titleLable.text isEqualToString:@"编辑"]) {
        [self postEditWaiter];
    }
    
    if ([_titleLable.text isEqualToString:@"添加"]) {
        if (!(_name.text.length > 0)) {
            [Util toastWithView:self.navigationController.view AndText:@"请输入姓名"];
            return ;
        }
        if (!(_number.text.length > 0)) {
            [Util toastWithView:self.navigationController.view AndText:@"请输入编号"];
            return ;
        }
//        if (!(_password.text.length > 0)) {
//            [Util toastWithView:self.navigationController.view AndText:@"请设置密码"];
//            return ;
//        }
        [self postAddWaiter];
    }

}

- (IBAction)returnBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)postEditWaiter{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/addWaiter"];
//    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"waiterName":_name.text, @"waiterNum":_number.text, @"loginName":_waiterInfo[@"loginName"], @"password": _password.text.length>0 ? _password.text:_waiterInfo[@"password"], @"id":_waiterInfo[@"id"]};
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"waiterName":_name.text, @"waiterNum":_number.text, @"id":_waiterInfo[@"id"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"编辑服务员成功 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                NSArray *dict = responseObject;
                self.block(dict);
                
                [Util toastWithView:self.navigationController.view AndText:@"编辑成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if([res isEqualToString:@"2"]){
                [Util toastWithView:self.navigationController.view AndText:@"该编号已存在"];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"编辑失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"编辑失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"编辑服务员失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}


-(void)postAddWaiter{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/addWaiter"];
//    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"waiterName":_name.text, @"waiterNum":_number.text, @"loginName":loginName, @"password":_password.text};
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"waiterName":_name.text, @"waiterNum":_number.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"添加服务员成功 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                NSArray *dict = responseObject;
                self.block(dict);
                
                [Util toastWithView:self.navigationController.view AndText:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if([res isEqualToString:@"2"]){
                [Util toastWithView:self.navigationController.view AndText:@"该编号已存在"];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"添加失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"添加失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"添加服务员失败 %@", error);
        [_hud hideAnimated:YES];

        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}


@end
