//
//  incomeTodayDetailsViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*今日订单细节*//

#import "incomeTodayDetailsViewController.h"
#import "goodListCell.h"
#import "incomeDailsCell.h"
#import "incomeDailsCell2.h"
#import "incomeDailsCell3.h"

@interface incomeTodayDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *AlldeStatus;      //配送状态
    NSDictionary *ALLpayType;       //支付方式

}

@property (strong, nonatomic) UILabel *pain;      //预计收入

@end

@implementation incomeTodayDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"goodListCell" bundle:nil] forCellReuseIdentifier:@"goodListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"incomeDailsCell" bundle:nil] forCellReuseIdentifier:@"incomeDailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"incomeDailsCell2" bundle:nil] forCellReuseIdentifier:@"incomeDailsCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"incomeDailsCell3" bundle:nil] forCellReuseIdentifier:@"incomeDailsCell3"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initBottomView];
    
    AlldeStatus = [[NSDictionary alloc] initWithObjects:@[@"系统已接单", @"已分配骑手", @"骑手已到店", @"配送中", @"已取消", @"系统拒单/配送异常", @"等待接单", @"商家自行配送"] forKeys:@[@"1", @"20", @"80", @"2", @"4", @"5", @"6", @"7"]];
    ALLpayType = [[NSDictionary alloc] initWithObjects:@[@"余额支付", @"微信支付", @"余额+微信" , @"支付宝", @"支付宝+余额"] forKeys:@[@"1", @"2", @"3", @"4", @"5"]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];

}

-(void)initBottomView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 116, SCREEN_WIDTH, 50)];
    footerView .backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    backBtn.backgroundColor = BG_COLOR;
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *topLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLable.backgroundColor = [UIColor grayColor];
    
    [footerView addSubview:backBtn];
    [footerView addSubview:topLable];
    [self.view addSubview:footerView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerVeiw.backgroundColor = [UIColor whiteColor];
    
    _pain = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    _pain.backgroundColor = [UIColor whiteColor];
    _pain.textColor = NAV_COLOR;
    [_pain setFont:[UIFont systemFontOfSize:20.0]];
    _pain.textAlignment = NSTextAlignmentCenter;
    if (_arrayList[@"plan"] != nil && ![_arrayList[@"plan"] isKindOfClass:[NSNull class]]) {
        _pain.text = [NSString stringWithFormat:@"%@%@%@", @"+￥", _arrayList[@"plan"], @"元"];
    }
    else
        _pain.text = @"+￥0.00元";

    UILabel *bottom = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    bottom.backgroundColor = [UIColor lightGrayColor];
    
    [headerVeiw addSubview:bottom];
    [headerVeiw addSubview:_pain];
    return headerVeiw;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _goodsLists.count) {
        return 40;
    }
    else
        return 100;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodsLists.count + 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row < _goodsLists.count) {
        goodListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"goodListCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[goodListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"goodListCell"];
            return cell;
        }
        
        if (_goodsLists[indexPath.row][@"goodsAttrName"] != nil && ![_goodsLists[indexPath.row][@"goodsAttrName"] isKindOfClass:[NSNull class]]) {
            cell.goodsAttrName.text = _goodsLists[indexPath.row][@"goodsAttrName"];
        }
        else
            cell.goodsAttrName.text = @"";

        if (_goodsLists[indexPath.row][@"goodsName"] != nil && ![_goodsLists[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
            cell.goodsName.text = [NSString stringWithFormat:@"%@%@%@",@"·  ", _goodsLists[indexPath.row][@"goodsName"], cell.goodsAttrName.text];
        }
        else
            cell.goodsName.text = @"";
        
        
        if (_goodsLists[indexPath.row][@"goodsNums"] != nil && ![_goodsLists[indexPath.row][@"goodsNums"] isKindOfClass:[NSNull class]]) {
            cell.goodsNums.text = [NSString stringWithFormat:@"%@%@", @"×", _goodsLists[indexPath.row][@"goodsNums"]];
        }
        else
            cell.goodsAttrName.text = @"×0";
        
        if (_goodsLists[indexPath.row][@"goodsPrice"] != nil && ![_goodsLists[indexPath.row][@"goodsPrice"] isKindOfClass:[NSNull class]]) {
            cell.goodsPrice.text = [NSString stringWithFormat:@"%@%@%@", @"￥", _goodsLists[indexPath.row][@"goodsPrice"], @"    "];
        }
        else
            cell.goodsPrice.text = @"￥0";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == _goodsLists.count){
        incomeDailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"incomeDailsCell" forIndexPath:indexPath];
        cell.title01.text = @"活动支出";
        cell.title02.text = @"折扣商品";
        
        if (_arrayList[@"shopALLPayOut"] != nil && ![_arrayList[@"shopALLPayOut"] isKindOfClass:[NSNull class]]) {
            cell.money01.text = [NSString stringWithFormat:@"%@%@",@"-￥", _arrayList[@"shopALLPayOut"]];
        }
        else{
            cell.money01.text = [NSString stringWithFormat:@"%@",@"-￥0.00"];
        }
        
        if (_arrayList[@"shopHyZKPayOut"] != nil && ![_arrayList[@"shopHyZKPayOut"] isKindOfClass:[NSNull class]]) {
            cell.money02.text = [NSString stringWithFormat:@"%@%@",@"-￥", _arrayList[@"shopHyZKPayOut"]];
        }
        else{
            cell.money02.text = [NSString stringWithFormat:@"%@",@"-￥0.00"];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == _goodsLists.count + 1){
        incomeDailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"incomeDailsCell" forIndexPath:indexPath];
        cell.title01.text = @"平台抽佣";
        cell.title02.text = @"平台服务费";
        
        if (_arrayList[@"serverPrice"] != nil && ![_arrayList[@"serverPrice"] isKindOfClass:[NSNull class]]) {
            cell.money01.text = [NSString stringWithFormat:@"%@%@",@"-￥", _arrayList[@"serverPrice"]];
            cell.money02.text = [NSString stringWithFormat:@"%@%@",@"-￥", _arrayList[@"serverPrice"]];
            
        }
        else{
            cell.money01.text = [NSString stringWithFormat:@"%@",@"-￥0.00"];
            cell.money02.text = [NSString stringWithFormat:@"%@",@"-￥0.00"];
        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if (indexPath.row == _goodsLists.count + 2){
        incomeDailsCell2 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"incomeDailsCell2" forIndexPath:indexPath];
        if (_arrayList[@"plan"] != nil && ![_arrayList[@"plan"] isKindOfClass:[NSNull class]]) {
            cell.pain.text = [NSString stringWithFormat:@"%@%@", @"+￥", _arrayList[@"plan"]];
        }
        else
            cell.pain.text = @"+￥0.00";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

    else if (indexPath.row == _goodsLists.count + 3){
        incomeDailsCell3 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"incomeDailsCell3" forIndexPath:indexPath];
        if (_arrayList[@"orderNo"] != nil && ![_arrayList[@"orderNo"] isKindOfClass:[NSNull class]]) {
            cell.orderNo.text = [NSString stringWithFormat:@"%@", _arrayList[@"orderNo"]];
        }
        else
            cell.orderNo.text = @"";
        
        if (_arrayList[@"createTime"] != nil && ![_arrayList[@"createTime"] isKindOfClass:[NSNull class]]) {
            cell.createTime.text = [NSString stringWithFormat:@"%@", _arrayList[@"createTime"]];
        }
        else
            cell.createTime.text = @"";
        
        if (_arrayList[@"createTime"] != nil && ![_arrayList[@"createTime"] isKindOfClass:[NSNull class]]) {
            cell.createTime.text = [NSString stringWithFormat:@"%@", _arrayList[@"createTime"]];
        }
        else
            cell.createTime.text = @"";
        
        if (_arrayList[@"payType"] != nil && ![_arrayList[@"payType"] isKindOfClass:[NSNull class]]) {
            cell.payType.text = [NSString stringWithFormat:@"%@", [ALLpayType objectForKey:[NSString stringWithFormat:@"%@",_arrayList[@"payType"]]]];
        }
        else
            cell.payType.text = @"";

        if (_arrayList[@"deStatus"] != nil && ![_arrayList[@"deStatus"] isKindOfClass:[NSNull class]]) {
            cell.deStatus.text = [NSString stringWithFormat:@"%@", [AlldeStatus objectForKey:[NSString stringWithFormat:@"%@", _arrayList[@"deStatus"]]]];
        }
        else
            cell.deStatus.text = @"";

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

    return cell;
}


-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
