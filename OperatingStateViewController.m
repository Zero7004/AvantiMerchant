//
//  OperatingStateViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*营业状态*//


#import "OperatingStateViewController.h"
#import "ChangeTimeViewController.h"
#import "StoreInformationViewController.h"

@interface OperatingStateViewController (){
    BOOL stare;
}
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;  //商家logo
@property (weak, nonatomic) IBOutlet UILabel *stareLabel;          //营业状态
@property (weak, nonatomic) IBOutlet UILabel *operationTime;      //营业时间


@property (weak, nonatomic) IBOutlet UIButton *stateBtn;          //状态按钮
@property (weak, nonatomic) IBOutlet UIButton *backBtn;           //返回按钮

- (IBAction)changeTimeBtn:(id)sender;   //修改营业时间
- (IBAction)BackBtnClick:(id)sender;
- (IBAction)changStareBtnClick:(id)sender;   //修改状态



@end

@implementation OperatingStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";

    [self initView];
}


-(void)initView{
    _stareLabel.text = _shopAtive;
    
    if (_shopImgUrl != nil && ![_shopImgUrl isKindOfClass:[NSNull class]]) {
        [_shopImg sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_shopImgUrl]] placeholderImage:[UIImage imageNamed:@"noimg"]];
    }
    else
        _shopImg.image = [UIImage imageNamed:@"noimg"];

    _operationTime.text = [NSString stringWithFormat:@"%@%@%@%@", @"营业时间：",_startTime, @"-", _endTime];
    
    if ([_stareLabel.text isEqualToString:@"营业中"]) {
        stare = YES;
    }
    else
        stare = NO;
    
    if (stare) {
        [_stateBtn setTitle:@"停止营业" forState:UIControlStateNormal];
    }
    else{
        [_stateBtn setTitle:@"恢复营业" forState:UIControlStateNormal];
    }
    
    _backBtn.layer.cornerRadius = 5;
    _backBtn.layer.borderWidth = 1;
    _backBtn.layer.borderColor = [BG_COLOR CGColor];
    _backBtn.layer.masksToBounds = YES;

    _stateBtn.layer.cornerRadius = 5;
    _stateBtn.layer.borderWidth = 1;
    _stateBtn.layer.borderColor = [[UIColor colorWithRed:223/255.0 green:134/255.0 blue:114/255.0 alpha:1] CGColor];
    _stateBtn.layer.masksToBounds = YES;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeTimeBtn:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChangeTimeViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"changeTime"];
    vc.startTime = _startTime;
    vc.endTime = _endTime;
    vc.block = ^(NSString *startTime, NSString *endTime) {
        _startTime = startTime;
        _endTime = endTime;
        _operationTime.text = [NSString stringWithFormat:@"%@%@%@%@", @"营业时间：",startTime, @"-", endTime];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)BackBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changStareBtnClick:(id)sender {
    if ([_stareLabel.text isEqualToString:@"营业中"]) {
        [_stateBtn setTitle:@"停止营业" forState:UIControlStateNormal];
        _stareLabel.text = @"营业中";
        self.block(_stareLabel.text);
        [self postSetShopActveWithStare:@"0"];
    }
    else{
        [_stateBtn setTitle:@"恢复营业" forState:UIControlStateNormal];
        _stareLabel.text = @"停止营业";
        self.block(_stareLabel.text);
        [self postSetShopActveWithStare:@"1"];
    }
}


//设置营业状态
-(void)postSetShopActveWithStare:(NSString *)stareNum{
    NSString *url = [API stringByAppendingString:@"AdminShop/StopAtive"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"shopAtive":stareNum};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"设置营业状态%@", responseObject);
        
        NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
        
        if (responseObject != nil) {
            if ([res isEqualToString:@"1"]) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[StoreInformationViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"设置失败"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"设置营业状态失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


@end
