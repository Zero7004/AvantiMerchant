//
//  EditDeskDetailViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDeskDetailViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *dicDesk;
@property (nonatomic, strong) NSString *titleLable;

typedef void(^GetData)(void);
@property (nonatomic, copy) GetData block;

@end
