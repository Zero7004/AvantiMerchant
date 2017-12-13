//
//  WithdrawViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/7.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*提现*//


#import "WithdrawViewController.h"



@interface WithdrawViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;  //银行卡
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNo;
@property (weak, nonatomic) IBOutlet UILabel *bankUserName;

@property (weak, nonatomic) IBOutlet UILabel *Money;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextfile;   //提现金额
@property (weak, nonatomic) IBOutlet UITextField *withdrawPwTextfile;  //提现密码
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;   //确认提现按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;  //取消按钮

@property (strong, nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) NSInteger hight;
@property (assign, nonatomic) NSInteger bHight;

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    _Money.text = [NSString stringWithFormat:@"%@%@%@", @"提现金额（当前余额￥", _userMoney, @"）"];
    //初始化部分控件样式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initWithControl];
    [self initBankInfor];
}

-(void)initWithControl{
    //设置顶部银行卡
    // 颜色渐变效果
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    _topView.layer.cornerRadius = 7;
    
    
    //设置提现金额框
    UIImageView *imageViewMon=[[UIImageView alloc]initWithFrame:CGRectMake(-10, 10, 20, 12)];
    imageViewMon.image=[UIImage imageNamed:@"钱"];
    _moneyTextfile.leftView=imageViewMon;
    _moneyTextfile.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _moneyTextfile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _moneyTextfile.keyboardType = UIKeyboardTypeDecimalPad;
//    _moneyTextfile.delegate = self;
    
    UIImageView *imageViewPW=[[UIImageView alloc]initWithFrame:CGRectMake(-10, 10, 20, 12)];
    imageViewPW.image=[UIImage imageNamed:@"星号"];
    _withdrawPwTextfile.leftView=imageViewPW;
    _withdrawPwTextfile.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    _withdrawPwTextfile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _withdrawPwTextfile.keyboardType = UIKeyboardTypeDecimalPad;
//    _withdrawPwTextfile.delegate = self;
    
    //设置按钮边框
    [self.verifyBtn.layer setBorderColor:[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1].CGColor];
    [self.verifyBtn.layer setBorderWidth:1.0];
    [self.verifyBtn.layer setCornerRadius:5];
    self.verifyBtn.layer.masksToBounds = YES;
    [_verifyBtn addTarget:self action:@selector(verifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮边框
    [self.cancelBtn.layer setBorderColor:[UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1].CGColor];
    [self.cancelBtn.layer setBorderWidth:1.0];
    [self.cancelBtn.layer setCornerRadius:5];
    self.cancelBtn.layer.masksToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}


-(void)initBankInfor{
    if (_bank[@"bankName"] != nil && ![_bank[@"bankName"] isKindOfClass:[NSNull class]]) {
        _bankName.text = [NSString stringWithFormat:@"%@", _bank[@"bankName"]];
    }
    else{
        _bankName.text = @"";
    }
    
    if (_bank[@"bankNo"] != nil && ![_bank[@"bankNo"] isKindOfClass:[NSNull class]]) {
        _bankNo.text = [NSString stringWithFormat:@"%@", _bank[@"bankNo"]];
    }
    else{
        _bankNo.text = @"----";

    }
    
    if (_bank[@"bankUserName"] != nil && ![_bank[@"bankUserName"] isKindOfClass:[NSNull class]]) {
        _bankUserName.text = [NSString stringWithFormat:@"%@", _bank[@"bankUserName"]];
    }
    else{
        _bankUserName.text = @"";
    }
}

- (void) keyboardWillShow:(NSNotification *)notification {
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (_withdrawPwTextfile.frame.origin.y+_withdrawPwTextfile.frame.size.height) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.hight = self.view.frame.origin.y;
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, offset - self.hight, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    

}
- (void) UIKeyboardWillHide:(NSNotification *)notification{

    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, self.hight, self.view.frame.size.width, self.view.frame.size.height);
        }];
}
-(void)verifyBtnClick{
    [_moneyTextfile resignFirstResponder];
    [_withdrawPwTextfile resignFirstResponder];
    
    if (!(_moneyTextfile.text.length > 0)) {
        [Util toastWithView:self.view AndText:@"请输入提现金额"];
        return ;
    }
    if (!(_withdrawPwTextfile.text.length > 0)) {
        [Util toastWithView:self.view AndText:@"请输入提现密码"];
        return ;
    }
    
    [self getWithdraw];

}

//提现
-(void)getWithdraw{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/drawsCash"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId ,@"money":_moneyTextfile.text, @"payPwd":_withdrawPwTextfile.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"提现 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            NSString *sta;
            if (responseObject[@"status"] != nil && ![responseObject[@"status"] isKindOfClass:[NSNull class]]) {
                sta = [NSString stringWithFormat:@"%@", responseObject[@"status"]];
            }
            else{
                if (responseObject[@"money"][@"userMoney"] != nil && ![responseObject[@"money"][@"userMoney"] isKindOfClass:[NSNull class]]) {
                    _Money.text = [NSString stringWithFormat:@"%@%@%@", @"提现金额（当前余额￥", responseObject[@"money"][@"userMoney"], @"）"];
                }
                [Util toastWithView:self.view AndText:@"提现成功"];
                return ;
            }
            if ([sta isEqualToString:@"-1"]) {
                [Util toastWithView:self.view AndText:responseObject[@"msg"]];
            }
            else{
                [Util toastWithView:self.view AndText:@"提现失败"];
            }
        }
        else{
            [Util toastWithView:self.view AndText:@"提现失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"提现失败 %@", error);
        [_hud hideAnimated:YES];

        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}



-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_moneyTextfile resignFirstResponder];
    [_withdrawPwTextfile resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消掉通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
