//
//  EditDescriptionViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

//**编辑分类**//

#import "EditDescriptionViewController.h"

@interface EditDescriptionViewController ()<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;   //名称
@property (weak, nonatomic) IBOutlet UITextView *Description;  //描述
@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;    //删除按钮


@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *senderBtn;

@property BOOL isChange;     //是否修改，是否保存


@end

@implementation EditDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"阿凡提商家";
    _isChange = NO;
    _name.delegate = self;
    _Description.delegate = self;
    [self initTopBtn];

    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.text = @"请输入分类描述，最多255字";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_Description addSubview:_placeHolderLabel];
    [_delectBtn addTarget:self action:@selector(delectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_Type isEqualToString:@"编辑"]) {
        if (_catDic[@"catName"] != nil && ![_catDic[@"catName"] isKindOfClass:[NSNull class]]) {
            _catName = [NSString stringWithFormat:@"%@", _catDic[@"catName"]];
        }
        else
            _catName = @"";
        _delectBtn.hidden = NO;
        
    }
    else{
        _catName = @"";
        _delectBtn.hidden = YES;
        
    }
    
    _name.text = _catName;
}

-(void)initTopBtn{
    //取消按钮
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.bounds = CGRectMake(-10, 0, 50, 40);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:_cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBtn;

    //保存按钮
    _senderBtn = [[UIButton alloc] init];
    _senderBtn.bounds = CGRectMake(0, 0, 50, 40);
    [_senderBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _senderBtn.hidden = NO;
    [_senderBtn addTarget:self action:@selector(senderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *senderBtn = [[UIBarButtonItem alloc] initWithCustomView:_senderBtn];
    self.navigationItem.rightBarButtonItem = senderBtn;
}


//点击取消
-(void)cancelBtnClick{
    [_name resignFirstResponder];
    [_Description resignFirstResponder];
    
    if (_isChange) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"退出后修改的内容将不被保存，是否退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:cancelAction];
        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];

    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//点击保存--编辑/新建分类
-(void)senderBtnClick{
    [_name resignFirstResponder];
    [_Description resignFirstResponder];
    _isChange = NO;
    if ([_name.text isEqualToString:@""]) {
        [Util toastWithView:self.navigationController.view AndText:@"分类名不可为空"];
        return ;
    }
    if ([_Type isEqualToString:@"编辑"]) {
        //保存--编辑分类
        [self postEditddCat];
//        [self.navigationController popViewControllerAnimated:YES];

    }
    else{
        //保存--新建分类
        [self postAddCat];
//        [Util toastWithView:self.navigationController.view AndText:@"新增分类成功"];
    }
}


-(void)textViewDidChange:(UITextView *)textView{
    _isChange = YES;
    if (_Description.text.length > 255) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"最多输入255字" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:cancelAction];
        [self presentViewController:alter animated:YES completion:nil];
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


//判断内容是否改变
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _name) {
        if (_name.text.length > 20) {
            [Util toastWithView:self.navigationController.view AndText:@"名字长度不能大于20个字"];
        }
    }
    if ([_catName isEqualToString:_name.text]) {
        _isChange = NO;
    }
    else
        _isChange = YES;
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name resignFirstResponder];
    [_Description resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_name resignFirstResponder];
    [_Description resignFirstResponder];
}


//删除按钮
-(void)delectBtnClick{
    NSLog(@"删除");
    NSArray *distop = [[NSArray alloc] init];    //暂时存放菜单
    distop = _catDic[@"distop"];
    //有商品的不能删除
    if (distop != nil && ![distop isKindOfClass:[NSNull class]]) {
    }
    else
        distop = @[];
    
    if (distop.count != 0) {
        [Util toastWithView:self.navigationController.view AndText:@"该分类下有商品，不可删除"];
    }
    else{
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"是否删除该分类？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //删除分类
            [self postDeleteCatWithCatId];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:cancelAction];
        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
}


//删除分类
-(void)postDeleteCatWithCatId{
    NSString *url = [API stringByAppendingString:@"shops/deleteCat"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"catId":_catDic[@"catId"]};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除分类 %@", responseObject);
        if (responseObject != nil) {
            [Util toastWithView:self.navigationController.view AndText:@"删除分类成功"];
            [self.navigationController popViewControllerAnimated:YES];

        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"删除分类失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除分类失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];
}


//保存--新建分类
-(void)postAddCat{
    [_name resignFirstResponder];
    [_Description resignFirstResponder];
    if (!(_name.text.length > 0)) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入分类名称"];
        return ;
    }
    
    NSString *url = [API stringByAppendingString:@"shops/addCat"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"catName":_name.text, @"languageId":_languageId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"新建分类 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"新建分类成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"新建分类失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"新建分类失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"新建分类失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];
}


//保存--编辑分类
-(void)postEditddCat{
    [_name resignFirstResponder];
    [_Description resignFirstResponder];
    if (!(_name.text.length > 0)) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入分类名称"];
        return ;
    }
    
    NSString *url = [API stringByAppendingString:@"shops/editCat"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"catName":_name.text, @"catId":_catDic[@"catId"]};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"新建分类 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"编辑分类成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"编辑分类失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"编辑分类失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"新建分类失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
