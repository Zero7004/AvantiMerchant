//
//  SelectShopViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/8.
//  Copyright © 2017年 Mac. All rights reserved.
//


/////选择店铺/////

#import "SelectShopViewController.h"
#import "ShopTableViewCell.h"

@interface SelectShopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *backBtn;

@property (strong, nonatomic) NSArray *shopArray;

@end

@implementation SelectShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _shopArray = [[NSArray alloc] init];
    
    [self initTableView];
    
    //获取全部商店信息
    [self postGetBossShopAllShop];
}


-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"ShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"ShopTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger active = 0;
    //计算活动个数
    if (_shopArray[indexPath.row][@"full"] != nil && ![_shopArray[indexPath.row][@"full"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"full"] isEqual:@"0"]) {
            active++;
        }
    }
    if (_shopArray[indexPath.row][@"newCou"] != nil && ![_shopArray[indexPath.row][@"newCou"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"newCou"] isEqual:@"0"]) {
            active++;
        }
    }
    if (_shopArray[indexPath.row][@"isCou"] != nil && ![_shopArray[indexPath.row][@"isCou"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"isCou"] isEqual:@"0"]) {
            active++;
        }
    }
    if (_shopArray[indexPath.row][@"couNum"] != nil && ![_shopArray[indexPath.row][@"couNum"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"couNum"] isEqual:@"0"]) {
            active++;
        }
    }
    
    if (active < 2) {
        return 120;
    }
    else{
        return 120 + 20 * (active - 1);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _shopArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = NAV_COLOR;
    UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH - 80, 53)];
    topTitle.text = @"选择商店";
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.font = [UIFont systemFontOfSize:18];
    topTitle.textColor = [UIColor whiteColor];
    [topView addSubview:topTitle];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(20, 20, 40, 40);
//    _backBtn.bounds = CGRectMake(0, 0, 40, 40);
    _backBtn.imageView.contentMode = UIViewContentModeLeft;
    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:_backBtn];
    
    return topView;
}

-(void)pressBack{
    //清除用户信息
    [[AppDelegate APP].user cleanUserInfo];
    //放回登录页面
    [[AppDelegate APP] rootLoginView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShopTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ShopTableViewCell"];
        
    }
    
    if (_shopArray[indexPath.row][@"shopImg"] != nil && ![_shopArray[indexPath.row][@"shopImg"] isKindOfClass:[NSNull class]]) {
        [cell.shopImg sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_shopArray[indexPath.row][@"shopImg"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
    }
    else
        cell.shopImg.image = [UIImage imageNamed:@"noimg"];
    
    if (_shopArray[indexPath.row][@"shopName"] != nil && ![_shopArray[indexPath.row][@"shopName"] isKindOfClass:[NSNull class]]) {
        cell.shopName.text = _shopArray[indexPath.row][@"shopName"];
    }
    else{
        cell.shopName.text = @"--";
    }
    
    if (_shopArray[indexPath.row][@"shopSales"] != nil && ![_shopArray[indexPath.row][@"shopSales"] isKindOfClass:[NSNull class]]) {
        cell.shopSales.text = [NSString stringWithFormat:@"%@%@", @"月售", _shopArray[indexPath.row][@"shopSales"]];
    }
    else{
        cell.shopSales.text = @"月售0";
    }
    
    NSString *deliveryFreeMoney;    //起送价
    NSString *deliveryStartMoney;   //配送费
    if (_shopArray[indexPath.row][@"deliveryFreeMoney"] != nil && ![_shopArray[indexPath.row][@"deliveryFreeMoney"] isKindOfClass:[NSNull class]]) {
        deliveryFreeMoney = _shopArray[indexPath.row][@"deliveryFreeMoney"];
    }
    else{
        deliveryFreeMoney = @"0";
    }
    
    if (_shopArray[indexPath.row][@"deliveryStartMoney"] != nil && ![_shopArray[indexPath.row][@"deliveryStartMoney"] isKindOfClass:[NSNull class]]) {
        deliveryStartMoney = _shopArray[indexPath.row][@"deliveryStartMoney"];
    }
    else{
        deliveryStartMoney = @"0";
    }

    cell.delivery.text = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"￥", deliveryFreeMoney, @"起送价", @"￥", deliveryStartMoney, @"配送费"];
    
//    if (_shopArray[indexPath.row][@""] != nil && ![_shopArray[indexPath.row][@""] isKindOfClass:[NSNull class]]) {
//        cell.shopName.text = _shopArray[indexPath.row][@""];
//    }
//    else{
//        cell.shopName.text = @"--";
//    }
    
    //活动数量
    NSInteger active = 0;
    
    //添加优惠活动
    //减
    //判断是否有减满活动
    UILabel *youhuiTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.line.frame.origin.x, cell.line.frame.origin.y + 5 + 20 * active, 17, 17)];
    if (_shopArray[indexPath.row][@"full"] != nil && ![_shopArray[indexPath.row][@"full"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"full"] isEqual:@"0"]) {
            youhuiTitle.text = @"减";
            youhuiTitle.backgroundColor =  [UIColor colorWithRed:253/255.0 green:66/255.0 blue:70/255.0 alpha:1];
            youhuiTitle.textColor = [UIColor whiteColor];
            youhuiTitle.font = [UIFont systemFontOfSize:13];
            youhuiTitle.textAlignment = NSTextAlignmentCenter;
            [cell.bgView addSubview:youhuiTitle];
            
            UILabel *youhui = [[UILabel alloc] initWithFrame:CGRectMake(youhuiTitle.frame.origin.x + 19, youhuiTitle.frame.origin.y, 280, 17)];
            youhui.textColor = [UIColor darkGrayColor];
            youhui.font = [UIFont systemFontOfSize:13];
            if (_shopArray[indexPath.row][@"youhui"] != nil && ![_shopArray[indexPath.row][@"youhui"] isKindOfClass:[NSNull class]]) {
                youhui.text = _shopArray[indexPath.row][@"youhui"];
            }
            else{
                youhui.text = @"--";
            }
            [cell.bgView addSubview:youhui];

            active++;
        }
    }
    
    //新
    UILabel *newCouTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.line.frame.origin.x, cell.line.frame.origin.y + 5 + 20 * active, 17, 17)];
    if (_shopArray[indexPath.row][@"newCou"] != nil && ![_shopArray[indexPath.row][@"newCou"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"newCou"] isEqual:@"0"]) {
            newCouTitle.text = @"新";
            newCouTitle.backgroundColor = [UIColor colorWithRed:111/255.0 green:138/255.0 blue:66/255.0 alpha:1];
            newCouTitle.textColor = [UIColor whiteColor];
            newCouTitle.font = [UIFont systemFontOfSize:13];
            newCouTitle.textAlignment = NSTextAlignmentCenter;
            [cell.bgView addSubview:newCouTitle];
            
            UILabel *newCou = [[UILabel alloc] initWithFrame:CGRectMake(newCouTitle.frame.origin.x + 19, newCouTitle.frame.origin.y, 280, 17)];
            newCou.textColor = [UIColor darkGrayColor];
            newCou.font = [UIFont systemFontOfSize:13];
            newCou.text = [NSString stringWithFormat:@"%@%@%@", @"新用户立减", _shopArray[indexPath.row][@"newCou"], @"元"];
            
            [cell.bgView addSubview:newCou];

            active++;

        }
    }
    
    //享
    UILabel *isCouTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.line.frame.origin.x, cell.line.frame.origin.y + 5 + 20 * active, 17, 17)];
    if (_shopArray[indexPath.row][@"isCou"] != nil && ![_shopArray[indexPath.row][@"isCou"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"isCou"] isEqual:@"0"]) {
            isCouTitle.text = @"享";
            isCouTitle.backgroundColor = [UIColor colorWithRed:234/255.0 green:211/255.0 blue:46/255.0 alpha:1];
            isCouTitle.textColor = [UIColor whiteColor];
            isCouTitle.font = [UIFont systemFontOfSize:13];
            isCouTitle.textAlignment = NSTextAlignmentCenter;
            [cell.bgView addSubview:isCouTitle];
            
            UILabel *isCou = [[UILabel alloc] initWithFrame:CGRectMake(isCouTitle.frame.origin.x + 19, isCouTitle.frame.origin.y, 280, 17)];
            isCou.textColor = [UIColor darkGrayColor];
            isCou.font = [UIFont systemFontOfSize:13];
            isCou.text = @"下单分享即得代金券";
            
            [cell.bgView addSubview:isCou];
            
            active++;
        }
    }

    //领
    UILabel *couNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(cell.line.frame.origin.x, cell.line.frame.origin.y + 5 + 20 * active, 17, 17)];
    if (_shopArray[indexPath.row][@"couNum"] != nil && ![_shopArray[indexPath.row][@"couNum"] isKindOfClass:[NSNull class]]) {
        if (![_shopArray[indexPath.row][@"couNum"] isEqual:@"0"]) {
            couNumTitle.text = @"领";
            couNumTitle.backgroundColor = [UIColor colorWithRed:168/255.0 green:25/255.0 blue:95/255.0 alpha:1];
            couNumTitle.textColor = [UIColor whiteColor];
            couNumTitle.font = [UIFont systemFontOfSize:13];
            couNumTitle.textAlignment = NSTextAlignmentCenter;
            [cell.bgView addSubview:couNumTitle];
            
            UILabel *couNum = [[UILabel alloc] initWithFrame:CGRectMake(couNumTitle.frame.origin.x + 19, couNumTitle.frame.origin.y, 280, 17)];
            couNum.textColor = [UIColor darkGrayColor];
            couNum.font = [UIFont systemFontOfSize:13];
            couNum.text = @"进店领取代金券";
            
            [cell.bgView addSubview:couNum];
            
            active++;
        }
    }



    
    return cell;
}


//点击选择商店
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //添加商店信息
    [AppDelegate APP].user.userId = _shopArray[indexPath.row][@"userId"];
    [AppDelegate APP].user.shopId = _shopArray[indexPath.row][@"shopId"];
    [AppDelegate APP].user.shopName = _shopArray[indexPath.row][@"shopName"];
    [AppDelegate APP].user.dlvService = _shopArray[indexPath.row][@"dlvService"];
    [AppDelegate APP].user.shopImg = _shopArray[indexPath.row][@"shopImg"];

//    [self dismissViewControllerAnimated:YES completion:nil];
    
    //进入视图
    [[AppDelegate APP] rootMainView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 接口
//获取总店所有商店信息
-(void)postGetBossShopAllShop{
    NSString *url = [API stringByAppendingString:@"BoosShop/allShop"];
    NSDictionary *dic = @{@"userId":[AppDelegate APP].user.userLoginId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取全部商店信息 %@", responseObject);
        if (responseObject != nil) {
            _shopArray = responseObject;
            [self.tableView reloadData];
        }
        else{
            [Util toastWithView:self.view AndText:@"获取全部商店失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取商店信息失败 %@", error);
        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
}




@end
