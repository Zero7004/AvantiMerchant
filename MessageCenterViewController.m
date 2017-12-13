//
//  MessageCenterViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/12.
//  Copyright © 2017年 Mac. All rights reserved.
//

//**消息中心**//

#import "MessageCenterViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BusinessMessageTableViewCell.h"
#import "SyestemMessageTableViewCell.h"

@interface MessageCenterViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, getter=isLoading)BOOL loading;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISegmentedControl *segment;

@property BOOL isBusiness;    //是否查看业务信息

@end

@implementation MessageCenterViewController

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
    _isBusiness = YES;    //初始默认查看业务信息

    [self initHeaderView];
    [self initTableView];
}


-(void)initHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    _segment = [[UISegmentedControl alloc] init];
    _segment.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 35);
    [_segment insertSegmentWithTitle:@"业务信息" atIndex:0 animated:NO];
    [_segment insertSegmentWithTitle:@"系统消息" atIndex:1 animated:NO];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(segChange) forControlEvents:UIControlEventValueChanged];
    _segment.tintColor = NAV_COLOR;
    //设置选中颜色 -- 默认为白色
    [_segment setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    [headerView addSubview:line];
    [headerView addSubview:_segment];
    [self.view addSubview:headerView];
}


-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessMessageTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SyestemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"SyestemMessageTableViewCell"];
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    [self.view addSubview:_tableView];
}


//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isBusiness) {
        return 70;
    }
    else
        return 50 + 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (_isBusiness) {
        BusinessMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessMessageTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[BusinessMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BusinessMessageTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
    }
    else{
        SyestemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SyestemMessageTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[SyestemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SyestemMessageTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    return cell;
}

-(void) segChange
{
//    NSLog(@"%ld", (long)_segment.selectedSegmentIndex);
//    [_segment setTitle:@"ee" forSegmentAtIndex:_segment.selectedSegmentIndex];
    if (_segment.selectedSegmentIndex == 0) {
        _isBusiness = YES;
        [self.tableView reloadData];
    }
    else{
        _isBusiness = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无消息";
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loading = NO;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
