//
//  propertyCell03.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface propertyCell03 : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *shopPrice;   //价格
@property (weak, nonatomic) IBOutlet UITextField *goodsStock;  //库存
@property (weak, nonatomic) IBOutlet UISwitch *swichNumber;    //是否库存无限

@property (weak, nonatomic) IBOutlet UIButton *addBtn;   //添加多规格按钮

@end
