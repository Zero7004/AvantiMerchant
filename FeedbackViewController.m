//
//  FeedbackViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*产品意见反馈*//

#import "FeedbackViewController.h"
#import "JFImagePickerController.h"
#import "WSPhotosBroseVC.h"
#import "MyFeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UINavigationControllerDelegate>{
    
    NSMutableArray<UIImage *> *_photosArray;
    MBProgressHUD *hud;

}

@property (weak, nonatomic) IBOutlet UIButton *questionBtn;    //配送问题按钮
@property (weak, nonatomic) IBOutlet UIButton *complaintBtn;   //投诉业务经理按钮
@property (weak, nonatomic) IBOutlet UIButton *suggestBtn;     //功能改善意见按钮
@property (weak, nonatomic) IBOutlet UIButton *otherBtn; //其他问题
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;      //提交按钮
@property (weak, nonatomic) IBOutlet UITextView *contentText;     //意见文本

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;   //图片

@property (nonatomic, strong) UILabel *placeHolderLabel;            
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;        //手机号码

@property (strong, nonatomic) NSString *feedtype;     //反馈类型

- (IBAction)questionBtnClick:(id)sender;
- (IBAction)complaintBtnClick:(id)sender;
- (IBAction)suggestBtnClick:(id)sender;
- (IBAction)otherBtnClick:(id)sender;


@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    _contentText.delegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _feedtype = @"";
    [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    [self intiView];
}

-(void)intiView{
    _questionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _questionBtn.layer.borderWidth = 1;
    _questionBtn.layer.cornerRadius = 5;
    _complaintBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _complaintBtn.layer.borderWidth = 1;
    _complaintBtn.layer.cornerRadius = 5;
    _suggestBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _suggestBtn.layer.borderWidth = 1;
    _suggestBtn.layer.cornerRadius = 5;
    _otherBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _otherBtn.layer.borderWidth = 1;
    _otherBtn.layer.cornerRadius = 5;
    _contentText.layer.borderWidth = 1;
    _contentText.layer.borderColor = NAV_COLOR.CGColor;
    _contentText.layer.cornerRadius = 7;
    _submitBtn.layer.cornerRadius = 7;
    
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.text = @"请详细描述问题";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_contentText addSubview:_placeHolderLabel];
}

- (void)initializeData {
    _photosArray = [NSMutableArray new];
    [_photosArray addObject:[UIImage imageNamed:@"photoadd"]];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_contentText resignFirstResponder];
    [_phoneNum resignFirstResponder];
    
    if (indexPath.row == 0) {
        MyFeedbackViewController *vc = [[MyFeedbackViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHolderLabel.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0 ){
        _placeHolderLabel.text = @"请详细描述问题";
    }
    else{
        _placeHolderLabel.text = @"";
    }
    
}

#pragma mark - collectionViewDelegate

//多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每组数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
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
    UIImage *img = _photosArray[indexPath.row];
    imgView.image = img;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_photosArray.count - 1 == indexPath.row) {
        //点击选择图片
        [self selectPic];
    }
    else{
        NSMutableArray *tmpArray = [NSMutableArray new];
        for (UIImage *img in _photosArray) {
            WSImageModel *model = [WSImageModel new];
            model.image = img;
            [tmpArray addObject:model];
        }
        
        WSPhotosBroseVC *vc = [WSPhotosBroseVC new];
        vc.imageArray = tmpArray;
        vc.showIndex = indexPath.row;
        //该回到那边改变了count的判断
        vc.completion = ^ (NSArray *array){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_photosArray removeAllObjects];
                [_photosArray addObjectsFromArray:array];
                //                [self refreshCollectionView];
                //                [_photosArray removeObjectAtIndex:_photosArray.count-1];
                //                [_photosArray addObject:[UIImage imageNamed:@"photoadd"]];
                [_collectionView reloadData];
                
            });
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH-80)/4, 80);
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
            
            NSInteger count = 4 - _photosArray.count;
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
    [_photosArray addObject:img];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    //    [self refreshCollectionView];
    [_collectionView reloadData];
    
}

- (IBAction)questionBtnClick:(id)sender {
    _questionBtn.layer.borderColor = NAV_COLOR.CGColor;
    _complaintBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _suggestBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _otherBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_questionBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_complaintBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_suggestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _feedtype = @"1";
    
}

- (IBAction)complaintBtnClick:(id)sender {
    _questionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _complaintBtn.layer.borderColor = NAV_COLOR.CGColor;
    _suggestBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _otherBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_questionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_complaintBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_suggestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _feedtype = @"2";

}

- (IBAction)suggestBtnClick:(id)sender {
    _questionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _complaintBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _suggestBtn.layer.borderColor = NAV_COLOR.CGColor;
    _otherBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_questionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_complaintBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_suggestBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _feedtype = @"3";

}

- (IBAction)otherBtnClick:(id)sender {
    _questionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _complaintBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _suggestBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _otherBtn.layer.borderColor = NAV_COLOR.CGColor;
    
    [_questionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_complaintBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_suggestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_otherBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    
    _feedtype = @"4";

}


//点击提交
-(void)submitBtnClick{
    if ([_feedtype isEqualToString:@""]) {
        [Util toastWithView:self.navigationController.view AndText:@"请选择反馈类型"];
        return ;
    }
    if ([_contentText.text isEqualToString:@""]) {
        [Util toastWithView:self.navigationController.view AndText:@"请描述您的意见"];
        return ;
    }
    if ([_phoneNum.text isEqualToString:@""]) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入您的手机号码"];
        return ;
    }
    if (_phoneNum.text.length != 11) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入正确的手机号码"];
        return ;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self postSubmitFeederbackWithQuestion:_contentText.text Phone:_phoneNum.text Feedtype:_feedtype];
}


//提交建议
-(void)postSubmitFeederbackWithQuestion:(NSString *)question Phone:(NSString *)phone Feedtype:(NSString *)feedtype{
    NSString *url = [API stringByAppendingString:@"Setshop/setfeedback"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId, @"question":question, @"phone":phone, @"feedtype":feedtype};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"提交建议%@", responseObject);
        [hud hideAnimated:YES];
        if (responseObject != nil) {
            NSString *res = @"";
            if (responseObject[@"res"] != nil && ![responseObject[@"res"] isKindOfClass:[NSNull class]]) {
                res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:self.navigationController.view AndText:@"反馈成功"];
                    if (responseObject[@"id"] != nil && ![responseObject[@"id"] isKindOfClass:[NSNull class]]) {
                        //上传图片
                        if (_photosArray.count > 1) {
                            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                            hud.label.text = @"正在上传图片";
                            [self postImageWithId:responseObject[@"id"]];
                        }
                    }
                }
                else{
                    [Util toastWithView:self.navigationController.view AndText:@"反馈失败"];
                    [hud hideAnimated:YES];
                }
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"反馈失败"];
                [hud hideAnimated:YES];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"提交建议失败 %@", error);
        [hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

//上传图片
-(void)postImageWithId:(NSString *)feedbackId{
    NSString *url = [API stringByAppendingString:@"AdminShop/feedupdimg"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        NSData *data=UIImagePNGRepresentation(image);
        for (int i = 0; i < _photosArray.count - 1; i++) {
            NSData *data = UIImageJPEGRepresentation(_photosArray[i], 0.7);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"编辑带图片 %@", responseObject);
//        [Util toastWithView:self.navigationController.view AndText:@"图片上传成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"编辑带图片失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"图片上传失败"];
        [hud hideAnimated:YES];
        
        return ;
    }];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
