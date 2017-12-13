//
//  GradeWaiterViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/9.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "GradeWaiterViewController.h"
#import "EvaluationWaiterTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface GradeWaiterViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *gradeHighestBtn;  //评分最高按钮
@property (strong, nonatomic) UIButton *gradeLowestBtn;   //评分最低按钮

@property (strong, nonatomic) NSArray *waiterPoint;

@property (nonatomic, getter=isLoading)BOOL loading;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation GradeWaiterViewController

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
    
    _waiterPoint = [[NSArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluationWaiterTableViewCell" bundle:nil] forCellReuseIdentifier:@"EvaluationWaiterTableViewCell"];
    self.tableView.separatorStyle = NO; //隐藏分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    
    [self addRefreshView];

    [self postWaiterPoint];
    
    [self initHeaderView];
}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}


-(void)refreshAction{
    [self postWaiterPoint];
}


-(void)initHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    headerView.backgroundColor = [UIColor blackColor];

    //    _gradeHighestBtn = [UIButton alloc] initWithFrame:
    
//    self.tableView.tableHeaderView = headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _gradeHighestBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/2 - 10, 50)];
    [_gradeHighestBtn setTitle:@"评分最高" forState:UIControlStateNormal];
    [_gradeHighestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _gradeHighestBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _gradeHighestBtn.backgroundColor = [UIColor whiteColor];
    [_gradeHighestBtn addTarget:self action:@selector(gradeHightestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _gradeLowestBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, 5, SCREEN_WIDTH/2 - 10, 50)];
    [_gradeLowestBtn setTitle:@"评分最低" forState:UIControlStateNormal];
    [_gradeLowestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _gradeLowestBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _gradeLowestBtn.backgroundColor = [UIColor whiteColor];
    [_gradeLowestBtn addTarget:self action:@selector(gradeLowestBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *centerLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 5, 1, 40)];
    centerLable.backgroundColor = [UIColor grayColor];
    UILabel *bottomLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, SCREEN_WIDTH, 1)];
    bottomLable.backgroundColor = [UIColor lightGrayColor];
    
    [headerView addSubview:_gradeHighestBtn];
    [headerView addSubview:_gradeLowestBtn];
    [headerView addSubview:centerLable];
    [headerView addSubview:bottomLable];
    
    return headerView;
}

//初始化底部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _waiterPoint.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvaluationWaiterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EvaluationWaiterTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EvaluationWaiterTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EvaluationWaiterTableViewCell"];
    }
    cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_waiterPoint[indexPath.row][@"waiterName"] != nil && ![_waiterPoint[indexPath.row][@"waiterName"] isKindOfClass:[NSNull class]]) {
        cell.name.text = [NSString stringWithFormat:@"%@%@", @"姓名：",_waiterPoint[indexPath.row][@"waiterName"]];
    }
    else
        cell.name.text = [NSString stringWithFormat:@"%@", @"姓名："];
    

    if (_waiterPoint[indexPath.row][@"waiterNum"] != nil && ![_waiterPoint[indexPath.row][@"waiterNum"] isKindOfClass:[NSNull class]]) {
        cell.number.text = [NSString stringWithFormat:@"%@%@", @"编号：",_waiterPoint[indexPath.row][@"waiterNum"]];
    }
    else
        cell.number.text = [NSString stringWithFormat:@"%@", @"编号："];

    if (_waiterPoint[indexPath.row][@"goods"] != nil && ![_waiterPoint[indexPath.row][@"goods"] isKindOfClass:[NSNull class]]) {
        cell.point.text = [NSString stringWithFormat:@"%@",_waiterPoint[indexPath.row][@"goods"]];
    }
    else
        cell.point.text = [NSString stringWithFormat:@"%@",@"-"];
    
    return cell;
    
}

//点击评分最高--冒泡排序法
-(void)gradeHightestBtnClick{
    NSLog(@"点击最高分排序");
    if (_waiterPoint.count > 0) {
        NSMutableArray *tempArray = [_waiterPoint mutableCopy];
        for (int i = 0; i < tempArray.count-1; i++) {
            for (int j = 0; j < tempArray.count - i - 1; j++) {
                if ([tempArray[j][@"goods"] integerValue] < [tempArray[j+1][@"goods"] integerValue]) {
                    [tempArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
            }
        }
        
        _waiterPoint = [tempArray copy];
        [self.tableView reloadData];
    }
    
}

//点击评分最低
-(void)gradeLowestBtnClick{
    NSLog(@"点击最低分排序");
    if (_waiterPoint.count > 0) {
        NSMutableArray *tempArray = [_waiterPoint mutableCopy];
        for (int i = 0; i < tempArray.count-1; i++) {
            for (int j = 0; j < tempArray.count - i - 1; j++) {
                if ([tempArray[j][@"goods"] integerValue] > [tempArray[j+1][@"goods"] integerValue]) {
                    [tempArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
            }
        }
        
        _waiterPoint = [tempArray copy];
        [self.tableView reloadData];
    }

}

//获取服务员评分
-(void)postWaiterPoint{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/seewaiter"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loading = NO;
        [_hud hideAnimated:YES];

        NSLog(@"获取服务员评分 %@", responseObject);
        [self.tableView.header endRefreshing];

        if (responseObject != nil) {
            _waiterPoint = responseObject;
            [self.tableView reloadData];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取服务员评分失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取服务员评分失败 %@", error);
        self.loading = NO;
        [_hud hideAnimated:YES];

        [self.tableView.header endRefreshing];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}


#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无服务员评分";
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
    
    [self postWaiterPoint];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
