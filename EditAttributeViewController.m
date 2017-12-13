//
//  EditAttributeViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/20.
//  Copyright © 2017年 Mac. All rights reserved.
//

//**编辑属性**//


#import "EditAttributeViewController.h"
#import "propertyCell08.h"

@interface EditAttributeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UIButton *senderBtn;
@property (strong, nonatomic) UIButton *backBtn;


@end

@implementation EditAttributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    //判断_guigeList的数量
    if (_guigeAttr.count == 0) {
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"attrName":@"", @"attrContent":@""};
        [_guigeAttr addObject:dic];
    }

    [self initTableView];
    [self initTopBtn];
//    [self initFooterView];
    
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell08" bundle:nil] forCellReuseIdentifier:@"propertyCell08"];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
}


-(void)initTopBtn{
    //添加返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.bounds = CGRectMake(0, 0, 40, 40);
    _backBtn.imageView.contentMode = UIViewContentModeLeft;
    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = backBtn;
    
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


-(void)initFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 130, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    _addBtn = [[UIButton alloc] init];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addBtn.frame = CGRectMake(30, 10, SCREEN_WIDTH - 60, 45);
    [_addBtn setBackgroundColor:NAV_COLOR];
    _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setTitle:@"+ 添加属性" forState:UIControlStateNormal];
    [footerView addSubview:_addBtn];
    [self.view addSubview:footerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 135;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    footerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    propertyCell08 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"propertyCell08" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[propertyCell08 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell08"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.title.text = [NSString stringWithFormat:@"%@%ld", @"属性", (indexPath.row + 1)];
    cell.attrName.text = _guigeAttr[indexPath.row][@"attrName"];
    cell.attrContent.text = _guigeAttr[indexPath.row][@"attrContent"];
    cell.attrName.delegate = self;
    cell.attrContent.delegate = self;
    cell.delectBtn.tag = indexPath.row;
    cell.attrName.tag = indexPath.row;
    cell.attrContent.tag = indexPath.row;
    [cell.delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.delectBtn.hidden = YES;
    
    return cell;
}



//退出视图
-(void)pressBack{
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

//点击保存
-(void)senderBtnClick{
//    [_guigeList removeAllObjects];
    //结束编辑状态
    [self.view endEditing:YES];
    for (int i = 0; i < _guigeAttr.count; i++) {
        propertyCell08 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.attrName.text isEqualToString:@""] || [cell.attrContent.text isEqualToString:@""]) {
            [Util toastWithView:self.navigationController.view AndText:@"请填写完整信息"];
            return ;
        }
    }
    self.block(_guigeAttr);
    [self.navigationController popViewControllerAnimated:YES];
}

//编辑完成存储数据
-(void)textFieldDidEndEditing:(UITextField *)textField{
    propertyCell08 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    NSDictionary *guigeDic = [[NSDictionary alloc] init];
    NSDictionary *dic = [[NSDictionary alloc] init];
    guigeDic = _guigeAttr[textField.tag];
    if ([guigeDic objectForKey:@"attrId"] == nil) {
        dic = @{@"shopId":[AppDelegate APP].user.shopId, @"attrName":cell.attrName.text, @"attrContent":cell.attrContent.text};
    }
    else
        dic = @{@"shopId":[AppDelegate APP].user.shopId, @"attrId":[guigeDic objectForKey:@"attrId"], @"attrName":cell.attrName.text, @"attrContent":cell.attrContent.text};
    [_guigeAttr removeObjectAtIndex:textField.tag];
    [_guigeAttr insertObject:dic atIndex:textField.tag];
    NSLog(@"bianji %@", _guigeAttr);
}



//添加属性
-(void)addBtnClick{
    if (_guigeAttr.count < 1) {
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"attrName":@"", @"attrContent":@""};
        [_guigeAttr addObject:dic];
        [self.tableView reloadData];
    }
    else{
        [Util toastWithView:self.navigationController.view AndText:@"暂时最多不能超过1个"];
    }
}


//删除属性
-(void)delectBtnClick:(id)sender{
    [self.view endEditing:YES];
    UIButton *btn = (UIButton *)sender;
    [_guigeAttr removeObjectAtIndex:btn.tag];
    if (_guigeAttr.count == 0) {
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"attrName":@"", @"attrContent":@""};
        [_guigeAttr addObject:dic];
    }
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
