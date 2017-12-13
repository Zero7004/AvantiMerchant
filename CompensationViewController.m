//
//  CompensationViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*赔偿*//

#import "CompensationViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NewOrderTableViewCell.h"

@interface CompensationViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, getter=isLoading)BOOL loading;

@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, strong) NSArray *complaintId;
@property (nonatomic, strong) NSArray *complaintTitle;

@property (strong, nonatomic) MBProgressHUD *hud;


//@property (assign, nonatomic)BOOL isRefresh;


@end

@implementation CompensationViewController

- (void)setLoading:(BOOL)loading
{
    if (self.loading == loading) {
        return;
    }
    _loading = loading;
    [self.tableView reloadEmptyDataSet];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderArray = [[NSArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    [self.tableView registerNib:[UINib nibWithNibName:@"NewOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"newOrder"];
//    _isRefresh = NO;
    
    _complaintId = [[NSArray alloc] init];
    _complaintTitle = [[NSArray alloc] init];
    

    _complaintId = @[@"230", @"150", @"160", @"190", @"170", @"140", @"210", @"220", @"200", @"130"];
    _complaintTitle = @[@"其他", @"未保持餐品完整", @"服务态度恶劣", @"额外索取费用", @"诱导收货人或商户退单", @"提前点击送达", @"虚假标记异常", @"少餐错餐", @"虚假配送", @"未进行配送"];
    
    [self addRefreshView];
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postCompArr) name:@"postCompArr" object:nil];

    [self postCompArr];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postCompArr" object:nil];
    
}

- (void)addRefreshView
{
    __weak __typeof(self)weakSelf = self;
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
}
- (void)refreshAction
{
//    _isRefresh = YES;
    
    [self postCompArr];
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_orderArray.count == 0) {
        return 0;
    }
    else
        return 220;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_orderArray.count == 0) {
        UIView *footrerView = [UIView new];
        return footrerView;
    }
    else
    {
        UIView *footrerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        footrerView.backgroundColor = [UIColor whiteColor];
        return footrerView;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置订单类型
    NSString *orderType;
    CGFloat addressHight;
    CGFloat userNameHeight;
    if (_orderArray[indexPath.row][@"orderType"] != nil && ![_orderArray[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
    //在原来基础上隐藏地址高度
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        addressHight = -15;
    }
    else{
        addressHight = -15;
        
    }
    if ([orderType integerValue] == 1) {
        userNameHeight = -20;
        addressHight = 0;
    }
    else{
        userNameHeight = 21;
    }
    
    NSArray *goodLists = _orderArray[indexPath.row][@"goodlist"];
    CGFloat tableHight = (goodLists.count + 1) * 30;
    
    return 240 + addressHight + tableHight + userNameHeight;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewOrderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"newOrder" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newOrder"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置订单类型
    NSString *orderType;
    if (_orderArray[indexPath.row][@"orderType"] != nil && ![_orderArray[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
    
    //堂内、自取、预定订单隐藏地址
    //堂内 隐藏用户名和手机
    switch ([orderType integerValue]) {
        case 0:{
            cell.orderType.text = @"外卖";
            
            if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@", @"立即送达 ", _orderArray[indexPath.row][@"requireTime"]];
            }
            else
                cell.requireTime.text = @"";
            
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 4)];
            cell.requireTime.attributedText = str;
            
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.userAddress.text = @"";
            
            //            cell.tip.text = @"立即送达";
        }
            break;
        case 1:{
            cell.orderType.text = @"堂内";
            cell.userAddress.text = @"";
            //时间处显示桌位号，
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.requireTime.text = @"";
            
            
            cell.requireTime.textColor = [UIColor orangeColor];
            
            [cell.mealsOnWheelsBtn setTitle:@"备餐" forState:UIControlStateNormal];
        }
            break;
        case 3:{
            cell.orderType.text = @"预订";
            if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@%@", @"预定", _orderArray[indexPath.row][@"requireTime"], @" 送达"];
            }
            else
                cell.requireTime.text = @"";
            
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
            cell.requireTime.attributedText = str;
            
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.userAddress.text = @"";
            
            
        }
            break;
        case 4:{
            cell.orderType.text = @"团购";
        }
        case 5:{
            cell.orderType.text = @"自取";
            
            if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@", @"预定", _orderArray[indexPath.row][@"requireTime"]];
            }
            else
                cell.requireTime.text = @"";
#pragma mark 地址赋值
            //实现富文本
            //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.requireTime.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
            cell.requireTime.attributedText = str;
            
            if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
                cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
            }
            else
                cell.userAddress.text = @"";
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    if (_orderArray[indexPath.row][@"userName"] != nil && ![_orderArray[indexPath.row][@"userName"] isKindOfClass:[NSNull class]]) {
        cell.userName.text = _orderArray[indexPath.row][@"userName"];
    }
    else
        cell.userName.text = @"";
    
    if (_orderArray[indexPath.row][@"userPhone"] != nil && ![_orderArray[indexPath.row][@"userPhone"] isKindOfClass:[NSNull class]]) {
        cell.userPhone.text = _orderArray[indexPath.row][@"userPhone"];
    }
    else
        cell.userPhone.text = @"";
    
    
    if (_orderArray[indexPath.row][@"distance"] != nil && ![_orderArray[indexPath.row][@"distance"] isKindOfClass:[NSNull class]]) {
        cell.distance.text = [NSString stringWithFormat:@"%@%@", _orderArray[indexPath.row][@"distance"], @"km"];
    }
    else
        cell.distance.text = @"0km";
    
    if (_orderArray[indexPath.row][@"realTotalMoney"] != nil && ![_orderArray[indexPath.row][@"realTotalMoney"] isKindOfClass:[NSNull class]]) {
        cell.realTotalMoney.text = [NSString stringWithFormat:@"%@%@", @"￥",_orderArray[indexPath.row][@"realTotalMoney"]];
    }
    else
        cell.realTotalMoney.text = @"￥0.00";
    
    if (_orderArray[indexPath.row][@"orderNo"] != nil && ![_orderArray[indexPath.row][@"orderNo"] isKindOfClass:[NSNull class]]) {
        cell.orderNo.text = [@"订单号:" stringByAppendingString:_orderArray[indexPath.row][@"orderNo"]];
    }
    else
        cell.orderNo.text = @"订单号:";
    
    if (_orderArray[indexPath.row][@"createTime"] != nil && ![_orderArray[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
        cell.createTime.text = [_orderArray[indexPath.row][@"createTime"] stringByAppendingString:@"下单"];
    }
    else
        cell.createTime.text = @"";
    
    //将数据传入
    cell.goodlist = _orderArray[indexPath.row][@"goodlist"];
    if (_orderArray[indexPath.row][@"boxFee"] != nil && ![_orderArray[indexPath.row][@"boxFee"] isKindOfClass:[NSNull class]]) {
        cell.boxFee = [NSString stringWithFormat:@"%@",_orderArray[indexPath.row][@"boxFee"]];
    }
    else
        cell.boxFee = @"0";
    
    [cell.userAddress setUserInteractionEnabled:NO];
    
    //餐赔不需要地址和导航
    //计算约束高度---地址跟导航全部隐藏
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        cell.addressConstraintHeight.constant = 0;
        cell.distance.hidden = YES;
        cell.daohangBtn.hidden = YES;
    }
    else{
        cell.addressConstraintHeight.constant = 0;
        cell.distance.hidden = YES;
        cell.daohangBtn.hidden = YES;
    }
    
    if ([orderType integerValue] == 1) {
        cell.cellBtn.hidden = YES;
        cell.userName.text = @"";
        cell.userPhone.text = @"";
    }
    else{
        cell.cellBtn.hidden = NO;
    }
    
    cell.tableViewHeight.constant = (cell.goodlist.count + 1) * 30;
    
    [cell.tableView reloadData];
    
    cell.cancelOrderBtn.tag = indexPath.row;
    cell.cellBtn.tag = indexPath.row;
    cell.mealsOnWheelsBtn.tag = indexPath.row;
    cell.daohangBtn.tag = indexPath.row;
//    [cell.cancelOrderBtn addTarget:self action:@selector(cancelOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.daohangBtn addTarget:self action:@selector(daohangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //隐藏左边按钮
    cell.cancelOrderBtn.hidden = YES;
    //修改右边按钮字样
    [cell.mealsOnWheelsBtn setTitle:@"申请餐赔" forState:UIControlStateNormal];
    [cell.mealsOnWheelsBtn addTarget:self action:@selector(mealsOnWheelsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
//打电话
-(void)cellBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_orderArray[btn.tag][@"userPhone"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

//申请餐赔
-(void)mealsOnWheelsBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"请选择餐赔类型" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < _complaintTitle.count; i++) {
        [alter addAction:[UIAlertAction actionWithTitle:_complaintTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否确定选择一下类型" message:_complaintTitle[i] preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"选择了 = %d", i);
                
                _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                _hud.label.text = @"正在申请餐赔";
                [self postOrderComplaintWithOrderNo:_orderArray[btn.tag][@"orderNo"] ComplaintId:_complaintId[i]];
                
            }]];
            [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }]];
    }
    
    //添加取消选项
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alter dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alter animated:YES completion:nil];

}







#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无新订单";
    UIFont *font = [UIFont systemFontOfSize:17];
    UIColor *color = [UIColor lightGrayColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:text attributes:attribult];
}

//详情标题（返回详情标题）
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"点击重新加载";
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [attributes setObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    [attributes setValue:paragraph forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return attributeString;
}

//让图片进行旋转
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

//返回单张图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    } else {
        return [UIImage imageNamed:@"暂无数据"];
    }
}

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return self.isLoading;
}
//点击view加载三秒后停止
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.loading = YES;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.loading = NO;
//    });
    [self postCompArr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 接口

//获取餐赔订单
- (void)postCompArr
{
    
    NSString *url = [API stringByAppendingString:@"Personal/getComplaint"];
    if ([AppDelegate APP].user.userId == nil) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取餐赔信息 ：%@",responseObject);

        self.loading = NO;
        [self.tableView.header endRefreshing];
        
        if (responseObject != nil) {
            if ([[responseObject[@"res"] stringValue] isEqualToString:@"1"] ) {
                
                NSArray *compA = [[NSArray alloc] init];
                compA = responseObject[@"complaintOrder"];
                
                if (compA != nil && ![compA isKindOfClass:[NSNull class]]) {
                    _orderArray = compA;
                }
                else{
                    _orderArray = @[];
                }
                
                [self.tableView reloadData];

            }
            else{
                _orderArray = @[];
                [self.tableView reloadData];
            }
        }
        else{
            _orderArray = @[];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loading = NO;
        [self.tableView.header endRefreshing];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//申请餐赔
-(void)postOrderComplaintWithOrderNo:(NSString *)orderNo ComplaintId:(NSString *)complaintId{

    NSString *url = [API stringByAppendingString:@"Personal/orderComplaint"];
    if ([AppDelegate APP].user.userId == nil) {
        return;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic = @{@"orderNo":orderNo, @"complaintId":complaintId};
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [_hud hideAnimated:YES];

        NSLog(@"申请餐赔信息 ：%@",responseObject);
        
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"申请成功"];
                [self postCompArr];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"申请失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"申请失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"申请餐赔失败 %@", error);
        [_hud hideAnimated:YES];

        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



@end
