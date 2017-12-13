//
//  EndActiveCell.h
//  AvantiMerchant
//
//  Created by long on 2017/12/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndActiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *activeType;
@property (weak, nonatomic) IBOutlet UILabel *validStartTime;
@property (weak, nonatomic) IBOutlet UILabel *validEndTime;

@end
