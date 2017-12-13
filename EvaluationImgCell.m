//
//  EvaluationImgCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "EvaluationImgCell.h"
#import "XLPhotoBrowser.h"


@interface EvaluationImgCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

@end

@implementation EvaluationImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _replyBtn.layer.borderWidth = 1;
    _replyBtn.layer.borderColor = NAV_COLOR.CGColor;
    [_replyBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    
    _colectionView.delegate = self;
    _colectionView.dataSource = self;
    _colectionView.backgroundColor = [UIColor whiteColor];
    _colectionView.showsVerticalScrollIndicator = NO;
    _colectionView.showsHorizontalScrollIndicator = NO;
    // 取消弹簧效果
    _colectionView.bounces = NO;
    _colectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_colectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imagePickerCellIdentifier"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - collectionViewDelegate
//设置每组cell个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArray.count;
}
//设置多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagePickerCellIdentifier" forIndexPath:indexPath];
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        if (_imageArray.count == indexPath.row) {
            imgView.contentMode = UIViewContentModeScaleToFill;
        }
        else{
            imgView.contentMode = UIViewContentModeScaleAspectFill;
        }
        imgView.clipsToBounds = YES;
        imgView.tag = 1;
        [cell addSubview:imgView];
    }

    //加载图片
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_IMG,_imageArray[indexPath.row][@"img"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
    
    return cell;
}

//点击查看图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:indexPath.row imageCount:_imageArray.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleSimple;
    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式

}

//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((_colectionView.frame.size.width - 15)/4, _colectionView.frame.size.height);
}

//行之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//列之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}


#pragma mark    -   XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_IMG, _imageArray[index][@"img"]]];
}

//返回默认图片
//-(UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
//    return [UIImage imageNamed:smallImageUrl[index]];
//}

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    // do something yourself
    switch (actionSheetindex) {
        case 1: // 保存
        {
            //            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [browser saveCurrentShowImage];
        }
            break;
        default:
        {
            //            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
        }
            break;
    }
}


@end
