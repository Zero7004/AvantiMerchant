//
//  InProgressViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*进行中*//

#import "InProgressViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "InProgressCell.h"

#import <MapKit/MapKit.h>   //地图使用


//#import "UIView+frameAdjust.h"
//#import "NoContentView.h"
//#import "SVProgressHUD.h"
//#import "BaseTableView.h"

@interface InProgressViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *AlldeStatus;      //配送状态
    NSDictionary *ALLpayType;       //支付方式
    
    UIWindow *topWindow;
}

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;  //!< 要导航的坐标
@property (nonatomic, strong) NSString *toLocationName;       //目标地名

@end

@implementation InProgressViewController


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
    _isRefresh = NO;
    AlldeStatus = [[NSDictionary alloc] initWithObjects:@[@"系统已接单", @"已分配骑手", @"骑手已到店", @"配送中", @"已取消", @"系统拒单/配送异常", @"等待蜂鸟接单", @"商家自行配送"] forKeys:@[@"1", @"20", @"80", @"2", @"4", @"5", @"6", @"7"]];
    ALLpayType = [[NSDictionary alloc] initWithObjects:@[@"余额支付", @"微信支付", @"余额+微信" , @"支付宝", @"支付宝+余额"] forKeys:@[@"1", @"2", @"3", @"4", @"5"]];
    [self initTableView];
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];

    [self addRefreshView];
    
    self.tableView.separatorStyle = NO; //隐藏分割线



}


-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction{
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrderInfor" object:nil];

//    [self.tableView.header endRefreshing];

}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"InProgressCell" bundle:nil] forCellReuseIdentifier:@"InProgressCell"];
    
    //    [self.tableView showEmptyViewWithType:NoContentTypeOrder];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

-(void)topWindow{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        topWindow = [[UIWindow alloc] init];
        topWindow.windowLevel = UIWindowLevelAlert;
        topWindow.frame = [UIApplication sharedApplication].statusBarFrame;
        topWindow.backgroundColor = [UIColor clearColor];
        topWindow.hidden = NO;
        [topWindow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowClick)]];
    });

}

-(void)topWindowClick{
    //使用这个方法可以将滚动到特定的区域，让视图可见。
    //rect的作用是定义要可见视图的区域，这个区域需要在滚动视图的坐标空间中
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dictGoon.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *orderType;
    CGFloat addressHight;
    CGFloat userNameHeight;
    if (_dictGoon[indexPath.row][@"orderType"] != nil && ![_dictGoon[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _dictGoon[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        addressHight = 0;
        
    }
    else{
        addressHight = [Util countTextHeight:_dictGoon[indexPath.row][@"userAddress"]] - 5;
        
    }
    if ([orderType integerValue] == 1) {
        userNameHeight = -20;
    }
    else{
        userNameHeight = 10;
    }

//    CGFloat addressHight = [Util countTextHeight:_dictGoon[indexPath.row][@"userAddress"]] - 5;
    NSArray *goodLists = _dictGoon[indexPath.row][@"goodlist"];
    CGFloat tableHight = (goodLists.count + 2) * 30;
    return 340 + addressHight + tableHight + userNameHeight;
    
//    return 515;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_dictGoon.count == 0) {
        return 0;
    }
    else
        return 150;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_dictGoon.count == 0) {
        UIView *footrerView = [UIView new];
        return footrerView;
    }
    else
    {
        UIView *footrerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        footrerView.backgroundColor = [UIColor whiteColor];
        return footrerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InProgressCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[InProgressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InProgressCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.userAddress.scrollEnabled = NO;
    
    //设置订单类型
    NSString *orderType;
    if (_dictGoon[indexPath.row][@"orderType"] != nil && ![_dictGoon[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _dictGoon[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
    switch ([orderType integerValue]) {
        case 0:{
            cell.orderType.text = @"外卖";
            if (_dictGoon[indexPath.row][@"requireTime"] != nil && ![_dictGoon[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@", @"立即送达 ", _dictGoon[indexPath.row][@"requireTime"]];
            }
            else
                cell.requireTime.text = @"";
            
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 4)];
            cell.requireTime.attributedText = str;
            
            if (_dictGoon[indexPath.row][@"userAddress"] != nil && ![_dictGoon[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _dictGoon[indexPath.row][@"userAddress"];
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
            if (_dictGoon[indexPath.row][@"userAddress"] != nil && ![_dictGoon[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = _dictGoon[indexPath.row][@"userAddress"];
            }
            else
                cell.requireTime.text = @"";
            
            cell.requireTime.textColor = [UIColor orangeColor];

        }
            break;
        case 3:{
            cell.orderType.text = @"预订";
//            cell.tip.text = @"预定";
            if (_dictGoon[indexPath.row][@"requireTime"] != nil && ![_dictGoon[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@%@", @"预定", _dictGoon[indexPath.row][@"requireTime"], @" 送达"];
            }
            else
                cell.requireTime.text = @"";
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
            cell.requireTime.attributedText = str;
            
            if (_dictGoon[indexPath.row][@"userAddress"] != nil && ![_dictGoon[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _dictGoon[indexPath.row][@"userAddress"];
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
            
            if (_dictGoon[indexPath.row][@"requireTime"] != nil && ![_dictGoon[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@", @"预定", _dictGoon[indexPath.row][@"requireTime"]];
            }
            else
                cell.requireTime.text = @"";
            
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
            cell.requireTime.attributedText = str;
            
            if (_dictGoon[indexPath.row][@"userAddress"] != nil && ![_dictGoon[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _dictGoon[indexPath.row][@"userAddress"];
            }
            else
                cell.userAddress.text = @"";

        }
            
            break;
            
        default:
            break;
    }

    
    if (_dictGoon[indexPath.row][@"userName"] != nil && ![_dictGoon[indexPath.row][@"userName"] isKindOfClass:[NSNull class]]) {
        cell.userName.text = _dictGoon[indexPath.row][@"userName"];
    }
    else
        cell.userName.text = @"";
    
    if (_dictGoon[indexPath.row][@"userPhone"] != nil && ![_dictGoon[indexPath.row][@"userPhone"] isKindOfClass:[NSNull class]]) {
        cell.userPhone.text = _dictGoon[indexPath.row][@"userPhone"];
    }
    else
        cell.userPhone.text = @"";
    
    
    if (_dictGoon[indexPath.row][@"distance"] != nil && ![_dictGoon[indexPath.row][@"distance"] isKindOfClass:[NSNull class]]) {
        cell.distance.text = [NSString stringWithFormat:@"%@%@", _dictGoon[indexPath.row][@"distance"], @"km"];
    }
    else
        cell.distance.text = @"0km";
    
    if (_dictGoon[indexPath.row][@"deStatus"] != nil && ![_dictGoon[indexPath.row][@"deStatus"] isKindOfClass:[NSNull class]]) {
        cell.deStatus.text = [NSString stringWithFormat:@"%@%@", @"状态：", [AlldeStatus objectForKey:_dictGoon[indexPath.row][@"deStatus"]]];
    }
    else
        cell.deStatus.text = @"";
    
    if (_dictGoon[indexPath.row][@"smallAdd"] != nil && ![_dictGoon[indexPath.row][@"smallAdd"] isKindOfClass:[NSNull class]]) {
        cell.smallAdd.text = [NSString stringWithFormat:@"%@%@",@"￥", _dictGoon[indexPath.row][@"smallAdd"]];
    }
    else
        cell.smallAdd.text = [NSString stringWithFormat:@"%@",@"￥"];
    
    if (_dictGoon[indexPath.row][@"shopALLPayOut"] != nil && ![_dictGoon[indexPath.row][@"shopALLPayOut"] isKindOfClass:[NSNull class]]) {
        cell.shopALLPayOut.text = [NSString stringWithFormat:@"%@%@",@"-￥", _dictGoon[indexPath.row][@"shopALLPayOut"]];
        
    }
    else
        cell.shopALLPayOut.text = [NSString stringWithFormat:@"%@",@"-￥"];
    
    
    if (_dictGoon[indexPath.row][@"serverMoney"] != nil && ![_dictGoon[indexPath.row][@"serverMoney"] isKindOfClass:[NSNull class]]) {
        cell.serverMoney.text = [NSString stringWithFormat:@"%@%@", @"-￥", _dictGoon[indexPath.row][@"serverMoney"]];
    }
    else
        cell.serverMoney.text = @"-￥";
    
    if (_dictGoon[indexPath.row][@"plan"] != nil && ![_dictGoon[indexPath.row][@"plan"] isKindOfClass:[NSNull class]]) {
        cell.plan.text = [NSString stringWithFormat:@"%@", _dictGoon[indexPath.row][@"plan"]];
    }
    else
        cell.plan.text = @"";
    
    if (_dictGoon[indexPath.row][@"realityPay"] != nil && ![_dictGoon[indexPath.row][@"realityPay"] isKindOfClass:[NSNull class]]) {
        cell.realityPay.text = [NSString stringWithFormat:@"%@", _dictGoon[indexPath.row][@"realityPay"]];
    }
    else
        cell.realityPay.text = @"";

    if (_dictGoon[indexPath.row][@"payType"] != nil && ![_dictGoon[indexPath.row][@"payType"] isKindOfClass:[NSNull class]]) {
        cell.payType.text = [ALLpayType objectForKey:[NSString stringWithFormat:@"%@", _dictGoon[indexPath.row][@"payType"]]];
    }
    else
        cell.payType.text = @"";
    
//    if (_dictGoon[indexPath.row][@"realTotalMoney"] != nil && ![_dictGoon[indexPath.row][@"realTotalMoney"] isKindOfClass:[NSNull class]]) {
//        cell.realTotalMoney.text = [NSString stringWithFormat:@"%@", _dictGoon[indexPath.row][@"realTotalMoney"]];
//    }
//    else
//        cell.realTotalMoney.text = @"";
    
    if (_dictGoon[indexPath.row][@"orderNo"] != nil && ![_dictGoon[indexPath.row][@"orderNo"] isKindOfClass:[NSNull class]]) {
        cell.orderNo.text = [@"订单号:" stringByAppendingString:_dictGoon[indexPath.row][@"orderNo"]];
    }
    else
        cell.orderNo.text = @"订单号:";
    
    if (_dictGoon[indexPath.row][@"createTime"] != nil && ![_dictGoon[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
        cell.createTime.text = [_dictGoon[indexPath.row][@"createTime"] stringByAppendingString:@"下单"];
    }
    else
        cell.createTime.text = @"";
    
    //将数据传入
    cell.goodlist = _dictGoon[indexPath.row][@"goodlist"];
    if (_dictGoon[indexPath.row][@"boxFee"] != nil && ![_dictGoon[indexPath.row][@"boxFee"] isKindOfClass:[NSNull class]]) {
        cell.boxFee = [NSString stringWithFormat:@"%@",_dictGoon[indexPath.row][@"boxFee"]];    }
    else
        cell.boxFee = @"0";
    if (_dictGoon[indexPath.row][@"dsm"] != nil && ![_dictGoon[indexPath.row][@"dsm"] isKindOfClass:[NSNull class]]) {
        cell.dsm = [NSString stringWithFormat:@"%@", _dictGoon[indexPath.row][@"dsm"]];
    }
    else
        cell.dsm = @"0";
    
    [cell.tableView reloadData];

    [cell.userAddress setUserInteractionEnabled:NO];

    //计算约束高度
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        cell.addressConstraintHeight.constant = 0;
        cell.distance.hidden = YES;
        cell.daohangBtn.hidden = YES;
    }
    else{
        cell.addressConstraintHeight.constant = [Util countTextHeight:cell.userAddress.text];
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
    
    cell.tableViewHeight.constant = (cell.goodlist.count + 2) * 30;
    
    cell.cellBtn.tag = indexPath.row;
    cell.daohangBtn.tag = indexPath.row;
    [cell.cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.daohangBtn addTarget:self action:@selector(daohangBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

//打电话
-(void)cellBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_dictGoon[btn.tag][@"userPhone"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

//导航
-(void)daohangBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"点击了 %ld",(long)btn.tag);
    
    //初始化目的地址
    self.coordinate = CLLocationCoordinate2DMake([_dictGoon[btn.tag][@"lat"] doubleValue], [_dictGoon[btn.tag][@"lng"] doubleValue]);
    
    if (_dictGoon[btn.tag][@"userAddress"] != nil && ![_dictGoon[btn.tag][@"userAddress"] isKindOfClass:[NSNull class]]) {
        _toLocationName = _dictGoon[btn.tag][@"userAddress"];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrderInfor" object:nil];

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
