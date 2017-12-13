//
//  MyFeedbackViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

//**我的反馈**//

#import "MyFeedbackViewController.h"
#import "MyFeedbackTableViewCell.h"

@interface MyFeedbackViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *feedbackArray;

@end

@implementation MyFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    _feedbackArray = [[NSArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BG_COLOR;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyFeedbackTableViewCell" bundle:nil] forCellReuseIdentifier:@"myFeedbackCell"];
    //    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initFooterView];
    [self getFeedBackInfo];
}

//初始化底部视图
-(void)initFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 134, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 50)];
    [bottomBtn setTitle:@"返回" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [bottomBtn.layer setCornerRadius:7];
    bottomBtn.layer.masksToBounds = YES;
    
    [footerView addSubview:bottomBtn];
    [self.view addSubview:footerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 130;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _feedbackArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat repH;
    CGFloat quH;
    NSString *rep;
    NSString *qu;
    if (_feedbackArray[indexPath.row][@"question"] != nil && ![_feedbackArray[indexPath.row][@"question"] isKindOfClass:[NSNull class]]) {
        qu = _feedbackArray[indexPath.row][@"question"];
    }
    else
        qu = @"";
    
    if (_feedbackArray[indexPath.row][@"replay"] != nil && ![_feedbackArray[indexPath.row][@"replay"] isKindOfClass:[NSNull class]]) {
        rep = _feedbackArray[indexPath.row][@"replay"];
    }
    else
        rep = @"暂无回复";
    repH = [Util countTextHeight:rep];
    quH = [Util countTextHeight:qu];
    
    return 120 + repH + quH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFeedbackTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"myFeedbackCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyFeedbackTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myFeedbackCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_feedbackArray[indexPath.row][@"createTime"] != nil && ![_feedbackArray[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
        cell.createTime.text = _feedbackArray[indexPath.row][@"createTime"];
    }
    else{
        cell.createTime.text = @"";
    }
    
    if (_feedbackArray[indexPath.row][@"feedtype"] != nil && ![_feedbackArray[indexPath.row][@"feedtype"] isKindOfClass:[NSNull class]]) {
        NSString *type = [NSString stringWithFormat:@"%@", _feedbackArray[indexPath.row][@"feedtype"]];
        switch ([type intValue]) {
            case 1:
                cell.feedtype.text = @"配送问题";
                break;
            case 2:
                cell.feedtype.text = @"投诉业务经理";
                break;
            case 3:
                cell.feedtype.text = @"功能改善建议";
                break;
            case 4:
                cell.feedtype.text = @"其他用户";
                break;
            default:
                break;
        }
    }
    else{
        cell.feedtype.text = @"";
    }

    if (_feedbackArray[indexPath.row][@"question"] != nil && ![_feedbackArray[indexPath.row][@"question"] isKindOfClass:[NSNull class]]) {
        cell.question.text = _feedbackArray[indexPath.row][@"question"];
        cell.questionHeight.constant = [Util countTextHeight:@"question"];
    }
    else{
        cell.question.text = @"";
    }

    if (_feedbackArray[indexPath.row][@"replay"] != nil && ![_feedbackArray[indexPath.row][@"replay"] isKindOfClass:[NSNull class]]) {
        cell.replay.text = _feedbackArray[indexPath.row][@"replay"];
        cell.replayHeight.constant = [Util countTextHeight:@"replay"];

    }
    else{
        cell.replay.text = @"暂无回复";
    }

    
    return cell;
}



-(void)bottomBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


//过去反馈信息配送
-(void)getFeedBackInfo{
    NSString *url = [API stringByAppendingString:@"Setshop/feedback"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"关闭反馈信息 %@", responseObject);
        
        if (responseObject != nil) {
            _feedbackArray = responseObject;
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取反馈信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
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
