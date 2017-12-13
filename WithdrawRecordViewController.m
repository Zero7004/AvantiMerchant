//
//  WithdrawRecordViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/7.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*提现记录*//

#import "WithdrawRecordViewController.h"
#import "WithdrawTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"


@interface WithdrawRecordViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, getter=isLoading)BOOL loading;

@property (strong, nonatomic) NSArray *recordList;      //列表

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation WithdrawRecordViewController

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
    self.title = @"阿凡提商家";

    [self getWithdrawalRecord];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WithdrawTableViewCell" bundle:nil] forCellReuseIdentifier:@"withdrawCell"];

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WithdrawTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"withdrawCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[WithdrawTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"withdrawCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_recordList[indexPath.row][@"money"] != nil && ![_recordList[indexPath.row][@"money"] isKindOfClass:[NSNull class]]) {
        cell.money.text = [NSString stringWithFormat:@"%@", _recordList[indexPath.row][@"money"]];
    }
    else
        cell.money.text = @"0.00";
    
    if (_recordList[indexPath.row][@"cashSatus"] != nil && ![_recordList[indexPath.row][@"cashSatus"] isKindOfClass:[NSNull class]]) {
        cell.cashSatus.text = [[NSString stringWithFormat:@"%@", _recordList[indexPath.row][@"cashSatus"]] isEqualToString:@"1"]?@"已入账":@"已申请";
    }
    else
        cell.cashSatus.text = @"错误";
    
    if ([cell.cashSatus.text isEqualToString:@"已申请"]) {
        if (_recordList[indexPath.row][@"createTime"] != nil && ![_recordList[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
            cell.createTime.text = [NSString stringWithFormat:@"%@", _recordList[indexPath.row][@"createTime"]];
            cell.tip.text = @"待平台审核";
        }
        else{
            cell.createTime.text = @"---";
            cell.tip.text = @"";
        }
    }
    else if([cell.cashSatus.text isEqualToString:@"已入账"]){
        if (_recordList[indexPath.row][@"handleTime"] != nil && ![_recordList[indexPath.row][@"handleTime"] isKindOfClass:[NSNull class]]) {
            cell.createTime.text = [NSString stringWithFormat:@"%@", _recordList[indexPath.row][@"handleTime"]];
            cell.tip.text = @"";
        }
        else{
            cell.createTime.text = @"---";
            cell.tip.text = @"";
        }

    }
    
    return cell;
}

-(void)getWithdrawalRecord{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Personal/txSatus"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取提现记录 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            _recordList = responseObject;
            [self.tableView reloadData];
        }
        else{
            [Util toastWithView:self.view AndText:@"暂无提现记录"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取提现记录失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}

#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无提现记录";
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loading = NO;
    });
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
