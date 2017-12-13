//
//  AddEditViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/19.
//  Copyright © 2017年 Mac. All rights reserved.
//


//**编辑规格**//

#import "AddEditViewController.h"
#import "propertyCell05.h"
#import "propertyCell07.h"

@interface AddEditViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UIButton *senderBtn;
@property (strong, nonatomic) UIButton *backBtn;


@property NSInteger addCount;     //数量

@end

@implementation AddEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    _addCount = 2;
    
    //判断_guigeList的数量，两种情况 >2 和 <2
    if (_guigeList.count > 2) {
        _addCount = _guigeList.count;
    }
    else{
        _addCount = 2;
    }
    
    [self initTableView];
    [self initTopBtn];
    [self initFooterView];

}

-(void)initTableView{
    if (_tableView == nil) {
        UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];

//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.tableView = tvc.tableView;
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
        [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell05" bundle:nil] forCellReuseIdentifier:@"propertyCell05"];
        [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell07" bundle:nil] forCellReuseIdentifier:@"propertyCell07"];
        
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
    [_addBtn setTitle:@"+ 添加规格" forState:UIControlStateNormal];
    [footerView addSubview:_addBtn];
    [self.view addSubview:footerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170 + 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addCount;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    footerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    return footerView;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_guigeList.count < 2) {
        propertyCell07 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"propertyCell07" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[propertyCell07 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell07"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.price.text = _shopPrice;    //价格
            if ([_goodsStock isEqualToString:@"-1"]) {
                cell.kucun.text = @"无限";   //库存
                cell.kucun.enabled = false;
                [cell.swichNumber setOn:YES];
            }
            else{
                cell.kucun.text = _goodsStock;   //库存
                cell.kucun.enabled = true;
                [cell.swichNumber setOn:NO];
            }
        }
        else{
            cell.price.text = @"";
            cell.kucun.text = @"";
        }
        cell.number.text = [NSString stringWithFormat:@"%@%ld", @"规格", (indexPath.row + 1)];
        cell.guigeName.text = @"";
        cell.delectBtn.tag = indexPath.row;
        [cell.delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.guigeName.delegate = self;
        cell.price.delegate = self;
        cell.kucun.delegate = self;
        cell.guigeName.tag = indexPath.row;
        cell.price.tag = indexPath.row;
        cell.kucun.tag = indexPath.row;
        
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"guigeName":cell.guigeName.text, @"price":cell.price.text, @"kucun":cell.kucun.text};
        [_guigeList addObject:dic];
        
        cell.swichNumber.tag = indexPath.row;
        [cell.swichNumber addTarget:self action:@selector(swichNumberClick:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    else{
        propertyCell07 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"propertyCell07" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[propertyCell07 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell07"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.number.text = [NSString stringWithFormat:@"%@%ld", @"规格", (indexPath.row + 1)];
        cell.delectBtn.tag = indexPath.row;
        cell.guigeName.text = _guigeList[indexPath.row][@"guigeName"];
        cell.price.text = _guigeList[indexPath.row][@"price"];
        if ([_guigeList[indexPath.row][@"kucun"] isEqualToString:@"-1"]) {
            cell.kucun.text = @"无限";
            [cell.swichNumber setOn:YES];
            cell.kucun.enabled = false;
        }
        else{
            cell.kucun.text = _guigeList[indexPath.row][@"kucun"];
            [cell.swichNumber setOn:NO];
            cell.kucun.enabled = true;
        }
        cell.guigeName.tag = indexPath.row;
        cell.price.tag = indexPath.row;
        cell.kucun.tag = indexPath.row;
        cell.guigeName.delegate = self;
        cell.price.delegate = self;
        cell.kucun.delegate = self;
        [cell.delectBtn addTarget:self action:@selector(delectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.swichNumber.tag = indexPath.row;
        [cell.swichNumber addTarget:self action:@selector(swichNumberClick:) forControlEvents:UIControlEventValueChanged];
        
        return cell;

    }
    
    
    
}


-(void)swichNumberClick:(id)sender{
    UISwitch *swichNum = (UISwitch *)sender;
    propertyCell07 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:swichNum.tag inSection:0]];
    
    if ([swichNum isOn]) {
        cell.kucun.text = @"无限";
        cell.kucun.enabled = false;
    }
    else{
        cell.kucun.text = @"";
        cell.kucun.enabled = true;
    }
    
    //存储数据
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic = @{@"shopId":[AppDelegate APP].user.shopId, @"guigeName":cell.guigeName.text, @"price":cell.price.text, @"kucun":[cell.kucun.text isEqualToString:@"无限"]?@"-1":cell.kucun.text};
    [_guigeList removeObjectAtIndex:swichNum.tag];
    [_guigeList insertObject:dic atIndex:swichNum.tag];

}


//编辑完成存储数据
-(void)textFieldDidEndEditing:(UITextField *)textField{
    propertyCell07 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:0]];
//    NSDictionary *guigeDic = [[NSDictionary alloc] init];
    NSDictionary *dic = [[NSDictionary alloc] init];
//    guigeDic = _guigeList[textField.tag];

    dic = @{@"shopId":[AppDelegate APP].user.shopId, @"guigeName":cell.guigeName.text, @"price":cell.price.text, @"kucun":[cell.kucun.text isEqualToString:@"无限"]?@"-1":cell.kucun.text};

    NSLog(@"tag = %ld", (long)textField.tag);
    [_guigeList removeObjectAtIndex:textField.tag];
    [_guigeList insertObject:dic atIndex:textField.tag];
}


//添加规格
-(void)addBtnClick{
    _addCount++;
    //判断数量，最多不能超过10
    if (_addCount <= 10) {
        //先增加数据源--为“”的数据
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"guigeName":@"", @"price":@"", @"kucun":@""};
        [_guigeList addObject:dic];

        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_addCount -1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationBottom];
    }
    else{
        _addCount--;
        [Util toastWithView:self.navigationController.view AndText:@"最多不能超过10个"];
    }

}


//删除规格
-(void)delectBtnClick:(id)sender{
    //结束所有编辑
    [self.view endEditing:YES];
    _addCount--;
    UIButton *btn = (UIButton *)sender;
    //判断数量，最少不能小于2
    if (_addCount < 2) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提醒" message:@"商品多规格至少包含两个规格，如果删除将退出多规格设置。是否删除多规格？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除只剩下一个的情况--退出编辑
            [_guigeList removeObjectAtIndex:btn.tag];
            self.block(_guigeList);
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续编辑" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            _addCount++;
        }];
        [alter addAction:cancelAction];
        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];

    }
    else{
        [_guigeList removeObjectAtIndex:btn.tag];
        [self.tableView reloadData];

//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
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
    [self.view endEditing:YES];
    for (int i = 0; i < _addCount; i++) {
        propertyCell07 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.guigeName.text isEqualToString:@""] || [cell.price.text isEqualToString:@""] || [cell.kucun.text isEqualToString:@""]) {
            [Util toastWithView:self.navigationController.view AndText:@"请填写完整信息"];
            return ;
        }
//        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"guigeName":cell.guigeName.text, @"price":cell.price.text, @"kucun":cell.kucun.text};
//        NSLog(@"%@", cell.guigeName.text);
//        [_guigeList addObject:dic];
    }
    self.block(_guigeList);
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
