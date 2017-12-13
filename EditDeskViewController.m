//
//  EditDeskViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/11.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*编辑定桌*//

#import "EditDeskViewController.h"
#import "DeskCollectionViewCell.h"
#import "EditDeskDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"


@interface EditDeskViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
- (IBAction)SwitchChange:(id)sender;     //状态改变按钮
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong ,nonatomic) UIView *footerView;
//@property NSInteger num;

@property (nonatomic, getter=isLoading)BOOL loading;

@property (strong, nonatomic) NSArray *deskLists;    //桌位列表
@property (strong, nonatomic) UIButton *addDeskBtn;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation EditDeskViewController

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
//    _num = 4;
    _deskLists = [[NSArray alloc] init];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BG_COLOR;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeskCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DeskCollectionViewCell"];
    self.collectionView.hidden = NO;
    [self.collectionView setEmptyDataSetDelegate:self];
    [self.collectionView setEmptyDataSetSource: self];

    [self addRefreshView];
    [self addBottomView];
    
    //阴影设置
    _topView.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    _topView.layer.shadowOffset = CGSizeMake(0,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _topView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    _topView.layer.shadowRadius = 1.0f;//阴影半径，默认3

    
//    [self postgetDesks];
}

//使用了navigationController加载视图导致返回视图时该方法失效
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取桌位预定状态--列表
    [self postgetDesks];
}


-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
}

-(void)refreshAction{
    [self postgetDesks];
}


-(void)addBottomView{
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 116, SCREEN_WIDTH, 50)];
    _footerView.backgroundColor = [UIColor whiteColor];
    
    _addDeskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [_addDeskBtn setTitle:@"添加桌位" forState:UIControlStateNormal];
    [_addDeskBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _addDeskBtn.backgroundColor = [UIColor whiteColor];
    [_addDeskBtn addTarget:self action:@selector(addDeskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *topLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLable.backgroundColor = [UIColor grayColor];

    [_footerView addSubview:_addDeskBtn];
    [_footerView addSubview:topLable];
    [self.view addSubview:_footerView];
}



#pragma mark - collectionViewDelegate


//多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每组数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([_switchBtn isOn]) {
        return _deskLists.count;
    }
    else
        return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeskCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"DeskCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.deleteDeskBtn.tag = indexPath.row;
    [cell.deleteDeskBtn addTarget:self action:@selector(deleteDeskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.editDeskBtn.tag = indexPath.row;
    [cell.editDeskBtn addTarget:self action:@selector(editDeskBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    if (_deskLists[indexPath.row][@"deskImg"] != nil && ![_deskLists[indexPath.row][@"deskImg"] isKindOfClass:[NSNull class]]) {
        NSString *imgUrl = [API_IMG stringByAppendingString:_deskLists[indexPath.row][@"deskImg"]];
        [cell.deskImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"noimg"]];
    }
    else{
        [cell.deskImg setImage:[UIImage imageNamed:@"noimg"]];
    }

    if (_deskLists[indexPath.row][@"deskName"] != nil && ![_deskLists[indexPath.row][@"deskName"] isKindOfClass:[NSNull class]]) {
        cell.deskName.text = [NSString stringWithFormat:@"%@%@", @"桌位名称：", _deskLists[indexPath.row][@"deskName"]];
    }
    else{
        cell.deskName.text = @"桌位名称：";
    }
    
    if (_deskLists[indexPath.row][@"deskNum"] != nil && ![_deskLists[indexPath.row][@"deskNum"] isKindOfClass:[NSNull class]]) {
        cell.deskNum.text = [NSString stringWithFormat:@"%@%@", @"桌位号：", _deskLists[indexPath.row][@"deskNum"]];
    }
    else{
        cell.deskNum.text = @"桌位号：";
    }

    if (_deskLists[indexPath.row][@"deskPersonNum"] != nil && ![_deskLists[indexPath.row][@"deskPersonNum"] isKindOfClass:[NSNull class]]) {
        cell.deskPersonNum.text = [NSString stringWithFormat:@"%@%@%@", @"用餐人数：", _deskLists[indexPath.row][@"deskPersonNum"], @"人"];
    }
    else{
        cell.deskPersonNum.text = @"用餐人数：- 人";
    }

    if (_deskLists[indexPath.row][@"deskType"] != nil && ![_deskLists[indexPath.row][@"deskType"] isKindOfClass:[NSNull class]]) {
        cell.deskType.text = [NSString stringWithFormat:@"%@%@", @"桌位类型：", _deskLists[indexPath.row][@"deskType"]];
    }
    else{
        cell.deskType.text = @"桌位类型：";
    }

    if (_deskLists[indexPath.row][@"reserveMoney"] != nil && ![_deskLists[indexPath.row][@"reserveMoney"] isKindOfClass:[NSNull class]]) {
        cell.reserveMoney.text = [NSString stringWithFormat:@"%@%@%@", @"预定价格：", _deskLists[indexPath.row][@"reserveMoney"], @"元"];
    }
    else{
        cell.reserveMoney.text = @"预定价格：0.00元";
    }

    
    return cell;
}

//设置cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2 -5, 330);
}

//行之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//列之间距离
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//switch状态改变
- (IBAction)SwitchChange:(id)sender {
    if ([_switchBtn isOn]) {
        _footerView.hidden = NO;
        [self.collectionView reloadData];
    }
    else{
        _footerView.hidden = YES;
        [self.collectionView reloadData];
    }
    [self postdeskServiceWithCheck:[_switchBtn isOn]?@"true":@"false"];
}


//添加桌位按钮
-(void)addDeskBtnClick{
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    EditDeskDetailViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"deskDetail"];
    vc.titleLable = @"添加";
    vc.block = ^{
        //获取新数据
        [self postgetDesks];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//删除按钮
-(void)deleteDeskBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该桌位！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteDeskWithDeskId:_deskLists[btn.tag][@"id"]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//编辑按钮
-(void)editDeskBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    EditDeskDetailViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"deskDetail"];
    vc.dicDesk = [[NSDictionary alloc] init];
    vc.dicDesk = _deskLists[btn.tag];
    vc.titleLable = @"编辑";
    [self.navigationController pushViewController:vc animated:YES];
}



//获取桌位列表--桌位预定功能是否开启
-(void)postgetDesks{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        
        return ;
    }
    NSString *url = [API stringByAppendingString:@"Personal/getDesks"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"桌位列表 %@", responseObject);
        [self.collectionView.header endRefreshing];
        self.loading = NO;

        if (responseObject != nil) {
            
            _deskLists = responseObject[@"desk"];
            if ([responseObject[@"reserveDesk"] isEqual:@"1"]) {
                [_switchBtn setOn:YES];
                _footerView.hidden = NO;
//                [self.collectionView reloadData];
            }
            else{
                [_switchBtn setOn:NO];
                _footerView.hidden = YES;
            }
            [self.collectionView reloadData];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取桌位列表失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取桌位列表失败 %@", error);
        [self.collectionView.header endRefreshing];
        self.loading = NO;
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//开启或者关闭桌位预定功能
-(void)postdeskServiceWithCheck:(NSString *)check{
    NSString *url = [API stringByAppendingString:@"Personal/deskService"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"check":check};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"开启关闭桌位预订功能 %@", responseObject);
        if (responseObject != nil) {
        
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"开启关闭桌位预订功能失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"开启关闭桌位预订功能失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}


//删除桌位
-(void)deleteDeskWithDeskId:(NSString *)deskId{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/deleteDesk"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"id":deskId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除桌位 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            _deskLists = responseObject[@"desk"];
            [self.collectionView reloadData];

        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"删除桌位失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除桌位失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

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
    [self postgetDesks];
}


@end
