//
//  BargainingViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/13.
//  Copyright © 2017年 Mac. All rights reserved.
//


///***砍价商品***///

#import "BargainingViewController.h"
#import "THDatePickerView2.h"
#import "ChooseGoodsViewController.h"

@interface BargainingViewController ()<THDatePickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UIButton *commodityName;       //商品名称
@property (weak, nonatomic) IBOutlet UITextField *price;            //商品原价
@property (weak, nonatomic) IBOutlet UITextField *bargainPrice;     //最低价格

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) THDatePickerView2 *dateView;

@property NSInteger BtnTag;

@property (strong, nonatomic) NSString *selectGoodsId;   //选中的商品id
@end

@implementation BargainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"阿凡提商家";
    
    _bargainPrice.delegate = self;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    _confirmBtn.layer.cornerRadius = 7;
    _cancelBtn.layer.cornerRadius = 7;
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _BtnTag = 1;
    
    [_startTime addTarget:self action:@selector(startTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_endTime addTarget:self action:@selector(endTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //点击选择商品
    [_commodityName addTarget:self action:@selector(commodityNameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_startTime setTitle:[Util getNowTime] forState:UIControlStateNormal];
    [_endTime setTitle:@"未选择" forState:UIControlStateNormal];
    
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

//确定按钮
-(void)confirmBtnClick{
    if ([_endTime.titleLabel.text isEqualToString:@"未选择"]) {
        [Util toastWithView:self.navigationController.view AndText:@"请设置活动时间"];
        return ;
    }
    if ([_commodityName.titleLabel.text isEqualToString:@"未选择"]) {
        [Util toastWithView:self.navigationController.view AndText:@"请选择商品"];
        return ;
    }
    if (_price.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入原价价格"];
        return ;
    }
    if (_bargainPrice.text.length == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请输入最低价格"];
        return ;
    }
    if ([_bargainPrice.text floatValue] >= [_price.text floatValue]) {
        [Util toastWithView:self.navigationController.view AndText:@"最低价不能大于或等于原价"];
        return ;
    }
    if ([_bargainPrice.text floatValue] <= 0) {
        [Util toastWithView:self.navigationController.view AndText:@"最低价不能为0"];
        return ;
    }
    NSString *url = [API stringByAppendingString:@"Setshop/bargainGoods"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":_selectGoodsId, @"startTime":_startTime.titleLabel.text, @"endTime":_endTime.titleLabel.text, @"maxPrice":_price.text, @"minPrice":_bargainPrice.text};
    if ([_switchBtn isOn]) {
        
        [self postActiveWithUrl:url Parameters:dic];
    }
    else{
        [Util toastWithView:self.navigationController.view AndText:@"您尚未同意《商家自营销协议》"];
        return ;
    }
    
    
}

//取消
-(void)cancelBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)startTimeBtnClick{
    _BtnTag = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
        [self.dateView show];
    }];
    
}

-(void)endTimeBtnClick{
    _BtnTag = 2;
    [UIView animateWithDuration:0.3 animations:^{
        self.dateView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
        [self.dateView show];
    }];
    
}


//选择商品
-(void)commodityNameBtnClick{
    ChooseGoodsViewController *vc = [[ChooseGoodsViewController alloc] init];
    vc.activeType = @"砍价活动";
    vc.block = ^(NSString *selectId, NSString *selctName, NSString *selectPrice) {
        _selectGoodsId = selectId;
        [_commodityName setTitle:selctName forState:UIControlStateNormal];
        [_commodityName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _price.text = selectPrice;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


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
            [_startTime setTitle:timer forState:UIControlStateNormal];
            break;
            
        case 2:
            [_endTime setTitle:timer forState:UIControlStateNormal];
            break;
            
            
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
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _bargainPrice.text = [NSString stringWithFormat:@"%.2f", [_bargainPrice.text floatValue]];
}


#pragma mark - 接口
-(void)postActiveWithUrl:(NSString *)url Parameters:(NSDictionary *)parameters{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"创建活动 %@", responseObject);
        if (responseObject != nil) {
            if ([responseObject[@"res"] isEqual:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"活动创建成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
                [self.navigationController popViewControllerAnimated:YES];

            }
            else if ([responseObject[@"res" ] isEqual:@"-1"]){
                [Util toastWithView:self.navigationController.view AndText:@"该商品已创建此类活动"];

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
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
    
}



@end
