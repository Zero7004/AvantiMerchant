//
//  FinancialAccountsViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/7.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*财务对账*//


#import "FinancialAccountsViewController.h"
#import "WithdrawRecordViewController.h"
#import "WithdrawViewController.h"
#import "IncomeTodayViewController.h"

@interface FinancialAccountsViewController (){
    NSString *userM;
    NSDictionary *bank;
}
@property (weak, nonatomic) IBOutlet UIView *topView01;
@property (weak, nonatomic) IBOutlet UIView *topView02;
@property (weak, nonatomic) IBOutlet UILabel *inLabel;


@property (weak, nonatomic) IBOutlet UIButton *WithdrawBtn;      //提现按钮

@property (weak, nonatomic) IBOutlet UILabel *userMoney;    //可提现金额
@property (weak, nonatomic) IBOutlet UILabel *todayGot;     //今日收入
@property (weak, nonatomic) IBOutlet UILabel *tnNum;        //堂内笔数
@property (weak, nonatomic) IBOutlet UILabel *tnMoney;      //堂内收入
@property (weak, nonatomic) IBOutlet UILabel *wmNum;        //外卖笔数
@property (weak, nonatomic) IBOutlet UILabel *wmMoney;      //外卖收入
@property (weak, nonatomic) IBOutlet UILabel *czNum;        //充值笔数
@property (weak, nonatomic) IBOutlet UILabel *czMoney;      //充值收入
@property (weak, nonatomic) IBOutlet UILabel *tkNum;        //退款笔数
@property (weak, nonatomic) IBOutlet UILabel *tkMoney;      //退款金额

@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction)withdrawBtnClick:(id)sender;    //提现按钮
@end

@implementation FinancialAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.title = @"阿凡提商家";
    
    self.topView01.backgroundColor = NAV_COLOR;
    self.topView02.backgroundColor = NAV_COLOR;
    [self.inLabel setTextColor:NAV_COLOR];
    [self.todayGot setTextColor:NAV_COLOR];
    
    userM = @"0.00";
    bank = [[NSDictionary alloc] init];
    //设置提现按钮边框
    [self.WithdrawBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.WithdrawBtn.layer setBorderWidth:1.0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:{
            //查看提现记录
            WithdrawRecordViewController *vc = [[WithdrawRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        
        case 3:{
//            UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
//            IncomeTodayViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"incomeToday"];
            IncomeTodayViewController *vc = [[IncomeTodayViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//获取商家财务信息
-(void)GetMoneyLog{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/moneyLog"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"userId":[AppDelegate APP].user.userId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取商家财务信息 %@", responseObject);
        [_hud hideAnimated:YES];
        
        if (responseObject != nil) {
            if (responseObject[@"money"][@"userMoney"] != nil && ![responseObject[@"money"][@"userMoney"] isKindOfClass:[NSNull class]]) {
                _userMoney.text = [NSString stringWithFormat:@"%@%@", @"￥",responseObject[@"money"][@"userMoney"]];
                userM = [NSString stringWithFormat:@"%@", responseObject[@"money"][@"userMoney"]];
            }
            else
                _userMoney.text = @"￥0.00";
            
            if (responseObject[@"todayGot"] != nil && ![responseObject[@"todayGot"] isKindOfClass:[NSNull class]]) {
                _todayGot.text = [NSString stringWithFormat:@"%@%@", @"￥",responseObject[@"todayGot"]];
            }
            else
                _todayGot.text = @"￥0";
            
            if (responseObject[@"tnNum"] != nil && ![responseObject[@"tnNum"] isKindOfClass:[NSNull class]]) {
                _tnNum.text = [NSString stringWithFormat:@"%@%@%@", @"共",responseObject[@"tnNum"],@"笔"];
            }
            else
                _tnNum.text = @"共0笔";

            if (responseObject[@"tnMoney"] != nil && ![responseObject[@"tnMoney"] isKindOfClass:[NSNull class]]) {
                _tnMoney.text = [NSString stringWithFormat:@"%@%@", @"￥",responseObject[@"tnMoney"]];
            }
            else
                _tnMoney.text = @"￥0";
            
            if (responseObject[@"wmNum"] != nil && ![responseObject[@"wmNum"] isKindOfClass:[NSNull class]]) {
                _wmNum.text = [NSString stringWithFormat:@"%@%@%@", @"共",responseObject[@"wmNum"],@"笔"];
            }
            else
                _wmNum.text = @"共0笔";
            
            if (responseObject[@"wmMoney"] != nil && ![responseObject[@"wmMoney"] isKindOfClass:[NSNull class]]) {
                _wmMoney.text = [NSString stringWithFormat:@"%@%@", @"￥",responseObject[@"wmMoney"]];
            }
            else
                _wmMoney.text = @"￥0";

            if (responseObject[@"czNum"] != nil && ![responseObject[@"czNum"] isKindOfClass:[NSNull class]]) {
                _czNum.text = [NSString stringWithFormat:@"%@%@%@", @"共",responseObject[@"czNum"],@"笔"];
            }
            else
                _czNum.text = @"共0笔";

            if (responseObject[@"czMoney"] != nil && ![responseObject[@"czMoney"] isKindOfClass:[NSNull class]]) {
                _czMoney.text = [NSString stringWithFormat:@"%@%@", @"￥",responseObject[@"czMoney"]];
            }
            else
                _czMoney.text = @"￥0";

            if (responseObject[@"tkNum"] != nil && ![responseObject[@"tkNum"] isKindOfClass:[NSNull class]]) {
                _tkNum.text = [NSString stringWithFormat:@"%@%@%@", @"共",responseObject[@"tkNum"],@"笔"];
            }
            else
                _tkNum.text = @"共0笔";
            
            if (responseObject[@"tkMoney"] != nil && ![responseObject[@"tkMoney"] isKindOfClass:[NSNull class]]) {
                _tkMoney.text = [NSString stringWithFormat:@"%@%@", @"￥",responseObject[@"tkMoney"]];
            }
            else
                _tkMoney.text = @"￥0";

            bank = responseObject[@"bank"];
        }
        else{
            [Util toastWithView:self.view AndText:@"获取商家财务信息失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商家财务信息失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
    
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

- (IBAction)withdrawBtnClick:(id)sender {
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    WithdrawViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"withdraw"];
    vc.userMoney = userM;
    vc.bank = [[NSDictionary alloc] init];
    vc.bank = bank;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
