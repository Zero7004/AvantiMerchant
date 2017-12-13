//
//  SetMerchantsViewController.m
//  AvantiMerchant
//
//  Created by long on 2017/12/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

////** 设置会员等级 **////

#import "SetMerchantsViewController.h"
#import "MerchantsVIPCell.h"
#import "EditMerchantsVIPViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface SetMerchantsViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *vipArray;
@property (strong, nonatomic) UIButton *editBtn;
@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic, getter=isLoading)BOOL loading;

@end

@implementation SetMerchantsViewController

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
    _vipArray = [[NSArray alloc] init];
    
//    //查看会员等级
//    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑会员等级" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
//    rightBarBtn.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    [self initTableView];
    [self initFooterView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self postVIP];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MerchantsVIPCell" bundle:nil] forCellReuseIdentifier:@"MerchantsVIPCell"];
    _tableView.tableFooterView = [UIView new];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];

    [self.view addSubview:_tableView];
}

-(void)initFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 130, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    _editBtn = [[UIButton alloc] init];
    [_editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _editBtn.frame = CGRectMake(30, 10, SCREEN_WIDTH - 60, 45);
    [_editBtn setBackgroundColor:NAV_COLOR];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setTitle:@"编辑会员等级" forState:UIControlStateNormal];
    [footerView addSubview:_editBtn];
    [self.view addSubview:footerView];
}

#pragma mark === UITableViewDelegate ===
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 39)];
    nameLabel.text = @"  等级名称";
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    
    UILabel *zkLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 39)];
    zkLabel.text = @"享受折扣";
    zkLabel.font = [UIFont systemFontOfSize:17];
    zkLabel.textAlignment = NSTextAlignmentCenter;
    zkLabel.textColor = [UIColor blackColor];

    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3 * 2, 0, SCREEN_WIDTH/3 - 10, 39)];
    moneyLabel.text = @"充值金额";
    moneyLabel.font = [UIFont systemFontOfSize:17];
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.textColor = [UIColor blackColor];

    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    bottomLabel.backgroundColor = [UIColor grayColor];
    
    [headerView addSubview:nameLabel];
    [headerView addSubview:zkLabel];
    [headerView addSubview:moneyLabel];
    [headerView addSubview:bottomLabel];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _vipArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MerchantsVIPCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"MerchantsVIPCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MerchantsVIPCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MerchantsVIPCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_vipArray[indexPath.row][@"name"] != nil && ![_vipArray[indexPath.row][@"name"] isKindOfClass:[NSNull class]]) {
        cell.name.text = _vipArray[indexPath.row][@"name"];
    }
    else{
        cell.name.text = @"--";
    }
    
    if (_vipArray[indexPath.row][@"money"] != nil && ![_vipArray[indexPath.row][@"money"] isKindOfClass:[NSNull class]]) {
        cell.money.text = [NSString stringWithFormat:@"%@", _vipArray[indexPath.row][@"money"]];
    }
    else{
        cell.money.text = @"--";
    }

    if (_vipArray[indexPath.row][@"zk"] != nil && ![_vipArray[indexPath.row][@"zk"] isKindOfClass:[NSNull class]]) {
        cell.zk.text = [NSString stringWithFormat:@"%.1f", [_vipArray[indexPath.row][@"zk"] floatValue]];
    }
    else{
        cell.zk.text = @"--";
    }

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 编辑会员等级
 */
-(void)editBtnClick{
    EditMerchantsVIPViewController *vc = [[EditMerchantsVIPViewController alloc] init];
    vc.vipArray = [NSMutableArray array];
    vc.vipArray = [_vipArray mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark === 接口 ===

/**
 获取商家设置的会员信息
 */
-(void)postVIP{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API_ReImg stringByAppendingString:@"Setshop/shopVip"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_hud hideAnimated:YES];
        self.loading = NO;
        NSLog(@"获取商家会员等级%@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                _vipArray = responseObject[@"shopVip"];
                [self.tableView reloadData];
            }else{
//                [Util toastWithView:self.navigationController.view AndText:@"获取会员等级信息失败"];
            }
        }else{
            [Util toastWithView:self.navigationController.view AndText:@"获取会员等级信息失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家会员等级失败%@", error);
        [_hud hideAnimated:YES];
        self.loading = NO;
        [Util toastWithView:self.navigationController.view AndText:@"获取会员等级信息失败"];
    }];
}

#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无会员等级";
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

    [self postVIP];
}


@end
