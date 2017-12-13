//
//  NewOrdersViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*新订单*//

#import "NewOrdersViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NewOrderTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "DistributionManagementViewController.h"
#import "SelectDistributionVC.h"

#import <MapKit/MapKit.h>   //地图使用

@interface NewOrdersViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标
@property (nonatomic, strong) NSString *toLocationName;       //目标地名


@end

@implementation NewOrdersViewController


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewOrder:) name:@"addNewOrder" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewOrder) name:@"pushGetNewOrder" object:nil];

    
    [self addRefreshView];

}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    
    //添加通知，当有新订单推送过来时由推送接口调用
    //判断已存在订单列表是否有该订单，若存在，添加列表并且刷新，若没有不做操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewOrder:) name:@"addNewOrder" object:nil];
    
    //收到退款通知时调用刷新--直接获取数据刷新
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewOrder) name:@"pushGetNewOrder" object:nil];


    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];

}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction{
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];

}

//处理推送过来的订单
-(void)addNewOrder:(NSNotification *)order{
    NSDictionary * infoDic = [order object];
    NSLog(@"新订单 = %@", infoDic);
    NSMutableArray *tempArray = [NSMutableArray array];
    tempArray = [_orderArray mutableCopy];
//    NSLog(@"久订单 = %@", _orderArray);
    //判断新订单是否存在于列表中
    BOOL isExist = NO;    //是否存在标记
    for (NSDictionary *ord in _orderArray) {
        if ([ord[@"orderId"] isEqual:infoDic[@"orderId"]]) {
            isExist = YES;
            break ;
        }
        else
            isExist = NO;
    }
    //不存在，将订单加入并刷新列表
    if (!isExist) {
        if (tempArray == nil) {
            tempArray = [NSMutableArray array];
        }
//        [tempArray insertObject:infoDic atIndex:0];
        [tempArray addObject:infoDic];
        _orderArray = [tempArray copy];
        [self.tableView reloadData];
    }
    [self.tableView reloadData];

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
    //设置订单类型
    NSString *orderType;
    CGFloat addressHight;
    CGFloat userNameHeight;
    if (_orderArray[indexPath.row][@"orderType"] != nil && ![_orderArray[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
       addressHight = -15;
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    //堂内、自取、预定订单隐藏地址
    //堂内 隐藏用户名和手机
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

            [cell.mealsOnWheelsBtn setTitle:@"备餐" forState:UIControlStateNormal];
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
#pragma mark 地址赋值
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

    cell.cancelOrderBtn.tag = indexPath.row;
    cell.cellBtn.tag = indexPath.row;
    cell.mealsOnWheelsBtn.tag = indexPath.row;
    cell.daohangBtn.tag = indexPath.row;
    [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mealsOnWheelsBtn addTarget:self action:@selector(mealsOnWheelsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.daohangBtn addTarget:self action:@selector(daohangBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

//取消订单
-(void)cancelOrderBtnClick:(id)sender{
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"是否取消订单？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIButton *btn = (UIButton *)sender;
        _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.label.text = @"正在取消订单";
        [self cancelOrderWithOrderId:_orderArray[btn.tag][@"orderId"]];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alter addAction:cancelAction];
    [alter addAction:okAction];
    [self presentViewController:alter animated:YES completion:nil];
}


//打电话
-(void)cellBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;

    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_orderArray[btn.tag][@"userPhone"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}


//送餐
-(void)mealsOnWheelsBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    //判断是否开启配送
    if ([[DEFAULT objectForKey:@"isDistribution"] isEqual:@"0"] || [DEFAULT objectForKey:@"isDistribution"] == nil) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未开启配送" message:@"是否前往设置配送" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DistributionManagementViewController *vc = [[DistributionManagementViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else{
        //判断订单类型
        if ([btn.titleLabel.text isEqualToString:@"送餐"]) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Pending" bundle:[NSBundle mainBundle]];
            SelectDistributionVC *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectDistribution"];
            [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
            [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//        [self presentViewController:vc animated:YES completion:nil];
            UIApplication *ap = [UIApplication sharedApplication];
            [ap.keyWindow addSubview:vc.view];
            
            vc.block = ^(BOOL isPeiSong) {
                [vc.view removeFromSuperview];
                if (isPeiSong) {
                    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    _hud.label.text = @"正在送餐";
                    [self sendDistributionWithOrderId:_orderArray[btn.tag][@"orderId"]];
                }
            };
        }
        else{
            //备餐
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认备餐" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                _hud.label.text = @"正在备餐";
                [self sendDistributionWithOrderId:_orderArray[btn.tag][@"orderId"]];

            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
}

//导航
-(void)daohangBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"点击了 %ld",(long)btn.tag);
    
    //初始化目的地址  1、维度 2、经度
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
        //传送目标地名
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








//取消订单
-(void)cancelOrderWithOrderId:(NSString *)orderId{
    NSString *url = [API stringByAppendingString:@"Personal/butCancel"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"orderId":orderId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"取消订单 %@", responseObject);
        [_hud hideAnimated:YES];
        
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"订单取消成功"];
                _isRefresh = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"订单取消失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"订单取消失败"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"取消订单失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

//送餐接口
-(void)sendDistributionWithOrderId:(NSString *)orderId{
    NSString *url = [API stringByAppendingString:@"Personal/waitGive"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"orderId":orderId, @"deStatus":[DEFAULT objectForKey:@"deStatusPeisong"]};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"送餐 %@", responseObject);
        [_hud hideAnimated:YES];
        
        if (responseObject != nil) {
            [Util toastWithView:self.navigationController.view AndText:@"送餐成功"];
            //刷新新订单
            _isRefresh = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
            //刷新正在进行订单
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrderInfor" object:nil];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"送餐失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"送餐失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//堂内订单备餐
-(void)postEquipmentEat:(NSString *)orderId{
    NSString *url = [API stringByAppendingString:@"Personal/waitGive"];
    //配送方式默认为商家自配送
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"orderId":orderId, @"deStatus":@"1"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"备餐 %@", responseObject);
        [_hud hideAnimated:YES];
        
        if (responseObject != nil) {
            [Util toastWithView:self.navigationController.view AndText:@"备餐成功"];
            //刷新新订单
            _isRefresh = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
            //刷新正在进行订单
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrderInfor" object:nil];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"备餐失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"备餐失败 %@", error);
        [_hud hideAnimated:YES];
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

//离开视图控制器注销通知
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNewOrder" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushGetNewOrder" object:nil];

}










@end
