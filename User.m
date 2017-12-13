//
//  User.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "User.h"

@implementation User

-(void)setUserIfoWithNumber:(NSString *) number UserId:(NSString *)userId ShopId:(NSString *)shopId ShopName:(NSString *)shopName DLVServeice:(NSString *)dlvService ShopImg:(NSString *)shopImg UserLoginId:(NSString *)userLoginId{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    [accountDefaults setObject:number forKey:@"number"];
    [accountDefaults setObject:userId forKey:@"userId"];
    [accountDefaults setObject:shopId forKey:@"shopId"];
    [accountDefaults setObject:shopName forKey:@"shopName"];
    [accountDefaults setObject:dlvService forKey:@"dlvService"];
    [accountDefaults setObject:shopImg forKey:@"shopImg"];
    [accountDefaults setObject:userLoginId forKey:@"userLoginId"];

}


-(void)getUserInfo{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    _number = [accountDefaults objectForKey:@"number"];
    _userId = [accountDefaults objectForKey:@"userId"];
    _shopId = [accountDefaults objectForKey:@"shopId"];
    _shopName = [accountDefaults objectForKey:@"shopName"];
    _dlvService = [accountDefaults objectForKey:@"dlvService"];
    _shopImg = [accountDefaults objectForKey:@"shopImg"];
    _userLoginId = [accountDefaults objectForKey:@"userLoginId"];
}


-(void)cleanUserInfo{
    _number = nil;
    _userId = nil;
    _shopId = nil;
    _shopName = nil;
    _dlvService = nil;
    _shopImg = nil;
    _userLoginId = nil;
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    [accountDefaults removeObjectForKey:@"number"];
    [accountDefaults removeObjectForKey:@"userId"];
    [accountDefaults removeObjectForKey:@"shopId"];
    [accountDefaults removeObjectForKey:@"shopName"];
    [accountDefaults removeObjectForKey:@"dlvService"];
    [accountDefaults removeObjectForKey:@"shopImg"];
    [accountDefaults removeObjectForKey:@"userLoginId"];

}



@end
