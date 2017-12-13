//
//  DeskCollectionViewCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeskCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteDeskBtn;       //删除按钮
@property (weak, nonatomic) IBOutlet UIButton *editDeskBtn;         //编辑按钮

@property (weak, nonatomic) IBOutlet UIImageView *deskImg;
@property (weak, nonatomic) IBOutlet UILabel *deskNum;
@property (weak, nonatomic) IBOutlet UILabel *deskName;
@property (weak, nonatomic) IBOutlet UILabel *deskType;
@property (weak, nonatomic) IBOutlet UILabel *deskPersonNum;
@property (weak, nonatomic) IBOutlet UILabel *reserveMoney;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editHeigth;

@end
