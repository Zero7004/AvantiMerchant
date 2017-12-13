//
//  ShopTableViewCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *line;

@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *shopSales; //月售
@property (weak, nonatomic) IBOutlet UILabel *delivery; //起送价，配送费


@end
