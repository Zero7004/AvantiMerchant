//
//  LoginViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*登录页*//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PhoneRegisterViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginSegmentViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIButton *ShopManagerBtn;       //店长登录按钮
@property (weak, nonatomic) IBOutlet UIButton *HeadquartersBtn;       //总店登录按钮

- (IBAction)ShopManagerBtnClick:(id)sender;
- (IBAction)HeadquartersBtnClick:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _ShopManagerBtn.layer.cornerRadius = 7;
    _HeadquartersBtn.layer.cornerRadius = 7;
}

-(void)viewWillAppear:(BOOL)animated{

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWithNameNumber) name:@"loginWithNameNumber" object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWithPhoneNumber) name:@"loginWithPhoneNumber" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//店长登录按钮
- (IBAction)ShopManagerBtnClick:(id)sender {
    LoginSegmentViewController *segmentVC = [[LoginSegmentViewController alloc] init];
    segmentVC.loginType = @"1";
    [self presentViewController:segmentVC animated:YES completion:nil];
}


//总店登录按钮
- (IBAction)HeadquartersBtnClick:(id)sender {

    LoginSegmentViewController *segmentVC = [[LoginSegmentViewController alloc] init];
    segmentVC.loginType = @"2";
    [self presentViewController:segmentVC animated:YES completion:nil];

}




//店长登录
//-(void)loginShopManager{
//    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//    RegisterViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"register"];
////    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
////    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    vc.loginType = @"1";
//    [self presentViewController:vc animated:YES completion:nil];
//
//}

////手机号码登录
//-(void)loginWithPhoneNumber{
//
//    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//    PhoneRegisterViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"PhoneRegister"];
////    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
////    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    vc.loginType = @"1";
//    [self presentViewController:vc animated:YES completion:nil];
//
//}
//
////账号登录
//-(void)loginWithNameNumber{
//    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//    RegisterViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"register"];
////    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
////    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    vc.loginType = @"1";
//    [self presentViewController:vc animated:YES completion:nil];
//
//}



//验证登录
//-(void)postLoginWithUrl:(NSString *)url Parameters:(id)parameters{
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.label.text = @"正在登录";
//
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"登录成功 %@", responseObject);
////        [_hud hideAnimated:YES];
//        
//        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
//        if ([status isEqualToString:@"1"]) {
//            //初始化用户数据
//            [AppDelegate APP].user = [[User alloc] init];
//            [AppDelegate APP].user.userId = [responseObject objectForKey:@"status"];
//            [[AppDelegate APP].user setUserIfoWithNumber:parameters[@"loginName"] UserId:[AppDelegate APP].user.userId ShopId:[AppDelegate APP].user.shopId ShopName:[AppDelegate APP].user.shopName DLVServeice:[AppDelegate APP].user.dlvService ShopImg:[AppDelegate APP].user.shopImg];
//    
//            
//            [self getMerchantInfor];
//            [[AppDelegate APP] rootMainView];
//            
//        }
//        else{
//            [Util toastWithView:self.view AndText:@"账号或者密码错误"];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"登录失败 %@", error);
////        [_hud hideAnimated:YES];
//        [Util toastWithView:self.view AndText:@"网络连接异常"];
//    }];
//}







//获取商家信息
//-(void)getMerchantInfor{
//    NSString *url = [API stringByAppendingString:@"Personal/personal"];
//    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSLog(@"获取商家信息 %@", responseObject);
//        NSLog(@"%@",responseObject);
//        if (responseObject != nil) {
//            NSDictionary *dictShop = [responseObject objectForKey:@"shop"];
//            NSDictionary *dictNew = [responseObject objectForKey:@"arr"][@"new"];
//            NSDictionary *dictGoon = [responseObject objectForKey:@"arr"][@"goon"];
//            NSDictionary *dictRefund = [responseObject objectForKey:@"arr"][@"refund"];
//            NSDictionary *dictReminder = [responseObject objectForKey:@"arr"][@"reminder"];
//            
//            //商家信息
//            if (![dictShop isKindOfClass:[NSNull class]]) {
//                NSLog(@"Shop = %@", dictShop);
//                [AppDelegate APP].user.shopId = dictShop[@"shopId"];
//                [AppDelegate APP].user.shopName = dictShop[@"shopName"];
//                [AppDelegate APP].user.dlvService = dictShop[@"dlvService"];
//                [AppDelegate APP].user.shopImg = dictShop[@"shopImg"];
//                
//            }
//            //新订单
//            if (![dictNew isKindOfClass:[NSNull class]]) {
//            }
//            //进行中的订单
//            if (![dictGoon isKindOfClass:[NSNull class]]) {
//                
//            }
//            //退款单
//            if (![dictRefund isKindOfClass:[NSNull class]]) {
//                ;
//            }
//            //催单
//            if (![dictReminder isKindOfClass:[NSNull class]]) {
//                
//            }
//            
//            
//        }
//        
//        else{
//            [Util toastWithView:self.view AndText:@"获取信息失败"];
//            
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"获取商家信息失败 %@", error);
//        [Util toastWithView:self.view AndText:@"网络连接异常"];
//    }];
//}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginWithNameNumber" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginWithPhoneNumber" object:nil];

}

@end
