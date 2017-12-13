//
//  EditAttributeViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAttributeViewController : UIViewController

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSMutableArray *guigeAttr; //属性列表

//@property (strong, nonatomic) NSString *shopPrice;    //价格
//@property (strong, nonatomic) NSString *goodsStock;   //库存

typedef void(^Attribute)(NSMutableArray *AttributeArray);
@property (nonatomic, copy) Attribute block;


@end
