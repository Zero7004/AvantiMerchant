//
//  EditDeskDetailViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*编辑细节*//

#import "EditDeskDetailViewController.h"
#import "JFImagePickerController.h"
#import "WSPhotosBroseVC.h"
#import "XLPhotoBrowser.h"
#import "SDWebImageManager.h"


@interface EditDeskDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource, VPImageCropperDelegate>{
    
    MBProgressHUD *hud;

}

@property (weak, nonatomic) IBOutlet UIImageView *deskImg;
@property (weak, nonatomic) IBOutlet UIButton *deskImgBtn;

@property (weak, nonatomic) IBOutlet UITextField *number;   //桌位号
@property (weak, nonatomic) IBOutlet UITextField *name;     //桌位名称
@property (weak, nonatomic) IBOutlet UISlider *peopleNumber; //用餐人数
@property (weak, nonatomic) IBOutlet UILabel *people_num;   //显示用餐人数
@property (weak, nonatomic) IBOutlet UITextField *price;    //价格
@property (weak, nonatomic) IBOutlet UIButton *scatteredBtn;    //散台
@property (weak, nonatomic) IBOutlet UIButton *boxBtn;          //包厢

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;   //取消按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) NSString *deskType;

- (IBAction)scatteredBtnClick:(id)sender;    //散台按钮
- (IBAction)boxBtn:(id)sender;               //包厢按钮
- (IBAction)cancelBtn:(id)sender;            //取消
- (IBAction)confirm:(id)sender;              //确定
- (IBAction)deskImgClick:(id)sender;         //点击图片


@end



@implementation EditDeskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self inittableView];
    [self initDeskInfo];
}

-(void)inittableView{
    _number.layer.borderColor= NAV_COLOR.CGColor;
    _number.layer.borderWidth= 1.0f;
    _name.layer.borderColor= NAV_COLOR.CGColor;
    _name.layer.borderWidth= 1.0f;
    _price.layer.borderColor= NAV_COLOR.CGColor;
    _price.layer.borderWidth= 1.0f;

    //边框设置
    _cancelBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
    _cancelBtn.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    _cancelBtn.layer.borderColor= [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;

    _confirmBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
    _confirmBtn.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    _confirmBtn.layer.borderColor= [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    

    [_peopleNumber addTarget:self action:@selector(sliderChange) forControlEvents:UIControlEventValueChanged];
    
    //添加图片长按按钮事件--长按为换图片，点击为查看图片
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deskImgBtnLong)];
//    longPress.minimumPressDuration = 0.8;
//    [self.deskImgBtn addGestureRecognizer:longPress];

}

//初始化数据
-(void)initDeskInfo{
    if ([_titleLable isEqualToString:@"编辑"]) {
        
        if (_dicDesk[@"deskImg"] != nil && ![_dicDesk[@"deskImg"] isKindOfClass:[NSNull class]]) {
            NSString *imgUrl = [API_IMG stringByAppendingString:_dicDesk[@"deskImg"]];
            [_deskImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"noimg"]];
            [_deskImgBtn setTitle:@"" forState:UIControlStateNormal];
        }
        else{
            [_deskImg setImage:[UIImage imageNamed:@"noimg"]];
        }
        
        if (_dicDesk[@"deskNum"] != nil && ![_dicDesk[@"deskNum"] isKindOfClass:[NSNull class]]) {
            _number.text = [NSString stringWithFormat:@"%@", _dicDesk[@"deskNum"]];
        }
        else{
            _number.text = @"";
        }
        
        if (_dicDesk[@"deskName"] != nil && ![_dicDesk[@"deskName"] isKindOfClass:[NSNull class]]) {
            _name.text = [NSString stringWithFormat:@"%@", _dicDesk[@"deskName"]];

        }
        else{
            _name.text = @"";
        }

        if (_dicDesk[@"deskType"] != nil && ![_dicDesk[@"deskType"] isKindOfClass:[NSNull class]]) {
            if ([_dicDesk[@"deskType"] isEqualToString:@"散台"]) {
                _deskType = @"散台";
                [_scatteredBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
                [_boxBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
            }
            else{
                _deskType = @"包厢";
                [_scatteredBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
                [_boxBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
            }
        }
        else{
            [_scatteredBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
            [_boxBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
        }

        if (_dicDesk[@"deskPersonNum"] != nil && ![_dicDesk[@"deskPersonNum"] isKindOfClass:[NSNull class]]) {
            _people_num.text = [NSString stringWithFormat:@"%@", _dicDesk[@"deskPersonNum"]];
            _peopleNumber.value = [_people_num.text intValue];
        }
        else{
            _people_num.text = [NSString stringWithFormat:@"%@", @"0"];
            _peopleNumber.value = 0;
        }

        if (_dicDesk[@"reserveMoney"] != nil && ![_dicDesk[@"reserveMoney"] isKindOfClass:[NSNull class]]) {
            _price.text = [NSString stringWithFormat:@"%@", _dicDesk[@"reserveMoney"]];
        }
        else{
            _price.text = @"";
        }

    }
    else{
        //添加桌位
        _peopleNumber.value = 1;
        _people_num.text = [NSString stringWithFormat:@"%d", (int)_peopleNumber.value];
        _deskType = @"散台";
        [_deskImgBtn setTitle:@"点击添加图片" forState:UIControlStateNormal];

    }
}


-(void)sliderChange{
    _people_num.text = [NSString stringWithFormat:@"%d", (int)_peopleNumber.value];
}

//上传数据
-(void)AddNewDesk{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_number resignFirstResponder];
    [_name resignFirstResponder];
    [_price resignFirstResponder];
}


- (IBAction)scatteredBtnClick:(id)sender {
    _deskType = @"散台";
    [_scatteredBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];
    [_boxBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    
}

- (IBAction)boxBtn:(id)sender {
    _deskType = @"包厢";
    [_scatteredBtn setImage:[UIImage imageNamed:@"勾号0"] forState:UIControlStateNormal];
    [_boxBtn setImage:[UIImage imageNamed:@"勾号1"] forState:UIControlStateNormal];

}


- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)confirm:(id)sender {
    [_number resignFirstResponder];
    [_name resignFirstResponder];
    [_peopleNumber resignFirstResponder];
    [_price resignFirstResponder];

    if (!(_number.text.length > 0)) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入桌位号码"];
        return ;
    }
    if (!(_name.text.length > 0)) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入桌位名称"];
        return ;
    }
    if (_peopleNumber.value == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"用餐人数不能为0"];
        return ;
    }
    if (!(_price.text.length > 0)) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入预定价格"];
        return ;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if ([_titleLable isEqualToString:@"编辑"]) {
        //上传编辑信息
        [self postEditDesk];
    }
    else{
        if ([AppDelegate APP].user.shopId == nil) {
            [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
            
            return ;
        }
        //判断是否有图片
        if (_deskImg.image != nil) {
            //带图片
            NSString *url = [API stringByAppendingString:@"Personal/addDesk"];
            NSDictionary *dic = @{@"deskNum":_number.text, @"deskName":_name.text, @"deskType":_deskType, @"deskPersonNum":_people_num.text, @"reserveMoney":_price.text};
            NSDictionary *data = @{@"shopId":[AppDelegate APP].user.shopId, @"data":[Util convertToJSONData:dic], @"change":@"1"};
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
            [manager POST:url parameters:data constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                //        NSData *data=UIImagePNGRepresentation(image);
                NSData *data = UIImageJPEGRepresentation(_deskImg.image, 0.7);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [hud hideAnimated:YES];
                self.block();
                [self.navigationController popViewControllerAnimated:YES];

                NSLog(@"上传图片 %@", responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"上传图片失败 %@", error);
                [Util toastWithView:self.view AndText:@"网络连接异常"];
                [hud hideAnimated:YES];

                return ;
            }];
        }
        else{
            //不带图片
            NSString *url = [API stringByAppendingString:@"Personal/addDesk"];
            NSDictionary *dic = @{@"deskNum":_number.text, @"deskName":_name.text, @"deskType":_deskType, @"deskPersonNum":_people_num.text, @"reserveMoney":_price.text};
            NSDictionary *data = @{@"shopId":[AppDelegate APP].user.shopId, @"data":[Util convertToJSONData:dic],  @"change":@"1"};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:url parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"添加桌位 %@", responseObject);
                [hud hideAnimated:YES];

                self.block();
                [self.navigationController popViewControllerAnimated:YES];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"添加桌位失败 %@", error);
                [Util toastWithView:self.view AndText:@"网络连接异常"];
                [hud hideAnimated:YES];

                return ;
            }];
            self.block();

        }

    }
    
}



//编辑桌位
-(void)postEditDesk{
    if (_deskImg.image == nil || [UIImagePNGRepresentation(_deskImg.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"noimg"])]) {
        //不带图片
        NSString *url = [API stringByAppendingString:@"Personal/editDesk"];
        NSDictionary *dic = @{@"deskNum":_number.text, @"deskName":_name.text, @"deskType":_deskType, @"deskPersonNum":_people_num.text, @"reserveMoney":_price.text};
        NSDictionary *data = @{@"shopId":[AppDelegate APP].user.shopId, @"data":[Util convertToJSONData:dic], @"id":_dicDesk[@"id"]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:url parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"编辑桌位 %@", responseObject);
            [hud hideAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [Util toastWithView:self.view AndText:@"网络连接异常"];
            [hud hideAnimated:YES];

            return ;
        }];
    }
    else{
        //带图片
        NSString *url = [API stringByAppendingString:@"Personal/editDesk"];
        NSDictionary *dic = @{@"deskNum":_number.text, @"deskName":_name.text, @"deskType":_deskType, @"deskPersonNum":_people_num.text, @"reserveMoney":_price.text};
        NSDictionary *data = @{@"shopId":[AppDelegate APP].user.shopId, @"data":[Util convertToJSONData:dic], @"id":_dicDesk[@"id"], @"change":@"1"};
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
        [manager POST:url parameters:data constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //        NSData *data=UIImagePNGRepresentation(image);
            NSData *data = UIImageJPEGRepresentation(_deskImg.image, 0.7);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hideAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];

            NSLog(@"编辑带图片 %@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"编辑带图片失败 %@", error);
            [Util toastWithView:self.view AndText:@"网络连接异常"];
            [hud hideAnimated:YES];

            return ;
        }];
        
    }


}





//点击图片
- (IBAction)deskImgClick:(id)sender {
//    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:1 datasource:self];
//    browser.browserStyle = XLPhotoBrowserStyleSimple;
//    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效
//    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    
    [self deskImgBtnLong];
}


//长按图片
-(void)deskImgBtnLong{
    UIAlertController *actionsheetController = [[UIAlertController alloc]init];
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate=self;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        
        else {
            
            [Util toastWithView:self.navigationController.view AndText:@"不支持相机"];
        }
    }];
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate=self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    
    [actionsheetController addAction: canceAction];
    [actionsheetController addAction:takePhotoAction];
    [actionsheetController addAction:selectAction];
    [self presentViewController:actionsheetController animated:true completion:nil];

}

//选择图片，获取图片源
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    //通过key值获取到图片
//        image =info[UIImagePickerControllerOriginalImage];
    //调用截图图片方法
    [self showEditImageController:info[UIImagePickerControllerOriginalImage]];
    
    //判断数据源类型
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        NSLog(@"在相机中选择图片");
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)showEditImageController:(UIImage *)image {
    CGFloat y = (self.view.bounds.size.height - self.view.bounds.size.width) / 2.0;
    VPImageCropperViewController *imageCropper = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, y-50, self.view.bounds.size.width, self.view.bounds.size.width) limitScaleRatio:3.0];
    imageCropper.delegate = self;
    [self.navigationController pushViewController:imageCropper animated:YES];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //    [self updateUserIcon:editedImage];
//    NSString *url = [UPLOAD_API stringByAppendingString:@"image/upload?key=cuckoo_eooker_cuckoo"];
//    NSDictionary *dict = @{@"key":@"cuckoo_eooker_cuckoo"};
//    [self uploadImages:url parameters:dict Image:editedImage];
    
    //获取选择的图片--处理后
    [_deskImg setImage:editedImage];
    [_deskImgBtn setTitle:@"" forState:UIControlStateNormal];

    [cropperViewController.navigationController popViewControllerAnimated:YES];
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}




#pragma mark    -   XLPhotoBrowserDatasource
//查看图片，添加图片源
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imgUrl = [API_IMG stringByAppendingString:_dicDesk[@"deskImg"]];
    return [NSURL URLWithString:imgUrl];
}

//查看图片，点击保存
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
