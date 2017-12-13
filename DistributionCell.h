//
//  DistributionCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistributionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UITextField *content;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Wlayout;

@end
