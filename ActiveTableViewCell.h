//
//  ActiveTableViewCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/18.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *activeStste;   //活动状态

@property (weak, nonatomic) IBOutlet UILabel *name;      //活动名称
@property (weak, nonatomic) IBOutlet UILabel *allCount;  //
@property (weak, nonatomic) IBOutlet UILabel *allPay;    //
@property (weak, nonatomic) IBOutlet UILabel *lastCount;   //
@property (weak, nonatomic) IBOutlet UILabel *lastPay;     //
@property (weak, nonatomic) IBOutlet UILabel *activeType;   //活动类型
@property (weak, nonatomic) IBOutlet UILabel *activeRule;     //活动规则
@property (weak, nonatomic) IBOutlet UILabel *validStartTime; //开始时间
@property (weak, nonatomic) IBOutlet UILabel *validEndTime;   //结束时间

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width01;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width02;

@property (weak, nonatomic) IBOutlet UITableView *goodsNameTableView;
@property (strong, nonatomic) NSArray *goodsName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TableViewHeight;

@end
