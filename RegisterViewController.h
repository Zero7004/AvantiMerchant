//
//  RegisterViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (nonatomic, strong) NSString *loginType;

@property (strong, nonatomic) MBProgressHUD *hud;

-(void)postLoginWithUrl:(NSString *)url Parameters:(id)parameters;

//typedef void(^changPhoneLogin)(void);
//@property (nonatomic, copy) changPhoneLogin block;


@end
