//
//  PendingViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "PendingViewController.h"
#import "PendingCollectionViewCell.h"
//#import "SegmentControl.h"
#import "NewOrdersViewController.h"
#import "ReminderViewController.h"
#import "DrawbackViewController.h"
#import "CompensationViewController.h"
#import "ScanViewController.h"
#import "SegmentControl02.h"


@interface PendingViewController ()

@property (strong, nonatomic) SegmentControl02 *segmentControl;
@property (strong, nonatomic) NewOrdersViewController *OrderVC;
@property (strong, nonatomic) ReminderViewController *reminderVC;
@property (strong, nonatomic) DrawbackViewController *drawbackVC;
@property (strong, nonatomic) CompensationViewController *compensationVC;
@property (strong, nonatomic) ScanViewController *scanVC;

@property (strong, nonatomic) UIButton *backBtn;

@property (strong, nonatomic) NSArray *titles;   //标题

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation PendingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMerchantInfor) name:@"getOrder" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewOrder) name:@"pushGetNewOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewReminder) name:@"pushGetNewReminder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewRefund) name:@"pushGetNewRefund" object:nil];
    
    //获取新订单时调用通知跳转顶部导航栏切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetNewOrder) name:@"GetNewOrder" object:nil];

//    [_segmentControl setScrollViewContenOffset];
    
    [self getMerchantInfor];

    //把扫码按钮的添加和消除放到这里，解决订单管理也已取消按钮被覆盖的问题
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:_scanVC.scanBtn];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阿凡提商家";
    _titles = @[@"新", @"催", @"退", @"赔", @"扫"];

    [self initSegmentCotrol];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMerchantInfor) name:@"getOrder" object:nil];

    //去掉顶部的黑线
    self.navigationController.navigationBar.subviews[0].subviews[1].hidden = YES;
    
    NSLog(@"LoginType = %@", [DEFAULT objectForKey:@"LoginType"]);
    if ([[DEFAULT objectForKey:@"LoginType"] isEqualToString:@"2"]) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    _backBtn.frame = CGRectMake(20, 20, 40, 40);
        _backBtn.bounds = CGRectMake(0, 0, 40, 40);
        _backBtn.imageView.contentMode = UIViewContentModeLeft;
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        _backBtn.adjustsImageWhenHighlighted = NO;
        [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
    

}

//返回商店选择
-(void)pressBack{
    [[AppDelegate APP] selectShopView];
}


-(void)initSegmentCotrol{
    _OrderVC = [[NewOrdersViewController alloc] init];
    _reminderVC = [[ReminderViewController alloc] init];
    _drawbackVC = [[DrawbackViewController alloc] init];
    _compensationVC = [[CompensationViewController alloc] init];
    _scanVC = [[ScanViewController alloc] init];
    
    _OrderVC.isRefresh = YES;
    _reminderVC.isRefresh = NO;
    _drawbackVC.isRefresh = NO;
    
    _OrderVC.orderArray = [[NSArray alloc] init];
    _reminderVC.orderArray = [[NSArray alloc] init];
    _drawbackVC.orderArray = [[NSArray alloc] init];

    _segmentControl = [[SegmentControl02 alloc] initStaticTitlesWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    _segmentControl.titles = @[@"新订单", @"催单", @"退款", @"餐赔", @"扫码"];
    _segmentControl.backgroundColor = NAV_COLOR;
    _segmentControl.viewControllers = @[_OrderVC, _reminderVC, _drawbackVC, _compensationVC, _scanVC];
    _segmentControl.titleNormalColor = [UIColor whiteColor];
    _segmentControl.titleSelectColor = SELECTColor;
    [_segmentControl setBottomViewColor:SELECTColor];
    _segmentControl.isTitleScale = YES;
//    _segmentControl.Item = 0;
    
//    self.headView.backgroundColor = NAV_COLOR;
    [self.view addSubview:_segmentControl];
    
    
    //顶部字体
    CGFloat width = SCREEN_WIDTH / _titles.count;
    for (int i = 0; i < _titles.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * i, 10, width, 60)];
        label.text = _titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:22];
        [self.view addSubview:label];
    }
    
}


//获取新订单信息
-(void)getMerchantInfor{
    NSString *url = [API stringByAppendingString:@"Personal/personals"];
    if ([AppDelegate APP].user.userId == nil) {
//        [Util toastWithView:self.view AndText:@"登录失效 请重新登录"];
        return;
    }
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"获取商家信息 %@", responseObject);
        _OrderVC.loading = NO;
        _reminderVC.loading = NO;
        _drawbackVC.loading = NO;
        
        if (responseObject != nil) {
            NSDictionary *dictShop = [responseObject objectForKey:@"shop"];
            NSArray *dictNew = [responseObject objectForKey:@"arr"][@"newOrder"];
            NSArray *dictGoon = [responseObject objectForKey:@"arr"][@"goon"];
            NSArray *dictRefund = [responseObject objectForKey:@"arr"][@"refund"];
            NSArray *dictReminder = [responseObject objectForKey:@"arr"][@"reminder"];
            
            //商家信息
            if (![dictShop isKindOfClass:[NSNull class]]) {
                NSLog(@"Shop = %@", dictShop);
                [AppDelegate APP].user.shopId = dictShop[@"shopId"];
                [AppDelegate APP].user.shopName = dictShop[@"shopName"];
                [AppDelegate APP].user.dlvService = dictShop[@"dlvService"];
                [AppDelegate APP].user.shopImg = dictShop[@"shopImg"];
                
                //配送信息
                if ([DEFAULT objectForKey:@"deStatus"] == nil) {
                    [DEFAULT setObject:@"1" forKey:@"deStatus"];
                }
                if (dictShop[@"dlvService"] != nil && ![dictShop[@"dlvService"] isKindOfClass:[NSNull class]]) {
                    NSString *s = dictShop[@"dlvService"];
                    if ([s isEqualToString:@"1"]) {
                        [DEFAULT setObject:@"1" forKey:@"deStatus"];
                    }
                    else if ([s isEqualToString:@"2"]){
                        [DEFAULT setObject:@"2" forKey:@"deStatus"];
                    }
                    else
                        [DEFAULT setObject:@"1,2" forKey:@"deStatus"];
                    
                }
                else{
                    [DEFAULT setObject:@"1" forKey:@"deStatus"];
                }

            }
            //新订单
            if (![dictNew isKindOfClass:[NSNull class]]) {
                _OrderVC.orderArray = [[NSArray alloc] init];
                _OrderVC.orderArray = dictNew;
                if (_OrderVC.isRefresh) {
                    _OrderVC.isRefresh = NO;
                    [_OrderVC.tableView reloadData];
                    [_OrderVC.tableView.header endRefreshing];
                }
            }
            else{
                _OrderVC.orderArray = [[NSArray alloc] init];
                if (_OrderVC.isRefresh) {
                    _OrderVC.isRefresh = NO;
                    [_OrderVC.tableView reloadData];
                    [_OrderVC.tableView.header endRefreshing];
                }
            }
            //进行中的订单
            if (![dictGoon isKindOfClass:[NSNull class]]) {
                
            }
            //退款单
            if (![dictRefund isKindOfClass:[NSNull class]]) {
                _drawbackVC.orderArray = [[NSArray alloc] init];
                _drawbackVC.orderArray = dictRefund;
                if (_drawbackVC.isRefresh) {
                    _drawbackVC.isRefresh = NO;
                    [_drawbackVC.tableView reloadData];
                    [_drawbackVC.tableView.header endRefreshing];
                }
            }
            else{
                _drawbackVC.orderArray = [[NSArray alloc] init];

                if (_drawbackVC.isRefresh) {
                    _drawbackVC.isRefresh = NO;
                    [_drawbackVC.tableView reloadData];
                    [_drawbackVC.tableView.header endRefreshing];

                }
            }
            //催单
            if (![dictReminder isKindOfClass:[NSNull class]]) {
                _reminderVC.orderArray = [[NSArray alloc] init];
                _reminderVC.orderArray = dictReminder;
                if (_reminderVC.isRefresh) {
                    _reminderVC.isRefresh = NO;
                    [_reminderVC.tableView reloadData];
                    [_reminderVC.tableView.header endRefreshing];
                }
                
            }
            else{
                _reminderVC.orderArray = [[NSArray alloc] init];

                if (_reminderVC.isRefresh) {
                    _reminderVC.isRefresh = NO;
                    [_reminderVC.tableView reloadData];
                    [_reminderVC.tableView.header endRefreshing];
                }
            }
            
            
        }
        
        else{
            
            if (_OrderVC.isRefresh) {
                _OrderVC.isRefresh = NO;
                [_OrderVC.tableView.header endRefreshing];
            }
            if (_drawbackVC.isRefresh) {
                _drawbackVC.isRefresh = NO;
                [_drawbackVC.tableView.header endRefreshing];
            }
            if (_reminderVC.isRefresh) {
                _reminderVC.isRefresh = NO;
                [_reminderVC.tableView.header endRefreshing];
            }
//            [Util toastWithView:self.view AndText:@"获取商家信息失败"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家信息失败 %@", error);
        
        if (_OrderVC.isRefresh) {
            _OrderVC.isRefresh = NO;
            [_OrderVC.tableView.header endRefreshing];
        }
        if (_drawbackVC.isRefresh) {
            _drawbackVC.isRefresh = NO;
            [_drawbackVC.tableView.header endRefreshing];
        }
        if (_reminderVC.isRefresh) {
            _reminderVC.isRefresh = NO;
            [_reminderVC.tableView.header endRefreshing];
        }


        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //离开视图移除扫码按钮
    [_scanVC.scanBtn removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getOrder" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushGetNewOrder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushGetNewReminder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushGetNewRefund" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetNewOrder" object:nil];
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


-(void)GetNewOrder{
    [_segmentControl setScrollViewContenOffsetWithIndext:0];
}




//推送调用用刷新
//获取新订单信息
-(void)pushGetNewOrder{
    //顶部视图跳转
    [_segmentControl setScrollViewContenOffsetWithIndext:0];

    
    NSString *url = [API stringByAppendingString:@"Personal/personals"];
    if ([AppDelegate APP].user.userId == nil) {
        //        [Util toastWithView:self.view AndText:@"登录失效 请重新登录"];
        return;
    }
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取商家信息 %@", responseObject);
        
        if (responseObject != nil) {
            NSDictionary *dictShop = [responseObject objectForKey:@"shop"];
            NSArray *dictNew = [responseObject objectForKey:@"arr"][@"newOrder"];
            //            NSArray *dictGoon = [responseObject objectForKey:@"arr"][@"goon"];
            //            NSArray *dictRefund = [responseObject objectForKey:@"arr"][@"refund"];
            //            NSArray *dictReminder = [responseObject objectForKey:@"arr"][@"reminder"];
            
            //商家信息
            if (![dictShop isKindOfClass:[NSNull class]]) {
                NSLog(@"Shop = %@", dictShop);
                [AppDelegate APP].user.shopId = dictShop[@"shopId"];
                [AppDelegate APP].user.shopName = dictShop[@"shopName"];
                [AppDelegate APP].user.dlvService = dictShop[@"dlvService"];
                [AppDelegate APP].user.shopImg = dictShop[@"shopImg"];
                
            }
            //新订单
            if (![dictNew isKindOfClass:[NSNull class]]) {
                _OrderVC.orderArray = [[NSArray alloc] init];
                _OrderVC.orderArray = dictNew;
                [_OrderVC.tableView reloadData];
                
            }
            else{
                _OrderVC.orderArray = @[];
                [_OrderVC.tableView reloadData];
                
            }
            
        }
        
        else{
            _OrderVC.orderArray = @[];
            [_OrderVC.tableView reloadData];
            [_OrderVC.tableView.header endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家信息失败 %@", error);
        _OrderVC.loading = NO;
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//推送调用用刷新
//获取退订单信息
-(void)pushGetNewRefund{
    //顶部视图跳转
    [_segmentControl setScrollViewContenOffsetWithIndext:2];

    
    NSString *url = [API stringByAppendingString:@"Personal/personals"];
    if ([AppDelegate APP].user.userId == nil) {
        //        [Util toastWithView:self.view AndText:@"登录失效 请重新登录"];
        return;
    }
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取商家信息 %@", responseObject);
        
        if (responseObject != nil) {
            NSDictionary *dictShop = [responseObject objectForKey:@"shop"];
//            NSArray *dictNew = [responseObject objectForKey:@"arr"][@"newOrder"];
//            NSArray *dictGoon = [responseObject objectForKey:@"arr"][@"goon"];
            NSArray *dictRefund = [responseObject objectForKey:@"arr"][@"refund"];
//            NSArray *dictReminder = [responseObject objectForKey:@"arr"][@"reminder"];
            
            //商家信息
            if (![dictShop isKindOfClass:[NSNull class]]) {
                NSLog(@"Shop = %@", dictShop);
                [AppDelegate APP].user.shopId = dictShop[@"shopId"];
                [AppDelegate APP].user.shopName = dictShop[@"shopName"];
                [AppDelegate APP].user.dlvService = dictShop[@"dlvService"];
                [AppDelegate APP].user.shopImg = dictShop[@"shopImg"];
                
            }
            //退款单
            if (![dictRefund isKindOfClass:[NSNull class]]) {
                _drawbackVC.orderArray = [[NSArray alloc] init];
                _drawbackVC.orderArray = dictRefund;
                [_drawbackVC.tableView reloadData];
            }
            else{
                _drawbackVC.orderArray = @[];
                [_drawbackVC.tableView reloadData];
                
            }
        }
        
        else{
            _drawbackVC.orderArray = @[];
            [_drawbackVC.tableView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家信息失败 %@", error);
        _drawbackVC.loading = NO;
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//推送催单
-(void)pushGetNewReminder{
    //顶部视图跳转
    [_segmentControl setScrollViewContenOffsetWithIndext:1];
    
    NSString *url = [API stringByAppendingString:@"Personal/personals"];
    if ([AppDelegate APP].user.userId == nil) {
        //        [Util toastWithView:self.view AndText:@"登录失效 请重新登录"];
        return;
    }
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取商家信息 %@", responseObject);
        
        if (responseObject != nil) {
            NSDictionary *dictShop = [responseObject objectForKey:@"shop"];
            //            NSArray *dictNew = [responseObject objectForKey:@"arr"][@"newOrder"];
            //            NSArray *dictGoon = [responseObject objectForKey:@"arr"][@"goon"];
            //            NSArray *dictRefund = [responseObject objectForKey:@"arr"][@"refund"];
            NSArray *dictReminder = [responseObject objectForKey:@"arr"][@"reminder"];
            
            //商家信息
            if (![dictShop isKindOfClass:[NSNull class]]) {
                NSLog(@"Shop = %@", dictShop);
                [AppDelegate APP].user.shopId = dictShop[@"shopId"];
                [AppDelegate APP].user.shopName = dictShop[@"shopName"];
                [AppDelegate APP].user.dlvService = dictShop[@"dlvService"];
                [AppDelegate APP].user.shopImg = dictShop[@"shopImg"];
                
            }
            //退款单
            if (![dictReminder isKindOfClass:[NSNull class]]) {
                _reminderVC.orderArray = [[NSArray alloc] init];
                _reminderVC.orderArray = dictReminder;
                [_reminderVC.tableView reloadData];
            }
            else{
                _reminderVC.orderArray = @[];
                [_reminderVC.tableView reloadData];
                
            }
        }
        
        else{
            _reminderVC.orderArray = @[];
            [_reminderVC.tableView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家信息失败 %@", error);
        _reminderVC.loading = NO;
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


@end
