//
//  DistributionManagementViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/12.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*配送管理*//

#import "DistributionManagementViewController.h"
#import "DistributionCell.h"
#import "DistributionCell2.h"

@interface DistributionManagementViewController ()<UITableViewDelegate, UITableViewDataSource>{

    NSInteger swith;
    
    NSString *rangeTextfile; //配送范围
    NSString *distributionMoneyTextfile;   //配送费
    NSString *MessboxTextfile;  //餐盒费
    NSString *startingPriceTextfile;    //起步价
}


@property (strong, nonatomic) UISwitch *switchBtn;
@property (strong, nonatomic) UIButton *confirmBtn;       //确定按钮


@property (nonatomic, strong) UITableView *tableView;



@end

@implementation DistributionManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";

    //初始化配送变量
    //是否配送 0不配送 1配送
    if ([DEFAULT objectForKey:@"isDistribution"] == nil) {
        [DEFAULT setObject:@"0" forKey:@"isDistribution"];
    }
    //配送方式 --默认1商家配送，2蜂鸟配送
    if ([DEFAULT objectForKey:@"deStatus"] == nil) {
        [DEFAULT setObject:@"1" forKey:@"deStatus"];
    }
    //配送范围
    if ([DEFAULT objectForKey:@"distributionRange"] == nil) {
        [DEFAULT setObject:@"0" forKey:@"distributionRange"];
    }
    //配送时间
    if ([DEFAULT objectForKey:@"deliveryCostTime"] == nil) {
        [DEFAULT setObject:@"0" forKey:@"deliveryCostTime"];
    }
    //配送费
    if ([DEFAULT objectForKey:@"distributionMoney"] == nil) {
        [DEFAULT setObject:@"0" forKey:@"distributionMoney"];
    }
    //餐盒费
    if ([DEFAULT objectForKey:@"Messbox"] == nil) {
        [DEFAULT setObject:@"0" forKey:@"Messbox"];
    }
    //起步价
    if ([DEFAULT objectForKey:@"startingPrice"] == nil) {
        [DEFAULT setObject:@"0" forKey:@"startingPrice"];
    }
    
    [self getPeiSong];

    _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 71, 30, 51, 31)];
    if ([[DEFAULT objectForKey:@"isDistribution"] isEqual:@"0"]) {
        [_switchBtn setOn:NO];
        swith = 0;
    }
    else{
        swith = 10 + 2;
        [_switchBtn setOn:YES];
    }
    
    
    [self initTableView];
}

-(void)initTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributionCell" bundle:nil] forCellReuseIdentifier:@"DistributionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributionCell2" bundle:nil] forCellReuseIdentifier:@"DistributionCell2"];

    self.tableView.backgroundColor = CELLBG_COLOR;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    topView.backgroundColor = CELLBG_COLOR;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(18, 35, 70, 20)];
    title.textColor = [UIColor blackColor];
    [title setFont:[UIFont systemFontOfSize:16.0]];
    title.text = @"是否配送";
    
    [_switchBtn addTarget:self action:@selector(switchBtnChange:) forControlEvents:UIControlEventValueChanged];
    
    [headerView addSubview:topView];
    [headerView addSubview:title];
    [headerView addSubview:_switchBtn];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footerView.backgroundColor = CELLBG_COLOR;
    
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 50)];
    [_confirmBtn setTitle:@"确认并保存" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = NAV_COLOR;
    _confirmBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:_confirmBtn];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %2 == 0) {
        return 10;
    }
    else
        return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return swith;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row %2 == 0) {
        cell.backgroundColor = CELLBG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        switch (indexPath.row) {
            case 1:{
                DistributionCell2 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DistributionCell2" forIndexPath:indexPath];
                [cell.merchantBtn addTarget:self action:@selector(merchantBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.mangoBtn addTarget:self action:@selector(mangoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                if ([[DEFAULT objectForKey:@"deStatus"] isEqual:@"1"]) {
                    [cell.merchantBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
                    [cell.mangoBtn setImage:[UIImage imageNamed:@"方块未选"] forState:UIControlStateNormal];
                }
                else if([[DEFAULT objectForKey:@"deStatus"] isEqual:@"2"]){
                    [cell.merchantBtn setImage:[UIImage imageNamed:@"方块未选"] forState:UIControlStateNormal];
                    [cell.mangoBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
                }
                else{
                    [cell.merchantBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
                    [cell.mangoBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 3:{
                DistributionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DistributionCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title.text = @"配送范围";
                cell.unit.text = @"公里";
                cell.content.text = [DEFAULT objectForKey:@"distributionRange"];
                cell.Wlayout.constant = -10;
                return cell;
            }
                break;
            case 5:{
                DistributionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DistributionCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title.text = @"配送时间";
                cell.unit.text = @"分钟";
                cell.content.text = [DEFAULT objectForKey:@"deliveryCostTime"];
                cell.Wlayout.constant = -10;
                
                return cell;
            }

            case 7:{
                DistributionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DistributionCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title.text = @"配送费";
                cell.unit.text = @"元";
                cell.content.text = [DEFAULT objectForKey:@"distributionMoney"];
                cell.Wlayout.constant = -27;

                return cell;
            }
                break;
            case 9:{
                DistributionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DistributionCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title.text = @"餐盒费";
                cell.unit.text = @"元";
                cell.content.text = [DEFAULT objectForKey:@"Messbox"];
                cell.Wlayout.constant = -27;

                return cell;
            }
                break;
            case 11:{
                DistributionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DistributionCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title.text = @"起送价";
                cell.unit.text = @"元";
                cell.content.text = [DEFAULT objectForKey:@"startingPrice"];
                cell.Wlayout.constant = -27;

                return cell;
            }
                break;

                
            default:
                break;
        }
    }
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//商家自配送 ---默认选择商家自配送
- (void)merchantBtnClick:(id)sender {
//    UIButton *merchantBtn = (UIButton *)sender;
    DistributionCell2 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    [cell.merchantBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
//    [cell.mangoBtn setImage:[UIImage imageNamed:@"方块未选"] forState:UIControlStateNormal];
//    [DEFAULT setObject:@"1" forKey:@"deStatus"];
    
    //至少选择一种
    if ([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"至少要选择一种配送方式" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        if ([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"2"]) {
            [DEFAULT setObject:@"1,2" forKey:@"deStatus"];
            [cell.merchantBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
            [cell.mangoBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
        }
        else{
            [DEFAULT setObject:@"2" forKey:@"deStatus"];
            [cell.merchantBtn setImage:[UIImage imageNamed:@"方块未选"] forState:UIControlStateNormal];
            [cell.mangoBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
        }
    }
}

//蜂鸟配送
- (void)mangoBtnClick:(id)sender {
    DistributionCell2 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    //至少选择一种
    if ([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"2"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"至少要选择一种配送方式" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        if ([[DEFAULT objectForKey:@"deStatus"] isEqualToString:@"1"]) {
            [DEFAULT setObject:@"1,2" forKey:@"deStatus"];
            [cell.merchantBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
            [cell.mangoBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
        }
        else{
            [DEFAULT setObject:@"1" forKey:@"deStatus"];
            [cell.merchantBtn setImage:[UIImage imageNamed:@"方块选中"] forState:UIControlStateNormal];
            [cell.mangoBtn setImage:[UIImage imageNamed:@"方块未选"] forState:UIControlStateNormal];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %2 != 0 && indexPath.row != 1) {
        DistributionCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.content resignFirstResponder];
    }

}

//是否配送
-(void)switchBtnChange:(id)sender {
    BOOL isBtnOn = [_switchBtn isOn];
    if (isBtnOn) {
//        [DEFAULT setObject:@"1" forKey:@"isDistribution"];
        swith = 10;
        [self.tableView reloadData];
    }
    else{
//        [DEFAULT setObject:@"0" forKey:@"isDistribution"];
        swith = 0;
        [self.tableView reloadData];
        

    }
}


//- (IBAction)switchBtnChange:(id)sender {
//    if (isBtnOn) {
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//        NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:13 inSection:0];
//        [self.tableView moveRowAtIndexPath:scrollIndexPath toIndexPath:destinationIndexPath];
//        
//        UITableViewCell *cell;
//        for (int i = 3; i < 13; i++) {
//            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//            cell.hidden = NO;
//
//    }
//    else{
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:13 inSection:0];
//        NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//        [self.tableView moveRowAtIndexPath:scrollIndexPath toIndexPath:destinationIndexPath];
//        
//        UITableViewCell *cell;
//        for (int i = 4; i < 13; i++) {
//            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//            cell.hidden = YES;
//        }
//    }
//}


//点击确定
-(void)confirmBtnClick{
    BOOL isBtnOn = [_switchBtn isOn];
    if (isBtnOn) {
        [DEFAULT setObject:@"1" forKey:@"isDistribution"];
        for (int i = 0; i < 10; i++) {
            if (i %2 != 0 && i != 1) {
                DistributionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell.content resignFirstResponder];
                
                if (!(cell.content.text.length > 0)) {
                    [Util toastWithView:self.navigationController.view AndText:@"请填写完整配送信息"];
                    return ;
                }
                switch (i) {
                    case 3:
                        [DEFAULT setObject:cell.content.text forKey:@"distributionRange"];
                        break;
                    case 5:
                        [DEFAULT setObject:cell.content.text forKey:@"distributionMoney"];
                        break;
                    case 7:
                        [DEFAULT setObject:cell.content.text forKey:@"deliveryCostTime"];
                        break;
                    case 9:
                        [DEFAULT setObject:cell.content.text forKey:@"Messbox"];
                        break;
                    case 11:
                        [DEFAULT setObject:cell.content.text forKey:@"startingPrice"];
                        break;
                        
                    default:
                        break;
                }
            }
        }
        [self postPeiSong];
    }
    else{
        [DEFAULT setObject:@"0" forKey:@"isDistribution"];
        [self closePeisong];
    }

    
    
    [Util toastWithView:self.navigationController.view AndText:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}


//获取配送信息
-(void)getPeiSong{
    NSString *url = [API stringByAppendingString:@"Personal/peisong"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取配送信息 %@", responseObject);
        
        if (responseObject != nil) {
            if (responseObject[@"boxFee"] != nil && ![responseObject[@"boxFee"] isKindOfClass:[NSNull class]]) {
                [DEFAULT setObject:responseObject[@"boxFee"] forKey:@"Messbox"];
            }
            else{
                [DEFAULT setObject:@"0.00" forKey:@"Messbox"];
            }
            
            if (responseObject[@"deliveryFreeMoney"] != nil && ![responseObject[@"deliveryFreeMoney"] isKindOfClass:[NSNull class]]) {
                [DEFAULT setObject:responseObject[@"deliveryFreeMoney"] forKey:@"startingPrice"];
            }
            else{
                [DEFAULT setObject:@"0.00"  forKey:@"startingPrice"];
            }
            
            if (responseObject[@"deliveryStartMoney"] != nil && ![responseObject[@"deliveryStartMoney"] isKindOfClass:[NSNull class]]) {
                [DEFAULT setObject:responseObject[@"deliveryStartMoney"] forKey:@"distributionMoney"];
            }
            else{
                [DEFAULT setObject:@"0.00"  forKey:@"distributionMoney"];
            }
            
            if (responseObject[@"dlvService"] != nil && ![responseObject[@"dlvService"] isKindOfClass:[NSNull class]]) {
                NSString *s = responseObject[@"dlvService"];
                if ([s isEqualToString:@"1"]) {
                    [DEFAULT setObject:@"1" forKey:@"deStatus"];
                }
                else if ([s isEqualToString:@"2"]){
                    [DEFAULT setObject:@"2" forKey:@"deStatus"];
                }
                else
                    [DEFAULT setObject:@"1,2" forKey:@"deStatus"];

            }
            else{
                [DEFAULT setObject:@"1" forKey:@"deStatus"];
            }
            
            if (responseObject[@"isdelivery"] != nil && ![responseObject[@"isdelivery"] isKindOfClass:[NSNull class]]) {
                NSString *s = responseObject[@"isdelivery"];
                if ([s isEqualToString:@"1"]) {
                    [DEFAULT setObject:@"1" forKey:@"isDistribution"];
                }
                else
                    [DEFAULT setObject:@"0" forKey:@"isDistribution"];

            }
            else{
                [DEFAULT setObject:responseObject[@""] forKey:@"isDistribution"];
            }
            
            if (responseObject[@"range"] != nil && ![responseObject[@"range"] isKindOfClass:[NSNull class]]) {
                [DEFAULT setObject:responseObject[@"range"] forKey:@"distributionRange"];
            }
            else{
                [DEFAULT setObject:@"0.00"  forKey:@"distributionRange"];
            }
            
            if (responseObject[@"deliveryCostTime"] != nil && ![responseObject[@"deliveryCostTime"] isKindOfClass:[NSNull class]]) {
                [DEFAULT setObject:responseObject[@"deliveryCostTime"] forKey:@"deliveryCostTime"];
            }
            else{
                [DEFAULT setObject:@"0.00"  forKey:@"deliveryCostTime"];
            }
            
            [self.tableView reloadData];
        }
        else{

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取配送信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//关闭配送
-(void)closePeisong{
    NSString *url = [API stringByAppendingString:@"Personal/setPeisong"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"isdelivery":[DEFAULT objectForKey:@"isDistribution"]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"关闭配送 %@", responseObject);
        
        if (responseObject != nil) {
            ;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"关闭配送失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//保存配送信息
-(void)postPeiSong{
    NSString *url = [API stringByAppendingString:@"Personal/setPeisong"];
    NSDictionary *dic = @{@"isdelivery":[[DEFAULT objectForKey:@"isDistribution"] isEqualToString:@"1"]?@"true":@"false", @"dlvService":[DEFAULT objectForKey:@"deStatus"], @"range":[DEFAULT objectForKey:@"distributionRange"], @"deliveryStartMoney":[DEFAULT objectForKey:@"distributionMoney"], @"boxFee":[DEFAULT objectForKey:@"Messbox"], @"deliveryFreeMoney":[DEFAULT objectForKey:@"startingPrice"], @"deliveryCostTime":[DEFAULT objectForKey:@"deliveryCostTime"]};
    NSDictionary *data = @{@"shopId":[AppDelegate APP].user.shopId, @"data":[Util convertToJSONData:dic]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:data progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"保存配送 %@", responseObject);
        
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
//                [Util toastWithView:self.navigationController.view AndText:@"保存成功"];
            }
            else{
//                [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
                return ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"保存配送失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}



@end
