//
//  EditMerchandiseViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMerchandiseViewController : UIViewController

@property (strong, nonatomic) NSString *catId;              //选中的菜单ID
//@property (strong, nonatomic) NSString *menuStr;
@property (strong, nonatomic) NSMutableArray *goodList;     //食物列表
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSString *languageId;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSArray *dishesList;   //纯菜单列表


@end
