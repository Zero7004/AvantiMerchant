//
//  CodeViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*二维码视图*//

#import "CodeViewController.h"

@interface CodeViewController ()

@property (strong, nonatomic) UIButton *QRCodeBtn;        //二维码按钮
@property (strong, nonatomic) UIButton *appletCodeBtn;    //小程序按钮
@property (strong, nonatomic) UIImageView *codeImg;       //二维码
@property (strong, nonatomic) UIButton *saveBtn;          //保存按钮
@property (strong, nonatomic) UILabel *bottom01;
@property (strong, nonatomic) UILabel *bottom02;

@property (strong, nonatomic) NSDictionary *imgDic;

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _imgDic = [[NSDictionary alloc] init];
    
    [self initView];
    [self getEwm];
}

-(void)initView{
    _codeImg = [[UIImageView alloc] initWithFrame:CGRectMake(80, 100, SCREEN_WIDTH - 160, SCREEN_WIDTH - 160)];
    _codeImg.backgroundColor = [UIColor whiteColor];
    
    _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_WIDTH, SCREEN_WIDTH - 40, 50)];
    [_saveBtn setTitle:@"保存二维码" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    _saveBtn.backgroundColor = NAV_COLOR;
    _saveBtn.layer.cornerRadius = 5;
    [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_codeImg];
    [self.view addSubview:_saveBtn];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _QRCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2 - 20, 49)];
    [_QRCodeBtn setTitle:@"二维码" forState:UIControlStateNormal];
    [_QRCodeBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    _QRCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _QRCodeBtn.backgroundColor = [UIColor whiteColor];
    [_QRCodeBtn addTarget:self action:@selector(QRCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _bottom01 = [[UILabel alloc] initWithFrame:CGRectMake(20, 49, SCREEN_WIDTH/2 - 20, 2)];
    _bottom01.backgroundColor = NAV_COLOR;

    _appletCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2 - 20, 49)];
    [_appletCodeBtn setTitle:@"小程序二维码" forState:UIControlStateNormal];
    [_appletCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _appletCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _appletCodeBtn.backgroundColor = [UIColor whiteColor];
    [_appletCodeBtn addTarget:self action:@selector(appletBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _bottom02 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 49, SCREEN_WIDTH/2 - 20, 2)];
    _bottom02.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:_QRCodeBtn];
    [headerView addSubview:_bottom01];
    [headerView addSubview:_appletCodeBtn];
    [headerView addSubview:_bottom02];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(void)QRCodeBtnClick{
    [_QRCodeBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    _bottom01.backgroundColor = NAV_COLOR;
    [_appletCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bottom02.backgroundColor = [UIColor whiteColor];

    [_codeImg sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_imgDic[@"wxAppCode"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
}

-(void)appletBtnClick{
    [_QRCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _bottom01.backgroundColor = [UIColor whiteColor];
    [_appletCodeBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    _bottom02.backgroundColor = NAV_COLOR;
    
    [_codeImg sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_imgDic[@"wxCode"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];

}


//获取门店二维码
-(void)getEwm{
    NSString *url = [API stringByAppendingString:@"AdminShop/getEwm"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取门店二维码 %@", responseObject);
        
        if (responseObject != nil) {
            _imgDic = responseObject;
            [_codeImg sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_imgDic[@"wxAppCode"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
            NSLog(@"%@", [API_IMG stringByAppendingString:@"wxAppCode"]);
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取二维码失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取门店二维码失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


-(void)saveBtnClick{
    [self loadImageFinished:_codeImg.image];
}


- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [Util toastWithView:self.navigationController.view AndText:@"保存成功"];
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
