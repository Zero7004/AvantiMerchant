//
//  ReductionActiveViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/23.
//  Copyright © 2017年 Mac. All rights reserved.
//


//**活动创建**//

#import "ReductionActiveViewController.h"
#import "THDatePickerView2.h"

@interface ReductionActiveViewController ()<THDatePickerViewDelegate, UITextFieldDelegate>

//减满活动
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *discountMoney;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn00;


//创建优惠券
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *time;
@property (weak, nonatomic) IBOutlet UIButton *end;
@property (weak, nonatomic) IBOutlet UITextField *conditionMoney;
@property (weak, nonatomic) IBOutlet UITextField *money02;
@property (weak, nonatomic) IBOutlet UISwitch *switch02;


//创建新客立减
@property (weak, nonatomic) IBOutlet UITextField *money03;
@property (weak, nonatomic) IBOutlet UISwitch *switch03;


//创建团购活动
//@property (weak, nonatomic) IBOutlet UITextField *tuanName;
//@property (weak, nonatomic) IBOutlet UIButton *startTime;
//@property (weak, nonatomic) IBOutlet UIButton *endTime;
//@property (weak, nonatomic) IBOutlet UISwitch *switch04;


@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) THDatePickerView2 *dateView;

@property NSInteger BtnTag;


@end

@implementation ReductionActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _BtnTag = 0;
    
    _conditionMoney.delegate = self;
    _money02.delegate = self;
    _name.delegate = self;
    
    _confirmBtn.layer.cornerRadius = 7;
    _cancelBtn.layer.cornerRadius = 7;
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_time addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_end addTarget:self action:@selector(endBntClick) forControlEvents:UIControlEventTouchUpInside];
    [_time setTitle:[Util getNowTime] forState:UIControlStateNormal];
    [_end setTitle:@"未选择" forState:UIControlStateNormal];
    
//    [_startTime addTarget:self action:@selector(startTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [self initDateView];

}

-(void)initDateView{
    _dateView = [[THDatePickerView2 alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    _dateView.delegate = self;
    _dateView.title = @"请选择时间";
    self.dateView = _dateView;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.view addSubview:_dateView];
}


-(void)viewWillDisappear:(BOOL)animated{
    [_dateView removeFromSuperview];
}




//确定保存
-(void)confirmBtnClick{
    switch (_tag) {
        case 0:{
            [_money resignFirstResponder];
            [_discountMoney resignFirstResponder];
            if (!(_money.text.length > 0) || !(_discountMoney.text.length > 0)) {
                [Util toastWithView:self.navigationController.view AndText:@"请填写完整信息"];
                return ;
            }
            NSString *RegularStr = @"^[1-9]+[0-9]*([,][1-9]+[0-9]*){0,2}$";
            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", RegularStr];
            if ([regextestcm evaluateWithObject:_money.text] && [regextestcm evaluateWithObject:_discountMoney.text]) {
                NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/setMj"];
                NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"money":[_money.text stringByReplacingOccurrencesOfString:@"，" withString:@","], @"discountMoney":[_discountMoney.text stringByReplacingOccurrencesOfString:@"，" withString:@","]};
                if ([_switchBtn00 isOn]) {
                    [self postActiveWithUrl:url Parameters:dic];
                }
                else{
                    [Util toastWithView:self.navigationController.view AndText:@"您尚未同意《商家自营销协议》"];
                    return ;
                }
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"请填写正确的格式"];
            }
        }
            break;
            
        case 2:{
            [_name resignFirstResponder];
            [_conditionMoney resignFirstResponder];
            if (!(_name.text.length > 0) || !(_conditionMoney.text.length > 0) || !(_money02.text.length > 0 || [_end.titleLabel.text isEqualToString:@"未选择"]) ) {
                [Util toastWithView:self.navigationController.view AndText:@"请填写完整信息"];
                return ;
            }
            if ([_money02.text floatValue] <= 0 || [_conditionMoney.text floatValue] <= 0) {
                [Util toastWithView:self.navigationController.view AndText:@"金额不能为0"];
                return ;
            }
            if ([_money02.text floatValue] <= [_conditionMoney.text floatValue]) {
                [Util toastWithView:self.navigationController.view AndText:@"满金额要大于优惠金额"];
                return ;
            }
            NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/setCoupon"];
            NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"money":_money02.text, @"conditionMoney":_conditionMoney.text, @"name":_name.text, @"end":_end.titleLabel.text, @"time":_time.titleLabel.text};
            if ([_switch02 isOn]) {
                [self postActiveWithUrl:url Parameters:dic];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"您尚未同意《商家自营销协议》"];
                return ;

            }
            

        }
            break;
            
        case 3:{
            [_money03 resignFirstResponder];
            if (!(_money03.text.length > 0)) {
                [Util toastWithView:self.navigationController.view AndText:@"请填写完整信息"];
                return ;
            }
            if (!([_money03.text floatValue] > 0)) {
                [Util toastWithView:self.navigationController.view AndText:@"金额不能为0"];
                return ;
            }
            NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/setNewCou"];
            NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"money":_money03.text};
            if ([_switch03 isOn]) {
                [self postActiveWithUrl:url Parameters:dic];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"您尚未同意《商家自营销协议》"];
                return ;
            }

        }
            break;
            
//        case 4:{
//            [_tuanName resignFirstResponder];
//            if (!(_tuanName.text.length > 0)) {
//                [Util toastWithView:self.navigationController.view AndText:@"请填写完整信息"];
//                return ;
//            }
//            NSString *url = [API stringByAppendingString:@"AdminShop/savetuan"];
//            NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"tuanName":_tuanName.text, @"startTime":_startTime.titleLabel.text, @"endTime":_endTime.titleLabel.text};
//            if ([_switch04 isOn]) {
//                [self postActiveWithUrl:url Parameters:dic];
//            }
//            else{
//                [Util toastWithView:self.navigationController.view AndText:@"您尚未同意《商家自营销协议》"];
//                return ;
//            }
//            
//
//        }
//            break;
            
        default:
            break;
    }

//    [self.navigationController popViewControllerAnimated:YES];
}

//取消
-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)postActiveWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"创建活动 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"活动创建成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"活动创建失败"];
//                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"活动创建失败"];
//            [self.navigationController popViewControllerAnimated:YES];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"创建活动失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



//减满活动
#pragma mark 减满活动



//创建优惠券
#pragma mark 创建优惠券
-(void)timeBtnClick{
    [_name resignFirstResponder];
    [_conditionMoney resignFirstResponder];
    [_money02 resignFirstResponder];
    
    _BtnTag = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
        [self.dateView show];
    }];
}

-(void)endBntClick{
    [_name resignFirstResponder];
    [_conditionMoney resignFirstResponder];
    [_money02 resignFirstResponder];
    
    _BtnTag = 2;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
        [self.dateView show];
    }];

}




//创建新客立减
#pragma mark 创建新客立减




//创建团购活动
#pragma mark 创建团购活动
//-(void)startTimeBtnClick{
//    _BtnTag = 3;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
//        [self.dateView show];
//    }];
//
//}
//
//-(void)endTimeBtnClick{
//    _BtnTag = 4;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.dateView.frame = CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 300);
//        [self.dateView show];
//    }];
//
//}

#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    //    NSLog(@"保存点击");
    
//    [_topButton setTitle:timer forState:UIControlStateNormal];

    switch (_BtnTag) {
        case 1:
            [_time setTitle:timer forState:UIControlStateNormal];
            break;
            
        case 2:
            [_end setTitle:timer forState:UIControlStateNormal];
            break;

//        case 3:
//            [_startTime setTitle:timer forState:UIControlStateNormal];
//            break;

//        case 4:
//            [_endTime setTitle:timer forState:UIControlStateNormal];
//            break;

            
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }];
    
//    [self getTodayWithTime:timer];
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    //    NSLog(@"取消点击");
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UItextFieldDelegate
//修改数量
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _conditionMoney) {
        _conditionMoney.text = [NSString stringWithFormat:@"%.2f", [_conditionMoney.text floatValue]];
    }
    else if (textField == _money02){
        _money02.text = [NSString stringWithFormat:@"%.2f", [_money02.text floatValue]];
    }
    else if (textField == _name){
        if (_name.text.length > 10) {
            [Util toastWithView:self.navigationController.view AndText:@"活动名称不能超过10个字"];
        }
    }
    
}


@end
