//
//  ScanTableViewCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/28.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *name;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;
@end
