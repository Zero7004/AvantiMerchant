//
//  newActiveTableViewCell.h
//  AvantiMerchant
//
//  Created by Mac on 2017/9/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newActiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sub;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;   //新建按钮

@end
