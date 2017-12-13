//
//  CompletedCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *requireTime;    //送达时间
@property (weak, nonatomic) IBOutlet UILabel *userName;       //用户姓名
@property (weak, nonatomic) IBOutlet UILabel *userPhone;      //用户电话
@property (weak, nonatomic) IBOutlet UITextView *userAddress; //用户地址
@property (weak, nonatomic) IBOutlet UILabel *distance;  //距离
@property (weak, nonatomic) IBOutlet UILabel *smallAdd;       //小计
@property (weak, nonatomic) IBOutlet UILabel *shopALLPayOut;  //商家活动支出
@property (weak, nonatomic) IBOutlet UILabel *serverMoney;    //平台服务费
@property (weak, nonatomic) IBOutlet UILabel *fnps;       //蜂鸟配送费
@property (weak, nonatomic) IBOutlet UILabel *plan;           //本单预计收入
@property (weak, nonatomic) IBOutlet UILabel *realityPay;     //实际收入
@property (weak, nonatomic) IBOutlet UILabel *payType;        //支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNo;        //订单号
@property (weak, nonatomic) IBOutlet UILabel *createTime;     //下单时间


@property (weak, nonatomic) IBOutlet UIButton *cellBtn;       //电话按钮
@property (weak, nonatomic) IBOutlet UIButton *daohangBtn;    //导航按钮
@property (weak, nonatomic) IBOutlet UITableView *tableView;  //菜单列表
@property (weak, nonatomic) IBOutlet UIImageView *daohangImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressConstraintHeight;      //地址高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHight;

@property (strong, nonatomic) NSArray *goodlist;
@property (strong, nonatomic) NSString *boxFee;                //餐盒费
@property (strong, nonatomic) NSString *dsm;                   //配送费

@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *tip;

@end
