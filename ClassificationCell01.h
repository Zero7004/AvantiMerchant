//
//  ClassificationCell01.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/30.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationCell01 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *addNewBtn;

@property (weak, nonatomic) IBOutlet UILabel *catName;
@property (weak, nonatomic) IBOutlet UILabel *FoodCount;

@end
