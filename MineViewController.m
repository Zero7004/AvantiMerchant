//
//  MineViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

//**我的**//

#import "MineViewController.h"
#import "CodeViewController.h"
#import "StoreInformationViewController.h"
#import "MerchantServiceCentreViewController.h"
#import "FinancialAccountsViewController.h"

@interface MineViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;  //二维码按钮
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;   //店家头像
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIButton *FinancialAccountsBtn;     //进入财务对账按钮

@property (strong, nonatomic) NSDictionary *shopInfoDic;      //门店信息

@property (weak, nonatomic) IBOutlet UILabel *userNumber;   //用户当前账号

- (IBAction)codeBtnClick:(id)sender;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阿凡提商家";
    _topView.backgroundColor = NAV_COLOR;
    _shopInfoDic = [[NSDictionary alloc] init];
    self.navigationController.navigationBar.subviews[0].subviews[1].hidden = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.codeBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.codeBtn.layer setBorderWidth:1.0];
    
//    [self getShopInfo];
    
    //点击进入财务对账
    [_FinancialAccountsBtn addTarget:self action:@selector(FinancialAccountsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopInfo) name:@"getShopInfo" object:nil];

    if ([AppDelegate APP].user.shopName != nil) {
        _shopName.text = [AppDelegate APP].user.shopName;
    }
    else{
        _shopName.text = @"--";
    }
    
}

//
-(void)viewWillAppear:(BOOL)animated{
    //获取门店信息
    [self getShopInfo];
    
    if (_shopInfoDic[@"shopImg"] != nil && ![_shopInfoDic[@"shopImg"] isKindOfClass:[NSNull class]]) {
        [_mainImageView sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_shopInfoDic[@"shopImg"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
    }
    else
        _mainImageView.image = [UIImage imageNamed:@"noimg"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 2:{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            StoreInformationViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"storeInformation"];
            vc.shopInfoDic = [[NSDictionary alloc] init];
//            vc.shopInfoDic = _shopInfoDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 4:{
            MerchantServiceCentreViewController *vc = [[MerchantServiceCentreViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 8:{
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"15220000777"];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }
            
            break;
        
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取门店信息
-(void)getShopInfo{
    NSString *url = [API stringByAppendingString:@"AdminShop/getShopInfo"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取门店信息 %@", responseObject);
        
        if (responseObject != nil) {
            _shopInfoDic = responseObject;
            
            if (_shopInfoDic[@"shopImg"] != nil && ![_shopInfoDic[@"shopImg"] isKindOfClass:[NSNull class]]) {
                [_mainImageView sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_shopInfoDic[@"shopImg"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
            }
            else
                _mainImageView.image = [UIImage imageNamed:@"noimg"];
            
            if (_shopInfoDic[@"loginName"] != nil && ![_shopInfoDic[@"loginName"] isKindOfClass:[NSNull class]]) {
                _userNumber.text = [NSString stringWithFormat:@"%@", _shopInfoDic[@"loginName"]];
            }
            else
                _userNumber.text = @"--";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取门店信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//门店二维码
- (IBAction)codeBtnClick:(id)sender {
    CodeViewController *vc = [[CodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//离开视图控制器注销通知
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getShopInfo" object:nil];
//    
//}


//点击进入财务对账
-(void)FinancialAccountsBtnClick{
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    FinancialAccountsViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"financialAccounts"];
    [vc GetMoneyLog];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
