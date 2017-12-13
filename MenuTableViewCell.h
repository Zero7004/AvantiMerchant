//
//  MenuTableViewCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsThums;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *shopPrice;
@property (weak, nonatomic) IBOutlet UITextView *goodsName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameHeight;
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSort;

@end
