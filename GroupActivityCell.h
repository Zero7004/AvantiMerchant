//
//  GroupActivityCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UITextField *num;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;

@end
