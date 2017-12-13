//
//  EvaluateViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*用户评价*//

#import "EvaluateViewController.h"
#import "EvaluateTopView.h"
#import "EvaluationCell.h"
#import "EvaluationImgCell.h"
#import "replyView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "TipViewController.h"
#import "ReportViewController.h"


#define color [UIColor colorWithRed:217/255.0 green:122/255.0 blue:0 alpha:1]
#define backC [UIColor colorWithRed:217/255.0 green:122/255.0 blue:0 alpha:1]

@interface EvaluateViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    UIWindow *topWindow;
    UIView *view;
}

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) EvaluateTopView *evaluateTopView;
@property (strong, nonatomic) replyView *repalyView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (strong, nonatomic) UITableView *tableView;

@property BOOL isLoadMore;   //是否加载更多

@property BOOL isRefreshAllpinglun;    //是否是刷新
@property BOOL isRefreshNoReply;       //是否是刷新
@property BOOL isRefreshBadNoReply;    //是否是刷新
@property BOOL isReplyAll;                //是否回复
@property BOOL isReplyBad;                //是否回复
@property BOOL isReplyNo;                //是否回复

@property (strong, nonatomic) NSString *plType;    //评论类型：评论状态0全部1好评2中评3差评

@property NSInteger startRow;   //页数

@property (strong, nonatomic) NSArray *pinglun;    //显示用数组
@property (strong, nonatomic) NSMutableArray *Allpinglun;
@property (strong, nonatomic) NSMutableArray *NoReply;
@property (strong, nonatomic) NSMutableArray *BadNoReply;

@property (nonatomic, getter=isLoading)BOOL loading;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation EvaluateViewController

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
    _isLoadMore = NO;
    _isRefreshAllpinglun = YES;
    _isRefreshNoReply = YES;
    _isRefreshBadNoReply = YES;
    _isReplyNo = NO;
    _isReplyBad = NO;
    _isReplyAll = NO;
    _plType = @"0";
    _Allpinglun = [NSMutableArray array];
    _NoReply = [NSMutableArray array];
    _BadNoReply = [NSMutableArray array];
    _pinglun = [[NSArray alloc] init];
    
    //注册键盘监听事件 分别为 键盘即将显示 -- 键盘即将消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initTableView];
    [self configEvaluateView];
    [self configReplyView];
    [self addRefreshView];
    [self topWindow];

    _startRow = 0;
    //获取未回复评论
    [self postGetNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
    //获取未回复差评
    [self postGetBadNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
    //获取全部评论
//    [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
    [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
    //加载全部评论
    _pinglun = [_Allpinglun copy];
    [self.tableView reloadData];
}



-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_HEIGHT - 200) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BG_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluationCell" bundle:nil] forCellReuseIdentifier:@"EvaluationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EvaluationImgCell" bundle:nil] forCellReuseIdentifier:@"EvaluationImgCell"];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource: self];

    [self.view addSubview:self.tableView];
}


//初始化顶部视图
-(void)configEvaluateView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];   //140
    _topView.backgroundColor = [UIColor whiteColor];
    _evaluateTopView = [[EvaluateTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    
    [_evaluateTopView.segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    //默认选择全部评论
    [_evaluateTopView.segment setSelectedSegmentIndex:2];
    
    _evaluateTopView.allBtn.layer.borderWidth = 1;
    _evaluateTopView.allBtn.layer.borderColor = color.CGColor;
    _evaluateTopView.allBtn.layer.cornerRadius = 10;
    [_evaluateTopView.allBtn setTitleColor:color forState:UIControlStateNormal];
    
    _evaluateTopView.goodBtn.layer.borderWidth = 1;
    _evaluateTopView.goodBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.goodBtn.layer.cornerRadius = 10;
    [_evaluateTopView.goodBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.mediumBtn.layer.borderWidth = 1;
    _evaluateTopView.mediumBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.mediumBtn.layer.cornerRadius = 10;
    [_evaluateTopView.mediumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.badBtn.layer.borderWidth = 1;
    _evaluateTopView.badBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.badBtn.layer.cornerRadius = 10;
    [_evaluateTopView.badBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [_evaluateTopView.allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_evaluateTopView.goodBtn addTarget:self action:@selector(goodBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_evaluateTopView.mediumBtn addTarget:self action:@selector(mediumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_evaluateTopView.badBtn addTarget:self action:@selector(badBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_topView addSubview:_evaluateTopView];
    [self.view addSubview:_topView];
}

//添加回复视图
-(void)configReplyView{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 60)];
    
    _repalyView = [[replyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
    _repalyView.content.delegate = self;
    _repalyView.content.layer.borderWidth = 1;
    _repalyView.content.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_repalyView.content.layer setMasksToBounds:YES];

    [_repalyView.senderBtn addTarget:self action:@selector(senderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加textview的place属性
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _repalyView.content.frame.size.width, _repalyView.content.frame.size.height)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.numberOfLines = 0;
    _placeHolderLabel.text = @"您的回复会被公开展示，且不能修改，请注意措辞，最多300字。";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_repalyView.content addSubview:_placeHolderLabel];
    
    [view addSubview:_repalyView];
    [self.view addSubview:view];
    
}

//加载刷新视图
- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    _startRow = 0;   //下拉计数

    weakSelf.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
    
    weakSelf.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    
}

//下拉刷新
- (void)refreshAction {
//    _isRefresh = YES;
    _startRow = 0;
    
    switch (_evaluateTopView.segment.selectedSegmentIndex) {
        case 0:{
            _isRefreshBadNoReply = YES;
            [self postGetBadNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
        }
            break;
        case 1:{
            _isRefreshNoReply = YES;
            [self postGetNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
        }
            break;
        case 2:{
            _isRefreshAllpinglun = YES;
//            [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld", (long)_startRow]];
            [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

        }
            break;
            
        default:
            break;
    }
    
}

//上拉加载更多
- (void)loadMoreAction {
    _isLoadMore = YES;
    _startRow = _startRow + _pinglun.count;
    
    switch (_evaluateTopView.segment.selectedSegmentIndex) {
        case 0:{
            [self postGetBadNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
        }
            break;
        case 1:{
            [self postGetNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
        }
            break;
        case 2:{
//            [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld", (long)_startRow]];
            [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

        }
            break;
            
        default:
            break;
    }
    
}


//回到顶部
-(void)topWindow
{
    //dispath_after 延迟一定时间后处理某件事
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        topWindow = [[UIWindow alloc] init];
        topWindow.windowLevel = UIWindowLevelAlert;
        topWindow.frame = [UIApplication sharedApplication].statusBarFrame;
        topWindow.backgroundColor = [UIColor clearColor];
        topWindow.hidden = NO;
        [topWindow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowClick)]];
    });
}

//点击屏幕顶部
-(void)topWindowClick
{
    //使用这个方法可以将滚动到特定的区域，让视图可见。
    //rect的作用是定义要可见视图的区域，这个区域需要在滚动视图的坐标空间中
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
}



//选择评论分类
-(void)segmentChange{
    _startRow = 0;
    NSLog(@"%ld", (long)_evaluateTopView.segment.selectedSegmentIndex);
    switch (_evaluateTopView.segment.selectedSegmentIndex) {
        case 0:{
            _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            _evaluateTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            _tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 116);
            
            _evaluateTopView.allBtn.hidden = YES;
            _evaluateTopView.goodBtn.hidden = YES;
            _evaluateTopView.mediumBtn.hidden = YES;
            _evaluateTopView.badBtn.hidden = YES;
            _evaluateTopView.onlyLockBtn.hidden = YES;
            _evaluateTopView.textLable.hidden = YES;
            _evaluateTopView.bottomView.hidden = YES;
            
            _pinglun = [_BadNoReply copy];
            if (_pinglun.count == 0) {
                _isRefreshBadNoReply = YES;
                [self postGetBadNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
            }

            [self.tableView reloadData];
        }
            break;
        case 1:{
            _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            _evaluateTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
            _tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 116);
            
            _evaluateTopView.allBtn.hidden = YES;
            _evaluateTopView.goodBtn.hidden = YES;
            _evaluateTopView.mediumBtn.hidden = YES;
            _evaluateTopView.badBtn.hidden = YES;
            _evaluateTopView.onlyLockBtn.hidden = YES;
            _evaluateTopView.textLable.hidden = YES;
            _evaluateTopView.bottomView.hidden = YES;

            _pinglun = [_NoReply copy];
            if (_pinglun.count == 0) {
                _isRefreshNoReply = YES;
                [self postGetNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
            }
            
            [self.tableView reloadData];
        }
            break;
        case 2:{
            _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
            _evaluateTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
            _tableView.frame = CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_HEIGHT - 200);
            
            _evaluateTopView.allBtn.hidden = NO;
            _evaluateTopView.goodBtn.hidden = NO;
            _evaluateTopView.mediumBtn.hidden = NO;
            _evaluateTopView.badBtn.hidden = NO;
            _evaluateTopView.onlyLockBtn.hidden = YES;
            _evaluateTopView.textLable.hidden = YES;
            _evaluateTopView.bottomView.hidden = NO;

            _pinglun = [_Allpinglun copy];
            if (_pinglun.count == 0) {
                _isRefreshAllpinglun = YES;
//                [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld", (long)_startRow]];
                [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

            }

            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}


-(void)allBtnClick{
    _evaluateTopView.allBtn.layer.borderWidth = 1;
    _evaluateTopView.allBtn.layer.borderColor = color.CGColor;
    _evaluateTopView.allBtn.layer.cornerRadius = 10;
    [_evaluateTopView.allBtn setTitleColor:color forState:UIControlStateNormal];
    
    _evaluateTopView.goodBtn.layer.borderWidth = 1;
    _evaluateTopView.goodBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.goodBtn.layer.cornerRadius = 10;
    [_evaluateTopView.goodBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.mediumBtn.layer.borderWidth = 1;
    _evaluateTopView.mediumBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.mediumBtn.layer.cornerRadius = 10;
    [_evaluateTopView.mediumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.badBtn.layer.borderWidth = 1;
    _evaluateTopView.badBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.badBtn.layer.cornerRadius = 10;
    [_evaluateTopView.badBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _plType = @"0";
    _isRefreshAllpinglun = YES;
    [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];
}

-(void)goodBtnClick{
    _evaluateTopView.allBtn.layer.borderWidth = 1;
    _evaluateTopView.allBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.allBtn.layer.cornerRadius = 10;
    [_evaluateTopView.allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.goodBtn.layer.borderWidth = 1;
    _evaluateTopView.goodBtn.layer.borderColor = color.CGColor;
    _evaluateTopView.goodBtn.layer.cornerRadius = 10;
    [_evaluateTopView.goodBtn setTitleColor:color forState:UIControlStateNormal];
    
    _evaluateTopView.mediumBtn.layer.borderWidth = 1;
    _evaluateTopView.mediumBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.mediumBtn.layer.cornerRadius = 10;
    [_evaluateTopView.mediumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.badBtn.layer.borderWidth = 1;
    _evaluateTopView.badBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.badBtn.layer.cornerRadius = 10;
    [_evaluateTopView.badBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _plType = @"1";
    _isRefreshAllpinglun = YES;
    [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

}


-(void)mediumBtnClick{
    _evaluateTopView.allBtn.layer.borderWidth = 1;
    _evaluateTopView.allBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.allBtn.layer.cornerRadius = 10;
    [_evaluateTopView.allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.goodBtn.layer.borderWidth = 1;
    _evaluateTopView.goodBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.goodBtn.layer.cornerRadius = 10;
    [_evaluateTopView.goodBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.mediumBtn.layer.borderWidth = 1;
    _evaluateTopView.mediumBtn.layer.borderColor = color.CGColor;
    _evaluateTopView.mediumBtn.layer.cornerRadius = 10;
    [_evaluateTopView.mediumBtn setTitleColor:color forState:UIControlStateNormal];
    
    _evaluateTopView.badBtn.layer.borderWidth = 1;
    _evaluateTopView.badBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.badBtn.layer.cornerRadius = 10;
    [_evaluateTopView.badBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _plType = @"2";
    _isRefreshAllpinglun = YES;
    [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

}


-(void)badBtnClick{
    _evaluateTopView.allBtn.layer.borderWidth = 1;
    _evaluateTopView.allBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.allBtn.layer.cornerRadius = 10;
    [_evaluateTopView.allBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.goodBtn.layer.borderWidth = 1;
    _evaluateTopView.goodBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.goodBtn.layer.cornerRadius = 10;
    [_evaluateTopView.goodBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.mediumBtn.layer.borderWidth = 1;
    _evaluateTopView.mediumBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _evaluateTopView.mediumBtn.layer.cornerRadius = 10;
    [_evaluateTopView.mediumBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _evaluateTopView.badBtn.layer.borderWidth = 1;
    _evaluateTopView.badBtn.layer.borderColor = color.CGColor;
    _evaluateTopView.badBtn.layer.cornerRadius = 10;
    [_evaluateTopView.badBtn setTitleColor:color forState:UIControlStateNormal];
    
    _plType = @"3";
    _isRefreshAllpinglun = YES;
    [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

}


//点击回复按钮
-(void)replyBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    //使textView进入编辑模式
    _repalyView.content.tag = btn.tag;
    [_repalyView.content becomeFirstResponder];
    
}


//发送回复
-(void)senderBtnClick{
    if (!(_repalyView.content.text.length > 0)) {
        [Util toastWithView:self.view AndText:@"请输入回复内容"];
        return ;
    }
    [_repalyView.content resignFirstResponder];
    [self postReplyWithId:_pinglun[_repalyView.content.tag][@"id"]];
    
}


//点击举报
-(void)reportBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    TipViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"TipViewController"];
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];
    
    vc.block = ^(BOOL isReport) {
        if (isReport) {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
            ReportViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
            vc.commentId = _pinglun[btn.tag][@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
}



-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
//    CGRect currentFrame;
//    currentFrame = view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
//    currentFrame.origin.y = currentFrame.origin.y -  change - 60;
//    view.frame = currentFrame;
    view.frame = CGRectMake(0, SCREEN_HEIGHT - 64 - change - 60, SCREEN_WIDTH, 60);

}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
//    CGRect currentFrame;
//    currentFrame = view.frame;
//    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
//    currentFrame.origin.y = currentFrame.origin.y + change ;
    view.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 60);
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0 ){
        _placeHolderLabel.text = @"您的回复会被公开展示，且不能修改，请注意措辞，最多300字。";
    }
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHolderLabel.text = @"您的回复会被公开展示，且不能修改，请注意措辞，最多300字。";
    }
    else{
        _placeHolderLabel.text = @"";
    }
    
    if (textView.text.length > 300) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"最多输入300字" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:cancelAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
}



#pragma mark tablViewDelgete

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _pinglun.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = @"";
    NSString *goodslist = @"";
    NSString *shopReplyContent = @"";
    CGFloat contentHeight = 0;
    CGFloat goodslistHeight = 0;
    CGFloat shopReplyContentHeight = 0;
    CGFloat collectionViewHeight = 100;
    if (_pinglun[indexPath.row][@"content"] != nil && ![_pinglun[indexPath.row][@"content"] isKindOfClass:[NSNull class]]) {
        content = _pinglun[indexPath.row][@"content"];
        
        contentHeight = [Util countTextHeight:content] + 5;
        
    }
    else{
        content = @"";
        
        contentHeight = 0;
        
    }
    
    NSArray *goods = _pinglun[indexPath.row][@"goodslist"];
    if (goods != nil && ![goods isKindOfClass:[NSNull class]]) {
        NSString *goodsStr = @"";
        for (int i = 0; i < goods.count; i++) {
            if (i == 0) {
                goodsStr = goods[i][@"goodsName"];
            }
            else{
                goodsStr = [NSString stringWithFormat:@"%@%@%@", goodsStr, @",", goods[i][@"goodsName"]];
            }
        }
        goodslist = goodsStr;
        goodslistHeight = [Util countTextHeight:goodslist];
        
    }
    else{
        goodslist = @"";
        goodslistHeight = 0;
    }
    
    if (_pinglun[indexPath.row][@"shopReply"] != nil && ![_pinglun[indexPath.row][@"shopReply"] isKindOfClass:[NSNull class]]) {
        NSDictionary *replyDic = _pinglun[indexPath.row][@"shopReply"][0];
        if (replyDic[@"content"] != nil && ![replyDic[@"content"] isKindOfClass:[NSNull class]]) {
            shopReplyContent = replyDic[@"content"];
            shopReplyContentHeight = [Util countTextHeight:shopReplyContent];
        }
        else{
            //无回复
            shopReplyContent = @"";
            shopReplyContentHeight = -20;
        }
        
    }
    else{
        //无回复
        shopReplyContent = @"";
        shopReplyContentHeight = -20;
    }
    
    //判断是否有图片
    NSArray *imgArray = _pinglun[indexPath.row][@"appraisesAnnex"];
    
    if (imgArray.count == 0) {
        return 140 + contentHeight + goodslistHeight + shopReplyContentHeight;
    }
    else{
        //根据屏幕宽度计算collectionView高度
        collectionViewHeight = (SCREEN_WIDTH - 20 - 15)/4;
        return 130 + contentHeight + goodslistHeight + shopReplyContentHeight + collectionViewHeight;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *imgArray = _pinglun[indexPath.row][@"appraisesAnnex"];
    //区分有没有图片
    if (imgArray.count > 0) {
        //********有图片*********//
        EvaluationImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluationImgCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[EvaluationImgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EvaluationImgCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_pinglun[indexPath.row][@"userName"] != nil && ![_pinglun[indexPath.row][@"userName"] isKindOfClass:[NSNull class]]) {
            cell.userName.text = _pinglun[indexPath.row][@"userName"];
        }
        else{
            cell.userName.text = @"匿名用户";
        }
        
        if (_pinglun[indexPath.row][@"createTime"] != nil && ![_pinglun[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
            cell.createTime.text = _pinglun[indexPath.row][@"createTime"];
        }
        else{
            cell.createTime.text = @"";
        }
        
        if (_pinglun[indexPath.row][@"tasteScore"] != nil && ![_pinglun[indexPath.row][@"tasteScore"] isKindOfClass:[NSNull class]]) {
            cell.tasteScore.text = [NSString stringWithFormat:@"%@%@%@", @"口味", _pinglun[indexPath.row][@"tasteScore"], @"星"];
        }
        else{
            cell.tasteScore.text = @"口味-星";
        }
        
        if (_pinglun[indexPath.row][@"warpScore"] != nil && ![_pinglun[indexPath.row][@"warpScore"] isKindOfClass:[NSNull class]]) {
            cell.warpScore.text = [NSString stringWithFormat:@"%@%@%@", @"包装", _pinglun[indexPath.row][@"warpScore"], @"星"];
        }
        else{
            cell.warpScore.text = @"包装-星";
        }
        
        if (_pinglun[indexPath.row][@"timeScore"] != nil && ![_pinglun[indexPath.row][@"timeScore"] isKindOfClass:[NSNull class]]) {
            cell.timeScore.text = [NSString stringWithFormat:@"%@%@%@", @"配送", _pinglun[indexPath.row][@"timeScore"], @"星"];
        }
        else{
            cell.timeScore.text = @"配送-星";
        }
        
        if (_pinglun[indexPath.row][@"avg"] != nil && ![_pinglun[indexPath.row][@"avg"] isKindOfClass:[NSNull class]]) {
            int avg = [_pinglun[indexPath.row][@"avg"] intValue];
            switch (avg) {
                case 0:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"差评";

                }
                    break;
                case 1:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"差评";

                }
                    break;
                case 2:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"中评";

                }
                    break;
                case 3:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"中评";

                }
                    break;
                case 4:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"中评";

                }
                    break;
                case 5:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-1"];
                    cell.avg.text = @"好评";

                }
                    break;
                    
                    
                    
                default:
                    break;
            }
        }
        else{
            
        }

        
        if (_pinglun[indexPath.row][@"content"] != nil && ![_pinglun[indexPath.row][@"content"] isKindOfClass:[NSNull class]]) {
            cell.content.text = _pinglun[indexPath.row][@"content"];
            //计算高度
            cell.contentHeight.constant = [Util countTextHeight:cell.content.text];
            
        }
        else{
            cell.content.text = @"";
            cell.contentHeight.constant = 0;
        }
        
        //食物列表
        NSArray *goodslist = _pinglun[indexPath.row][@"goodslist"];
        if (goodslist != nil && ![goodslist isKindOfClass:[NSNull class]]) {
            NSString *goodsStr = @"";
            for (int i = 0; i < goodslist.count; i++) {
                if (i == 0) {
                    goodsStr = goodslist[i][@"goodsName"];
                }
                else{
                    goodsStr = [NSString stringWithFormat:@"%@%@%@", goodsStr, @",", goodslist[i][@"goodsName"]];
                }
            }
            cell.goodslist.text = goodsStr;
            cell.goodslistHeight.constant = [Util countTextHeight:cell.goodslist.text];
        }
        else{
            cell.goodslist.text = @"";
            cell.goodslistHeight.constant = 0;
        }
        
        //商家回复内容
        NSLog(@"%@", _pinglun[indexPath.row][@"shopReply"]);
        if (_pinglun[indexPath.row][@"shopReply"] != nil && ![_pinglun[indexPath.row][@"shopReply"] isKindOfClass:[NSNull class]]) {
            NSDictionary *replyDic = _pinglun[indexPath.row][@"shopReply"][0];
            if (replyDic[@"content"] != nil && ![replyDic[@"content"] isKindOfClass:[NSNull class]]) {
                cell.shopReplyContent.text = replyDic[@"content"];
                cell.shopReplyContentHeight.constant = [Util countTextHeight:cell.shopReplyContent.text];
                cell.ReplyBViewHeight.constant = cell.shopReplyContentHeight.constant + 20;
                cell.replyView.hidden = NO;
                cell.replyBtn.hidden = YES;
            }
            else{
                //无回复
                cell.shopReplyContent.text = @"";
                cell.shopReplyContentHeight.constant = 0;
                cell.ReplyBViewHeight.constant = 0;
                cell.replyView.hidden = YES;
                cell.replyBtn.hidden = NO;
            }
            
            if (replyDic[@"days"] != nil && ![replyDic[@"days"] isKindOfClass:[NSNull class]]) {
                if ([[NSString stringWithFormat:@"%@", replyDic[@"days"]] isEqual:@"0"]) {
                    cell.days.text = @"当天";
                }
                else{
                    cell.days.text = [NSString stringWithFormat:@"%@%@", replyDic[@"days"], @"天后"];
                }
            }
            else{
                cell.days.text = @"当天";
            }
        }
        else{
            //无回复
            cell.shopReplyContent.text = @"";
            cell.days.text = @"当天";
            cell.shopReplyContent.text = @"";
            cell.shopReplyContentHeight.constant = 0;
            cell.ReplyBViewHeight.constant = 0;
            cell.replyView.hidden = YES;
            cell.replyBtn.hidden = NO;
        }

        
        //加载图片
        cell.imageArray = [imgArray mutableCopy];
        [cell.colectionView reloadData];
        cell.collectionViewHeight.constant = (cell.colectionView.frame.size.width - 15)/4;
        
        
        //设置回复按钮
        cell.replyBtn.tag = indexPath.row;
        [cell.replyBtn addTarget:self action:@selector(replyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        //设置举报按钮
        cell.reportBtn.tag = indexPath.row;
        [cell.reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    else{
        //********无图片*********//
        EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluationCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[EvaluationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EvaluationCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_pinglun[indexPath.row][@"userName"] != nil && ![_pinglun[indexPath.row][@"userName"] isKindOfClass:[NSNull class]]) {
            cell.userName.text = _pinglun[indexPath.row][@"userName"];
        }
        else{
            cell.userName.text = @"匿名用户";
        }
        
        if (_pinglun[indexPath.row][@"createTime"] != nil && ![_pinglun[indexPath.row][@"createTime"] isKindOfClass:[NSNull class]]) {
            cell.createTime.text = _pinglun[indexPath.row][@"createTime"];
        }
        else{
            cell.createTime.text = @"";
        }
        
        if (_pinglun[indexPath.row][@"tasteScore"] != nil && ![_pinglun[indexPath.row][@"tasteScore"] isKindOfClass:[NSNull class]]) {
            cell.tasteScore.text = [NSString stringWithFormat:@"%@%@%@", @"口味", _pinglun[indexPath.row][@"tasteScore"], @"星"];
        }
        else{
            cell.tasteScore.text = @"口味-星";
        }
        
        if (_pinglun[indexPath.row][@"warpScore"] != nil && ![_pinglun[indexPath.row][@"warpScore"] isKindOfClass:[NSNull class]]) {
            cell.warpScore.text = [NSString stringWithFormat:@"%@%@%@", @"包装", _pinglun[indexPath.row][@"warpScore"], @"星"];
        }
        else{
            cell.warpScore.text = @"包装-星";
        }
        
        if (_pinglun[indexPath.row][@"timeScore"] != nil && ![_pinglun[indexPath.row][@"timeScore"] isKindOfClass:[NSNull class]]) {
            cell.timeScore.text = [NSString stringWithFormat:@"%@%@%@", @"配送", _pinglun[indexPath.row][@"timeScore"], @"星"];
        }
        else{
            cell.timeScore.text = @"配送-星";
        }
        
        if (_pinglun[indexPath.row][@"avg"] != nil && ![_pinglun[indexPath.row][@"avg"] isKindOfClass:[NSNull class]]) {
            int avg = [_pinglun[indexPath.row][@"avg"] intValue];
            switch (avg) {
                case 0:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"差评";
                }
                    break;
                case 1:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"差评";

                }
                    break;
                case 2:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"中评";

                }
                    break;
                case 3:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-0"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"中评";

                }
                    break;
                case 4:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-0"];
                    cell.avg.text = @"中评";

                }
                    break;
                case 5:{
                    cell.xin0.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin1.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin2.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin3.image = [UIImage imageNamed:@"星号-1"];
                    cell.xin4.image = [UIImage imageNamed:@"星号-1"];
                    cell.avg.text = @"好评";

                }
                    break;


                    
                default:
                    break;
            }
        }
        else{
            
        }
        
        if (_pinglun[indexPath.row][@"content"] != nil && ![_pinglun[indexPath.row][@"content"] isKindOfClass:[NSNull class]]) {
            cell.content.text = _pinglun[indexPath.row][@"content"];
            //计算高度
            cell.contentHeight.constant = [Util countTextHeight:cell.content.text];

        }
        else{
            cell.content.text = @"";
            cell.contentHeight.constant = 0;
        }
        
        //食物列表
        NSArray *goodslist = _pinglun[indexPath.row][@"goodslist"];
        if (goodslist != nil && ![goodslist isKindOfClass:[NSNull class]]) {
            NSString *goodsStr = @"";
            for (int i = 0; i < goodslist.count; i++) {
                if (i == 0) {
                    goodsStr = goodslist[i][@"goodsName"];
                }
                else{
                    goodsStr = [NSString stringWithFormat:@"%@%@%@", goodsStr, @",", goodslist[i][@"goodsName"]];
                }
            }
            cell.goodslist.text = goodsStr;
            cell.goodslistHeight.constant = [Util countTextHeight:cell.goodslist.text];
        }
        else{
            cell.goodslist.text = @"";
            cell.goodslistHeight.constant = 0;
        }
        
        //商家回复内容
        NSLog(@"%@", _pinglun[indexPath.row][@"shopReply"]);
        if (_pinglun[indexPath.row][@"shopReply"] != nil && ![_pinglun[indexPath.row][@"shopReply"] isKindOfClass:[NSNull class]]) {
            NSDictionary *replyDic = _pinglun[indexPath.row][@"shopReply"][0];
            if (replyDic[@"content"] != nil && ![replyDic[@"content"] isKindOfClass:[NSNull class]]) {
                cell.shopReplyContent.text = replyDic[@"content"];
                cell.shopReplyContentHeight.constant = [Util countTextHeight:cell.shopReplyContent.text];
                cell.ReplyBViewHeight.constant = cell.shopReplyContentHeight.constant + 20;
                cell.replyView.hidden = NO;
                cell.replyBtn.hidden = YES;
            }
            else{
                //无回复
                cell.shopReplyContent.text = @"";
                cell.shopReplyContentHeight.constant = 0;
                cell.ReplyBViewHeight.constant = 0;
                cell.replyView.hidden = YES;
                cell.replyBtn.hidden = NO;
            }
            
            if (replyDic[@"days"] != nil && ![replyDic[@"days"] isKindOfClass:[NSNull class]]) {
                if ([[NSString stringWithFormat:@"%@", replyDic[@"days"]] isEqual:@"0"]) {
                    cell.days.text = @"当天";
                }
                else{
//                    NSString *timeStr = [NSString stringWithFormat:@"%@", ];
                    cell.days.text = [NSString stringWithFormat:@"%d%@", abs([replyDic[@"days"] intValue]), @"天后"];
                }
            }
            else{
                cell.days.text = @"当天";
            }
        }
        else{
            //无回复
            cell.shopReplyContent.text = @"";
            cell.days.text = @"当天";
            cell.shopReplyContent.text = @"";
            cell.shopReplyContentHeight.constant = 0;
            cell.ReplyBViewHeight.constant = 0;
            cell.replyView.hidden = YES;
            cell.replyBtn.hidden = NO;
        }

        //设置回复按钮
        cell.replyBtn.tag = indexPath.row;
        [cell.replyBtn addTarget:self action:@selector(replyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        //设置举报按钮
        cell.reportBtn.tag = indexPath.row;
        [cell.reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    
    
 
}



#pragma mark 接口

//获取全部评论数
-(void)postGetAllShopUserPlWith:(NSString *)pageNum addTpye:(NSString *)plType{
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Setshop/shopUserPl"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"page":pageNum, @"plType":plType};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_hud hideAnimated:YES];

        self.loading = NO;

        NSLog(@"获取全部评论 %@", responseObject);
        if (responseObject != nil) {
            //设置各数量
            if (responseObject[@"noReplyBad"] != nil && ![responseObject[@"noReplyBad"] isKindOfClass:[NSNull class]]) {
                [_evaluateTopView.segment setTitle:[NSString stringWithFormat:@"%@%@%@", @"未回复差评(", responseObject[@"noReplyBad"], @")"] forSegmentAtIndex:0];
            }
            else{
                [_evaluateTopView.segment setTitle:@"未回复差评(0)" forSegmentAtIndex:0];
            }
            if (responseObject[@"noReply"] != nil && ![responseObject[@"noReply"] isKindOfClass:[NSNull class]]) {
                [_evaluateTopView.segment setTitle:[NSString stringWithFormat:@"%@%@%@", @"未回复(", responseObject[@"noReply"], @")"] forSegmentAtIndex:1];
            }
            else{
                [_evaluateTopView.segment setTitle:@"未回复(0)" forSegmentAtIndex:1];
            }
            
            [_evaluateTopView.segment setTitle:@"全部" forSegmentAtIndex:2];

            if (responseObject[@"allcount"] != nil && ![responseObject[@"allcount"] isKindOfClass:[NSNull class]]) {
                [_evaluateTopView.allBtn setTitle:[NSString stringWithFormat:@"%@%@%@", @" 全部(", responseObject[@"allcount"], @") "] forState:UIControlStateNormal];
            }
            else{
                [_evaluateTopView.allBtn setTitle:@" 全部(0) " forState:UIControlStateNormal];
            }

            if (responseObject[@"goods"] != nil && ![responseObject[@"goods"] isKindOfClass:[NSNull class]]) {
                [_evaluateTopView.goodBtn setTitle:[NSString stringWithFormat:@"%@%@%@", @" 好评(", responseObject[@"goods"], @") "] forState:UIControlStateNormal];
            }
            else{
                [_evaluateTopView.goodBtn setTitle:@" 好评(0) " forState:UIControlStateNormal];
            }
            
            if (responseObject[@"assessment"] != nil && ![responseObject[@"assessment"] isKindOfClass:[NSNull class]]) {
                [_evaluateTopView.mediumBtn setTitle:[NSString stringWithFormat:@"%@%@%@", @" 中评(", responseObject[@"assessment"], @") "] forState:UIControlStateNormal];
            }
            else{
                [_evaluateTopView.mediumBtn setTitle:@" 中评(0) " forState:UIControlStateNormal];
            }
            
            if (responseObject[@"bad"] != nil && ![responseObject[@"bad"] isKindOfClass:[NSNull class]]) {
                [_evaluateTopView.badBtn setTitle:[NSString stringWithFormat:@"%@%@%@", @" 差评(", responseObject[@"bad"], @") "] forState:UIControlStateNormal];
            }
            else{
                [_evaluateTopView.badBtn setTitle:@" 差评(0) " forState:UIControlStateNormal];
            }

            //刷新
            if (_isRefreshAllpinglun) {
                _isRefreshAllpinglun = NO;
                [self.tableView.header endRefreshing];
                [_Allpinglun removeAllObjects];
                //评论内容
                _pinglun = responseObject[@"pinglun"];
//                _Allpinglun = [responseObject[@"pinglun"] mutableCopy];
                [_Allpinglun addObjectsFromArray:responseObject[@"pinglun"]];
                
                [self.tableView reloadData];
            }
            
            //加载更多
            if (_isLoadMore) {
                _isLoadMore = NO;
                NSArray *temp = responseObject[@"pinglun"];
                //判断是否还有评论
                if (temp.count > 0) {
                    [_Allpinglun addObjectsFromArray:[temp mutableCopy]];
                    [self.tableView.footer endRefreshing];

                }
                else{
                    [self.tableView.footer endRefreshing];
                    [Util toastWithView:self.view AndText:@"已经全部加载完毕"];
                }
                _pinglun = [_Allpinglun copy];
                [self.tableView reloadData];

            }
            else{
                
            }
            
            
            //是否是回复
            if (_isReplyBad || _isReplyNo) {
                _isReplyNo = NO;
                _isReplyBad = NO;
                [_Allpinglun removeAllObjects];
                [_Allpinglun addObjectsFromArray:responseObject[@"pinglun"]];
            }
            
            if (_isReplyAll) {
                _isReplyAll = NO;
                [_Allpinglun removeAllObjects];
                [_Allpinglun addObjectsFromArray:responseObject[@"pinglun"]];
                _pinglun = [_Allpinglun copy];
                [self.tableView reloadData];
            }
            
        }
        else{
            [Util toastWithView:self.view AndText:@"获取全部评论失败"];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取全部评论失败 %@", error);
        self.loading = NO;
        [_hud hideAnimated:YES];

        [self.tableView.header endRefreshing];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}



//查看未回复评论
-(void)postGetNoReplyWith:(NSString *)pageNum{
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Setshop/getNoReply"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"page":pageNum};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loading = NO;
        [_hud hideAnimated:YES];

        NSLog(@"获取未回复评论 %@", responseObject);
        if (responseObject != nil) {

            //刷新
            if (_isRefreshNoReply) {
                _isRefreshNoReply = NO;
                [self.tableView.header endRefreshing];
                [_NoReply removeAllObjects];
                //评论内容
                [_NoReply addObjectsFromArray:responseObject];
                _pinglun = [_NoReply copy];
                [self.tableView reloadData];
            }
            
            //加载更多
            if (_isLoadMore) {
                _isLoadMore = NO;
                NSArray *temp = responseObject;
                //判断是否还有评论
                if (temp.count > 0) {
                    [_NoReply addObjectsFromArray:[temp mutableCopy]];
                    [self.tableView.footer endRefreshing];
                    
                }
                else{
                    [self.tableView.footer endRefreshing];
                    [Util toastWithView:self.view AndText:@"已经全部加载完毕"];
                }
                _pinglun = [_NoReply copy];
                [self.tableView reloadData];
                
            }
            else{
                
            }

        }
        else{
            [Util toastWithView:self.view AndText:@"获取未回复评论失败"];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取未回复评论失败 %@", error);
        self.loading = NO;
        [_hud hideAnimated:YES];

        [self.tableView.header endRefreshing];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}



//查看未回复差评
-(void)postGetBadNoReplyWith:(NSString *)pageNum{
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Setshop/getNoReply"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"page":pageNum, @"bad":@"1"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.loading = NO;
        [_hud hideAnimated:YES];

        NSLog(@"获取未回复差评 %@", responseObject);
        if (responseObject != nil) {
            //刷新
            if (_isRefreshBadNoReply) {
                _isRefreshBadNoReply = NO;
                [self.tableView.header endRefreshing];
                [_NoReply removeAllObjects];
                //评论内容
//                _pinglun = responseObject;
//                _BadNoReply = [responseObject mutableCopy];
                [_BadNoReply addObjectsFromArray:responseObject];
                _pinglun = [_BadNoReply copy];
                [self.tableView reloadData];
            }
            
            //加载更多
            if (_isLoadMore) {
                _isLoadMore = NO;
                NSArray *temp = responseObject;
                //判断是否还有评论
                if (temp.count > 0) {
                    [_BadNoReply addObjectsFromArray:[temp mutableCopy]];
                    [self.tableView.footer endRefreshing];
                    
                }
                else{
                    [self.tableView.footer endRefreshing];
                    [Util toastWithView:self.view AndText:@"已经全部加载完毕"];
                }
                _pinglun = [_BadNoReply copy];
                [self.tableView reloadData];
                
            }
            else{
                
            }
            
        }
        else{
            [Util toastWithView:self.view AndText:@"获取未回复差评失败"];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取未回复差评失败 %@", error);
        self.loading = NO;
        [_hud hideAnimated:YES];

        [self.tableView.header endRefreshing];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}



//回复评论
-(void)postReplyWithId:(NSString *)pinglunId{
    NSString *url = [API_ReImg stringByAppendingString:@"Setshop/comments"];
    NSDictionary *dic = @{@"content":_repalyView.content.text, @"id":pinglunId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"回复评论 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.view AndText:@"回复成功"];
                
                //处理数据源
                switch (_evaluateTopView.segment.selectedSegmentIndex) {
                    case 0:{
                        [_BadNoReply removeObjectAtIndex:_repalyView.content.tag];
                        _pinglun = [_BadNoReply copy];
                        [self.tableView reloadData];
                        
                        _isReplyBad = YES;
//                        [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld", (long)_startRow]];
                        [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

                    }
                        break;
                    case 1:{
                        [_NoReply removeObjectAtIndex:_repalyView.content.tag];
                        _pinglun = [_NoReply copy];
                        [self.tableView reloadData];

                        _isReplyNo = YES;
//                        [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld", (long)_startRow]];
                        [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

                    }
                        break;
                    case 2:{
//                        [_Allpinglun removeObjectAtIndex:_repalyView.content.tag];
//                        _pinglun = [_Allpinglun copy];
//                        [self.tableView reloadData];

                        _isReplyAll = YES;
//                        [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld", (long)_startRow]];
                        [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];

                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }
            else{
                [Util toastWithView:self.view AndText:@"回复失败"];
            }
            
        }
        else{
            [Util toastWithView:self.view AndText:@"回复失败"];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"未回复失败 %@", error);
        [self.tableView.header endRefreshing];
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}

#pragma mark - 无数据处理
//上标题（返回标题）
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无评论";
    UIFont *font = [UIFont systemFontOfSize:17];
    UIColor *Color = [UIColor lightGrayColor];
    NSMutableDictionary *attribult = [NSMutableDictionary new];
    [attribult setObject:font forKey:NSFontAttributeName];
    [attribult setObject:Color forKey:NSForegroundColorAttributeName];
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
        return [UIImage imageNamed:@"暂无评论"];
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
//            self.loading = NO;
    //    });
    
    _startRow = 0;
    
    switch (_evaluateTopView.segment.selectedSegmentIndex) {
        case 0:{
            _isRefreshBadNoReply = YES;
            [self postGetBadNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
        }
            break;
        case 1:{
            _isRefreshNoReply = YES;
            [self postGetNoReplyWith:[NSString stringWithFormat:@"%ld",(long)_startRow]];
        }
            break;
        case 2:{
            _isRefreshAllpinglun = YES;
//            [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld", (long)_startRow]];
            [self postGetAllShopUserPlWith:[NSString stringWithFormat:@"%ld",(long)_startRow] addTpye:_plType];
        }
            break;
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
