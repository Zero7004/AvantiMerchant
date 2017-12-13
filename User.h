//
//  User.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *number;       //账号
@property (strong, nonatomic) NSString *password;     //密码
@property (strong, nonatomic) NSString *userId;       //用户id
@property (strong, nonatomic) NSString *shopName;     //商家名字
@property (strong, nonatomic) NSString *shopId;       //商家店铺ID
@property (strong, nonatomic) NSString *dlvService;   //配送方式
@property (strong, nonatomic) NSString *shopImg;      //商家头像Url
@property (strong, nonatomic) NSString *userLoginId;  //用户登录id



-(void)setUserIfoWithNumber:(NSString *) number UserId:(NSString *)userId ShopId:(NSString *)shopId ShopName:(NSString *)shopName DLVServeice:(NSString *)dlvService ShopImg:(NSString *)shopImg UserLoginId:(NSString *)userLoginId;


//取出用户信息
-(void)getUserInfo;

//清除用户信息
-(void)cleanUserInfo;


@end
