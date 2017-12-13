//
//  MerchantsMemberOrderTableViewCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantsMemberOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *payType;

@end
