//
//  MyAccountViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/2.
//  Copyright © 2017年 Mac. All rights reserved.
//


//***我的账户***//

#import "MyAccountViewController.h"
#import "FaceVerifyViewController.h"

@interface MyAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loginName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;

@property (weak, nonatomic) IBOutlet UILabel *openFaceState;

@property (strong, nonatomic) NSArray *UserPhoneArray;
@property (weak, nonatomic) IBOutlet UIButton *LoginOut;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的账户";
    self.tableView.tableFooterView = [UIView new];
    
    self.LoginOut.layer.cornerRadius = 5;
    [self.LoginOut addTarget:self action:@selector(LoginOutClick) forControlEvents:UIControlEventTouchUpInside];
//    [KeyChain delete:KEY_Server];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    _openFaceState.text = @"未开启 >";
    
    [self postGetUsetAccount];
}

//退出登录
-(void)LoginOutClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出登录？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[AppDelegate APP].user cleanUserInfo];
        [[AppDelegate APP] rootLoginView];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 3:{
            if (![_openFaceState.text isEqualToString:@"已开启"]) {
                //进行刷脸认证
                UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
                FaceVerifyViewController *vc = [loginStoryboard instantiateViewControllerWithIdentifier:@"FaceVerify"];
                vc.userPhone = _userPhone.text;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}





//获取账户信息
-(void)postGetUsetAccount{
    NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/myUser"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取账户信息 %@", responseObject);
        
        if (responseObject != nil) {
            
            if (responseObject[@"loginName"] != nil && ![responseObject[@"loginName"] isKindOfClass:[NSNull class]]) {
                _loginName.text = [NSString stringWithFormat:@"%@", responseObject[@"loginName"]];
                
            }
            else
                _loginName.text = @"--";
            
            if (responseObject[@"userPhone"] != nil && ![responseObject[@"userPhone"] isKindOfClass:[NSNull class]]) {
                _userPhone.text = [NSString stringWithFormat:@"%@", responseObject[@"userPhone"]];
            }
            else
                _userPhone.text = @"--";
            
            //是否开启刷脸登录
            if (responseObject[@"idImg"] != nil && ![responseObject[@"idImg"] isKindOfClass:[NSNull class]]) {
                NSString *idImg = [NSString stringWithFormat:@"%@", responseObject[@"idImg"]];
                if ([idImg isEqualToString:@"1"]) {
                    _openFaceState.text = @"已开启";
                }
                else{
                    _openFaceState.text = @"未开启 >";
                }
            }
            else
                _openFaceState.text = @"未开启 >";

        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取账户信息失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取账户信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
