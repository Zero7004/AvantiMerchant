//
//  PhoneRegisterViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/31.
//  Copyright © 2017年 Mac. All rights reserved.
//


//手机号码登录//


#import "PhoneRegisterViewController.h"
#import "FaceLoginViewController.h"
#import "SelectShopViewController.h"
#import "forgetViewController.h"

@interface PhoneRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *canceBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *code;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *faceLoginBtn;

@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction)RegisterBtnClick:(id)sender;
- (IBAction)CancelBtnClick:(id)sender;

- (IBAction)ForgetBtnClick:(id)sender;

@end

@implementation PhoneRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _registerBtn.layer.cornerRadius = 7;
    _canceBtn.layer.cornerRadius = 7;
    _getCodeBtn.layer.cornerRadius = 3;
    _registerBtn.backgroundColor = NAV_COLOR;
    [_faceLoginBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];

    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [_faceLoginBtn addTarget:self action:@selector(faceLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneNumber.text = [DEFAULT objectForKey:@"phoneNumber"];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//登录
- (IBAction)RegisterBtnClick:(id)sender {
    UIApplication *ap = [UIApplication sharedApplication];

    [_phoneNumber resignFirstResponder];
    [_code resignFirstResponder];

    if (!(_phoneNumber.text.length>0)) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入手机号码"];
        return ;
    }
    if (_phoneNumber.text.length != 11) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入有效手机号码"];
        return ;
    }

    if (!(_code.text.length>0)) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入验证码"];
        return ;
    }

    
    //调用接口登录
    NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/msmLogin"];
    NSDictionary *dic = @{@"phone": _phoneNumber.text, @"code":_code.text, @"deviceToken":[DEFAULT objectForKey:@"deviceToken"]};
    [self postLoginWithUrl:url Parameters:dic];
    
}




- (IBAction)CancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//获取验证码
-(void)getCodeBtnClick{
    UIApplication *ap = [UIApplication sharedApplication];

    [_phoneNumber resignFirstResponder];
    [_code resignFirstResponder];
    
    if (!(_phoneNumber.text.length>0)) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入手机号码"];
        return ;
    }
    if (![Util valiMobile:_phoneNumber.text]) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入有效手机号码"];
        return ;
    }

    [DEFAULT setObject:_phoneNumber.text forKey:@"phoneNumber"];
    
    NSString *url = [API_ReImg stringByAppendingString:@"Msm/appSendCode"];
    NSDictionary *dic = @{@"phone":_phoneNumber.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取验证码 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                //开始读秒
                [self openCountdown];
            }
            else if ([res isEqualToString:@"0"]){
                //开始读秒
                [self openCountdown];
                [Util toastWithView:ap.keyWindow AndText:@"获取验证码失败，请稍后操作"];
            }
            else{
                [Util toastWithView:ap.keyWindow AndText:@"获取验证码失败"];
            }
        }
        else{
            [Util toastWithView:ap.keyWindow AndText:@"获取验证码失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取验证码失败 %@", error);
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
    }];
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
        
        NSString *res = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
        if ([res isEqualToString:@"1"]) {
            //初始化用户数据
            [AppDelegate APP].user = [[User alloc] init];
            [AppDelegate APP].user.userId = [responseObject objectForKey:@"userId"];
            //登录返回的useId是用户登录的id，总店登录的时候会返回不同的userId
            [AppDelegate APP].user.userLoginId = [responseObject objectForKey:@"userId"];

            [[AppDelegate APP].user setUserIfoWithNumber:[AppDelegate APP].user.number UserId:[AppDelegate APP].user.userId ShopId:[AppDelegate APP].user.shopId ShopName:[AppDelegate APP].user.shopName DLVServeice:[AppDelegate APP].user.dlvService ShopImg:[AppDelegate APP].user.shopImg UserLoginId:[AppDelegate APP].user.userLoginId];
            
            //判断登录方式
            if ([_loginType isEqualToString:@"1"]) {
                
//                [self dismissViewControllerAnimated:YES completion:nil];
                
                //设置登录方式
                [DEFAULT setObject:@"1" forKey:@"LoginType"];

                [self getMerchantInfor];

            }
            else{
                //总店登录
//                SelectShopViewController *vc = [[SelectShopViewController alloc] init];
//                [self presentViewController:vc animated:YES completion:nil];
                
                //设置登录方式
                [DEFAULT setObject:@"2" forKey:@"LoginType"];

                //跳转选择商店页
                [[AppDelegate APP] selectShopView];


            }
            
            
        }
        else if ([res isEqualToString:@"2"]){
            [Util toastWithView:ap.keyWindow AndText:@"验证码失效"];
        }
        else if ([res isEqualToString:@"3"]){
            [Util toastWithView:ap.keyWindow AndText:@"请确认手机号码是否正确"];
        }
        else{
            [Util toastWithView:ap.keyWindow AndText:@"登录失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
    }];
}


//刷脸登录
-(void)faceLoginBtnClick{
    //有记录，可以进行刷脸登录
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    FaceLoginViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"FaceLogin"];
    vc.loginType = _loginType;
    [self presentViewController:vc animated:YES completion:nil];
    
//    UIApplication *ap = [UIApplication sharedApplication];
//
//    [_phoneNumber resignFirstResponder];
//    
//    if (!(_phoneNumber.text.length>0)) {
//        [Util toastWithView:ap.keyWindow AndText:@"请输入手机号码"];
//        return ;
//    }
//    if (_phoneNumber.text.length != 11) {
//        [Util toastWithView:ap.keyWindow AndText:@"请输入有效手机号码"];
//        return ;
//    }
//    
//    [DEFAULT setObject:_phoneNumber.text forKey:@"phoneNumber"];
//
//    NSMutableArray *UserPhoneArray = [KeyChain load:KEY_Server];
//    if (UserPhoneArray == nil) {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您未开启刷脸识别" message:@"我的-当前账号-开启刷脸识别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//        [alertView show];
//    }
//    else{
//        for (NSDictionary *keyPhone in UserPhoneArray) {
//            if ([keyPhone[@"userPhone"] isEqualToString:_phoneNumber.text]) {
//                //有记录，可以进行刷脸登录
//                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//                FaceLoginViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"FaceLogin"];
//                vc.loginType = _loginType;
//                [self presentViewController:vc animated:YES completion:nil];
//            }
//            else{
//                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您未开启刷脸识别" message:@"登录成功后前往-我的-当前账号-开启刷脸识别" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
//                [alertView show];
//            }
//        }
//    }
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNumber resignFirstResponder];
    [_code resignFirstResponder];
}



// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//                [self.getCodeBtn setTitleColor:[UIColor colorFromHexCode:@"FB8557"] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%.2d)", seconds] forState:UIControlStateNormal];
//                [self.getCodeBtn setTitleColor:[UIColor colorFromHexCode:@"979797"] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


- (IBAction)ForgetBtnClick:(id)sender {
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    forgetViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"forgetVC"];
    vc.userName = _phoneNumber.text;
    [self presentViewController:vc animated:YES completion:nil];

}
@end
