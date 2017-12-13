//
//  EvaluateTopView.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateTopView : UIView

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *mediumBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;

@property (weak, nonatomic) IBOutlet UIButton *onlyLockBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLable;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
