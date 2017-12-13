//
//  ReportViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ReportViewController.h"
#import "JFImagePickerController.h"
#import "WSPhotosBroseVC.h"
#import "UIImageView+WebCache.h"


@interface ReportViewController ()<UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UINavigationControllerDelegate, UITextViewDelegate>{

    NSMutableArray<UIImage *> *_photosArray;
    MBProgressHUD *hud;

}

@property (weak, nonatomic) IBOutlet UIButton *btn01;
@property (weak, nonatomic) IBOutlet UIButton *btn02;
@property (weak, nonatomic) IBOutlet UIButton *btn03;
@property (weak, nonatomic) IBOutlet UIButton *btn04;
@property (weak, nonatomic) IBOutlet UIButton *btn05;
@property (weak, nonatomic) IBOutlet UIButton *btn06;

@property (strong, nonatomic) NSString *reportType;
@property (weak, nonatomic) IBOutlet UITextView *describeText;   //问题描述
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;   //提交按钮

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"阿凡提商家";
    _reportType = @"";
    _describeText.delegate = self;
    _describeText.layer.borderWidth = 1;
    _describeText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btn01 addTarget:self action:@selector(btn01Click) forControlEvents:UIControlEventTouchUpInside];
    [_btn02 addTarget:self action:@selector(btn02Click) forControlEvents:UIControlEventTouchUpInside];
    [_btn03 addTarget:self action:@selector(btn03Click) forControlEvents:UIControlEventTouchUpInside];
    [_btn04 addTarget:self action:@selector(btn04Click) forControlEvents:UIControlEventTouchUpInside];
    [_btn05 addTarget:self action:@selector(btn05Click) forControlEvents:UIControlEventTouchUpInside];
    [_btn06 addTarget:self action:@selector(btn06Click) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    // 取消弹簧效果
    _collectionView.bounces = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imagePickerCellIdentifier"];
    
    [self initializeData];
    
    //添加textview的place属性
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, _describeText.frame.size.width, 30)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.numberOfLines = 0;
    _placeHolderLabel.text = @"请详细描述问题，最多300字";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    
    [_describeText addSubview:_placeHolderLabel];

}

- (void)initializeData {
    _photosArray = [NSMutableArray new];
    [_photosArray addObject:[UIImage imageNamed:@"photoadd"]];
}


//提交按钮
-(void)submitBtnClick{
    if ([_reportType isEqualToString:@""]) {
        [Util toastWithView:self.view AndText:@"请选择恶意评价类型"];
        return ;
    }
    if ([_describeText.text isEqualToString:@""]) {
        [Util toastWithView:self.view AndText:@"请详细描述问题"];
        return ;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    //提交举报
    [self postReportWithID:_commentId];
}


-(void)btn01Click{
    [_btn01 setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
    [_btn02 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn03 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn04 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn05 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn06 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];

    _reportType = @"泄露隐私";
}

-(void)btn02Click{
    [_btn01 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn02 setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
    [_btn03 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn04 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn05 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn06 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];

    _reportType = @"存在不文明用语";

}

-(void)btn03Click{
    [_btn01 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn02 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn03 setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
    [_btn04 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn05 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn06 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];

    _reportType = @"以差评谋求不正当利益";

}

-(void)btn04Click{
    [_btn01 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn02 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn03 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn04 setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
    [_btn05 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn06 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];

    _reportType = @"敏感或违法信息";

}

-(void)btn05Click{
    [_btn01 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn02 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn03 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn04 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn05 setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
    [_btn06 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];

    _reportType = @"同行恶意评价";

}

-(void)btn06Click{
    [_btn01 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn02 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn03 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn04 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn05 setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_btn06 setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];

    _reportType = @"广告或垃圾信息";

}




#pragma mark - collectionViewDelegate

//多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每组数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photosArray.count > 4) {
        return 4;
    }
    else
        return _photosArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagePickerCellIdentifier" forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        if (_photosArray.count-1 == indexPath.row) {
            imgView.contentMode = UIViewContentModeScaleToFill;
        }
        else{
            imgView.contentMode = UIViewContentModeScaleAspectFill;
        }
        imgView.clipsToBounds = YES;
        imgView.tag = 1;
        [cell addSubview:imgView];
    }
    
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.frame.size.width - 20, 0, 20, 20)];
    delBtn.tag = indexPath.row;
    [delBtn setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
    [cell addSubview:delBtn];
    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img = _photosArray[indexPath.row];
    imgView.image = img;
    
    if (_photosArray.count <= 4) {
        if (_photosArray.count == indexPath.row + 1) {
            delBtn.hidden = YES;
        }
        else{
            delBtn.hidden = NO;
        }
    }

    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_photosArray.count <= 4) {
        [self selectPic];
    }

}

//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((collectionView.frame.size.width - 30)/4, (collectionView.frame.size.width - 30)/4);
}

//行之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//列之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0 ){
        _placeHolderLabel.text = @"请详细描述问题，最多300字";
    }
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = @"请详细描述问题，最多300字";
    }
    else{
        _placeHolderLabel.text = @"";
    }
    
    if (textView.text.length > 300) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"最多输入300字" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:cancelAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
}

//删除图片
-(void)delBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [_photosArray removeObjectAtIndex:btn.tag];
    [self.collectionView reloadData];
}



//选择图片
-(void)selectPic{
    UIAlertController *actionsheetController = [[UIAlertController alloc]init];
    UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *vc = [UIImagePickerController new];
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
            vc.delegate = self;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            
        }
        
        else {
            
            [Util toastWithView:self.view AndText:@"不支持相机"];
        }
    }];
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            NSInteger count = 5 - _photosArray.count;
            [JFImagePickerController setMaxCount:count];
            JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
            picker.pickerDelegate = self;
            [self.navigationController presentViewController:picker animated:YES completion:nil];
            
        }
    }];
    
    [actionsheetController addAction: canceAction];
    [actionsheetController addAction:takePhotoAction];
    [actionsheetController addAction:selectAction];
    [self presentViewController:actionsheetController animated:true completion:nil];
}

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    
//    __weak typeof(self) weakself = self;
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [_photosArray addObject:img];
                [_photosArray insertObject:img atIndex:0];
//                [weakself refreshCollectionView];
                [_collectionView reloadData];
            });
        }];
    }
    [self imagePickerDidCancel:picker];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}


#pragma  mark - imagePickerController Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self imageHandleWithpickerController:picker MdediaInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imageHandleWithpickerController:(UIImagePickerController *)picker MdediaInfo:(NSDictionary *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [_photosArray addObject:img];
    [_photosArray insertObject:img atIndex:0];
    [picker dismissViewControllerAnimated:YES completion:^{}];
//    [self refreshCollectionView];
    [_collectionView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma  mark - 接口
-(void)postReportWithID:(NSString *)commentId{
    NSString *url = [API stringByAppendingString:@"setshop/report"];
    NSDictionary *dic = @{@"content":_describeText.text, @"reason":_reportType, @"shopId":[AppDelegate APP].user.shopId, @"pid":commentId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"提交举报 %@", responseObject);
        [hud hideAnimated:YES];
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
//                [Util toastWithView:self.view AndText:@"提交成功"];

                //上传图片
                NSString *reportId = [NSString stringWithFormat:@"%@", responseObject[@"reportId"]];
                if (_photosArray.count > 1) {
                    for (int i = 0; i < _photosArray.count - 1; i++) {
                        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.label.text = @"正在上传图片";
                        [self postPictureWithReportId:reportId AddImg:_photosArray[i]];
//                        [hud hideAnimated:YES];

                    }
                }
                
            }
            else{
                [Util toastWithView:self.view AndText:@"提交失败"];

            }

        }
        else{
            [Util toastWithView:self.view AndText:@"提交失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"提交举报失败 %@", error);
        [hud hideAnimated:YES];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}



//上传图片
-(void)postPictureWithReportId:(NSString *)reportId AddImg:(UIImage *)img{
    NSString *url = [API_ReImg stringByAppendingString:@"Setshop/reportImg"];
//    NSString *url = @"https://www.aftdc.com/index.php/Wxapp/Setshop/reportImg";
    NSDictionary *dic = @{@"reportId":reportId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *data=UIImagePNGRepresentation(image);
        NSData *data = UIImageJPEGRepresentation(img, 0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        NSLog(@"上传图片 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"上传成功"];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"上传失败"];
            }
            

        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"上传失败"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片上传失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];

    
    
}






@end
