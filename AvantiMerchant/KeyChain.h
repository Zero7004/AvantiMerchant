//
//  KeyChain.h
//  KeyChain测试
//
//  Created by 王健龙 on 2017/10/31.
//  Copyright © 2017年 王健龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;


@end
