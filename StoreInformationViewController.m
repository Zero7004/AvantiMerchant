//
//  StoreInformationViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*营业状态*//

#import "StoreInformationViewController.h"
#import "OperatingStateViewController.h"
#import "NoticeViewController.h"
#import "ChangePhoneViewController.h"
#import "ChangeTimeViewController.h"
#import "MerchantsMemberViewController.h"

@interface StoreInformationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stare;  //营业状态
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;        //电话号码
@property (weak, nonatomic) IBOutlet UILabel *shopAddress;
@property (weak, nonatomic) IBOutlet UILabel *time;           //营业时间
@property (weak, nonatomic) IBOutlet UISwitch *bill;     //是否支持发票

@property (strong, nonatomic) NSString *notice;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;


- (IBAction)billChange:(id)sender;

@end

@implementation StoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getShopInfo];
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            OperatingStateViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"OperatingState"];
            vc.shopImgUrl = _shopInfoDic[@"shopImg"];
            vc.shopAtive =_stare.text;
            vc.startTime = _startTime;
            vc.endTime = _endTime;
            vc.block = ^(NSString *stare) {
                _stare.text = stare;
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
         
        case 2:{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            NoticeViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"notice"];
            vc.notice = _notice;
            vc.block = ^(NSString *noti) {
                _notice = noti;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 4:{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ChangePhoneViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"changePhone"];
            vc.phoneNum = _phoneNumber.text;
            
            vc.block = ^(NSString *phone) {
                _phoneNumber.text = phone;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 6:{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ChangeTimeViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"changeTime"];
            vc.startTime = _startTime;
            vc.endTime = _endTime;
            vc.block = ^(NSString *startTime, NSString *endTime) {
                _time.text = [NSString stringWithFormat:@"%@%@%@", startTime, @" ~ ",endTime];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

        default:
            break;
    }
}

//初始化数据
-(void)initShopInfo{
    if (_shopInfoDic[@"shopAtive"] != nil && ![_shopInfoDic[@"shopAtive"] isKindOfClass:[NSNull class]]) {
        NSString *activ = [NSString stringWithFormat:@"%@", _shopInfoDic[@"shopAtive"]];
        switch ([activ intValue]) {
            case 0:
                _stare.text = @"停止营业";
                break;
            case 1:
                _stare.text = @"营业中";

                break;
            case 2:
                _stare.text = @"休息中";

                break;

                
            default:
                break;
        }
    }
    else
        _stare.text = @"营业中";
    
    if (_shopInfoDic[@"shopTel"] != nil && ![_shopInfoDic[@"shopTel"] isKindOfClass:[NSNull class]]) {
        _phoneNumber.text = _shopInfoDic[@"shopTel"];
    }
    else
        _phoneNumber.text = @"--";
    
    if (_shopInfoDic[@"shopAddress"] != nil && ![_shopInfoDic[@"shopAddress"] isKindOfClass:[NSNull class]]) {
        _shopAddress.text = _shopInfoDic[@"shopAddress"];
    }
    else
        _shopAddress.text = @"--";

    NSString *serviceStartTime = @"";
    NSString *serviceEndTime = @"";
    if (_shopInfoDic[@"serviceStartTime"] != nil && ![_shopInfoDic[@"serviceStartTime"] isKindOfClass:[NSNull class]]) {
        serviceStartTime = _shopInfoDic[@"serviceStartTime"];
    }
    if (_shopInfoDic[@"serviceStartTime"] != nil && ![_shopInfoDic[@"serviceStartTime"] isKindOfClass:[NSNull class]]) {
        serviceEndTime = _shopInfoDic[@"serviceEndTime"];
    }
    _time.text = [NSString stringWithFormat:@"%@%@%@", serviceStartTime, @" ~ ",serviceEndTime];
    
    if (_shopInfoDic[@"bill"] != nil && ![_shopInfoDic[@"bill"] isKindOfClass:[NSNull class]]) {
        NSString *bill = [NSString stringWithFormat:@"%@", _shopInfoDic[@"bill"]];
        if ([bill isEqualToString:@"1"]) {
            [_bill setOn:YES];
        }
        else
            [_bill setOn:NO];
    }
    else
        [_bill setOn:NO];
    
    if (_shopInfoDic[@"notice"] != nil && ![_shopInfoDic[@"notice"] isKindOfClass:[NSNull class]]) {
        _notice = _shopInfoDic[@"notice"];
    }
    else
        _notice = @"";

    if (_shopInfoDic[@"serviceStartTime"] != nil && ![_shopInfoDic[@"serviceStartTime"] isKindOfClass:[NSNull class]]) {
        _startTime = _shopInfoDic[@"serviceStartTime"];
    }
    else
        _startTime = @"---";

    if (_shopInfoDic[@"serviceEndTime"] != nil && ![_shopInfoDic[@"serviceEndTime"] isKindOfClass:[NSNull class]]) {
        _endTime = _shopInfoDic[@"serviceEndTime"];
    }
    else
        _endTime = @"---";

}


//设置发票
-(void)postSetBill:(NSString *)postSetBill{
    NSString *url = [API stringByAppendingString:@"AdminShop/setBill"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"bill":postSetBill};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"设置发票%@", responseObject);
        
        if (responseObject != nil) {
//            if (responseObject[@"success"] != nil && ![responseObject[@"success"] isKindOfClass:[NSNull class]]) {
//                if ([responseObject[@"success"] isEqualToString:@"success"]) {
////                    [Util toastWithView:self.navigationController.view AndText:@"发票设置成功"];
//                }
//                else
//                    [Util toastWithView:self.navigationController.view AndText:@"发票设置失败"];
//            }
//            else
//                [Util toastWithView:self.navigationController.view AndText:@"发票设置失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"发票设置失败"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发票失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)billChange:(id)sender {
    if ([_bill isOn]) {
        [self postSetBill:@"1"];
    }
    else
        [self postSetBill:@"0"];
    
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
            [self initShopInfo];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取门店信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



@end
