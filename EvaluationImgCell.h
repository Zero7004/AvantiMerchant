//
//  EvaluationImgCell.h
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluationImgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;  //用户名称
@property (weak, nonatomic) IBOutlet UILabel *createTime;  //评论时间
@property (weak, nonatomic) IBOutlet UILabel *tasteScore;  //口味
@property (weak, nonatomic) IBOutlet UILabel *warpScore;   //包装
@property (weak, nonatomic) IBOutlet UILabel *timeScore;   //配送

@property (weak, nonatomic) IBOutlet UILabel *avg; //评论等级

@property (weak, nonatomic) IBOutlet UITextView *content;  //评论内容
@property (weak, nonatomic) IBOutlet UITextView *goodslist;  //食物列表
@property (weak, nonatomic) IBOutlet UITextView *shopReplyContent; //商家回复内容
@property (weak, nonatomic) IBOutlet UILabel *days;   //商家回复天数 0为当天

@property (weak, nonatomic) IBOutlet UICollectionView *colectionView;  //图片容器

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIView *replyView;   //回复视图
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;  //举报按钮


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodslistHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopReplyContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ReplyBViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (nonatomic,strong) NSMutableArray *imageArray;  //图片数据


@property (weak, nonatomic) IBOutlet UIImageView *xin0;
@property (weak, nonatomic) IBOutlet UIImageView *xin1;
@property (weak, nonatomic) IBOutlet UIImageView *xin2;
@property (weak, nonatomic) IBOutlet UIImageView *xin3;
@property (weak, nonatomic) IBOutlet UIImageView *xin4;

@end
