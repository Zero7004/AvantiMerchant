//
//  registrationShopViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/23.
//  Copyright © 2017年 Mac. All rights reserved.
//

////***注册新店***/////

#import "registrationShopViewController.h"
#import "JFImagePickerController.h"
#import "WSPhotosBroseVC.h"
#import "UIImageView+WebCache.h"
#import "AddressPickerView.h"
#import "JSBridgeVC.h"
#import "WTPayManager.h"

@interface registrationShopViewController ()<UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UINavigationControllerDelegate,AddressPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{

    NSMutableArray<UIImage *> *_photosArrayFirst;
    NSMutableArray<UIImage *> *_photosArraySecond;

    MBProgressHUD *hud;

}

@property NSInteger selectImageTag;
@property (nonatomic, strong) AddressPickerView * pickerView;
@property (nonatomic, strong) UIView *CookingView;                //菜系选择视图
@property (nonatomic, strong) UIPickerView * CookingPickerView;   //菜系选择器
@property (nonatomic, strong) NSArray *CookingArray;              //菜系列表
@property (nonatomic, strong) NSString *CookingStr;               //选中的菜系
@property NSInteger selectCookingTag;                             //选中index


@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewFirst;      //证件照
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewSecond;     //身份照
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;                //选择地址
@property (weak, nonatomic) IBOutlet UIButton *SelectAddressBtn; //地图选择地址

@property (weak, nonatomic) IBOutlet UIButton *distributionType;          //配送方式
@property (weak, nonatomic) IBOutlet UIButton *StyleCooking;              //菜系分类

@property (weak, nonatomic) IBOutlet UITextField *shopName;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *shopAddress;   //详细地址
@property (weak, nonatomic) IBOutlet UITextField *acreage;
@property (weak, nonatomic) IBOutlet UITextField *weburl;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (nonatomic, strong) NSString *province;     //省份
@property (nonatomic, strong) NSString *city;         //市份
@property (nonatomic, strong) NSString *county;       //县/区份

@property (nonatomic, strong) NSDictionary *AddressDic;  //地址信息

@property (weak, nonatomic) IBOutlet UIButton *submit; //提交

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight2;

@end

@implementation registrationShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"阿凡提商家";
    _CookingArray = [[NSArray alloc] init];
    _AddressDic = [[NSDictionary alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    _codeBtn.layer.cornerRadius = 5;
    [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _shopName.delegate = self;
    _userName.delegate = self;
    _shopAddress.delegate = self;
    _phone.delegate = self;
    _code.delegate = self;
    _acreage.delegate = self;
    _weburl.delegate = self;
    _email.delegate = self;
    
    [self initUICollectionView];
    //地址选择器
    [self pickerView];
    //菜系选择器
    [self initCookingPickerView];
    
    [_addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_SelectAddressBtn addTarget:self action:@selector(SelectAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_distributionType addTarget:self action:@selector(distributionTypeSelect) forControlEvents:UIControlEventTouchUpInside];
    _StyleCooking.tag = -1;
    [_StyleCooking addTarget:self action:@selector(StyleCookingSelect) forControlEvents:UIControlEventTouchUpInside];
    [_submit addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _submit.backgroundColor = NAV_COLOR;
    
    //获取菜系信息
    [self postCooking];
    
}

-(void)keyboardDismiss{
    [_shopName resignFirstResponder];
    [_userName resignFirstResponder];
    [_phone resignFirstResponder];
    [_code resignFirstResponder];
    [_shopAddress resignFirstResponder];
    [_acreage resignFirstResponder];
    [_weburl resignFirstResponder];
    [_email resignFirstResponder];
}


-(void)initUICollectionView{
    _collectionViewFirst.delegate = self;
    _collectionViewFirst.dataSource = self;
    _collectionViewFirst.showsVerticalScrollIndicator = NO;
    _collectionViewFirst.showsHorizontalScrollIndicator = NO;
    // 取消弹簧效果
    _collectionViewFirst.bounces = NO;
    _collectionViewFirst.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionViewFirst registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imagePickerCellIdentifier"];
    
    _collectionViewSecond.delegate = self;
    _collectionViewSecond.dataSource = self;
    _collectionViewSecond.showsVerticalScrollIndicator = NO;
    _collectionViewSecond.showsHorizontalScrollIndicator = NO;
    // 取消弹簧效果
    _collectionViewSecond.bounces = NO;
    _collectionViewSecond.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionViewSecond registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imagePickerCellIdentifier"];
    
    //添加初始化图片
    [self initializeData];
    
}

//创建地址选择器
- (AddressPickerView *)pickerView{
    
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
        _pickerView.delegate = self;
        // 关闭默认支持打开上次的结果
//        _pickerView.isAutoOpenLast = YES;
    }
    return _pickerView;
}

//创建菜系选择器
-(void)initCookingPickerView{
    _CookingView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
    
    //创建标题
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    titleView.backgroundColor = NAV_COLOR;
    //标题按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(CookingCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 0, 70, 50)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(CookingConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [titleView addSubview:cancelBtn];
    [titleView addSubview:confirmBtn];
    
    //创建菜系选择器
    _CookingPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 200)];
    _CookingPickerView.backgroundColor = [UIColor whiteColor];
    _CookingPickerView.delegate = self;
    _CookingPickerView.dataSource = self;
    
    [_CookingView addSubview:titleView];
    [_CookingView addSubview:_CookingPickerView];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.view addSubview:_pickerView];
    [self.navigationController.view addSubview:_CookingView];

}

-(void)viewWillDisappear:(BOOL)animated{
    [_pickerView removeFromSuperview];
    [_CookingView removeFromSuperview];
}

- (void)initializeData {
    _photosArrayFirst = [NSMutableArray new];
    [_photosArrayFirst addObject:[UIImage imageNamed:@"photoadd"]];
    
    _photosArraySecond = [NSMutableArray new];
    [_photosArraySecond addObject:[UIImage imageNamed:@"photoadd"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 11) {
        if (SCREEN_WIDTH == 320) {
            _collectionViewHeight1.constant = _collectionViewHeight1.constant - 5;
            return 165 - 10;
        }
        else if (SCREEN_WIDTH == 375){
            return 165;
        }
        else{
            return 165;
        }
    }
    else if (indexPath.row == 12){
        if (SCREEN_WIDTH == 320) {
            _collectionViewHeight2.constant = _collectionViewHeight2.constant - 5;
            return 165 - 10;
        }
        else if (SCREEN_WIDTH == 375){
            return 165;
        }
        else{
            return 165;
        }    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.pickerView hide];
    [self CookingCancelBtnClick];
}

#pragma mark - collectionViewDelegate
//多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每组数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == _collectionViewFirst) {
        if (_photosArrayFirst.count > 4) {
            return 4;
        }
        else
            return _photosArrayFirst.count;
    }
    else{
        
        if (_photosArraySecond.count > 4) {
            return 4;
        }
        else
            return _photosArraySecond.count;

    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == _collectionViewFirst) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagePickerCellIdentifier" forIndexPath:indexPath];
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
        if (!imgView) {
            imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
            if (_photosArrayFirst.count-1 == indexPath.row) {
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
        delBtn.tag = indexPath.row + 1000;
        [delBtn setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
        [cell addSubview:delBtn];
        [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = _photosArrayFirst[indexPath.row];
        imgView.image = img;
        
        if (_photosArrayFirst.count <= 4) {
            if (_photosArrayFirst.count == indexPath.row + 1) {
                delBtn.hidden = YES;
            }
            else{
                delBtn.hidden = NO;
            }
        }

        return cell;

    }
    else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imagePickerCellIdentifier" forIndexPath:indexPath];
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1];
        if (!imgView) {
            imgView = [[UIImageView alloc] initWithFrame:cell.bounds];
            if (_photosArraySecond.count-1 == indexPath.row) {
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
        delBtn.tag = indexPath.row + 2000;
        [delBtn setImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
        [cell addSubview:delBtn];
        [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img = _photosArraySecond[indexPath.row];
        imgView.image = img;
        
        if (_photosArraySecond.count <= 4) {
            if (_photosArraySecond.count == indexPath.row + 1) {
                delBtn.hidden = YES;
            }
            else{
                delBtn.hidden = NO;
            }
        }
        
        return cell;

    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self keyboardDismiss];
    [self.pickerView hide];
    [self CookingCancelBtnClick];

    if (collectionView == _collectionViewFirst) {
        if (_photosArrayFirst.count < 4) {
            _selectImageTag = 1;
            [self selectPic];
        }
    }
    else{
        if (_photosArraySecond.count < 4) {
            _selectImageTag = 2;
            [self selectPic];
        }
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


//删除图片
-(void)delBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    //判断删除的是哪个
    if (btn.tag < 1500) {
        [_photosArrayFirst removeObjectAtIndex:btn.tag - 1000];
        [self.collectionViewFirst reloadData];
    }
    else{
        [_photosArraySecond removeObjectAtIndex:btn.tag - 2000];
        [self.collectionViewSecond reloadData];
    }
    
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
            
            if (_selectImageTag == 1) {
                NSInteger count = 4 - _photosArrayFirst.count;
                [JFImagePickerController setMaxCount:count];
                JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
                picker.pickerDelegate = self;
                [self.navigationController presentViewController:picker animated:YES completion:nil];
            }
            else{
                NSInteger count = 4 - _photosArraySecond.count;
                [JFImagePickerController setMaxCount:count];
                JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
                picker.pickerDelegate = self;
                [self.navigationController presentViewController:picker animated:YES completion:nil];
            }
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
                
                if (_selectImageTag == 1) {
                    [_photosArrayFirst insertObject:img atIndex:0];
                    [_collectionViewFirst reloadData];
                }
                else{
                    [_photosArraySecond insertObject:img atIndex:0];
                    [_collectionViewSecond reloadData];
                }
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
    
    if (_selectImageTag ==1) {
        [_photosArrayFirst insertObject:img atIndex:0];
        [picker dismissViewControllerAnimated:YES completion:^{}];
        [_collectionViewFirst reloadData];
    }
    else{
        [_photosArraySecond insertObject:img atIndex:0];
        [picker dismissViewControllerAnimated:YES completion:^{}];
        [_collectionViewSecond reloadData];
    }
    
}



#pragma mark - getCode -

-(void)codeBtnClick{
    [self keyboardDismiss];

    [self.tableView endEditing:YES];
    
    if (_phone.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入手机号码"];
        return ;
    }
    if (![Util valiMobile:_phone.text]) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入正确的手机号码"];
        return ;
    }
    
    NSString *url = [API_ReImg stringByAppendingString:@"Msm/appSendCode"];
    NSDictionary *dic = @{@"phone":_phone.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取验证码 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                //开始读秒
                [self openCountdown];
            }
            else if ([res isEqualToString:@"0"]){
                //开始读秒
                [self openCountdown];
                [Util toastWithView:self.view AndText:@"获取验证码失败，请稍后操作"];
            }
            else{
                [Util toastWithView:self.view AndText:@"获取验证码失败"];
            }
        }
        else{
            [Util toastWithView:self.view AndText:@"获取验证码失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取验证码失败 %@", error);
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                //                [self.getCodeBtn setTitleColor:[UIColor colorFromHexCode:@"FB8557"] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%.2d)", seconds] forState:UIControlStateNormal];
                //                [self.getCodeBtn setTitleColor:[UIColor colorFromHexCode:@"979797"] forState:UIControlStateNormal];
                self.codeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark - addressBtnClick -
//地址选择
-(void)addressBtnClick{
    [self.pickerView show];
}

//调用地图选择地址
-(void)SelectAddressBtnClick{
    JSBridgeVC *jsbVC = [[JSBridgeVC alloc] init];
    jsbVC.block = ^(NSDictionary *AddressDic) {
        _AddressDic = AddressDic;
        _shopAddress.text = _AddressDic[@"poiaddress"];
    };
    [self.navigationController pushViewController:jsbVC animated:YES];
}


#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    _province = province;
    _city = city;
    _county = area;
    [_addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@",province,city,area] forState:UIControlStateNormal];
    [self.pickerView hide];
}


#pragma mark - distributionTypeSelectSelect -
//配送方式
-(void)distributionTypeSelect{
    [self.tableView endEditing:YES];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择配送方式" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"商家自配送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_distributionType setTitle:@"商家自配送" forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"阿凡提提供配送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_distributionType setTitle:@"阿凡提提供配送" forState:UIControlStateNormal];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - StyleCookingSelect -
//弹出选择框
-(void)StyleCookingSelect{
    [self keyboardDismiss];
    [self.tableView endEditing:YES];

    [UIView animateWithDuration:0.5 animations:^{
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        _CookingView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
        [UIView commitAnimations];
    }];

}


#pragma mark CookingPickerView Delegate
//表盘数量
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _CookingArray.count;
}

//返回相应的title
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _CookingArray[row][@"name"];
}

//给pickview设置字体大小和颜色
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel *pickerLabel = (UILabel *)view;
    
    //加了这个判断会显示不出来
//    if (!pickerView) {
//
//    }
    pickerLabel = [[UILabel alloc] init];
    pickerLabel.adjustsFontSizeToFitWidth = YES;
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.textColor = [UIColor whiteColor];
    [pickerLabel setBackgroundColor:[UIColor lightGrayColor]];
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    //调用上一个委托方法，获得要展示的title
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

//选中某行后回调的方法，获得选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _CookingStr = _CookingArray[row][@"name"];
    _selectCookingTag = [_CookingArray[row][@"id"] integerValue];
}

//取消
-(void)CookingCancelBtnClick{
    [UIView animateWithDuration:0.5 animations:^{
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        _CookingView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        [UIView commitAnimations];
    }];
}

//确定
-(void)CookingConfirmBtnClick{
    //复制给对应的Btn
    [_StyleCooking setTitle:_CookingStr forState:UIControlStateNormal];
    _StyleCooking.tag = _selectCookingTag;
    
    [UIView animateWithDuration:0.5 animations:^{
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationDelegate:self];
        _CookingView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        [UIView commitAnimations];
    }];

}


#pragma mark - 提交 -
//提交店铺
-(void)submitBtnClick{
    
    WTPayManager *payManager = [[WTPayManager alloc] init];
    [self.navigationController pushViewController:payManager animated:YES];
    
    
    
    if (_shopName.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入商家名称"];
        return ;
    }
    if (_userName.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入商家姓名"];
        return ;
    }
    if (_phone.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入手机号码"];
        return ;
    }
    if (![Util valiMobile:_phone.text]) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入正确的手机号码"];
        return ;
    }
    if (_code.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入验证码"];
        return ;
    }
    if ([_addressBtn.titleLabel.text isEqualToString:@"-  请选择  -"]) {
        [Util toastWithView:self.navigationController.view AndText:@"请选择地区"];
        return ;
    }
    if (_shopAddress.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入详细地址"];
        return ;
    }
    if ([_distributionType.titleLabel.text isEqualToString:@"-  请选择  -"]) {
        [Util toastWithView:self.navigationController.view AndText:@"请选择配送方式"];
        return ;
    }
    if (_acreage.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入营业面积"];
        return ;
    }
    if (_email.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入电子邮箱"];
        return ;
    }
    if (![Util isValidateEmail:_email.text]) {
        [Util toastWithView:self.navigationController.view AndText:@"请正确的电子邮箱"];
        return ;
    }
    if ([_StyleCooking.titleLabel.text isEqualToString:@"-  请选择  -"] || [_StyleCooking.titleLabel.text isEqualToString:@""]) {
        [Util toastWithView:self.navigationController.view AndText:@"请选择菜系分类"];
        return ;
    }
    if (_photosArrayFirst.count <= 1) {
        [Util toastWithView:self.navigationController.view AndText:@"请上传相关营业执照"];
        return ;
    }
    if (_photosArraySecond.count <= 1) {
        [Util toastWithView:self.navigationController.view AndText:@"请上传身份证照"];
        return ;
    }
    if (_photosArrayFirst.count < 4) {
        [Util toastWithView:self.navigationController.view AndText:@"相关营业执照数量不够"];
        return ;
    }
    if (_photosArraySecond.count < 4) {
        [Util toastWithView:self.navigationController.view AndText:@"身份证照数量不够"];
        return ;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = @"正在提交申请";

    NSString *url = [API stringByAppendingString:@"shops/applyBranch"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId, @"shopName":_shopName.text, @"userName":_userName.text, @"phone":_phone.text, @"shopAddress":_shopAddress.text, @"province":_province, @"city":_city, @"county":_county, @"acreage":_acreage.text, @"email":_email.text, @"cuisineId":[NSString stringWithFormat:@"%ld", (long)_StyleCooking.tag], @"dlvService":[_distributionType.titleLabel.text isEqualToString:@"商家自配送"]?@"1":@"2", @"weburl":_weburl.text, @"yzm":_code.text, @"latitude":_AddressDic[@"latlng"][@"lat"], @"longitude":_AddressDic[@"latlng"][@"lng"]};
    //提交申请
    [self postSubmitWithUrl:url Parameters:dic];
}


#pragma mark - 接口 -
//获取菜系菜单
-(void)postCooking{
    NSString *url = [API_ReImg stringByAppendingString:@"Index/getCat"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取菜系信息 %@", responseObject);
        if (responseObject != nil) {
            _CookingArray = responseObject[0][@"child"];
            [_CookingPickerView reloadAllComponents];

        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取菜系菜单失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取菜系失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];

    }];
}


//提交申请开店
-(void)postSubmitWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请开店 %@", responseObject);
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"提交成功"];
                
                [hud hideAnimated:YES];

                //上传图片
                //上传营业执照
                for (int i = 0; i < _photosArrayFirst.count - 1; i++) {
                    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.label.text = @"正在上传图片";

                    [self postImageWith:_photosArrayFirst[i] ImageType:@"2" ShopId:responseObject[@"id"]];
//                    [self postImageWith:[UIImage imageNamed:@"photoadd"] ImageType:@"2" ShopId:responseObject[@"id"]];

                }
                //上传身份照
                for (int i = 0; i < _photosArraySecond.count - 1; i++) {
                    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.label.text = @"正在上传图片";
                    [self postImageWith:_photosArraySecond[i] ImageType:@"1" ShopId:responseObject[@"id"]];
//                    [self postImageWith:[UIImage imageNamed:@"photoadd"] ImageType:@"1" ShopId:responseObject[@"id"]];

                }

                
                
            }
            else if ([responseObject[@"res"] isEqual:@"3"]){
                [Util toastWithView:self.navigationController.view AndText:@"验证码失效或者错误"];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"提交失败"];
            }
        }
        else{
            [hud hideAnimated:YES];
            [Util toastWithView:self.navigationController.view AndText:@"提交失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"申请开店失败 %@", error);
        [hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}

//上传图片
-(void)postImageWith:(UIImage *)image ImageType:(NSString *)imageType ShopId:(NSString *)shopId{
    NSString *url = [API stringByAppendingString:@"shops/updimg"];
    NSDictionary *dic = @{@"shopId":shopId, @"ImgType":imageType};
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
        
        NSData *data = UIImageJPEGRepresentation(image, 0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];

        NSLog(@"图片上传 %@", responseObject);
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
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
        [Util toastWithView:self.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];
}


@end
