//
//  RegisterViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "forgetViewController.h"
#import "PhoneRegisterViewController.h"
#import "SelectShopViewController.h"

//账号登录//

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *canceBtn;
@property (weak, nonatomic) IBOutlet UIButton *fotgetBtn;

- (IBAction)RegisterBtnClick:(id)sender;
- (IBAction)CancelBtnClick:(id)sender;
- (IBAction)ForgetBtnClick:(id)sender;

//查看密码
@property (weak, nonatomic) IBOutlet UIButton *Checkpassword;

//@property (weak, nonatomic) IBOutlet UIButton *changeLoginType;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _bgView.layer.cornerRadius = 7;
    _registerBtn.layer.cornerRadius = 7;
    _canceBtn.layer.cornerRadius = 7;
    
    _registerBtn.backgroundColor = NAV_COLOR;
    
//    _number.text = @"123456";
//    _password.text = @"123456";
    _number.text = [DEFAULT objectForKey:@"LastNumber"];
    
//    [_changeLoginType setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_fotgetBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];

    //查看密码
    [_Checkpassword setImage:[UIImage imageNamed:@"查看密码1"] forState:UIControlStateNormal];
    [_Checkpassword addTarget:self action:@selector(CheckpasswordIn) forControlEvents:UIControlEventTouchUpInside];


}

-(void)CheckpasswordIn{
    _password.selected = !_password.selected;
    if (_password.selected) {
        _password.secureTextEntry = NO;
        [_Checkpassword setImage:[UIImage imageNamed:@"查看密码1"] forState:UIControlStateNormal];
    }
    else{
        _password.secureTextEntry = YES;
        [_Checkpassword setImage:[UIImage imageNamed:@"查看密码0"] forState:UIControlStateNormal];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_number resignFirstResponder];
    [_password resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)RegisterBtnClick:(id)sender {
    [_number resignFirstResponder];
    [_password resignFirstResponder];
    [DEFAULT setObject:_number.text forKey:@"LastNumber"];
    
    if (!(_number.text.length>0)) {
        UIApplication *ap = [UIApplication sharedApplication];
        [Util toastWithView:ap.keyWindow AndText:@"请输入账号"];
        return ;
    }
    if (!(_password.text.length>0)) {
        UIApplication *ap = [UIApplication sharedApplication];
//        [ap.keyWindow addSubview:vc.view];
        [Util toastWithView:ap.keyWindow AndText:@"请输入密码"];
        return ;
    }
    NSString *url = [API stringByAppendingString:@"Personal/checkLogin"];
    NSDictionary *dic = @{@"loginName": _number.text, @"loginPwd":_password.text, @"loginType":_loginType, @"deviceToken":[DEFAULT objectForKey:@"deviceToken"]};
    [self postLoginWithUrl:url Parameters:dic];
    
    
}

//验证登录
-(void)postLoginWithUrl:(NSString *)url Parameters:(id)parameters{
    UIApplication *ap = [UIApplication sharedApplication];

    _hud = [MBProgressHUD showHUDAddedTo:ap.keyWindow animated:YES];
    _hud.label.text = @"正在登录";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"登录成功 %@", responseObject);
        [_hud hideAnimated:YES];

        //status: 1为店长登录   2为总店登录
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            //初始化用户数据
            [AppDelegate APP].user = [[User alloc] init];
            [AppDelegate APP].user.userId = [responseObject objectForKey:@"userId"];
            //登录返回的useId是用户登录的id，总店登录的时候会返回不同的userId
            [AppDelegate APP].user.userLoginId = [responseObject objectForKey:@"userId"];

            [[AppDelegate APP].user setUserIfoWithNumber:_number.text UserId:[AppDelegate APP].user.userId ShopId:[AppDelegate APP].user.shopId ShopName:[AppDelegate APP].user.shopName DLVServeice:[AppDelegate APP].user.dlvService ShopImg:[AppDelegate APP].user.shopImg UserLoginId:[AppDelegate APP].user.userLoginId];
            
            //设置登录方式
            [DEFAULT setObject:@"1" forKey:@"LoginType"];

            
//            [self dismissViewControllerAnimated:YES completion:nil];
            
            //获取商家信息
            [self getMerchantInfor];

            
            
        }
        else if ([status isEqualToString:@"2"]){
            //初始化用户数据
            [AppDelegate APP].user = [[User alloc] init];
            [AppDelegate APP].user.userId = [responseObject objectForKey:@"userId"];
            //登录返回的useId是用户登录的id，总店登录的时候会返回不同的userId
            [AppDelegate APP].user.userLoginId = [responseObject objectForKey:@"userId"];

            [[AppDelegate APP].user setUserIfoWithNumber:_number.text UserId:[AppDelegate APP].user.userId ShopId:[AppDelegate APP].user.shopId ShopName:[AppDelegate APP].user.shopName DLVServeice:[AppDelegate APP].user.dlvService ShopImg:[AppDelegate APP].user.shopImg UserLoginId:[AppDelegate APP].user.userLoginId];
            
//            [self dismissViewControllerAnimated:YES completion:nil];
            
//            SelectShopViewController *vc = [[SelectShopViewController alloc] init];
//            [self presentViewController:vc animated:YES completion:nil];
            
            //设置登录方式
            [DEFAULT setObject:@"2" forKey:@"LoginType"];
            
            //跳转选择商店页
            [[AppDelegate APP] selectShopView];
        }
        else{
            [Util toastWithView:ap.keyWindow AndText:@"账号或者密码错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
    }];
}



- (IBAction)CancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)ForgetBtnClick:(id)sender {
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    forgetViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"forgetVC"];
    vc.userName = _number.text;
    [self presentViewController:vc animated:YES completion:nil];
    
}



//获取商家信息
-(void)getMerchantInfor{
    UIApplication *ap = [UIApplication sharedApplication];

    NSString *url = [API stringByAppendingString:@"Personal/personals"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取商家信息 %@", responseObject);
        if (responseObject != nil && ![responseObject isKindOfClass:[NSNull class]]) {
            NSDictionary *dictShop = [responseObject objectForKey:@"shop"];
            NSDictionary *dictNew = [responseObject objectForKey:@"arr"][@"new"];
            NSDictionary *dictGoon = [responseObject objectForKey:@"arr"][@"goon"];
            NSDictionary *dictRefund = [responseObject objectForKey:@"arr"][@"refund"];
            NSDictionary *dictReminder = [responseObject objectForKey:@"arr"][@"reminder"];
            
            //商家信息
            if (![dictShop isKindOfClass:[NSNull class]] && dictShop != nil) {
                NSLog(@"Shop = %@", dictShop);
                [AppDelegate APP].user.shopId = dictShop[@"shopId"];
                [AppDelegate APP].user.shopName = dictShop[@"shopName"];
                [AppDelegate APP].user.dlvService = dictShop[@"dlvService"];
                [AppDelegate APP].user.shopImg = dictShop[@"shopImg"];
                
                //进入视图
                [[AppDelegate APP] rootMainView];
            }
            else{
                [Util toastWithView:ap.keyWindow AndText:@"获取信息失败，请重新登录"];
            }

            //新订单
            if (![dictNew isKindOfClass:[NSNull class]]) {
            }
            //进行中的订单
            if (![dictGoon isKindOfClass:[NSNull class]]) {
                
            }
            //退款单
            if (![dictRefund isKindOfClass:[NSNull class]]) {
                ;
            }
            //催单
            if (![dictReminder isKindOfClass:[NSNull class]]) {
                
            }
            

        }
        
        else{
            [Util toastWithView:ap.keyWindow AndText:@"获取信息失败，请重新登录"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家信息失败 %@", error);
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
    }];
}


//-(void)changeLoginTypeClick{
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//}


@end
