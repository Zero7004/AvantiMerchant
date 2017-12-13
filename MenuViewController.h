//
//  MenuViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController


@property (strong, nonatomic) NSString *catId;
@property (strong, nonatomic) NSString *catName;        //当前选中菜单名
@property (strong, nonatomic) NSString *languageId;     //使用语言的id
@property (strong, nonatomic) NSString *language;       //使用的语言
@property (strong, nonatomic) NSString *menuStr;
@property (strong, nonatomic) NSArray *goodList;     //食物列表
@property (strong, nonatomic) UITableView *tableView;



@end
