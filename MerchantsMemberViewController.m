//
//  MerchantsMemberViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*商家会员*//

#import "MerchantsMemberViewController.h"
#import "MerchantsMemberTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MerchantsMemberOrderViewController.h"
#import "SetMerchantsViewController.h"

@interface MerchantsMemberViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *number;
@property (strong, nonatomic) NSArray *menberList;

@property (nonatomic, getter=isLoading)BOOL loading;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation MerchantsMemberViewController
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
    _menberList = [[NSArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BG_COLOR;

    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MerchantsMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"MerchantsMemberTableViewCell"];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];

    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    
    //查看会员等级    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"查看会员等级" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    rightBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    [self addRefreshView];
    [self initFooterView];
    [self postMember];

}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction{
    [self postMember];
}

//头部视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];

    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 50)];
    name.text = @"姓名";
    [name setFont:[UIFont systemFontOfSize:15.0]];
    name.backgroundColor = [UIColor whiteColor];
    [name setTextColor:[UIColor blackColor]];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 230, 0, 40, 50)];
//    UILabel *money = [[UILabel alloc] init];
    money.text = @"余额";
    [money setFont:[UIFont systemFontOfSize:15.0]];
    money.backgroundColor = [UIColor whiteColor];
    [money setTextColor:[UIColor blackColor]];

    UILabel *integral = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 0, 40, 50)];
//    UILabel *integral = [[UILabel alloc] init];
    integral.text = @"积分";
    [integral setFont:[UIFont systemFontOfSize:15.0]];
    integral.backgroundColor = [UIColor whiteColor];
    [integral setTextColor:[UIColor blackColor]];
    
    UILabel *discount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110, 0, 40, 50)];
//    UILabel *discount = [[UILabel alloc] init];
    discount.text = @"折扣";
    [discount setFont:[UIFont systemFontOfSize:15.0]];
    discount.backgroundColor = [UIColor whiteColor];
    [discount setTextColor:[UIColor blackColor]];
    
    UILabel *Call = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 50)];
    Call.text = @"拨打";
    [Call setFont:[UIFont systemFontOfSize:15.0]];
    Call.backgroundColor = [UIColor whiteColor];
    [Call setTextColor:[UIColor blackColor]];
    
    [headerView addSubview:name];
    [headerView addSubview:money];
    [headerView addSubview:integral];
    [headerView addSubview:discount];
    [headerView addSubview:Call];

    //添加约束
    
    return headerView;
}

//初始化底部视图
-(void)initFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(-75, SCREEN_HEIGHT - 150, 150, 150)];
    footerView.layer.cornerRadius = 75;//设置那个圆角的有多圆
    footerView.backgroundColor = NAV_COLOR;

    UILabel *count =  [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 60, 30)];
    count.text = @"总数";
    [count setFont:[UIFont systemFontOfSize:13]];
    [count setTextColor:[UIColor blackColor]];
    count.textAlignment = NSTextAlignmentCenter;
    
    _number = [[UILabel alloc] initWithFrame:CGRectMake(75, 38, 60, 50)];
    _number.text = @"0";
    if (SCREEN_WIDTH == 320) {
        [_number setFont:[UIFont systemFontOfSize:18]];
    }
    else if (SCREEN_WIDTH == 375){
        [_number setFont:[UIFont systemFontOfSize:20]];
    }
    else{
        [_number setFont:[UIFont systemFontOfSize:23]];
    }
    _number.textAlignment = NSTextAlignmentCenter;
    [_number setTextColor:[UIColor whiteColor]];

    [footerView addSubview:count];
    [footerView addSubview:_number];
    [self.view addSubview:footerView];
}


/**
 会员等级设置
 */
-(void)rightBtnClick{
    SetMerchantsViewController *vc = [[SetMerchantsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _menberList.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _menberList.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        return cell;
    }
    else{
        MerchantsMemberTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MerchantsMemberTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MerchantsMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MerchantsMemberTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_menberList[indexPath.row][@"userName"] != nil && ![_menberList[indexPath.row][@"userName"] isKindOfClass:[NSNull class]]) {
            cell.userName.text = [NSString stringWithFormat:@"%@", _menberList[indexPath.row][@"userName"]];
        }
        else
            cell.userName.text = @"";
        
        if (_menberList[indexPath.row][@"money"] != nil && ![_menberList[indexPath.row][@"money"] isKindOfClass:[NSNull class]]) {
            cell.money.text = [NSString stringWithFormat:@"%@", _menberList[indexPath.row][@"money"]];
            if ([cell.money.text floatValue] > 10000) {
                cell.money.text = [NSString stringWithFormat:@"%.2f%@", [cell.money.text floatValue] / 10000, @"万"];
            }
        }
        else
            cell.money.text = @"";
        
        if (_menberList[indexPath.row][@"userScore"] != nil && ![_menberList[indexPath.row][@"userScore"] isKindOfClass:[NSNull class]]) {
            cell.userScore.text = [NSString stringWithFormat:@"%@", _menberList[indexPath.row][@"userScore"]];
        }
        else
            cell.userScore.text = @"";
        
        if (_menberList[indexPath.row][@"userPhone"] != nil && ![_menberList[indexPath.row][@"userPhone"] isKindOfClass:[NSNull class]]) {
            [cell.phoneBtn setImage:[UIImage imageNamed:@"mobil"] forState:UIControlStateNormal];
            [cell.phoneBtn setEnabled:YES];
            cell.phoneBtn.tag = indexPath.row;
            [cell.phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [cell.phoneBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
            [cell.phoneBtn setEnabled:NO];
            cell.phoneBtn.tag = indexPath.row;
        }
        
        cell.zk.text = @"无";
        
        if (SCREEN_WIDTH == 320) {
            [cell.userName setFont:[UIFont systemFontOfSize:12]];
            [cell.money setFont:[UIFont systemFontOfSize:12]];
            [cell.userScore setFont:[UIFont systemFontOfSize:12]];
            [cell.zk setFont:[UIFont systemFontOfSize:12]];
        }
        else{
            [cell.userName setFont:[UIFont systemFontOfSize:15]];
            [cell.money setFont:[UIFont systemFontOfSize:15]];
            [cell.userScore setFont:[UIFont systemFontOfSize:15]];
            [cell.zk setFont:[UIFont systemFontOfSize:15]];
        }
        
        
        cell.userNameBtn.tag = indexPath.row;
        [cell.userNameBtn addTarget:self action:@selector(userNameBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}


-(void)postMember{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Setshop/member"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取商家会员 %@", responseObject);
        [self.tableView.header endRefreshing];
        self.loading = NO;
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            if (responseObject[@"num"] != nil && ![responseObject[@"num"] isKindOfClass:[NSNull class]]) {
                _number.text = [NSString stringWithFormat:@"%@", responseObject[@"num"]];
            }
            else
                _number.text = @"0";
            if (responseObject[@"people"] != nil && ![responseObject[@"people"] isKindOfClass:[NSNull class]]) {
                _menberList = responseObject[@"people"];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"获取商家会员失败"];
            [self.tableView reloadData];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取商家会员失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家会员失败 %@", error);
        self.loading = NO;
        [_hud hideAnimated:YES];

        [self.tableView.header endRefreshing];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}

//打电话
-(void)phoneBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_menberList[btn.tag][@"userPhone"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}


//点击用户名查看用户历史订单
-(void)userNameBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MerchantsMemberOrderViewController *vc = [[MerchantsMemberOrderViewController alloc] init];
    vc.userId = _menberList[btn.tag][@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无会员";
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
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

//返回单张图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
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
    [self postMember];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
