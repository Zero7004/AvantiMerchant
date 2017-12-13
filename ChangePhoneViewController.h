//
//  ChangePhoneViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhoneViewController : UIViewController

typedef void(^PhoneNum)(NSString *phone);
@property (nonatomic, copy) PhoneNum block;

@property (nonatomic, strong) NSString *phoneNum;

@end
