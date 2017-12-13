//
//  AddEditViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEditViewController : UIViewController

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSMutableArray *guigeList; //规格列表
@property (strong, nonatomic) NSMutableArray *guigeAttr; //属性列表

@property (strong, nonatomic) NSString *shopPrice;    //价格
@property (strong, nonatomic) NSString *goodsStock;   //库存

typedef void(^guige)(NSMutableArray *guigeList);
@property (nonatomic, copy) guige block;


@end
