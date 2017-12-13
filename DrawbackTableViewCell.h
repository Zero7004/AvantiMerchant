//
//  DrawbackTableViewCell.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawbackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *disagreeBtn;     //不同意按钮
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;      //同意退款按钮


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refundReasonConsHeight;    //退款原因文本高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressConstraintHeight;   //地址文本高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *userName;       //用户姓名
@property (weak, nonatomic) IBOutlet UILabel *userPhone;      //用户电话
@property (weak, nonatomic) IBOutlet UITextView *refundRemark;  //退款原因
@property (weak, nonatomic) IBOutlet UITextView *userAddress;      //地址
@property (weak, nonatomic) IBOutlet UILabel *realTotalMoney; //总计
@property (weak, nonatomic) IBOutlet UILabel *orderNo;        //订单号
@property (weak, nonatomic) IBOutlet UILabel *createTime;     //下单时间

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *goodlist;
@property (strong, nonatomic) NSString *boxFee;                //餐盒费


@end
