//
//  Config.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#ifndef Config_h
#define Config_h
#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define NAV_COLOR [UIColor colorWithRed:38/255.0 green:154/255.0 blue:245/255.0 alpha:1]
#define NAV_COLOR [UIColor colorWithRed:87/255.0 green:190/255.0 blue:174/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define Border_COLOR [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1]
#define CELLBG_COLOR [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]
#define SELECTColor [UIColor colorWithRed:23/255.0 green:249/255.0 blue:219/255.0 alpha:1]

#define Nav_color [UIColor colorWithRed:87/255.0 green:190/255.0 blue:174/255.0 alpha:1]

#define BorderC = [UIColor colorWithRed:217/255.0 green:122/255.0 blue:0 alpha:1]


#define DEFAULT [NSUserDefaults standardUserDefaults]

#define KEY_Server @"AvantiMerchant.app.user"

#define Point CGPointMake(self.frame.size.width/2 , self.frame.size.height/2)

#define API @"https://www.aftdc.com/index.php/Wxapp/"
#define API_IMG @"https://www.aftdc.com/"
#define API_REPLY @"https://www.aftdc.com/index.php/Home/"
#define API_ReImg @"https://www.aftdc.com/index.php/Wxapp/"

//宏定义
//#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define FONT_SIZE(size) ([UIFont systemFontOfSize:FontSize(size))

#endif /* Config_h */


