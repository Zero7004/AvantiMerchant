//
//  TipViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

typedef void(^Report)(BOOL isReport);
@property (nonatomic, copy) Report block;


@end
