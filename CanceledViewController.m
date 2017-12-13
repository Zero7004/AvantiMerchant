//
//  CanceledViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*已取消*//

#import "CanceledViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CompletedCell.h"


@interface CanceledViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    NSDictionary *ALLpayType;       //支付方式
}

@property (nonatomic, getter=isLoading)BOOL loading;

@property (nonatomic, strong) NSArray *orderArray;    //订单列表

@end

@implementation CanceledViewController

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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"阿凡提商家";
    _orderArray = [[NSArray alloc] init];
    ALLpayType = [[NSDictionary alloc] initWithObjects:@[@"余额支付", @"微信支付", @"余额+微信" , @"支付宝", @"支付宝+余额"] forKeys:@[@"1", @"2", @"3", @"4", @"5"]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CompletedCell" bundle:nil] forCellReuseIdentifier:@"CompletedCellcell"];
    self.tableView.separatorStyle = NO; //隐藏分割线

    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];

    [self addRefreshView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self postCancelOrder];
}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction{
    [self postCancelOrder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *orderType;
    CGFloat addressHight;
    CGFloat userNameHeight;
    if (_orderArray[indexPath.row][@"orderType"] != nil && ![_orderArray[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        addressHight = 0;
    }
    else{
        addressHight = [Util countTextHeight:_orderArray[indexPath.row][@"userAddress"]] - 5;
    }
    if ([orderType integerValue] == 1) {
        userNameHeight = -15;
    }
    else{
        userNameHeight = 10;
    }
    NSArray *goodLists = _orderArray[indexPath.row][@"goodlist"];
    CGFloat tableHight = (goodLists.count + 2) * 30;
    return 340 + addressHight + tableHight + userNameHeight;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_orderArray.count == 0) {
        return 0;
    }
    else
        return 150;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_orderArray.count == 0) {
        UIView *footrerView = [UIView new];
        return footrerView;
    }
    else
    {
        UIView *footrerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        footrerView.backgroundColor = [UIColor whiteColor];
        return footrerView;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompletedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedCellcell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CompletedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CompletedCellcell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置订单类型
    NSString *orderType;
    if (_orderArray[indexPath.row][@"orderType"] != nil && ![_orderArray[indexPath.row][@"orderType"] isKindOfClass:[NSNull class]]) {
        orderType = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"orderType"]];
    }
    else
        orderType = @"0";
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

        }
            break;
        case 3:{
            cell.orderType.text = @"预订";
            cell.tip.text = @"预定";
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
//            cell.tip.text = @"预定";
            
            if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
                cell.requireTime.text = [NSString stringWithFormat:@"%@%@", @"预定", _orderArray[indexPath.row][@"requireTime"]];
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
            
        default:
            break;
    }

//    if (_orderArray[indexPath.row][@"requireTime"] != nil && ![_orderArray[indexPath.row][@"requireTime"] isKindOfClass:[NSNull class]]) {
//        cell.requireTime.text = _orderArray[indexPath.row][@"requireTime"];
//    }
//    else
//        cell.requireTime.text = @"";
    
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
    
//    if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
//        cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
//    }
//    else
//        cell.userAddress.text = @"";
    
    if (_orderArray[indexPath.row][@"smallAdd"] != nil && ![_orderArray[indexPath.row][@"smallAdd"] isKindOfClass:[NSNull class]]) {
        cell.smallAdd.text = [NSString stringWithFormat:@"%@%@",@"￥", _orderArray[indexPath.row][@"smallAdd"]];
    }
    else
        cell.smallAdd.text = [NSString stringWithFormat:@"%@",@"￥"];
    
    if (_orderArray[indexPath.row][@"shopALLPayOut"] != nil && ![_orderArray[indexPath.row][@"shopALLPayOut"] isKindOfClass:[NSNull class]]) {
        cell.shopALLPayOut.text = [NSString stringWithFormat:@"%@%@",@"-￥", _orderArray[indexPath.row][@"shopALLPayOut"]];
        
    }
    else
        cell.shopALLPayOut.text = [NSString stringWithFormat:@"%@",@"-￥"];
    
    if (_orderArray[indexPath.row][@"serverMoney"] != nil && ![_orderArray[indexPath.row][@"serverMoney"] isKindOfClass:[NSNull class]]) {
        cell.serverMoney.text = [NSString stringWithFormat:@"%@%@", @"-￥", _orderArray[indexPath.row][@"serverMoney"]];
    }
    else
        cell.serverMoney.text = @"-￥";
    
    if (_orderArray[indexPath.row][@"fnps"] != nil && ![_orderArray[indexPath.row][@"fnps"] isKindOfClass:[NSNull class]]) {
        cell.fnps.text = [NSString stringWithFormat:@"%@%@", @"-￥", _orderArray[indexPath.row][@"fnps"]];
    }
    else
        cell.fnps.text = @"-￥";
    
    if (_orderArray[indexPath.row][@"plan"] != nil && ![_orderArray[indexPath.row][@"plan"] isKindOfClass:[NSNull class]]) {
        cell.plan.text = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"plan"]];
    }
    else
        cell.plan.text = @"";
    
    if (_orderArray[indexPath.row][@"realityPay"] != nil && ![_orderArray[indexPath.row][@"realityPay"] isKindOfClass:[NSNull class]]) {
        cell.realityPay.text = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"realityPay"]];
    }
    else
        cell.realityPay.text = @"";
    
    if (_orderArray[indexPath.row][@"payType"] != nil && ![_orderArray[indexPath.row][@"payType"] isKindOfClass:[NSNull class]]) {
        cell.payType.text = [ALLpayType objectForKey:[NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"payType"]]];
    }
    else
        cell.payType.text = @"";
    
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
    
    if (_orderArray[indexPath.row][@"dsm"] != nil && ![_orderArray[indexPath.row][@"dsm"] isKindOfClass:[NSNull class]]) {
        cell.dsm = [NSString stringWithFormat:@"%@", _orderArray[indexPath.row][@"dsm"]];
    }
    else
        cell.dsm = @"0";
    
    [cell.userAddress setUserInteractionEnabled:NO];

    //计算约束高度
    if ([orderType integerValue] == 1 || [orderType integerValue] == 3 || [orderType integerValue] == 5) {
        cell.addressConstraintHeight.constant = 0;
        cell.daohangBtn.hidden = YES;
    }
    else{
        cell.addressConstraintHeight.constant = [Util countTextHeight:cell.userAddress.text];
        cell.daohangBtn.hidden = NO;
    }
    if ([orderType integerValue] == 1) {
        cell.cellBtn.hidden = YES;
        cell.userName.text = @"";
        cell.userPhone.text = @"";
    }
    else{
        cell.cellBtn.hidden = NO;
    }
//    cell.addressConstraintHeight.constant = [Util countTextHeight:cell.userAddress.text] - 5;
    cell.tableViewHight.constant = (cell.goodlist.count + 2) * 30;
    
    [cell.tableView reloadData];
    
    cell.cellBtn.tag = indexPath.row;
    [cell.cellBtn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //隐藏不需要的控件
    cell.daohangBtn.hidden = YES;
    cell.daohangImg.hidden = YES;
    cell.distance.hidden = YES;
    cell.distance.text = @"";
    
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


//获取已取消订单
-(void)postCancelOrder{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        return ;
    }
    NSString *url = [API stringByAppendingString:@"Personal/cancel"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取已取消订单 %@", responseObject);
        self.loading = NO;
        [self.tableView.header endRefreshing];
        if (responseObject != nil) {
            _orderArray = responseObject;
            [self.tableView reloadData];
        }
        else{
//            [Util toastWithView:self.navigationController.view AndText:@"获取已取消订单失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取已取消订单失败 %@", error);
        [self.tableView.header endRefreshing];
        self.loading = NO;
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无取消订单";
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
    [self postCancelOrder];
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

@end
