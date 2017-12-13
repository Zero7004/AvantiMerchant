//
//  FaceLoginViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/2.
//  Copyright © 2017年 Mac. All rights reserved.
//


//***刷脸登录***//


#import "FaceLoginViewController.h"
#import "PhotographViewController.h"
#import "SelectShopViewController.h"


@interface FaceLoginViewController (){
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *canceBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (strong, nonatomic) UIImage *faceImage;

- (IBAction)RegisterBtnClick:(id)sender;
- (IBAction)CancelBtnClick:(id)sender;

@end

@implementation FaceLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _registerBtn.layer.cornerRadius = 7;
    _canceBtn.layer.cornerRadius = 7;
    _registerBtn.backgroundColor = NAV_COLOR;

    _phoneNumber.text = [DEFAULT objectForKey:@"phoneNumber"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RegisterBtnClick:(id)sender {
    UIApplication *ap = [UIApplication sharedApplication];

    [_phoneNumber resignFirstResponder];
    
    if (!(_phoneNumber.text.length>0)) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入手机号码"];
        return ;
    }
    if (![Util valiMobile:_phoneNumber.text]) {
        [Util toastWithView:ap.keyWindow AndText:@"请输入有效手机号码"];
        return ;
    }
    
    [DEFAULT setObject:_phoneNumber.text forKey:@"phoneNumber"];

    //验证改手机号是否开通刷脸登录
    [self verificationFaceIsOpenWithPhoneNumber:_phoneNumber.text];
    

}

//验证是否开启刷脸登录
-(void)verificationFaceIsOpenWithPhoneNumber:(NSString *)phoneNumber{
    UIApplication *ap = [UIApplication sharedApplication];
    
    NSString *url = [API stringByAppendingString:@"AddUser/checkFace"];
    NSDictionary *dic = @{@"userPhone":phoneNumber};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"验证手机号是否开启刷脸登录 %@", responseObject);
        if ([responseObject[@"res"] isEqual:@"1"]) {
            PhotographViewController *vc = [[PhotographViewController alloc] init];
            vc.block = ^(UIImage *image) {
                _faceImage = image;
                [self postVerifyWithFaceImage:_faceImage];
            };
            [self presentViewController:vc animated:YES completion:nil];

        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前账号未开启刷脸识别" message:@"前往 我的-当前账号-开启刷脸识别" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"验证失败失败 %@", error);
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
    }];
}


//上传图片验证
-(void)postVerifyWithFaceImage:(UIImage *)faceImage{
    UIApplication *ap = [UIApplication sharedApplication];

    hud = [MBProgressHUD showHUDAddedTo:ap.keyWindow animated:YES];
    hud.label.text = @"正在登录";
    
    NSString *url = [API stringByAppendingString:@"AddUser/face"];
    NSDictionary *dic = @{@"userPhone":_phoneNumber.text, @"deviceToken":[DEFAULT objectForKey:@"deviceToken"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        NSData *data=UIImagePNGRepresentation(image);
        NSData *data = UIImageJPEGRepresentation(faceImage, 0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        NSLog(@"上传图片成功 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                NSInteger confidence = [responseObject[@"confidence"] integerValue];
                if (confidence >= 85) {
                    
                    //初始化用户数据
                    [AppDelegate APP].user = [[User alloc] init];
                    [AppDelegate APP].user.userId = [responseObject objectForKey:@"userId"];
                    //登录返回的useId是用户登录的id，总店登录的时候会返回不同的userId
                    [AppDelegate APP].user.userLoginId = [responseObject objectForKey:@"userId"];
                    
                    [[AppDelegate APP].user setUserIfoWithNumber:[AppDelegate APP].user.number UserId:[AppDelegate APP].user.userId ShopId:[AppDelegate APP].user.shopId ShopName:[AppDelegate APP].user.shopName DLVServeice:[AppDelegate APP].user.dlvService ShopImg:[AppDelegate APP].user.shopImg UserLoginId:[AppDelegate APP].user.userLoginId];
                    
                    
                    
                    if ([_loginType isEqualToString:@"1"]) {
//                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        //设置登录方式
                        [DEFAULT setObject:@"1" forKey:@"LoginType"];

                        [self getMerchantInfor];

                    }
                    else{
                        
//                        SelectShopViewController *vc = [[SelectShopViewController alloc] init];
//                        [self presentViewController:vc animated:YES completion:nil];

                        //设置登录方式
                        [DEFAULT setObject:@"2" forKey:@"LoginType"];

                        //跳转选择商店页
                        [[AppDelegate APP] selectShopView];

                    }
                    
                }
                else{
                    [Util toastWithView:ap.keyWindow AndText:@"验证失败，请重新操作"];
                }
            }
            else{
                [Util toastWithView:ap.keyWindow AndText:@"验证失败，请重新操作"];
            }
        }
        else{
            [Util toastWithView:ap.keyWindow AndText:@"验证失败，请重新操作"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片失败 %@", error);
        [Util toastWithView:ap.keyWindow AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];

}


- (IBAction)CancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNumber resignFirstResponder];
}


//获取商家信息
-(void)getMerchantInfor{
    UIApplication *ap = [UIApplication sharedApplication];

    NSString *url = [API stringByAppendingString:@"Personal/personals"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取商家信息 %@", responseObject);
        NSLog(@"%@",responseObject);
        if (responseObject != nil) {
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


@end
