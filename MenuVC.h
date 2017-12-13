//
//  MenuVC.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuVC : UIViewController

@property (strong, nonatomic) NSString *menuStr;
@property (strong, nonatomic) UITableView *tableView;


typedef void(^SelectId_Menu)(NSString *selectId, NSString *selctName, NSString *selectPrice);
@property (nonatomic, copy) SelectId_Menu block;

typedef void(^select_Group)(NSMutableArray *selctGroup);
@property (nonatomic, copy) select_Group block_group;


@property (strong, nonatomic) NSMutableArray *selectGoods;   //选择的商品列表


@property (strong, nonatomic) NSArray *distopList;    //对应菜单下的商品列表

@property (strong, nonatomic) NSString *activeType;          //活动类型

@end
