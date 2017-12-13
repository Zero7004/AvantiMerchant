//
//  NewOrdersViewController.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrdersViewController : UITableViewController


@property (nonatomic, strong) NSArray *orderArray;    //新订单列表
@property BOOL isRefresh;
@property (nonatomic, getter=isLoading)BOOL loading;

//@property (strong, nonatomic) UITableView *tableView;

@end
