//
//  DeskCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/10.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeskCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelDeskBtn;

@property (weak, nonatomic) IBOutlet UILabel *deskNum;
@property (weak, nonatomic) IBOutlet UILabel *deskName;
@property (weak, nonatomic) IBOutlet UILabel *deskType;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *reachTime;

@end
