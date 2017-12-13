//
//  AddMerchandiseViewController.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMerchandiseViewController : UITableViewController

@property (strong, nonatomic) NSString *type;    //类型

@property (strong, nonatomic) NSArray *languageList;    //语言列表
@property (strong, nonatomic) NSString *languageId;     //使用语言的id
@property (strong, nonatomic) NSString *language;       //使用的语言
@property (strong, nonatomic) NSArray *dishesList;      //纯菜单列表
@property (strong, nonatomic) NSString *catId;          //当前选中菜单的catId
@property (strong, nonatomic) NSString *catName;        //当前选中菜单名


@property (strong, nonatomic) NSMutableArray *guigeList; //规格列表
@property (strong, nonatomic) NSMutableArray *guigeAttr; //属性列表

@property (strong, nonatomic) NSDictionary *goods;    //编辑时传入的商品信息

@end
