//
//  GroupActivityViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/13.
//  Copyright © 2017年 Mac. All rights reserved.
//


///**团购活动**///

#import "GroupActivityViewController.h"
#import "GroupActivityCell.h"
#import "THDatePickerView2.h"
#import "ChooseGoodsViewController.h"
#import "XLPhotoBrowser.h"

@interface GroupActivityViewController ()<THDatePickerViewDelegate, UITextFieldDelegate, VPImageCropperDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource, UITextViewDelegate>{
    
    MBProgressHUD *hud;

}



@property (strong, nonatomic) NSMutableArray *selectGoods;   //选择的商品列表

@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UIButton *commodityName;       //商品名称
@property (weak, nonatomic) IBOutlet UITextField *price;            //商品原价
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) THDatePickerView2 *dateView;

@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITextField *TotalPrice;  //商品总价
@property (weak, nonatomic) IBOutlet UIImageView *groupImage;
@property (weak, nonatomic) IBOutlet UIButton *groupImageBtn;
@property (weak, nonatomic) IBOutlet UITextView *describe;  //团购描述

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property NSInteger BtnTag;

@end

@implementation GroupActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"阿凡提商家";

    //选择的商品
    _selectGoods = [NSMutableArray array];
    
    _TotalPrice.delegate = self;
    _describe.delegate = self;
    _groupName.delegate = self;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    [self.tableView registerNib:[UINib nibWithNibName:@"GroupActivityCell" bundle:nil] forCellReuseIdentifier:@"GroupActivityCell"];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    _confirmBtn.layer.cornerRadius = 7;
    _cancelBtn.layer.cornerRadius = 7;
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _BtnTag = 1;

    [_startTime addTarget:self action:@selector(startTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_endTime addTarget:self action:@selector(endTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_startTime setTitle:[Util getNowTime] forState:UIControlStateNormal];
    [_endTime setTitle:@"未选择" forState:UIControlStateNormal];
    
    [_commodityName addTarget:self action:@selector(commodityNameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_groupImageBtn addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [self initDateView];

    [self initView];
}

-(void)initDateView{
    _dateView = [[THDatePickerView2 alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];

    _dateView.delegate = self;
    _dateView.title = @"请选择时间";
    self.dateView = _dateView;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.view addSubview:_dateView];
}


-(void)viewWillDisappear:(BOOL)animated{
    [_dateView removeFromSuperview];
}


-(void)initView{
    //添加textview的place属性
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.text = @"介绍一下你的团购活动吧";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_describe addSubview:_placeHolderLabel];

}


//确定按钮
-(void)confirmBtnClick{
    [self.tableView endEditing:YES];
    if (_groupName.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入管沟名称"];
        return ;
    }
    if ([_endTime.titleLabel.text isEqualToString:@"未选择"]) {
        [Util toastWithView:self.navigationController.view AndText:@"请设置活动时间"];
        return ;
    }
    if ([_commodityName.titleLabel.text isEqualToString:@"未选择"] || _selectGoods.count == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请选择商品"];
        return ;
    }
    if (_price.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入商品原价"];
        return ;
    }
    if (_TotalPrice.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入商品总价"];
        return ;
    }
    if ([_TotalPrice.text floatValue] >= [_price.text floatValue]) {
        [Util toastWithView:self.navigationController.view AndText:@"团购总价不能大于或等于原价"];
        return ;
    }
    if ([UIImagePNGRepresentation(_groupImage.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"加号-2"])]){
        [Util toastWithView:self.navigationController.view AndText:@"请上传团购图片"];
        return ;
    }
    //判断图片大小
    NSData *data = UIImageJPEGRepresentation(_groupImage.image, 1);
    NSLog(@"大小 = %lu", [data length]/1000);
    if ([data length]/1000 > 2 *1024) {
        [Util toastWithView:self.navigationController.view AndText:@"图片大小不能大于2M"];
        return ;
    }
    if (_describe.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请描述团购活动"];
        return ;
    }
    if (_describe.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请描述团购活动"];
        return ;
    }
    if (_selectGoods.count < 2) {
        [Util toastWithView:self.navigationController.view AndText:@"商品种类不能小于2种"];
        return ;
    }
    
    //整理选中的商品，只拿有用的字段
    NSMutableArray *goods = [NSMutableArray array];
    for (NSDictionary *dic in _selectGoods) {
        NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
        [goodsDic setValue:dic[@"goodsId"] forKey:@"goodsId"];
        [goodsDic setValue:dic[@"num"] forKey:@"num"];
        [goods addObject:goodsDic];
    }

    NSString *url = [API stringByAppendingString:@"Setshop/groupGoods"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"groupName":_groupName.text, @"startTime":_startTime.titleLabel.text, @"endTime":_endTime.titleLabel.text, @"marketPrice":_price.text, @"shopPrice":_TotalPrice.text, @"groupDes":_describe.text, @"goods":[Util arrayToJSONString:[goods copy]]};
    if ([_switchBtn isOn]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        //调用接口
        [self postActiveWithUrl:url Parameters:dic];
    }
    else{
        [Util toastWithView:self.navigationController.view AndText:@"您尚未同意《商家自营销协议》"];
        return ;
    }
    
    
}


//取消
-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startTimeBtnClick{
    [self.tableView endEditing:YES];
    _BtnTag = 1;
    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
    self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);

        [self.dateView show];
    }];
    
}

-(void)endTimeBtnClick{
    [self.tableView endEditing:YES];
    _BtnTag = 2;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
        [self.dateView show];
    }];
    
}

//选择商品
-(void)commodityNameBtnClick{
    ChooseGoodsViewController *vc = [[ChooseGoodsViewController alloc] init];
    vc.activeType = @"团购活动";
    vc.selectGoods = [NSMutableArray array];
    vc.selectGoods = _selectGoods;
    vc.block_group = ^(NSMutableArray *selctGroup) {
        _selectGoods = selctGroup;
        //计算原价
        float allPrice = 0.00;
        for (NSDictionary *dic in _selectGoods) {
            allPrice += [dic[@"shopPrice"] floatValue] * [dic[@"num"] floatValue];
        }
        _price.text = [NSString stringWithFormat:@"%.2f", allPrice];
        [self.tableView reloadData];
        
        [_commodityName setTitle:@"继续选择" forState:UIControlStateNormal];
        [_commodityName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //重新计算底部时间选择器的位置
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height + 300 + _selectGoods.count * 44, self.view.frame.size.width, 300);

    };
    [self.navigationController pushViewController:vc animated:YES];
}


//选择图片
-(void)selectImage{
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
            
            [Util toastWithView:self.view AndText:@"不支持相机"];
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


#pragma makr -  UITabeleViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:
            return 44;
            break;
            
        default:{
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            return _selectGoods.count;
        }
            
            
        default:
            return [super tableView:tableView numberOfRowsInSection:section];
            break;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:{
            GroupActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupActivityCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[GroupActivityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GroupActivityCell"];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.title.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
            cell.goodsName.text = _selectGoods[indexPath.row][@"goodsName"];
            cell.num.text = _selectGoods[indexPath.row][@"num"];
            cell.num.tag = indexPath.row + 2000;
            cell.num.delegate = self;
            cell.delectBtn.tag = indexPath.row;
            [cell.delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
            break;
            
        default:
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
            break;
    }

}

//需要实现该协议
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){ //（动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    
    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}


//删除列表
-(void)delectBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [_selectGoods removeObjectAtIndex:btn.tag];
    [self.tableView reloadData];
    
    if (_selectGoods.count == 0) {
        [_commodityName setTitle:@"未选择" forState:UIControlStateNormal];
    }
    
    //计算原价
    float allPrice = 0.00;
    for (NSDictionary *dic in _selectGoods) {
        allPrice += [dic[@"shopPrice"] floatValue] * [dic[@"num"] floatValue];
    }
    _price.text = [NSString stringWithFormat:@"%.2f", allPrice];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UItextFieldDelegate
//修改数量
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _groupName) {
        if (_groupName.text.length > 10) {
            [Util toastWithView:self.navigationController.view AndText:@"活动名称不能超过10个字"];
            return ;
        }
    }
    else if (textField == _TotalPrice) {
        _TotalPrice.text = [NSString stringWithFormat:@"%.2f", [_TotalPrice.text floatValue]];
    }
    else{
        NSMutableDictionary *dic = [_selectGoods[textField.tag - 2000] mutableCopy];
        [dic setObject:textField.text forKey:@"num"];
        [_selectGoods replaceObjectAtIndex:(textField.tag - 2000) withObject:dic];
        
        //计算原价
        float allPrice = 0.00;
        for (NSDictionary *dic in _selectGoods) {
            allPrice += [dic[@"shopPrice"] floatValue] * [dic[@"num"] floatValue];
        }
        _price.text = [NSString stringWithFormat:@"%.2f", allPrice];
    }

}



#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHolderLabel.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0 ){
        _placeHolderLabel.text = @"介绍一下你的团购活动吧";
    }
    else{
        _placeHolderLabel.text = @"";
    }
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 200) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"最多输入200字" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:cancelAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
}


#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    //    NSLog(@"保存点击");
    
    //    [_topButton setTitle:timer forState:UIControlStateNormal];
    
    switch (_BtnTag) {
        case 1:
            [_startTime setTitle:timer forState:UIControlStateNormal];
            break;
            
        case 2:
            [_endTime setTitle:timer forState:UIControlStateNormal];
            break;
            
            
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }];
    
    //    [self getTodayWithTime:timer];
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    //    NSLog(@"取消点击");
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }];
}


#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    //通过key值获取到图片
    //    image =info[UIImagePickerControllerOriginalImage];
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
    [cropperViewController.navigationController popViewControllerAnimated:YES];
    _groupImage.image = editedImage;
    //    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 接口
-(void)postActiveWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data = UIImageJPEGRepresentation(_groupImage.image, 0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        NSLog(@"创建活动 %@", responseObject);
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"活动创建成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];

                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                if (responseObject[@"msg"] != nil) {
                    [Util toastWithView:self.navigationController.view AndText:@"图片上传失败"];
                }
                else{
                    [Util toastWithView:self.navigationController.view AndText:@"活动创建失败"];
//                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"活动创建失败"];
//            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"创建活动失败 %@", error);
        [Util toastWithView:self.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];
    
}


@end
