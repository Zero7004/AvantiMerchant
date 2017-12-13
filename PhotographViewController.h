//
//  PhotographViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotographViewController : UIViewController

typedef void(^Face)(UIImage *image);
@property (nonatomic, copy) Face block;

@end
