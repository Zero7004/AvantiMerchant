//
//  InProgressViewController.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InProgressViewController : UIViewController

@property (strong, nonatomic) NSArray *dictGoon;     //进行中订单
@property (strong,nonatomic) UITableView *tableView;
@property BOOL isRefresh;

@property (nonatomic, getter=isLoading)BOOL loading;

@end
