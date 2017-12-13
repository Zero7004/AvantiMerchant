//
//  MyFeedbackTableViewCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFeedbackTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *feedtype;
@property (weak, nonatomic) IBOutlet UITextView *question;
@property (weak, nonatomic) IBOutlet UITextView *replay;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replayHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionHeight;
@end
