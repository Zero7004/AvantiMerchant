//
//  OrderManagementViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OrderManagementViewController.h"
#import "SegmentControl.h"
#import "InProgressViewController.h"
#import "CompletedViewController.h"
#import "CanceledViewController.h"

@interface OrderManagementViewController (){
    NSArray *dic_Goon;    //
}

@property (strong, nonatomic) InProgressViewController *inProgressVC;
@property (strong, nonatomic) CompletedViewController *completedVC;
@property (strong, nonatomic) CanceledViewController *canceledVC;

@property (strong, nonatomic) MBProgressHUD *hud;


@end

@implementation OrderManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阿凡提商家";
    [self initSegmentControl];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.subviews[0].subviews[1].hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderInfor) name:@"getOrderInfor" object:nil];

    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getOrderInfor];
}



//创建视图控制器
-(void)initSegmentControl{
    _inProgressVC = [[InProgressViewController alloc] init];
    _completedVC = [[CompletedViewController alloc] init];
    _canceledVC = [[CanceledViewController alloc] init];
    
    _inProgressVC.dictGoon = dic_Goon;

    
    SegmentControl *segmentControl = [[SegmentControl alloc] initStaticTitlesWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    segmentControl.titles = @[@"进行中", @"已完成", @"已取消"];
    segmentControl.backgroundColor = NAV_COLOR;
    segmentControl.viewControllers = @[_inProgressVC, _completedVC, _canceledVC];
    segmentControl.titleNormalColor = [UIColor whiteColor];
    segmentControl.titleSelectColor = SELECTColor;
    [segmentControl setBottomViewColor:SELECTColor];
    segmentControl.isTitleScale = YES;
    
    [self.view addSubview:segmentControl];
}

//获取订单信息
-(void)getOrderInfor{
    NSString *url = [API stringByAppendingString:@"Personal/personals"];
    if ([AppDelegate APP].user.userId == nil) {
//        [Util toastWithView:self.view AndText:@"登录失效 请重新登录"];
        return;
    }
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"获取商家信息 %@", responseObject);
        
        [_hud hideAnimated:YES];
        _inProgressVC.loading = NO;
        
        if (responseObject != nil) {
//            NSDictionary *dictShop = [responseObject objectForKey:@"shop"];
//            NSDictionary *dictNew = [responseObject objectForKey:@"arr"][@"newOrder"];
            NSArray *dictGoon = [responseObject objectForKey:@"arr"][@"goon"];
//            NSDictionary *dictRefund = [responseObject objectForKey:@"arr"][@"refund"];
//            NSDictionary *dictReminder = [responseObject objectForKey:@"arr"][@"reminder"];
            
            //商家信息
//            if (![dictShop isKindOfClass:[NSNull class]]) {
//                NSLog(@"Shop = %@", dictShop);
//                [AppDelegate APP].user.shopId = dictShop[@"shopId"];
//                [AppDelegate APP].user.shopName = dictShop[@"shopName"];
//                [AppDelegate APP].user.dlvService = dictShop[@"dlvService"];
//                [AppDelegate APP].user.shopImg = dictShop[@"shopImg"];
//                
//            }
            //新订单
//            if (![dictNew isKindOfClass:[NSNull class]]) {
//            }
            //进行中的订单
            if (![dictGoon isKindOfClass:[NSNull class]]) {
                dic_Goon = dictGoon;
                _inProgressVC.dictGoon = [[NSArray alloc] init];
                _inProgressVC.dictGoon = dic_Goon;
                if (_inProgressVC.isRefresh) {
                    _inProgressVC.isRefresh = NO;
                    [_inProgressVC.tableView reloadData];
                    [_inProgressVC.tableView.header endRefreshing];
                }
            }
            else{
                if (_inProgressVC.isRefresh) {
                    _inProgressVC.isRefresh = NO;
                    [_inProgressVC.tableView reloadData];
                    [_inProgressVC.tableView.header endRefreshing];
                }
            }
            
//            //退款单
//            if (![dictRefund isKindOfClass:[NSNull class]]) {
//                
//            }
//            //催单
//            if (![dictReminder isKindOfClass:[NSNull class]]) {
//                
//            }
        
        }
        
        else{
//            [Util toastWithView:self.view AndText:@"获取信息失败"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家信息失败 %@", error);
        _inProgressVC.loading = NO;
        [_hud hideAnimated:YES];
        [_inProgressVC.tableView.header endRefreshing];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

//离开视图控制器注销通知
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getOrderInfor" object:nil];
    
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
