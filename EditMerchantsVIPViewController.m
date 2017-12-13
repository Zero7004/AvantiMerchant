//
//  EditMerchantsVIPViewController.m
//  AvantiMerchant
//
//  Created by long on 2017/12/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

/////**编辑VIP设置**/////

#import "EditMerchantsVIPViewController.h"
#import "EditMerchantsVIPCell.h"

@interface EditMerchantsVIPViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UIButton *senderBtn;
@property (strong, nonatomic) UIButton *backBtn;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation EditMerchantsVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];

    //判断数量
    if (_vipArray.count == 0) {
        NSDictionary *dic = @{@"name":@"", @"money":@"0.00", @"zk":@"0.0"};
        [_vipArray addObject:dic];
    }
    
    [self initTableView];
    [self initTopBtn];
    [self initFooterView];
}

-(void)initTableView{
    if (self.tableView == nil) {
        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        self.tableView = tvc.tableView;
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
        [self.tableView registerNib:[UINib nibWithNibName:@"EditMerchantsVIPCell" bundle:nil] forCellReuseIdentifier:@"EditMerchantsVIPCell"];
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_tableView];
        [self addChildViewController:tvc];
    }
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
    [_addBtn setTitle:@"+ 添加会员等级" forState:UIControlStateNormal];
    [footerView addSubview:_addBtn];
    [self.view addSubview:footerView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130 + 40;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 70;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _vipArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditMerchantsVIPCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditMerchantsVIPCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EditMerchantsVIPCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EditMerchantsVIPCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.LV.text = [NSString stringWithFormat:@"会员等级%ld", indexPath.row + 1];
    
    if (_vipArray[indexPath.row][@"name"] != nil && ![_vipArray[indexPath.row][@"name"] isKindOfClass:[NSNull class]]) {
        cell.name.text = [NSString stringWithFormat:@"%@", _vipArray[indexPath.row][@"name"]];
    }
    else{
        cell.name.text = @"";
    }

    if (_vipArray[indexPath.row][@"money"] != nil && ![_vipArray[indexPath.row][@"money"] isKindOfClass:[NSNull class]]) {
        cell.money.text = [NSString stringWithFormat:@"%@", _vipArray[indexPath.row][@"money"]];
    }
    else{
        cell.money.text = @"";
    }
    
    if (_vipArray[indexPath.row][@"zk"] != nil && ![_vipArray[indexPath.row][@"zk"] isKindOfClass:[NSNull class]]) {
        cell.zk.text = [NSString stringWithFormat:@"%.1f", [_vipArray[indexPath.row][@"zk"] floatValue]];
    }
    else{
        cell.zk.text = @"";
    }
    
    cell.money.delegate = self;
    cell.zk.delegate = self;
    cell.money.tag = indexPath.row;
    cell.zk.tag = indexPath.row;
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    footerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    return footerView;
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

//添加属性
-(void)addBtnClick{
    if (_vipArray.count < 6) {
        NSDictionary *dic = @{@"name":@"", @"money":@"0.00", @"zk":@"0.0"};
        [_vipArray addObject:dic];
        [self.tableView reloadData];
    }
    else{
        [Util toastWithView:self.navigationController.view AndText:@"最多不能超过5个"];
    }
}

//删除属性
-(void)delectBtnClick:(id)sender{
    [self.view endEditing:YES];
    UIButton *btn = (UIButton *)sender;
    [_vipArray removeObjectAtIndex:btn.tag];
    if (_vipArray.count == 0) {
        NSDictionary *dic = @{@"name":@"", @"money":@"0.00", @"zk":@"0.0"};
        [_vipArray addObject:dic];
    }
    [self.tableView reloadData];
}

//编辑完成存储数据
-(void)textFieldDidEndEditing:(UITextField *)textField{
    EditMerchantsVIPCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
    NSDictionary *vipDic = [[NSDictionary alloc] init];
    vipDic = _vipArray[textField.tag];
    vipDic = @{@"name":cell.name.text, @"money":[NSString stringWithFormat:@"%.2f", [cell.money.text floatValue]], @"zk":[NSString stringWithFormat:@"%.1f", [cell.zk.text floatValue]]};
    [_vipArray removeObjectAtIndex:textField.tag];
    [_vipArray insertObject:vipDic atIndex:textField.tag];
    NSLog(@"vip = %@", _vipArray);
}

//点击保存
-(void)senderBtnClick{
    //结束编辑状态
    [self.view endEditing:YES];
    NSMutableArray *vipArray = [NSMutableArray array];
    for (int i = 0; i < _vipArray.count; i++) {
        EditMerchantsVIPCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.name.text isEqualToString:@""] || [cell.money.text isEqualToString:@""] || [cell.zk.text isEqualToString:@""]) {
            [Util toastWithView:self.navigationController.view AndText:@"请填写完整信息"];
            return ;
        }
        if (cell.name.text.length > 15) {
            [Util toastWithView:self.navigationController.view AndText:@"名称字数不能大于15个字符"];
            return ;
        }
        if ([cell.money.text floatValue] <= 0) {
            [Util toastWithView:self.navigationController.view AndText:@"金额不能为0"];
            return ;
        }
        if ([cell.zk.text floatValue] < 5 || [cell.zk.text floatValue] > 10) {
            [Util toastWithView:self.navigationController.view AndText:@"折扣范围在5~10之间"];
            return ;
        }
        NSDictionary *dic = @{@"name":cell.name.text, @"money":cell.money.text, @"zk":cell.zk.text};
        [vipArray addObject:dic];
    }
    [self postEditVipWithData:[vipArray copy]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark === 接口 ===

/**
 上传会员信息
 */
-(void)postEditVipWithData:(NSArray *)data{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *url = [API_ReImg stringByAppendingString:@"Setshop/setVip"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"data":[Util arrayToJSONString:data]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_hud hideAnimated:YES];
        
        NSLog(@"上传会员等级%@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
//                [Util toastWithView:self.navigationController.view AndText:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
            }
        }else{
            [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传会员等级失败%@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
    }];

}

@end
