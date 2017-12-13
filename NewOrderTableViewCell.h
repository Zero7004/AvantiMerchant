//
//  NewOrderTableViewCell.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *address; //地址
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressConstraintHeight;  //地址高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;    //取消订单按钮
@property (weak, nonatomic) IBOutlet UIButton *mealsOnWheelsBtn; //送餐按钮

@property (weak, nonatomic) IBOutlet UILabel *requireTime;    //送达时间
@property (weak, nonatomic) IBOutlet UILabel *userName;       //用户姓名
@property (weak, nonatomic) IBOutlet UILabel *userPhone;      //用户电话
@property (weak, nonatomic) IBOutlet UITextView *userAddress; //用户地址
@property (weak, nonatomic) IBOutlet UILabel *distance;  //距离
@property (weak, nonatomic) IBOutlet UILabel *realTotalMoney; //总计
@property (weak, nonatomic) IBOutlet UILabel *orderNo;        //订单号
@property (weak, nonatomic) IBOutlet UILabel *createTime;     //下单时间

@property (weak, nonatomic) IBOutlet UIButton *cellBtn;       //电话按钮
@property (weak, nonatomic) IBOutlet UIButton *daohangBtn;    //导航按钮
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *goodlist;
@property (strong, nonatomic) NSString *boxFee;                //餐盒费

@property (weak, nonatomic) IBOutlet UILabel *orderType;  //订单类型

//林华加的，隐藏地址和2个button
@property (assign, nonatomic) BOOL isComp;

@end
