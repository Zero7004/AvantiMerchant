//
//  StoreManagementViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "StoreManagementViewController.h"
#import "ActiveConfigurationViewController.h"
#import "WaiterManageViewController.h"
#import "CheckDeskViewController.h"
#import "MerchantsMemberViewController.h"
#import "CommodityManagementViewController.h"
#import "UserEvaluationViewController.h"
#import "FinancialAccountsViewController.h"
#import "DistributionManagementViewController.h"
#import "MessageCenterViewController.h"
#import "OpenShopTreasureViewController.h"

@interface StoreManagementViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction)ActiveConfigurationBtnClick:(id)sender;      //活动配置入口
- (IBAction)WaiterManageBtnClick:(id)sender;   //服务员管理入口
- (IBAction)CheckDeskBtn:(id)sender;      //查看桌位入口
- (IBAction)memberBtnClick:(id)sender;    //商家会员入口
- (IBAction)CommodityManagBtnClick:(id)sender;   //商品管理入口
- (IBAction)userEvaluationBtnClick:(id)sender;    //用户评价入口
- (IBAction)financialAccountsBtnClick:(id)sender;  //财务对账入口
- (IBAction)DistributionManagementBtnClick:(id)sender;   //配送管理入口
- (IBAction)MessageCenterBtnClick:(id)sender;  //消息中心入口
- (IBAction)OpenShopTreasureBtnClick:(id)sender;  //开店宝入口


- (IBAction)tipBtnClick:(id)sender;   //提示按钮

@property (weak, nonatomic) IBOutlet UILabel *OrderNum;    //当天有效订单数
@property (weak, nonatomic) IBOutlet UILabel *OrderMoney;  //当天订单收入

@end

@implementation StoreManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阿凡提商家";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = NAV_COLOR;
    //去掉导航栏底部黑线
    self.navigationController.navigationBar.subviews[0].subviews[1].hidden = YES;

    [self addRefreshView];

    [self todayGot];
}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction{
    [_hud hideAnimated:YES];
    [self todayGot];
}

//获取当天有效订单和收入
-(void)todayGot{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/todayGot"];
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        return;
    }

    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取当天有效订单和收入 %@", responseObject);
        [self.tableView.header endRefreshing];
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            
            if (responseObject[@"num"] != nil && ![responseObject[@"num"] isKindOfClass:[NSNull class]]) {
                _OrderNum.text = [NSString stringWithFormat:@"%@", responseObject[@"num"]];
            }
            else
                _OrderNum.text = @"0";
            
            if (responseObject[@"money"] != nil && ![responseObject[@"money"] isKindOfClass:[NSNull class]]) {
                _OrderMoney.text = [NSString stringWithFormat:@"%@", responseObject[@"money"]];
            }
            else
                _OrderMoney.text = @"0";

        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取当天有效订单和收入失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取当天有效订单和收入失败 %@", error);
        [self.tableView.header endRefreshing];
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//活动配置入口
- (IBAction)ActiveConfigurationBtnClick:(id)sender {
    ActiveConfigurationViewController *vc = [[ActiveConfigurationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//服务员管理入口
- (IBAction)WaiterManageBtnClick:(id)sender {
    WaiterManageViewController *vc = [[WaiterManageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//查看桌位入口
- (IBAction)CheckDeskBtn:(id)sender {
    CheckDeskViewController *vc = [[CheckDeskViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//商家会员入口
- (IBAction)memberBtnClick:(id)sender {
    MerchantsMemberViewController *vc = [[MerchantsMemberViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//商品管理入口
- (IBAction)CommodityManagBtnClick:(id)sender {
    CommodityManagementViewController *vc = [[CommodityManagementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//用户评价入口
- (IBAction)userEvaluationBtnClick:(id)sender {
    UserEvaluationViewController *vc = [[UserEvaluationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//财务对账入口
- (IBAction)financialAccountsBtnClick:(id)sender {
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    FinancialAccountsViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"financialAccounts"];
    [vc GetMoneyLog];
    [self.navigationController pushViewController:vc animated:YES];
}


//配送管理入口
- (IBAction)DistributionManagementBtnClick:(id)sender {
    DistributionManagementViewController *vc = [[DistributionManagementViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//消息中心入口
- (IBAction)MessageCenterBtnClick:(id)sender {
    MessageCenterViewController *vc = [[MessageCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//开店宝入口
- (IBAction)OpenShopTreasureBtnClick:(id)sender {
    OpenShopTreasureViewController *vc = [[OpenShopTreasureViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//查看提示按钮
- (IBAction)tipBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"今日订单收入" message:@"今日所有订单的预计收入总额，包含在线支付和货到付款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

    
}



@end
