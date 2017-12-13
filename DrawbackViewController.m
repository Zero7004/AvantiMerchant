//
//  DrawbackViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*退款*//

#import "DrawbackViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "DrawbackTableViewCell.h"


@interface DrawbackViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@end

@implementation DrawbackViewController

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
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DrawbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"drawback"];

    self.tableView.separatorStyle = NO; //隐藏分割线
    _isRefresh = NO;
    [self addRefreshView];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewRefund) name:@"pushGetNewRefund" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];

//    [self.tableView reloadData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGetNewRefund) name:@"pushGetNewRefund" object:nil];

}

-(void)addRefreshView{
    __weak __typeof(self)weakSelf = self;
    
    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction{
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_orderArray.count == 0) {
        return 0;
    }
    else
        return 220;    //150
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat addressHight = [Util countTextHeight:_orderArray[indexPath.row][@"userAddress"]] - 5;
    NSArray *goodLists = _orderArray[indexPath.row][@"goodlist"];
    CGFloat tableHight = (goodLists.count + 1) * 30;
    CGFloat reasonHight = [Util countTextHeight:_orderArray[indexPath.row][@"refundRemark"]];
    return 230 + addressHight + tableHight + reasonHight;

//    return 350;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DrawbackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"drawback" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DrawbackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"drawback"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    if (_orderArray[indexPath.row][@"userAddress"] != nil && ![_orderArray[indexPath.row][@"userAddress"] isKindOfClass:[NSNull class]]) {
        cell.userAddress.text = _orderArray[indexPath.row][@"userAddress"];
    }
    else
        cell.userAddress.text = @"";
    
    if (_orderArray[indexPath.row][@"refundRemark"] != nil && ![_orderArray[indexPath.row][@"refundRemark"] isKindOfClass:[NSNull class]]) {
        cell.refundRemark.text = [NSString stringWithFormat:@"%@%@", @"退款原因：", _orderArray[indexPath.row][@"refundRemark"]];
    }
    else
        cell.refundRemark.text = @"退款原因：";
    
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
    
    //计算约束高度
    [cell.userAddress setUserInteractionEnabled:NO];

    cell.refundReasonConsHeight.constant = [Util countTextHeight:cell.refundRemark.text];
    cell.addressConstraintHeight.constant = [Util countTextHeight:cell.userAddress.text];
    cell.tableViewHeight.constant = (cell.goodlist.count + 1) * 30;
    
    [cell.tableView reloadData];
    
    cell.disagreeBtn.tag = indexPath.row;
    cell.agreeBtn.tag = indexPath.row;
    [cell.disagreeBtn addTarget:self action:@selector(disagreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}


//不同意退款
-(void)disagreeBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self postDisagreeRefundWithOrderId:_orderArray[btn.tag][@"orderId"]];
}


//同意退款
-(void)agreeBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self postAgreeRefundWithOrderId:_orderArray[btn.tag][@"orderId"]];
}


//不同意退款
-(void)postDisagreeRefundWithOrderId:(NSString *)orderId{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        return ;
    }
    NSString *url = [API stringByAppendingString:@"Personal/bRefund"];
    NSDictionary *dic = @{@"orderId":orderId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"不同意退款 %@", responseObject);
        if (responseObject != nil) {
            if ([[NSString stringWithFormat:@"%@", responseObject[@"res"]] isEqualToString:@"1"]) {
                _isRefresh = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
                [Util toastWithView:self.navigationController.view AndText:@"不同意退款成功"];
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"不同意退款失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"不同意退款失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"不同意退款失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}



//同意退款
-(void)postAgreeRefundWithOrderId:(NSString *)orderId{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        return ;
    }
    NSString *url = [API stringByAppendingString:@"Personal/aRefund"];
    NSDictionary *dic = @{@"orderId":orderId, @"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"不同意退款 %@", responseObject);
        if (responseObject != nil) {
            _isRefresh = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
            [Util toastWithView:self.navigationController.view AndText:@"同意退款成功"];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"同意退款失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"同意退款失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
    
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
    _isRefresh = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getOrder" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"离开");
}



@end
