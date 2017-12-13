//
//  goodListCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/18.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goodListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsNums;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
//@property (weak, nonatomic) IBOutlet UILabel *goodsAttrName;    //规格，口味等

@property (strong, nonatomic) UILabel *goodsAttrName;

@end
