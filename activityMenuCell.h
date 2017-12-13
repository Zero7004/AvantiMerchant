//
//  activityMenuCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activityMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsThums;

@property (weak, nonatomic) IBOutlet UILabel *shopPrice;
@property (weak, nonatomic) IBOutlet UITextView *goodsName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameHeight;
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSort;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIButton *MultipleChoiceBtn; //团购活动多选按钮


@end
