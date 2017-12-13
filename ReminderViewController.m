//
//  ReminderViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*催单*//

#import "ReminderViewController.h"
#import "NewOrderTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"

#import <MapKit/MapKit.h>   //地图使用


@interface ReminderViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标
@property (nonatomic, strong) NSString *toLocationName;       //目标地名

@end

@implementation ReminderViewController

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
    

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"newOrder"];
    
    self.tableView.separatorStyle = NO; //隐藏分割线
    
    _isRefresh = NO;
    
    [self addRefreshView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewReminder) name:@"pushGetNewReminder" object:nil];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];

//    [self.tableView reloadData];

    //收到催单通知时调用刷新--直接获取数据刷新
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewReminder) name:@"pushGetNewReminder" object:nil];
}


-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction{
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_orderArray.count == 0) {
        return 0;
    }
    else
        return 220;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_orderArray.count == 0) {
        UIView *footrerView = [UIView new];
        return footrerView;
    }
    else
    {
        UIView *footrerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        footrerView.backgroundColor = [UIColor whiteColor];
        return footrerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *orderType;
    CGFloat addressHight;
    CGFloat userNameHeight;
    if (_orderArray[indexPath.row][@"orderType"] != nil && ![_orderArray[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
    
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        addressHight = -10;
        
    }
    else{
        addressHight = [Util countTextHeight:_orderArray[indexPath.row][@"userAddress"]] - 5;
        
    }
    if ([orderType integerValue] == 1) {
        userNameHeight = -20;
        addressHight = 0;
    }
    else{
        userNameHeight = 21;
    }
    
    NSArray *goodLists = _orderArray[indexPath.row][@"goodlist"];
    CGFloat tableHight = (goodLists.count + 1) * 30;
    
    return 240 + addressHight + tableHight + userNameHeight;
    //    return 300;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArray.count;
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewOrderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"newOrder" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newOrder"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置订单类型
    NSString *orderType;
    if (_orderArray[indexPath.row][@"orderType"] != nil && ![_orderArray[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";

    switch ([orderType integerValue]) {
        case 0:{
            cell.orderType.text = @"外卖";
            
            if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@", @"立即送达 ", _orderArray[indexPath.row][@"requireTime"]];
            }
            else
                cell.requireTime.text = @"";
            
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 4)];
            cell.requireTime.attributedText = str;
            
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.userAddress.text = @"";
            
//            cell.tip.text = @"立即送达";
        }
            break;
        case 1:{
            cell.orderType.text = @"堂内";
            cell.userAddress.text = @"";
            //时间处显示桌位号，
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.requireTime.text = @"";
            cell.requireTime.textColor = [UIColor orangeColor];
            
        }
            break;
        case 3:{
            cell.orderType.text = @"预订";
            if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@%@", @"预定", _orderArray[indexPath.row][@"requireTime"], @" 送达"];
            }
            else
                cell.requireTime.text = @"";
            
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
            cell.requireTime.attributedText = str;
            
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.userAddress.text = @"";
            
            
        }
            break;
        case 4:{
            cell.orderType.text = @"团购";
        }
        case 5:{
            cell.orderType.text = @"自取";
            if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@", @"预定", _orderArray[indexPath.row][@"requireTime"]];
            }
            else
                cell.requireTime.text = @"";
            
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
            cell.requireTime.attributedText = str;
            
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.userAddress.text = @"";
            
        }
            
            break;
            
        default:
            break;
    }

    
//    if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
//        cell.requireTime.text = _orderArray[indexPath.row][@"requireTime"];
//    }
//    else
//        cell.requireTime.text = @"";
    
    if (_orderArray[indexPath.row][@"userName"] != nil && ![_orderArray[indexPath.row][@"userName"] isKindOfClass:[NSNull class]]) {
        cell.userName.text = _orderArray[indexPath.row][@"userName"];
    }
    else
        cell.userName.text = @"";
    
    if (_orderArray[indexPath.row][@"userPhone"] != nil && ![_orderArray[indexPath.row][@"userPhone"] isKindOfClass:[NSNull class]]) {
        cell.userPhone.text = _orderArray[indexPath.row][@"userPhone"];
    }
    else
        cell.userPhone.text = @"";
    
//    if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
//        cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
//    }
//    else
//        cell.userAddress.text = @"";
    
    if (_orderArray[indexPath.row][@"distance"] != nil && ![_orderArray[indexPath.row][@"distance"] isKindOfClass:[NSNull class]]) {
        cell.distance.text = [NSString stringWithFormat:@"%@%@", _orderArray[indexPath.row][@"distance"], @"km"];
    }
    else
        cell.distance.text = @"0km";
    
    if (_orderArray[indexPath.row][@"realTotalMoney"] != nil && ![_orderArray[indexPath.row][@"realTotalMoney"] isKindOfClass:[NSNull class]]) {
        cell.realTotalMoney.text = [NSString stringWithFormat:@"%@%@", @"￥",_orderArray[indexPath.row][@"realTotalMoney"]];
    }
    else
        cell.realTotalMoney.text = @"￥0.00";
    
    if (_orderArray[indexPath.row][@"orderNo"] != nil && ![_orderArray[indexPath.row][@"orderNo"] isKindOfClass:[NSNull class]]) {
        cell.orderNo.text = [@"订单号:" stringByAppendingString:_orderArray[indexPath.row][@"orderNo"]];
    }
    else
        cell.orderNo.text = @"订单号:";
    
    if (_orderArray[indexPath.row][@"createTime"] != nil && ![_orderArray[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
        cell.createTime.text = [_orderArray[indexPath.row][@"createTime"] stringByAppendingString:@"下单"];
    }
    else
        cell.createTime.text = @"";
    
    //将数据传入
    cell.goodlist = _orderArray[indexPath.row][@"goodlist"];
    if (_orderArray[indexPath.row][@"boxFee"] != nil && ![_orderArray[indexPath.row][@"boxFee"] isKindOfClass:[NSNull class]]) {
        cell.boxFee = [NSString stringWithFormat:@"%@",_orderArray[indexPath.row][@"boxFee"]];
    }
    else
        cell.boxFee = @"0";
    
    [cell.userAddress setUserInteractionEnabled:NO];

    //计算约束高度
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        cell.addressConstraintHeight.constant = 0;
        cell.distance.hidden = YES;
        cell.daohangBtn.hidden = YES;
    }
    else{
        cell.addressConstraintHeight.constant = [Util countTextHeight:cell.userAddress.text] + 10;
        cell.distance.hidden = NO;
        cell.daohangBtn.hidden = NO;
    }
    if ([orderType integerValue] == 1) {
        cell.cellBtn.hidden = YES;
        cell.userName.text = @"";
        cell.userPhone.text = @"";
    }
    else{
        cell.cellBtn.hidden = NO;
    }
    
    cell.tableViewHeight.constant = (cell.goodlist.count + 1) * 30;
    
    [cell.tableView reloadData];
    
    cell.cellBtn.tag = indexPath.row;
    cell.daohangBtn.tag = indexPath.row;
    [cell.cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.daohangBtn addTarget:self action:@selector(daohangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //改变底部按钮
    [cell.cancelOrderBtn setTitle:@"处理催单" forState:UIControlStateNormal];
    cell.cancelOrderBtn.tag = indexPath.row;
    [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //隐藏送餐按钮
    cell.mealsOnWheelsBtn.hidden = YES;
    
    return cell;
}

//打电话
-(void)cellBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_orderArray[btn.tag][@"userPhone"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}


//导航
-(void)daohangBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"点击了 %ld",(long)btn.tag);
    
    //初始化目的地址
    self.coordinate = CLLocationCoordinate2DMake([_orderArray[btn.tag][@"lat"] doubleValue], [_orderArray[btn.tag][@"lng"] doubleValue]);
    
    if (_orderArray[btn.tag][@"userAddress"] != nil && ![_orderArray[btn.tag][@"userAddress"] isKindOfClass:[NSNull class]]) {
        _toLocationName = _orderArray[btn.tag][@"userAddress"];
    }
    else
        _toLocationName = @"未知位置";
    
    [self initAlertionController];
    
}



//地图弹框提示--调用地图
-(void)initAlertionController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        
        //使用自带地图导航
        //mapItemForCurrentLocation 当前位置的item
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //目标位置的item
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
        toLocation.name = _toLocationName;
        //开始导航
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
    }]];
    
    //判断是否安装了高德地图，如果安装则可以使用高德地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication= &backScheme= &lat=%f&lon=%f&dev=0&style=2",self.coordinate.latitude,self.coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
        
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
            
        }]];
    }
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    
    //显示alertController
    [self presentViewController:alertController animated:YES completion:nil];
}




//处理催单按钮
-(void)cancelOrderBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.label.text = @"正在取消订单";
    [self postReminderOrderWithOrderId:_orderArray[btn.tag][@"orderId"]];
}


//处理订单
-(void)postReminderOrderWithOrderId:(NSString *)orderId{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        return ;
    }
    NSString *url = [API stringByAppendingString:@"GoodsAppraises/cuidan"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"orderId":orderId, @"reminder":@"2"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"处理订单 %@", responseObject);
        [_hud hideAnimated:YES];
        [self.tableView.header endRefreshing];
        if (responseObject != nil) {
            if ([[NSString stringWithFormat:@"%@", responseObject[@"res"]] isEqualToString:@"1"]) {
                _isRefresh = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
                [Util toastWithView:self.navigationController.view AndText:@"订单已处理"];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"处理订单失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"处理订单失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"处理订单失败 %@", error);
        [_hud hideAnimated:YES];
        [self.tableView.header endRefreshing];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无新订单";
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
    
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
