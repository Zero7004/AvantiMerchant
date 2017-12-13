//
//  StoreDisplayViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/12.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*门店展示*//

#import "StoreDisplayViewController.h"
#import "JFImagePickerController.h"
#import "WSPhotosBroseVC.h"
#import "UIImageView+WebCache.h"
#import "EnvironmentTipViewController.h"
#import "VideoTipViewController.h"
#import "LiveTipViewController.h"


@interface StoreDisplayViewController ()<UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UINavigationControllerDelegate>{

    NSMutableArray<UIImage *> *_photosArray;
    MBProgressHUD *hud;
    
}

@property (weak, nonatomic) IBOutlet UITextView *videoLinkText;  //视频链接
@property (weak, nonatomic) IBOutlet UITextView *liveLinkText;  //直播链接
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;      //确认按钮
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;     //图片容器

@property (strong, nonatomic) NSMutableArray *imgUrl;
@property (strong, nonatomic) NSMutableArray *delectId;
@property (strong, nonatomic) NSMutableArray *imgUrlId;



- (IBAction)environmentTipBtnClick:(id)sender;    //环境提示
- (IBAction)videoTipBtnClick:(id)sender;   //视频提示

- (IBAction)liveTipBtnClick:(id)sender;    //直播提示

@property  BOOL isFirst;    //第一次加载图片

@end

@implementation StoreDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    _isFirst = YES;
    
    _imgUrl = [NSMutableArray array];
    _delectId = [NSMutableArray array];
    _imgUrlId = [NSMutableArray array];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [self initView];
    
    //获取商家环境信息
    [self postShopEnvironmentInfo];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.collectionView reloadData];

}

-(void)initView{
    
    self.videoLinkText.layer.borderWidth = 1;
    self.videoLinkText.layer.borderColor = [NAV_COLOR CGColor];
    self.videoLinkText.layer.cornerRadius = 7;
    self.liveLinkText.layer.borderWidth = 1;
    self.liveLinkText.layer.borderColor = [NAV_COLOR CGColor];
    self.liveLinkText.layer.cornerRadius = 7;

    _confirmBtn.layer.cornerRadius = 7;//设置那个圆角的有多圆

}

- (void)initializeData {
    _photosArray = [NSMutableArray new];
    [_photosArray addObject:[UIImage imageNamed:@"upload"]];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_videoLinkText resignFirstResponder];
    [_liveLinkText resignFirstResponder];
}


//确认保存
-(void)confirmBtnClick{
    //判断图片大小是否都符合
    for (int i = 0; i < _photosArray.count - 1; i++) {
        UIImage *image = [[UIImage alloc] init];
        image = _photosArray[i];
        NSData *data = UIImageJPEGRepresentation(image, 1);
        NSLog(@"大小 = %lu", [data length]/1000);
        if ([data length]/1000 > 2 *1024) {
            [Util toastWithView:self.navigationController.view AndText:[NSString stringWithFormat:@"第%d张图片大图2M", i]];
            return ;
        }
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    //上传图片-- 一张一张上传
    for (int i = 0; i < _photosArray.count - 1; i++) {
        if ([_imgUrlId[i] isEqualToString:@"-1"]) {
//            hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"正在上传图片";
            [self postUpImage:_photosArray[i]];
        }
    }
    //更新数据
    if (_photosArray.count == 1) {
        [hud hideAnimated:YES];
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    [self postSetShopEnvironmentInfo];

//    [self.navigationController popViewControllerAnimated:YES];

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
    
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.frame.size.width - 20, 0, 20, 20)];
    delBtn.tag = indexPath.row;
    [delBtn setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
    [cell addSubview:delBtn];
    [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_photosArray.count == indexPath.row + 1) {
        delBtn.hidden = YES;
    }
    
    
    if (_isFirst) {
        if (_imgUrl.count > 0) {
            if (_imgUrl.count == indexPath.row) {
                UIImage *img = _photosArray[indexPath.row];
                imgView.image = img;
            }
            else{
                if (_imgUrl[indexPath.row][@"ImgUrl"] != nil && ![_imgUrl[indexPath.row][@"ImgUrl"] isKindOfClass:[NSNull class]]) {
                    if ([_imgUrl[indexPath.row][@""] isEqualToString:@"add"]) {
                        UIImage *img = _photosArray[indexPath.row];
                        imgView.image = img;
                    }
                    else{
                        NSString *url = [API_IMG stringByAppendingString:_imgUrl[indexPath.row][@"ImgUrl"]];
                        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"noimg"]];
                    }
                }
                else{
                    imgView.image = [UIImage imageNamed:@"noimg"];
                }
                
            }
        }
        else{
            UIImage *img = _photosArray[indexPath.row];
            imgView.image = img;
        }
    }
    else{
        UIImage *img = _photosArray[indexPath.row];
        imgView.image = img;
    }
    
    [_photosArray replaceObjectAtIndex:indexPath.row withObject:imgView.image];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_photosArray.count - 1 == indexPath.row) {
        //点击选择图片
        [self selectPic];
    }
    else{
        NSMutableArray *tmpArray = [NSMutableArray new];
//        for (UIImage *img in _photosArray) {
        for(int i = 0; i < _photosArray.count - 1; i++){
            UIImage *img;
            img = _photosArray[i];
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
                [_photosArray addObject:[UIImage imageNamed:@"upload"]];
//                [self refreshCollectionView];
                [_collectionView reloadData];
            });
        };
        [self.navigationController pushViewController:vc animated:YES];

    }
}

//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH-80)/3, (200-35)/2);
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

//删除图片
-(void)delBtnClick:(id)sender{
    _isFirst = NO;
    UIButton *btn = (UIButton *)sender;
    if (![_imgUrlId[btn.tag] isEqualToString:@"-1"]) {
        [_delectId addObject:_imgUrlId[btn.tag]];
    }
    [_imgUrlId removeObjectAtIndex:btn.tag];
    [_photosArray removeObjectAtIndex:btn.tag];
    if (_imgUrl.count > 0) {
        [_imgUrl removeObjectAtIndex:btn.tag];
    }
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
            
            NSInteger count = 6 - _photosArray.count;
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
    _isFirst = NO;

//    __weak typeof(self) weakself = self;
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *img = [UIImage imageWithCGImage:imageRef];
            dispatch_async(dispatch_get_main_queue(), ^{
//                [_photosArray addObject:img];
                [_photosArray insertObject:img atIndex:0];
                [_imgUrlId insertObject:@"-1" atIndex:0];
                [_imgUrl insertObject:@{@"ImgUrl":@"add"} atIndex:0];
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
    _isFirst = NO;
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    [_photosArray addObject:img];
    [_photosArray insertObject:img atIndex:0];
    [_imgUrlId insertObject:@"-1" atIndex:0];
    [_imgUrl insertObject:@{@"ImgUrl":@"add"} atIndex:0];
    [picker dismissViewControllerAnimated:YES completion:^{}];
//    [self refreshCollectionView];
    [_collectionView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)environmentTipBtnClick:(id)sender {
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    EnvironmentTipViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"environmentTip"];
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)videoTipBtnClick:(id)sender {
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    VideoTipViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"videoTip"];
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)liveTipBtnClick:(id)sender {
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    LiveTipViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"liveTip"];
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];

}


//获取商家环境信息
-(void)postShopEnvironmentInfo{
    NSString *url = [API stringByAppendingString:@"Setshop/environment"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取商家环境信息 %@", responseObject);
        
        if (responseObject != nil) {
            
            NSDictionary *UrlDic = responseObject[@"url"];
            if ([UrlDic objectForKey:@"video"] != nil && ![[UrlDic objectForKey:@"video"] isKindOfClass:[NSNull class]]) {
                _videoLinkText.text = [UrlDic objectForKey:@"video"];
            }
            else{
                _videoLinkText.text = @"";
            }
            if ([UrlDic objectForKey:@"zhibo"] != nil && ![[UrlDic objectForKey:@"zhibo"] isKindOfClass:[NSNull class]]) {
                _liveLinkText.text = [UrlDic objectForKey:@"zhibo"];
            }
            else{
                _liveLinkText.text = @"";
            }
 
            if (responseObject[@"lunbo"] != nil && ![responseObject[@"lunbo"] isKindOfClass:[NSNull class]]) {
                NSArray *imgUrlArray = responseObject[@"lunbo"];
                _imgUrl = [imgUrlArray mutableCopy];
                
                if (imgUrlArray.count != 0) {
                    [_photosArray removeAllObjects];
                    for (int i = 0; i < _imgUrl.count; i++) {
                        UIImageView *imgView = [[UIImageView alloc] init];
                        imgView.image = [UIImage imageNamed:@"noimg"];
                        [_photosArray addObject:imgView.image];
                        //添加id
                        [_imgUrlId addObject:_imgUrl[i][@"id"]];
                    }
                    [_photosArray addObject:[UIImage imageNamed:@"upload"]];
                }

            }
            else{
                _imgUrl = [@[] mutableCopy];
            }
            
            [self.collectionView reloadData];
            
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取信息失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家环境信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
    
}



//保存商家环境信息
-(void)postSetShopEnvironmentInfo{

    NSString *url = [API stringByAppendingString:@"Setshop/setEnvironment"];
    NSString *deleteId = @"";
    for (int i = 0; i < _delectId.count; i++) {
        if (i == 0) {
            deleteId = [NSString stringWithFormat:@"%@", _delectId[i]];
        }
        else
            deleteId = [NSString stringWithFormat:@"%@%@%@", deleteId, @",", _delectId[i]];
    }
    NSDictionary *data = @{@"shopId":[AppDelegate APP].user.shopId, @"zhibo":_liveLinkText.text, @"video":_videoLinkText.text};
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"data":[Util convertToJSONData:data], @"deleteId":deleteId };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"设置商家环境 %@", responseObject);
        [hud hideAnimated:YES];
//        [Util toastWithView:self.navigationController.view AndText:@"保存成功"];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"设置商家环境失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
    }];
    
}


//上传图片
-(void)postUpImage:(UIImage *)image{
    NSString *url = [API stringByAppendingString:@"Setshop/setEnvironment"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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

        NSData *data = UIImageJPEGRepresentation(image, 0.7);
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
//                [Util toastWithView:self.navigationController.view AndText:@"保存成功"];
//                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"设置商家环境失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];

    
}


@end
