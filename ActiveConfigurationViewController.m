//
//  ActiveConfigurationViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/7.
//  Copyright © 2017年 Mac. All rights reserved.
//


//*活动配置*//

#import "ActiveConfigurationViewController.h"
#import "newActiveTableViewCell.h"
#import "inProgreTableVC.h"
#import "EndActiveTableVC.h"
#import "AgreementViewController.h"
#import "ReductionActiveViewController.h"
#import "DiscountViewController.h"
#import "BargainingViewController.h"
#import "GroupActivityViewController.h"
#import "SecondKillViewController.h"


@interface ActiveConfigurationViewController ()<UITableViewDataSource, UITableViewDelegate>{
    BOOL isagree;
}

@property (strong, nonatomic) UIButton *NewCreateBtn;    //新建活动按钮
@property (strong, nonatomic) UIButton *CreatedBtn;      //已创建活动

@property (strong, nonatomic) UITableView *ActiveTView;
@property (strong, nonatomic) UITableView *OldActiveTView;

@property (strong, nonatomic) NSArray *ActiveName;
@property (strong, nonatomic) NSArray *ActiveTitle;
@property (strong, nonatomic) NSArray *ActiveSub;

@property (strong, nonatomic) UIButton *inProgressBtn;
@property (strong, nonatomic) UIButton *endActiveBtn;

@property (strong, nonatomic) inProgreTableVC *inVC;
@property (strong, nonatomic) EndActiveTableVC *endVC;

@property (strong, nonatomic) NSMutableDictionary *inActiveList;
@property (strong, nonatomic) NSMutableDictionary *endActiveList;

@property (strong, nonatomic) MBProgressHUD *hud;

//@property BOOL btnClick;    //判断是否点击按钮

@end

@implementation ActiveConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"阿凡提商家";
    self.view.backgroundColor = [UIColor whiteColor];
    isagree = NO;
    _inActiveList = [[NSMutableDictionary alloc] init];
    _endActiveList = [[NSMutableDictionary alloc] init];
    
    [self setSourceData];
    [self initTopView];
    
//    [self.ActiveTView registerNib:[UINib nibWithNibName:@"newActiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"newActiveTableViewCell"];
    
    self.ActiveTView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.OldActiveTView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopActivity) name:@"getShopActivity" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopEndActivity) name:@"getShopEndActivity" object:nil];

    //获取已创建活动列表
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self getShopActivity];
    [self getShopEndActivity];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getShopActivity" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getShopEndActivity" object:nil];

}

#pragma mark - intView 初始化视图

//初始化数据源
-(void)setSourceData{
    _ActiveTitle = [[NSArray alloc] init];
    _ActiveTitle = @[@"减", @"折", @"领", @"新", @"团", @"砍", @"秒"];
    _ActiveName = [[NSArray alloc] init];
    _ActiveName = @[@"减满活动", @"折扣活动", @"商家优惠券", @"新客立减", @"团购活动", @"砍价活动", @"秒杀活动"];
    _ActiveSub = [[NSArray alloc] init];
    _ActiveSub = @[@"引流&促销", @"推新品&打造爆款", @"引流&拉新", @"拉新", @"引流", @"引流&拉新", @"推新品&打造爆款"];
}

//初始化顶部按钮视图
-(void)initTopView{
    _NewCreateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    [_NewCreateBtn setTitle:@"新建活动" forState:UIControlStateNormal];
    [_NewCreateBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_NewCreateBtn addTarget:self action:@selector(newCreateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _NewCreateBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
//    [_NewCreateBtn setBackgroundColor:[UIColor greenColor]];

    _CreatedBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    [_CreatedBtn setTitle:@"已创建活动" forState:UIControlStateNormal];
    [_CreatedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_CreatedBtn addTarget:self action:@selector(createdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _CreatedBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];

    UILabel *centerLable = [[UILabel alloc] init];
    centerLable.frame = CGRectMake(SCREEN_WIDTH/2, 10, 0.5, 30);
    centerLable.backgroundColor = [UIColor grayColor];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 10)];
    bottomView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    
    _ActiveTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    _ActiveTView.delegate = self;
    _ActiveTView.dataSource = self;

    [self.view addSubview:_NewCreateBtn];
    [self.view addSubview:_CreatedBtn];
    [self.view addSubview:centerLable];
    [self.view addSubview:bottomView];
    [self.view addSubview:_ActiveTView];
    
}

//点击创建新活动
-(void)newCreateBtnClick{
//    NSLog(@"创建新活动");
    [_NewCreateBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_CreatedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_ActiveTView removeFromSuperview];
    [_OldActiveTView removeFromSuperview];
    _ActiveTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    _ActiveTView.delegate = self;
    _ActiveTView.dataSource = self;
    self.ActiveTView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_ActiveTView];
}

//点击已创建活动
-(void)createdBtnClick{
//    NSLog(@"已创建活动");
    [_NewCreateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_CreatedBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_ActiveTView removeFromSuperview];
    [_OldActiveTView removeFromSuperview];
    _OldActiveTView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    _OldActiveTView.delegate = self;
    _OldActiveTView.dataSource = self;
    _OldActiveTView.backgroundColor = [UIColor whiteColor];
    self.OldActiveTView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _OldActiveTView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    [self initOldActiveBtn];
    [self.view addSubview:_OldActiveTView];

    //传入数据
    _inVC.activeList = _inActiveList;
    [_inVC.tableView reloadData];
    _endVC.activeList = _endActiveList;
}

//初始化已创建视图上的按钮
-(void)initOldActiveBtn{
    UIView *TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    TopView.backgroundColor = [UIColor whiteColor];
    
    _inProgressBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH/2, 50)];
    _inProgressBtn.backgroundColor = NAV_COLOR;
    [_inProgressBtn setTitle:@"进行中" forState:UIControlStateNormal];
    [_inProgressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _inProgressBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [_inProgressBtn addTarget:self action:@selector(inProgressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_inProgressBtn.layer setBorderColor:NAV_COLOR.CGColor];
    [_inProgressBtn.layer setBorderWidth:1.0];
    
    _endActiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2 - 20, 50)];
    _endActiveBtn.backgroundColor = [UIColor whiteColor];
    [_endActiveBtn setTitle:@"已结束" forState:UIControlStateNormal];
    [_endActiveBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    _endActiveBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [_endActiveBtn addTarget:self action:@selector(endActiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_endActiveBtn.layer setBorderColor:NAV_COLOR.CGColor];
    [_endActiveBtn.layer setBorderWidth:0.5];
    
    [TopView addSubview:_inProgressBtn];
    [TopView addSubview:_endActiveBtn];
//    _OldActiveTView.tableHeaderView = TopView;
    //禁用滚动，解决有时候两层tableview滚动卡视图的问题
    _OldActiveTView.scrollEnabled = NO;
    [_OldActiveTView addSubview:TopView];
    
    //初始化两个进行中活动和结束活动的tableview
    _inVC = [[inProgreTableVC alloc] init];
    _inVC.view.frame = CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT - 180);
    _inVC.activeList = [[NSMutableDictionary alloc] init];
    _endVC = [[EndActiveTableVC alloc] init];
    _endVC.view.frame = CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT - 180);
    _endVC.activeList = [[NSMutableDictionary alloc] init];

    //初始化视图
    [self inProgressBtnClick];
    
    _inProgressBtn.backgroundColor = NAV_COLOR;
    _endActiveBtn.backgroundColor = [UIColor whiteColor];
    [_inProgressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_endActiveBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];

}


//点击进行中按钮
-(void)inProgressBtnClick{
    [_inVC.tableView reloadData];
    _inProgressBtn.backgroundColor = NAV_COLOR;
    _endActiveBtn.backgroundColor = [UIColor whiteColor];
    [_inProgressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_endActiveBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    
    [_inVC.view removeFromSuperview];
    [_endVC.view removeFromSuperview];
    [self.OldActiveTView addSubview:_inVC.view];
}

//点击已结束按钮
-(void)endActiveBtnClick{
    [_endVC.tableView reloadData];
    _inProgressBtn.backgroundColor = [UIColor whiteColor];
    _endActiveBtn.backgroundColor = NAV_COLOR;
    [_inProgressBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [_endActiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_inVC.view removeFromSuperview];
    [_endVC.view removeFromSuperview];
    [self.OldActiveTView addSubview:_endVC.view];
    
}

#pragma mark - tableviewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (tableView == _OldActiveTView) {
//        return 50;
//    }
//    else
//        return 0;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.ActiveTView) {
        if (SCREEN_WIDTH <= 375) {
            return 80;
        }
        else{
            return 0;
        }
    }
    else{
        return 0;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.ActiveTView) {
        return 80;
    }
    else{
        return 40;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.ActiveTView) {
        return 7;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    UITableViewCell *cell = [_ActiveTView dequeueReusableCellWithIdentifier:str];
    
    //判断选择显示哪个uitableview
    if (tableView == self.ActiveTView) {
        [self.ActiveTView registerNib:[UINib nibWithNibName:@"newActiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"newActiveTableViewCell"];

        newActiveTableViewCell *cell = [self.ActiveTView dequeueReusableCellWithIdentifier:@"newActiveTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[newActiveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newActiveTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = _ActiveTitle[indexPath.row];
        cell.name.text = _ActiveName[indexPath.row];
        cell.sub.text = _ActiveSub[indexPath.row];
        cell.createBtn.tag = indexPath.row;
        [cell.createBtn addTarget:self action:@selector(createClick:) forControlEvents:UIControlEventTouchUpInside];
        //设置颜色
        switch (indexPath.row) {
            case 0:
                cell.title.backgroundColor = [UIColor colorWithRed:253/255.0 green:66/255.0 blue:70/255.0 alpha:1];
                break;
            case 1:
                cell.title.backgroundColor = [UIColor colorWithRed:234/255.0 green:211/255.0 blue:46/255.0 alpha:1];

                break;
            case 2:
                cell.title.backgroundColor = [UIColor colorWithRed:168/255.0 green:25/255.0 blue:95/255.0 alpha:1];
                break;
                
            case 3:
                cell.title.backgroundColor = [UIColor colorWithRed:111/255.0 green:138/255.0 blue:66/255.0 alpha:1];
                break;
            case 4:
                cell.title.backgroundColor = [UIColor colorWithRed:41/255.0 green:147/255.0 blue:251/255.0 alpha:1];
                break;
                
            case 5:
                cell.title.backgroundColor = [UIColor colorWithRed:234/255.0 green:211/255.0 blue:46/255.0 alpha:1];
                
                break;
            case 6:
                cell.title.backgroundColor = [UIColor colorWithRed:113/255.0 green:103/255.0 blue:207/255.0 alpha:1];
                
                break;


            default:
                break;
        }
        
        return cell;

    }
//    else if(tableView == self.OldActiveTView){
//        UITableViewCell *cell = [_ActiveTView dequeueReusableCellWithIdentifier:str];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:str];
//            
//        }
//        return cell;
//    }
    
    return cell;
}

//点击创建按钮
-(void)createClick:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"尚未签约商家自营销协议，无法创建活动" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去签约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
        AgreementViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"agreement"];
        vc.block = ^(BOOL isAgree) {
            isagree = isAgree;
            [self creatActiveViewWithIsAgree:isagree addTag:btn.tag];
        };
//        [self.navigationController pushViewController:vc animated:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//创建活动页
-(void)creatActiveViewWithIsAgree:(BOOL)isAgree addTag:(NSInteger)tag{
    if (isAgree) {
        UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
        switch (tag) {
            case 0:{
                ReductionActiveViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"active00"];
                vc.tag = tag;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:{
                //折扣商品活动
                DiscountViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"Discount"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{
                ReductionActiveViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"active02"];
                vc.tag = tag;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 3:{
                ReductionActiveViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"active03"];
                vc.tag = tag;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 4:{
                GroupActivityViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"GroupActivity"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 5:{
                BargainingViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"Bargaining"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 6:{
                SecondKillViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"SecondKill"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }
}


//获取正在进行中的活动列表
-(void)getShopActivity{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        return ;
    }
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"AdminShop/getShopActivity"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取已创建的活动 %@", responseObject);
        [_hud hideAnimated:YES];
        if (responseObject != nil) {
            [_inActiveList setValue:responseObject[@"coupon"] forKey:@"coupon"];
            [_inActiveList setValue:responseObject[@"bargain"] forKey:@"bargain"];
            [_inActiveList setValue:responseObject[@"seckill"] forKey:@"seckill"];

            [_inActiveList setValue:responseObject[@"mj"] forKey:@"mj"];
            [_inActiveList setValue:responseObject[@"newCou"] forKey:@"newCou"];
            [_inActiveList setValue:responseObject[@"tk"] forKey:@"tk"];
            [_inActiveList setValue:responseObject[@"zk"] forKey:@"zk"];

            [_inVC.tableView reloadData];
        }
        else{
//            [Util toastWithView:self.navigationController.view AndText:@"获取已创建的活动失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取已创建的活动失败 %@", error);
        [_hud hideAnimated:YES];

        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//获取已结束的活动列表
-(void)getShopEndActivity{
    if ([AppDelegate APP].user.shopId == nil) {
        [Util toastWithView:self.navigationController.view AndText:@"登录失效 请重新登录"];
        return ;
    }
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [API stringByAppendingString:@"Setshop/datedActivity"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取已结束的活动 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [_endActiveList setValue:responseObject[@"datedActivity"][@"kj"] forKey:@"kj"];
                [_endActiveList setValue:responseObject[@"datedActivity"][@"ms"] forKey:@"ms"];
                [_endActiveList setValue:responseObject[@"datedActivity"][@"tg"] forKey:@"tg"];
                [_endActiveList setValue:responseObject[@"datedActivity"][@"yjq"] forKey:@"yjq"];
                [_endActiveList setValue:responseObject[@"datedActivity"][@"zk"] forKey:@"zk"];
            }
            else{
                
            }
            [_endVC.tableView reloadData];
        }
        else{
//            [Util toastWithView:self.navigationController.view AndText:@"获取已创建的活动失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取已结束的活动失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
