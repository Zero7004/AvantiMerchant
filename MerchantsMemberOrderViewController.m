//
//  MerchantsMemberOrderViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/22.
//  Copyright © 2017年 Mac. All rights reserved.
//


////***会员历史订单***/////

#import "MerchantsMemberOrderViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MerchantsMemberOrderTableViewCell.h"

@interface MerchantsMemberOrderViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *array;     //活动列表
@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) UISegmentedControl *segmentControl;

@property (nonatomic, getter=isLoading)BOOL loading;

//订单分类数组
@property (strong, nonatomic) NSArray *waimaiList;
@property (strong, nonatomic) NSArray *tangneiList;
@property (strong, nonatomic) NSArray *dingzuoList;
@property (strong, nonatomic) NSArray *ziquList;
@property (strong, nonatomic) NSDictionary *payType;

@end

@implementation MerchantsMemberOrderViewController

- (void)setLoading:(BOOL)loading
{
    if (self.loading == loading) {
        return;
    }
    _loading = loading;
    [self.tableView reloadEmptyDataSet];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _array = [[NSArray alloc] init];
    _waimaiList = [[NSArray alloc] init];
    _tangneiList = [[NSArray alloc] init];
    _dingzuoList = [[NSArray alloc] init];
    _ziquList = [[NSArray alloc] init];

    _payType = [[NSDictionary alloc] init];
    _payType = @{@"1":@"余额支付", @"2":@"纯微信支付", @"3":@"余额+微信", @"4":@"支付宝", @"5":@"支付宝+余额"};

    [self initTableView];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MerchantsMemberOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MerchantsMemberOrderTableViewCell"];
    
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    
    [self initSegmentControl];
    [self PostMerchantsMemberOrder];
}

-(void)initSegmentControl{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    
    _segmentControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 40)];
    [_segmentControl insertSegmentWithTitle:@"外卖订单" atIndex:0 animated:NO];
    [_segmentControl insertSegmentWithTitle:@"堂内订单" atIndex:1 animated:NO];
    [_segmentControl insertSegmentWithTitle:@"订座订单" atIndex:2 animated:NO];
    [_segmentControl insertSegmentWithTitle:@"自取订单" atIndex:3 animated:NO];
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl setTintColor:NAV_COLOR];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [_segmentControl addTarget:self action:@selector(segmentControlChange) forControlEvents:UIControlEventValueChanged];
    
    [headerView addSubview:_segmentControl];
    [headerView addSubview:bottomView];
    
    [self.view addSubview:headerView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MerchantsMemberOrderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MerchantsMemberOrderTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MerchantsMemberOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MerchantsMemberOrderTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_array[indexPath.row][@"createTime"] != nil && ![_array[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
        cell.time.text = _array[indexPath.row][@"createTime"];
    }
    else{
        cell.time.text = @"--";
    }
    
    if (_array[indexPath.row][@"orderNo"] != nil && ![_array[indexPath.row][@"orderNo"] isKindOfClass:[NSNull class]]) {
        cell.orderNumber.text = _array[indexPath.row][@"orderNo"];
    }
    else{
        cell.orderNumber.text = @"--";
    }

    if (_array[indexPath.row][@"needPay"] != nil && ![_array[indexPath.row][@"needPay"] isKindOfClass:[NSNull class]]) {
        cell.money.text = [NSString stringWithFormat:@"%@%@", @"￥", _array[indexPath.row][@"needPay"]];
    }
    else{
        cell.money.text = @"￥0.00";
    }
    
    if (_array[indexPath.row][@"payType"] != nil && ![_array[indexPath.row][@"payType"] isKindOfClass:[NSNull class]]) {
        cell.payType.text = [_payType objectForKey:_array[indexPath.row][@"payType"]];
    }
    else{
        cell.payType.text = @"--";
    }

    
    return cell;
}

-(void)segmentControlChange{
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:{
            _array = _waimaiList;
            [self.tableView reloadData];
        }
            break;
        case 1:{
            _array = _tangneiList;
            [self.tableView reloadData];
        }
            break;
        case 2:{
            _array = _dingzuoList;
            [self.tableView reloadData];
        }
            break;
        case 3:{
            _array = _ziquList;
            [self.tableView reloadData];
        }
            break;

        default:
            break;
    }
}

#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无订单";
    UIFont *font = [UIFont systemFontOfSize:17];
    UIColor *color = [UIColor lightGrayColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attribult];
}

//详情标题（返回详情标题）
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"点击重新加载";
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [attributes setObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeString;
}


//让图片进行旋转
//- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
//{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
//    animation.duration = 0.25;
//    animation.cumulative = YES;
//    animation.repeatCount = MAXFLOAT;
//    
//    return animation;
//}

//返回单张图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
//        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
        return [UIImage imageNamed:@"暂无数据"];

    } else {
        return [UIImage imageNamed:@"暂无数据"];
    }
}


#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return self.isLoading;
}
//点击view加载三秒后停止
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.loading = YES;
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //    });
    [self PostMerchantsMemberOrder];
}



//获取会员历史订单
-(void)PostMerchantsMemberOrder{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *url = [API_ReImg stringByAppendingString:@"Setshop/memberOrder"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"userId":_userId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取商家会员历史订单 %@", responseObject);
        [self.tableView.header endRefreshing];
        self.loading = NO;
        [_hud hideAnimated:YES];
        
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
                _waimaiList = responseObject[@"memberOrder"][@"waiMai"];
                _tangneiList = responseObject[@"memberOrder"][@"tanNei"];
                _dingzuoList = responseObject[@"memberOrder"][@"yuDing"];
                _ziquList = responseObject[@"memberOrder"][@"zhiQu"];

                
                switch (_segmentControl.selectedSegmentIndex) {
                    case 0:{
                        _array = _waimaiList;
                        [self.tableView reloadData];
                    }
                        break;
                    case 1:{
                        _array = _tangneiList;
                        [self.tableView reloadData];
                    }
                        break;
                    case 2:{
                        _array = _dingzuoList;
                        [self.tableView reloadData];
                    }
                        break;
                    case 3:{
                        _array = _ziquList;
                        [self.tableView reloadData];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取商家会员历史订单失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家会员历史订单失败 %@", error);
        self.loading = NO;
        [_hud hideAnimated:YES];
        [self.tableView.header endRefreshing];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
