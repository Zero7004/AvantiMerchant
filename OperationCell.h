//
//  OperationCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsThums; //图片
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;      //价格
@property (weak, nonatomic) IBOutlet UITextView *goodsName;   //商品名称
@property (weak, nonatomic) IBOutlet UIButton *toTopBtn;      //置顶按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameHeight;
@property (weak, nonatomic) IBOutlet UILabel *stopLabel;

@end
