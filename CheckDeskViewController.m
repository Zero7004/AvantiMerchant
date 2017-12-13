//
//  CheckDeskViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//

//查看桌位

#import "CheckDeskViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "EditDeskViewController.h"
#import "DeskCell.h"
#import "DeskCollectionViewCell.h"


@interface CheckDeskViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIButton *scatteredDeskBtn;    //散台按钮
@property (strong, nonatomic) UIButton *boxBtn;              //包厢按钮
@property (strong, nonatomic) UIButton *editDeskBtn;         //编辑桌位按钮
@property BOOL isBoxBtn;      //是否选中包厢按钮

@property (nonatomic, getter=isLoading)BOOL loading;

@property (nonatomic, strong) NSMutableArray *deskList;
@property (nonatomic, strong) NSMutableArray *deskSanTai;
@property (nonatomic, strong) NSMutableArray *deskBaoXiang;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation CheckDeskViewController

- (void)setLoading:(BOOL)loading
{
    if (self.loading == loading) {
        return;
    }
    _loading = loading;
    [self.collectionView reloadEmptyDataSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = CELLBG_COLOR;
    
    _isBoxBtn = NO;
    _deskList = [[NSMutableArray alloc] init];
    _deskSanTai = [[NSMutableArray alloc] init];
    _deskBaoXiang = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 166) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = CELLBG_COLOR;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeskCell" bundle:nil] forCellWithReuseIdentifier:@"DeskCell"];
    [self.collectionView setEmptyDataSetDelegate:self];
    [self.collectionView setEmptyDataSetSource: self];
    [self.view addSubview:_collectionView];
    
    [self initHearderView];
    [self initBottomView];
    [self addRefreshView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取桌位预定状态--列表
    [self postGetDesk];
}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    

    weakSelf.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
}

-(void)refreshAction{

    [self postGetDesk];
}

//初始化头部视图
-(void)initHearderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _scatteredDeskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [_scatteredDeskBtn setTitle:@"散台" forState:UIControlStateNormal];
    [_scatteredDeskBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    _scatteredDeskBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _scatteredDeskBtn.backgroundColor = [UIColor whiteColor];
    [_scatteredDeskBtn addTarget:self action:@selector(scatteredDeskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _boxBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [_boxBtn setTitle:@"包厢" forState:UIControlStateNormal];
    [_boxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _boxBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _boxBtn.backgroundColor = [UIColor whiteColor];
    [_boxBtn addTarget:self action:@selector(boxBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *centerLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, 50)];
    centerLable.backgroundColor = [UIColor grayColor];
    
    UILabel *bottomLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    bottomLable.backgroundColor = [UIColor grayColor];
    
    [headerView addSubview:_scatteredDeskBtn];
    [headerView addSubview:_boxBtn];
    [headerView addSubview:centerLable];
    [headerView addSubview:bottomLable];
    [self.view addSubview:headerView];
}

//初始化底部视图
-(void)initBottomView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 116, SCREEN_WIDTH, 50)];
    footerView .backgroundColor = [UIColor whiteColor];
    
    _editDeskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [_editDeskBtn setTitle:@"编辑桌位" forState:UIControlStateNormal];
    [_editDeskBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _editDeskBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _editDeskBtn.backgroundColor = [UIColor whiteColor];
    [_editDeskBtn addTarget:self action:@selector(editDeskBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *topLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLable.backgroundColor = [UIColor grayColor];
    
    [footerView addSubview:_editDeskBtn];
    [footerView addSubview:topLable];
    [self.view addSubview:footerView];
}



#pragma mark - collectionViewDelegate
//多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


//每组数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _deskList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DeskCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"DeskCell" forIndexPath:indexPath];
    
    if (_deskList[indexPath.row][@"deskNum"] != nil && ![_deskList[indexPath.row][@"deskNum"] isKindOfClass:[NSNull class]]) {
        cell.deskNum.text = [NSString stringWithFormat:@"%@%@", @"桌位号：", _deskList[indexPath.row][@"deskNum"]];
    }
    else{
        cell.deskNum.text = @"桌位号码：";
    }
    
    if (_deskList[indexPath.row][@"deskName"] != nil && ![_deskList[indexPath.row][@"deskName"] isKindOfClass:[NSNull class]]) {
        cell.deskName.text = [NSString stringWithFormat:@"%@%@", @"桌位名称：", _deskList[indexPath.row][@"deskName"]];
    }
    else{
        cell.deskName.text = @"桌位名称：";
    }
    
    if (_deskList[indexPath.row][@"deskType"] != nil && ![_deskList[indexPath.row][@"deskType"] isKindOfClass:[NSNull class]]) {
        cell.deskType.text = [NSString stringWithFormat:@"%@%@", @"桌位类型：", _deskList[indexPath.row][@"deskType"]];
    }
    else{
        cell.deskType.text = @"桌位类型：";
    }
    
    //先判断是否收取定金，再判断是价格是否为0.00
    if (_deskList[indexPath.row][@"money"] != nil && ![_deskList[indexPath.row][@"money"] isKindOfClass:[NSNull class]]) {
        cell.money.text = [NSString stringWithFormat:@"%@%@%@", @"预定价格：", _deskList[indexPath.row][@"money"], @"元"];
        if ([_deskList[indexPath.row][@"money"] isEqualToString:@"0.00"]) {
            cell.cancelDeskBtn.hidden = NO;
            cell.returnBtn.hidden = YES;
            cell.takeBtn.hidden = YES;
        }
        else{
            //判断是否收取定金
            if (_deskList[indexPath.row][@"moneyType"] != nil && ![_deskList[indexPath.row][@"moneyType"] isKindOfClass:[NSNull class]]) {
                NSString *moneyType = [NSString stringWithFormat:@"%@", _deskList[indexPath.row][@"moneyType"]];
                if ([moneyType isEqualToString:@"0"]) {
                    cell.cancelDeskBtn.hidden = NO;
                    cell.returnBtn.hidden = YES;
                    cell.takeBtn.hidden = YES;
                }
                else if ([moneyType isEqualToString:@"1"]) {
                    cell.cancelDeskBtn.hidden = YES;
                    cell.returnBtn.hidden = NO;
                    cell.takeBtn.hidden = NO;
                }
                else{
                    cell.cancelDeskBtn.hidden = NO;
                    cell.returnBtn.hidden = YES;
                    cell.takeBtn.hidden = YES;
                }
            }
            else{
                cell.cancelDeskBtn.hidden = NO;
                cell.returnBtn.hidden = YES;
                cell.takeBtn.hidden = YES;
            }
        }
    }
    else{
        cell.money.text = @"预定价格：0.00元";
        cell.cancelDeskBtn.hidden = NO;
        cell.returnBtn.hidden = YES;
        cell.takeBtn.hidden = YES;
    }
    
    if (_deskList[indexPath.row][@"userName"] != nil && ![_deskList[indexPath.row][@"userName"] isKindOfClass:[NSNull class]]) {
        cell.userName.text = [NSString stringWithFormat:@"%@%@", @"姓名：", _deskList[indexPath.row][@"userName"]];
    }
    else{
        cell.userName.text = @"姓名：";
    }
    
    if (_deskList[indexPath.row][@"userPhone"] != nil && ![_deskList[indexPath.row][@"userPhone"] isKindOfClass:[NSNull class]]) {
        NSString *text = [NSString stringWithFormat:@"%@%@", @"电话：", _deskList[indexPath.row][@"userPhone"]];
        [cell.userPhone setTitle:text forState:UIControlStateNormal];
    }
    else{
        [cell.userPhone setTitle:@"电话：" forState:UIControlStateNormal];
    }
    
    if (_deskList[indexPath.row][@"remark"] != nil && ![_deskList[indexPath.row][@"remark"] isKindOfClass:[NSNull class]]) {
        cell.remark.text = [NSString stringWithFormat:@"%@%@", @"备注：", _deskList[indexPath.row][@"remark"]];
    }
    else{
        cell.remark.text = @"备注：";
    }
    
    if (_deskList[indexPath.row][@"reachTime"] != nil && ![_deskList[indexPath.row][@"reachTime"] isKindOfClass:[NSNull class]]) {
        cell.reachTime.text = [NSString stringWithFormat:@"%@%@", @"预定到店：", _deskList[indexPath.row][@"reachTime"]];
    }
    else{
        cell.reachTime.text = @"预定到店：";
    }
    
    cell.cancelDeskBtn.tag = indexPath.row;
    cell.returnBtn.tag = indexPath.row;
    cell.takeBtn.tag = indexPath.row;
    cell.userPhone.tag = indexPath.row;
    [cell.cancelDeskBtn addTarget:self action:@selector(cancelDeskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.returnBtn addTarget:self action:@selector(returnDeskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.takeBtn addTarget:self action:@selector(takeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.userPhone addTarget:self action:@selector(userPhoneClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2 -3, 300);
}

//行之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

//列之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}


-(void)postGetDesk{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        
        return ;
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/getDesk"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"桌位列表 %@", responseObject);
        [self.collectionView.header endRefreshing];
        [_hud hideAnimated:YES];

        self.loading = NO;
        if (responseObject != nil) {
            [_deskList removeAllObjects];
            [_deskSanTai removeAllObjects];
            [_deskBaoXiang removeAllObjects];
            NSArray *list = responseObject;
            for (int i = 0; i < list.count; i++) {
                //判空
                if (list[i][@"deskType"] != nil && ![list[i][@"deskType"] isKindOfClass:[NSNull class]]) {
                    //分类
                    if ([[NSString stringWithFormat:@"%@", list[i][@"deskType"]] isEqualToString:@"散台"]) {
                        [_deskSanTai addObject:list[i]];
                    }
                    else{
                        [_deskBaoXiang addObject:list[i]];
                    }
                }
                else{
                    [_deskSanTai addObject:list[i]];
                }
            }
            
//            [_deskList removeAllObjects];
            if (_isBoxBtn) {
                _deskList = _deskBaoXiang;
            }
            else
                _deskList = _deskSanTai;
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取桌位列表失败 %@", error);
        [self.collectionView.header endRefreshing];
        self.loading = NO;
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];

}

//取消订桌状态
-(void)cancelDeskBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"取消 %ld", (long)btn.tag);
    NSString *url = [API stringByAppendingString:@"AdminShop/cancelDeskType"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"deskId":_deskList[btn.tag][@"deskId"], @"userId":_deskList[btn.tag][@"userId"]};
    [self postDeskWithUrl:url Parameters:dic];
}

//退还订金
-(void)returnDeskBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"退回 %ld", (long)btn.tag);
    NSString *url = [API stringByAppendingString:@"AdminShop/cancelDesk"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"deskId":_deskList[btn.tag][@"deskId"], @"userId":_deskList[btn.tag][@"userId"]};
    [self postDeskWithUrl:url Parameters:dic];
}

//收取订金
-(void)takeBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"收取 %ld", (long)btn.tag);
    NSString *url = [API stringByAppendingString:@"AdminShop/reserve"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"deskId":_deskList[btn.tag][@"deskId"], @"userId":_deskList[btn.tag][@"userId"]};
    [self postDeskWithUrl:url Parameters:dic];
}

//电话
-(void)userPhoneClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"电话 %ld", (long)btn.tag);
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_deskList[btn.tag][@"userPhone"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}

//桌位操作
-(void)postDeskWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"桌位 %@", responseObject);
        if (responseObject != nil) {
            [self postGetDesk];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"桌位操作失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



//散台按钮
-(void)scatteredDeskBtnClick{
    _isBoxBtn = NO;
    [_scatteredDeskBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_boxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //刷新数据
//    [_deskList removeAllObjects];
    _deskList = _deskSanTai;
    [self.collectionView reloadData];
}

//包厢按钮
-(void)boxBtnBtnClick{
    _isBoxBtn = YES;
    [_scatteredDeskBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_boxBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    //刷新数据
//    [_deskList removeAllObjects];
    _deskList = _deskBaoXiang;
    [self.collectionView reloadData];
}

//编辑桌位按钮
-(void)editDeskBtnBtnClick{
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    EditDeskViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"editDesk"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无定桌";
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
//        self.loading = NO;
//    });
    [self postGetDesk];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
