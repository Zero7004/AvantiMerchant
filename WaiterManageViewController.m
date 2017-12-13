//
//  WaiterManageViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*服务员管理*//

#import "WaiterManageViewController.h"
#import "StewardTableViewCell.h"
#import "GradeWaiterViewController.h"
#import "AddWaiterViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface WaiterManageViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) UIButton *gradeBtn;   //服务员评分按钮
@property (strong, nonatomic) UIButton *addWaiterBtn;   //添加服务员按钮
@property (strong, nonatomic) UIView *footerView;   //底部视图

@property (strong,nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *waiterArray;

@property (nonatomic, getter=isLoading)BOOL loading;

@end

@implementation WaiterManageViewController

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
    
    _waiterArray = [[NSArray alloc] init];
    
    
    [self initTableView];
    [self initTableFooterView];
    [self addRefreshView];

}

-(void)viewWillAppear:(BOOL)animated{
    [self getAllWaiter];
}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}


-(void)refreshAction{
    [self getAllWaiter];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO; //隐藏分割线
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"StewardTableViewCell" bundle:nil] forCellReuseIdentifier:@"StewardTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];

    [self.view addSubview:_tableView];
}

//初始化底部视图
-(void)initTableFooterView{
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 130, SCREEN_WIDTH, 60)];
    _footerView.backgroundColor = BG_COLOR;
    
    _gradeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2 - 20, 50)];
    [_gradeBtn setTitle:@"服务员评分" forState:UIControlStateNormal];
    [_gradeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _gradeBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _gradeBtn.backgroundColor = [UIColor whiteColor];
    [_gradeBtn addTarget:self action:@selector(gradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _gradeBtn.layer.cornerRadius = 7.0;//2.0是圆角的弧度，根据需求自己更改
    _gradeBtn.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    _gradeBtn.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _gradeBtn.layer.shadowOpacity = 1.0f;//阴影透明度，默认0
    _gradeBtn.layer.shadowRadius = 4.0f;//阴影半径，默认3
    
    _addWaiterBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, 5, SCREEN_WIDTH/2 - 20, 50)];
    [_addWaiterBtn setTitle:@"添加服务员" forState:UIControlStateNormal];
    [_addWaiterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addWaiterBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _addWaiterBtn.backgroundColor = NAV_COLOR;
    [_addWaiterBtn addTarget:self action:@selector(addWaiterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _addWaiterBtn.layer.cornerRadius = 7.0;//2.0是圆角的弧度，根据需求自己更改
    _addWaiterBtn.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    _addWaiterBtn.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _addWaiterBtn.layer.shadowOpacity = 1.0f;//阴影透明度，默认0
    _addWaiterBtn.layer.shadowRadius = 4.0f;//阴影半径，默认3


    [_footerView addSubview:_gradeBtn];
    [_footerView addSubview:_addWaiterBtn];
    
    [self.view addSubview:_footerView];
//    self.tableView.tableFooterView = _footerView;
//    [self.navigationController.view addSubview:_footerView];
}

//初始化底部视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}


//使得底部视图停留在底部--但是我的底部视图加不上
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat sectionHeaderHeight = 60;//设置你footer高度
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 130;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _waiterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StewardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StewardTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[StewardTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"StewardTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_waiterArray[indexPath.row][@"waiterName"] != nil && ![_waiterArray[indexPath.row][@"waiterName"] isKindOfClass:[NSNull class]]) {
        cell.name.text = [NSString stringWithFormat:@"%@%@", @"姓名：",_waiterArray[indexPath.row][@"waiterName"]];
    }
    else
        cell.name.text = [NSString stringWithFormat:@"%@", @"姓名："];

    if (_waiterArray[indexPath.row][@"waiterNum"] != nil && ![_waiterArray[indexPath.row][@"waiterNum"] isKindOfClass:[NSNull class]]) {
        cell.number.text = [NSString stringWithFormat:@"%@%@", @"编号：",_waiterArray[indexPath.row][@"waiterNum"]];
    }
    else
        cell.number.text = [NSString stringWithFormat:@"%@", @"编号："];

    //按钮点击事件
    cell.EditBtn.tag = indexPath.row;
    [cell.EditBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.DeleteBtn.tag = indexPath.row;
    [cell.DeleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

//查看服务员列表
-(void)getAllWaiter{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/waiter"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.loading = NO;
        [_hud hideAnimated:YES];

        NSLog(@"获取店内服务员 %@", responseObject);
        [self.tableView.header endRefreshing];
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"0"]) {
                _waiterArray = @[];
                [self.tableView reloadData];
            }
            else{
                _waiterArray = responseObject[@"waiter"];
                [self.tableView reloadData];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取店内服务员失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取店内服务员失败 %@", error);
        
        self.loading = NO;
        [_hud hideAnimated:YES];
        _waiterArray = @[];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//点击编辑按钮
-(void)editBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    AddWaiterViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"addWaiter"];
    vc.titlelable = @"编辑";
    vc.waiterInfo = _waiterArray[btn.tag];
    vc.block = ^(NSArray *waiterArr) {
//        _waiterArray = waiterArr;
//        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//点击删除按钮
-(void)deleteBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self deleteWaiterWithID:[NSString stringWithFormat:@"%@",_waiterArray[btn.tag][@"id"]]];
}

//点击服务员评分
-(void)gradeBtnClick{
    GradeWaiterViewController *vc = [[GradeWaiterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击添加服务员
-(void)addWaiterBtnClick{
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    AddWaiterViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"addWaiter"];
    vc.titlelable = @"添加";
    vc.block = ^(NSArray *waiterArr) {
//        _waiterArray = waiterArr;
//        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//点击删除服务员
-(void)deleteWaiterWithID:(NSString *)waiterId{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/delWaiter"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"id":waiterId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除服务员 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"0"]) {
                _waiterArray = @[];
                [self.tableView reloadData];
            }
            else{
//                _waiterArray = responseObject;
//                [self.tableView reloadData];
                [self getAllWaiter];
                [Util toastWithView:self.navigationController.view AndText:@"删除成功"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"删除失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除服务员失败 %@", error);
        [_hud hideAnimated:YES];
     
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无服务员";
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
    
    [self getAllWaiter];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
