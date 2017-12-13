//
//  EndActiveTableVCCell.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndActiveTableVCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *name;      //活动名称
@property (weak, nonatomic) IBOutlet UILabel *state;     //活动状态
@property (weak, nonatomic) IBOutlet UILabel *allCount;  //总计订单
@property (weak, nonatomic) IBOutlet UILabel *allPay;    //总计流水
@property (weak, nonatomic) IBOutlet UILabel *lastCount;   //昨日订单
@property (weak, nonatomic) IBOutlet UILabel *lastPay;     //昨日流水
@property (weak, nonatomic) IBOutlet UILabel *activeType;   //活动类型
@property (weak, nonatomic) IBOutlet UILabel *activeRule;     //活动规则
@property (weak, nonatomic) IBOutlet UILabel *validStartTime; //开始时间
@property (weak, nonatomic) IBOutlet UILabel *validEndTime;   //结束时间


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width01;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width02;


@end
