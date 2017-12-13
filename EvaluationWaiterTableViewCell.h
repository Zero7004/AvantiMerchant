//
//  EvaluationWaiterTableViewCell.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationWaiterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *point;

@end
