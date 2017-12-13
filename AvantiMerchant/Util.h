//
//  Util.h
//  Vesstack2.0
//
//  Created by 陈德锋 on 16/4/30.
//  Copyright © 2016年 xcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (void)toastWithView:(UIView *)view AndText:(NSString *)text;

+ (void)toastWithView:(UIView *)view AndPoint:(CGPoint*)point AndText:(NSString *)text;


//URL解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

+ (NSString *)encodeParameter:(NSString *)originalUrl;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)convertToJSONData:(id)infoDict;

+ (NSString *)arrayToJSONString:(NSArray *)array;

+(CGFloat)countTextHeight:(NSString *) text;

+(CGFloat)countTextHeight:(NSString *) text Font:(UIFont *)font;

+(UIImage*) createImageWithColor:(UIColor*) color;

-(void)determinateNSProgress:(UIView *)view :(NSInteger)totalUnitCount;

+(NSURL *) getSmallImage:(NSString *)url;

+(NSString *)isKindOfNull:(NSString *)string;

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

+(NSString *)TimeDifference:(NSString *)statusTime;

+(NSString *)getNowTime;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

+ (BOOL)valiMobile:(NSString *)mobile;

+ (BOOL )isValidateEmail:(NSString *)email;


@end
