//
//  WTPayManager.m
//  AvantiMerchant
//
//  Created by long on 2017/12/13.
//  Copyright © 2017年 Mac. All rights reserved.
//


//////**支付集成**/////

#import "WTPayManager.h"
#import <AlipaySDK/AlipaySDK.h>

@interface WTPayManager (){
    MBProgressHUD *hud;
}

@end

@implementation WTPayManager

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"avantiMerchant";
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"正在生成支付订单";

    //调用接口获取订单信息
    [self postOrderStringWithappScheme:appScheme];
    
//    NSString *orderString = @"app_id=2017021705714622&timestamp=2016-07-29+16%3A55%3A53&biz_content=%7B%22timeout_express%22%3A%2230m%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22total_amount%22%3A%220.01%22%2C%22subject%22%3A%221%22%2C%22body%22%3A%22%E6%88%91%E6%98%AF%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%22%2C%22out_trade_no%22%3A%22121314083713646%22%7D&method=alipay.trade.app.pay&charset=utf-8&version=1.0&sign_type=RSA2&sign=PS2Lup9qxCEFRFdg8wNIqBhzUBPmyzv%2BUcTSkD2y2sjPTJt%2BMFGnf83cTaZeHoYY3OgR2RSbrSnyfTmPDMipTtLb8fBVy2MV6iCofb6OXeTVik3k7rtoMs%2BYzqgD02yiddzNyMGOkh%2Fl%2B7LhUd9FxAe02rJvF9PBxQucmXiwoT0io3XrSRUfh7BJBEP5Nq9Qi99GzK6kyPopnMQAc5JLhEhdIwvz2nfGIr9%2FPERSNyHciTkhiHOmxSZAsbBYunIzzP0tOg8pG5XdhyubszrkQdu%2FdbPxdhsh5t5lRF%2BHS92UykuVbjW40eJc%2FOcOzWbXw1WgQ5HN2Kx3fvgO8UqY%2BA%3D%3D";
//
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
//    }];
}


#pragma mark === 获取支付订单信息 ===

-(void)postOrderStringWithappScheme:(NSString *)appScheme{
    NSString *url = @"https://www.aftdc.com/Wxapp/Alipay/appAlipay";
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取支付订单 %@", responseObject);
        [hud hideAnimated:YES];
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                NSString *orderString = [NSString stringWithFormat:@"%@", responseObject[@"code"]];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"订单生成失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"订单生成失败"];
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取支付订单失败 %@", error);
        [hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
