//
//  IncomeTodayViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/7.
//  Copyright © 2017年 Mac. All rights reserved.
//


/*今日预计收入*/

#import "IncomeTodayViewController.h"
#import "THDatePickerView.h"
#import "IncomeTodayCell.h"
#import "incomeTodayDetailsViewController.h"


@interface IncomeTodayViewController ()<THDatePickerViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *allOrderType;
}


@property (strong, nonatomic) THDatePickerView *dateView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *topButton;

@property (strong, nonatomic) NSMutableArray *allOrder;       //充值订单和外卖订单
@property (strong, nonatomic) NSArray *cz;             //充值订单
@property (strong, nonatomic) NSArray *goods;          //外卖订单

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation IncomeTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"IncomeTodayCell" bundle:nil] forCellReuseIdentifier:@"IncomeTodayCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    allOrderType = [[NSDictionary alloc] initWithObjects:@[@"外卖订单", @"堂内订单", @"订座订单" , @"团购订餐"] forKeys:@[@"1", @"2", @"3", @"4"]];

    _allOrder = [[NSMutableArray alloc] init];
    
    _topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [_topButton setTitle:[Util getNowTime] forState:UIControlStateNormal];

    [self initDateView];
    
    //获取今日预计收入--获取今日时间
    [self getTodayWithTime:[Util getNowTime]];
}

-(void)initDateView{
    THDatePickerView *dateView = [[THDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    dateView.delegate = self;
    dateView.title = @"请选择时间";
    [self.view addSubview:dateView];
    self.dateView = dateView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 125;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    headerView.backgroundColor = [UIColor whiteColor];

    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 10)];
    centerView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];

    
//    _topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    [_topButton setTitle:[Util getNowTime] forState:UIControlStateNormal];
    [_topButton setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_topButton addTarget:self action:@selector(topBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _topButton.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    
    UILabel *orderNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 80, 50)];
    orderNum.text = @"订单号";
    [orderNum setTextColor:[UIColor blackColor]];
    
    UILabel *centerNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-35, 65, 80, 50)];
    centerNum.text = @"交易类型";
    [centerNum setTextColor:[UIColor blackColor]];

    UILabel *rightNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 65, 80, 50)];
    rightNum.text = @"金额";
    [rightNum setTextColor:[UIColor blackColor]];

    [headerView addSubview:_topButton];
    [headerView addSubview:orderNum];
    [headerView addSubview:centerView];
    [headerView addSubview:centerNum];
    [headerView addSubview:rightNum];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allOrder.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IncomeTodayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"IncomeTodayCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IncomeTodayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"IncomeTodayCell"];
    }
    if (indexPath.row < _cz.count) {
        cell.orderNo.text = @"充值无订单";
        cell.orderType.text = @"用户充值";
        cell.next.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_allOrder[indexPath.row][@"money"] != nil && ![_allOrder[indexPath.row][@"money"] isKindOfClass:[NSNull class]]) {
            cell.plan.text = [NSString stringWithFormat:@"%@%@", @"￥",_allOrder[indexPath.row][@"money"]];
        }
        else
            cell.plan.text = @"￥---";

    }
    else{
        cell.next.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (_allOrder[indexPath.row][@"orderNo"] != nil && ![_allOrder[indexPath.row][@"orderNo"] isKindOfClass:[NSNull class]]) {
            cell.orderNo.text = _allOrder[indexPath.row][@"orderNo"];
        }
        else
            cell.orderNo.text = @"---";
        
        if (_allOrder[indexPath.row][@"payType"] != nil && ![_allOrder[indexPath.row][@"payType"] isKindOfClass:[NSNull class]]) {
            cell.orderType.text = [allOrderType objectForKey:[NSString stringWithFormat:@"%@", _allOrder[indexPath.row][@"payType"]]];
        }
        else
            cell.orderType.text = @"---";

        if (_allOrder[indexPath.row][@"plan"] != nil && ![_allOrder[indexPath.row][@"plan"] isKindOfClass:[NSNull class]]) {
            cell.plan.text = [NSString stringWithFormat:@"%@%@", @"￥",_allOrder[indexPath.row][@"plan"]];
        }
        else
            cell.plan.text = @"￥---";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _cz.count) {
    }
    else{
        incomeTodayDetailsViewController *vc = [[incomeTodayDetailsViewController alloc] init];
        vc.arrayList = [[NSDictionary alloc] init];
        vc.goodsLists = [[NSArray alloc] init];
        vc.arrayList = _goods[indexPath.row - _cz.count];
        vc.goodsLists = _goods[indexPath.row - _cz.count][@"goodlist"];
        [vc.tableView reloadData];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//获取今天预计收入记录
-(void)getTodayWithTime:(NSString *)time{
//    NSString *birthdayStr = time;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
//    NSDate *dateTime = [dateFormatter dateFromString:birthdayStr];
//    NSTimeInterval interval = [dateTime timeIntervalSince1970];
//    int IntTime = interval;
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/getOrderLog"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"time":time};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取今日预计收入 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            _cz = responseObject[@"cz"];
            _goods = responseObject[@"goods"];
            [_allOrder removeAllObjects];
            if (_cz != nil && ![_cz isKindOfClass:[NSNull class]]) {
                [_allOrder addObjectsFromArray:_cz];
            }
            else
                _cz = [[NSArray alloc] init];
            
            if (_goods != nil && ![_goods isKindOfClass:[NSNull class]]) {
                [_allOrder addObjectsFromArray:_goods];
            }
            else
                _goods = [[NSArray alloc] init];
            
            [self.tableView reloadData];
        }
        else{
            [Util toastWithView:self.view AndText:@"获取今日预计收入失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取今日预计收入失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}

//选择日期入口
-(void)topBtnClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
        [self.dateView show];
    }];

}



#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
//    NSLog(@"保存点击");
    NSLog(@"%@", timer);
    [_topButton setTitle:timer forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
    
    [self getTodayWithTime:timer];
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
//    NSLog(@"取消点击");
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300);
    }];
}


@end
