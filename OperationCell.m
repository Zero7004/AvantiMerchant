//
//  OperationCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OperationCell.h"

@implementation OperationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _stopLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"选中方块-1"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"方块未选-1"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}

//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"方块未选-1"];
                    }
                }
            }
        }
    }

}



//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
