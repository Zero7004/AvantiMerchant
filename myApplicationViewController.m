//
//  myApplicationViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/22.
//  Copyright © 2017年 Mac. All rights reserved.
//

////***查看我的申请***////

#import "myApplicationViewController.h"
#import "OpenShopTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface myApplicationViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *array;     //申请列表

@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic, getter=isLoading)BOOL loading;

@end

@implementation myApplicationViewController

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

    [self initTableView];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"OpenShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"OpenShopTableViewCell"];

    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];

    [self PostMyApplicationViewController];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name;
    NSString *adress;
    float nameHeight = 30;
    float addressHeight = 30;
    if (_array[indexPath.row][@"shopName"] != nil && ![_array[indexPath.row][@"shopName"] isKindOfClass:[NSNull class]]) {
        name = _array[indexPath.row][@"shopName"];
    }
    else{
        name = @"--";
    }
    
    if (_array[indexPath.row][@"shopAddress"] != nil && ![_array[indexPath.row][@"shopAddress"] isKindOfClass:[NSNull class]]) {
        adress = _array[indexPath.row][@"shopAddress"];
    }
    else{
        adress = @"--";
    }
    
    nameHeight = [Util countTextHeight:name] <= 37 ? 30 : [Util countTextHeight:name] + 20;
    addressHeight = [Util countTextHeight:adress] <= 37 ? 30 : [Util countTextHeight:adress] + 20;

    return 110 + nameHeight + addressHeight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OpenShopTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OpenShopTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[OpenShopTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OpenShopTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_array[indexPath.row][@"createTime"] != nil && ![_array[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
        cell.time.text = _array[indexPath.row][@"createTime"];
    }
    else{
        cell.time.text = @"--";
    }
    
    if (_array[indexPath.row][@"shopStatus"] != nil && ![_array[indexPath.row][@"shopStatus"] isKindOfClass:[NSNull class]]) {
        if ([_array[indexPath.row][@"shopStatus"] isEqual:@"1"]) {
            cell.state.text = @"审核成功";
        }
        else if ([_array[indexPath.row][@"shopStatus"] isEqual:@"0"]){
            cell.state.text = @"待审核";
        }
        else{
            cell.state.text = @"审核失败";
        }
    }
    else{
        cell.state.text = @"待审核";
    }
    
    if (_array[indexPath.row][@"phone"] != nil && ![_array[indexPath.row][@"phone"] isKindOfClass:[NSNull class]]) {
        cell.phone.text = _array[indexPath.row][@"phone"];
    }
    else{
        cell.phone.text = @"--";
    }
    
    if (_array[indexPath.row][@"shopName"] != nil && ![_array[indexPath.row][@"shopName"] isKindOfClass:[NSNull class]]) {
        cell.name.text = _array[indexPath.row][@"shopName"];
    }
    else{
        cell.name.text = @"--";
    }
    
    if (_array[indexPath.row][@"shopAddress"] != nil && ![_array[indexPath.row][@"shopAddress"] isKindOfClass:[NSNull class]]) {
        cell.address.text = _array[indexPath.row][@"shopAddress"];
    }
    else{
        cell.address.text = @"--";
    }

    cell.nameHeight.constant = [Util countTextHeight:cell.name.text] <= 37 ? 30 : [Util countTextHeight:cell.name.text] + 20;
    cell.addressHeight.constant = [Util countTextHeight:cell.address.text] <= 37 ? 30 : [Util countTextHeight:cell.address.text] + 20;

    return cell;
}


#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无申请";
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
    [self PostMyApplicationViewController];
}


//获取申请列表
-(void)PostMyApplicationViewController{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *url = [API_ReImg stringByAppendingString:@"Shops/getApplyShop"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取申请列表 %@", responseObject);
        [self.tableView.header endRefreshing];
        self.loading = NO;
        [_hud hideAnimated:YES];
        
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"success"]) {
                _array = responseObject[@"data"];
                [self.tableView reloadData];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"获取申请列表失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取申请列表失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取申请列表失败 %@", error);
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
