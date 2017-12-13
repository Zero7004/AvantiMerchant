//
//  WithdrawTableViewCell.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *money;        //金额
@property (weak, nonatomic) IBOutlet UILabel *cashSatus;    //状态
@property (weak, nonatomic) IBOutlet UILabel *createTime;   //提现时间
@property (weak, nonatomic) IBOutlet UILabel *tip;          //入账时间

@end
