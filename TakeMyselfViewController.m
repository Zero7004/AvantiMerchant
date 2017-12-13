//
//  TakeMyselfViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/12.
//  Copyright © 2017年 Mac. All rights reserved.
//

///*到店自取*///

#import "TakeMyselfViewController.h"
#import "SelectTimeViewController.h"

@interface TakeMyselfViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;    //图片背景View

@property (weak, nonatomic) IBOutlet UISwitch *isTostore;
@property (strong, nonatomic) UIButton *backBtn;

@end

@implementation TakeMyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.bounds = CGRectMake(0, 0, 40, 40);
    _backBtn.imageView.contentMode = UIViewContentModeLeft;
    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = backBtn;

    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"查看协议" style:UIBarButtonItemStyleDone target:self action:@selector(pressRight)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = _imageBgView.frame;
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(_imageBgView.frame.size.width * 2, _imageBgView.frame.size.height - 50);
    
    UIImageView *view01 = [[UIImageView alloc] init];
    view01.image = [UIImage imageNamed:@"到店自取01"];
    view01.contentMode = UIViewContentModeScaleAspectFit;
    if (SCREEN_WIDTH == 320) {
        view01.frame = CGRectMake(-10, 0, _imageBgView.frame.size.width - 50,_imageBgView.frame.size.height - 50);
    }
    else if (SCREEN_WIDTH == 375){
        view01.frame = CGRectMake(5, 0, _imageBgView.frame.size.width - 50,_imageBgView.frame.size.height - 50);
    }
    else{
        view01.frame = CGRectMake(10, 0, _imageBgView.frame.size.width, _imageBgView.frame.size.height - 50);
    }
    [scrollView addSubview:view01];
    UIImageView *view02 = [[UIImageView alloc] init];
    view02.image = [UIImage imageNamed:@"到店自取02"];
    view02.contentMode = UIViewContentModeScaleAspectFit;
    if (SCREEN_WIDTH == 320) {
        view02.frame = CGRectMake(_imageBgView.frame.size.width - 30, 0, _imageBgView.frame.size.width, _imageBgView.frame.size.height - 50);
    }
    else if (SCREEN_WIDTH == 375){
        view02.frame = CGRectMake(_imageBgView.frame.size.width - 20, 0, _imageBgView.frame.size.width, _imageBgView.frame.size.height - 50);
    }
    else{
        view02.frame = CGRectMake(_imageBgView.frame.size.width, 0, _imageBgView.frame.size.width, _imageBgView.frame.size.height - 50);
    }
    [scrollView addSubview:view02];
    
    //取消按页滚动效果
    scrollView.pagingEnabled = NO;
    
    //滚动视图画布的移动位置，偏移位置
    scrollView.contentOffset = CGPointMake(0, 0);
    
    //将当前视图控制器作为代理对象
    scrollView.delegate = self;

    [_imageBgView addSubview:scrollView];
    
    
    [self postDaoDianInfo];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:{
            SelectTimeViewController *vc = [[SelectTimeViewController alloc] init];
            vc.time = _time.text;
            vc.block = ^(NSString *time) {
                _time.text = time;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}


//查看协议
-(void)pressRight{

}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//查看到店自取信息
-(void)postDaoDianInfo{
    NSString *url = [API stringByAppendingString:@"Setshop/daoDian"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取到店信息 %@", responseObject);
        
        if (responseObject != nil) {
            if (responseObject[@"isTostore"] != nil && ![responseObject[@"isTostore"] isKindOfClass:[NSNull class]]) {
                if ([responseObject[@"isTostore"] isEqual:@"1"]) {
                    [_isTostore setOn:YES];
                }
                else
                    [_isTostore setOn:NO];
            }
            else{
                [_isTostore setOn:YES];
            }
            
            if (responseObject[@"mealTime"] != nil && ![responseObject[@"mealTime"] isKindOfClass:[NSNull class]]) {
                _time.text = [NSString stringWithFormat:@"%@", responseObject[@"mealTime"]];
            }
            else{
                _time.text = @"20";
            }

            
        }
        else{
            [_isTostore setOn:YES];
            _time.text = @"20";
            [Util toastWithView:self.navigationController.view AndText:@"获取信息失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取到店信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}



//设置到店自取信息
-(void)postSetDaoDianInfo{
    NSString *url = [API stringByAppendingString:@"Setshop/setDaoDian"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"isTostore":[_isTostore isOn]?@"1":@"0", @"mealTime":_time.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"设置到店信息 %@", responseObject);
        
        if (responseObject != nil) {
//            if ([responseObject[@"res"] isEqual:@"1"]) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                [Util toastWithView:self.navigationController.view AndText:@"设置失败"];
//                return ;
//            }
//        }
//        else{
//            [Util toastWithView:self.navigationController.view AndText:@"设置失败"];
//            return ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"设置到店信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
    
}


//退出视图
-(void)pressBack{
    [self postSetDaoDianInfo];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
