//
//  ScanViewController.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*扫描*//

#import "ScanViewController.h"
#import "ScanTableViewCell.h"
#import "HMScannerController.h"


@interface ScanViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) UIButton *scanBtn;

@property (strong, nonatomic) NSDictionary *groupGoods;    //团购信息
@property (strong, nonatomic) NSArray *goodslist;
@property (strong, nonatomic) UIButton *checkBtn;    //核实按钮

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *shopPrice;


@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _orderId = @"";
    _shopPrice = @"";
    _goodslist = [[NSArray alloc] init];
    
    [self initTableView];
    [self initScanBtn];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //注册通知，当segmentController 滑动到或者点击扫描的时候调用   在SegmentControl02.m文件中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartScan) name:@"StartScan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeaveView) name:@"LeaveView" object:nil];

}



//增加一个按钮在扫字上面，因为当进入扫码控制器之后上面没有点击事件，触发不了再次扫码
//进入该视图控制器是显示该控件，离开时隐藏
-(void)initScanBtn{
    
    _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH/5, 64, SCREEN_WIDTH/5, 80)];
//    [_scanBtn setTitle:@"扫" forState:UIControlStateNormal];
    _scanBtn.backgroundColor = [UIColor clearColor];
    [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    _scanBtn.layer.cornerRadius = 25;
    
    
    UIApplication *ap = [UIApplication sharedApplication];
    [ap.keyWindow addSubview:_scanBtn];

}


-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 220) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"ScanTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}


-(void)scanBtnClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartScan" object:nil];
}

//开始扫描
-(void)StartScan{
    HMScannerController *scanner = [HMScannerController scannerWithCardName:@"" avatar:nil completion:^(NSString *stringValue) {
        
        NSLog(@"二维码值 = %@", stringValue);
        //获取团购信息
        if (stringValue != nil) {
            [self postGetGroupGoodsWithCode:[NSString stringWithFormat:@"%@",stringValue]];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"扫描失败"];
        }
        
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];

    _scanBtn.hidden = NO;

}

//离开该视图控制器
-(void)LeaveView{
    _scanBtn.hidden = YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _goodslist.count) {
        NSString *name = @"";
        if (_goodslist[indexPath.row][@"goodsName"] != nil && ![_goodslist[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
            name = _goodslist[indexPath.row][@"goodsName"];
        }
        else
            name = @"";
        
        CGFloat nameHeight = [Util countTextHeight:name];
        if (nameHeight < 44) {
            return 44;
        }
        else{
            return nameHeight + 10;
        }
    }
    else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH - 40, 44)];
    _checkBtn.backgroundColor = NAV_COLOR;
    _checkBtn.layer.cornerRadius = 5;
    [_checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *orderStatus = @"0";
    if (_groupGoods[@"orderStatus"] != nil && ![_groupGoods[@"orderStatus"] isKindOfClass:[NSNull class]]) {
        orderStatus = [NSString stringWithFormat:@"%@", _groupGoods[@"orderStatus"]];
    }
    else
        orderStatus = @"0";
    
    if ([orderStatus isEqualToString:@"0"]) {
        [_checkBtn setTitle:@"待核销" forState:UIControlStateNormal];
        _checkBtn.tag = 20000;
        [_checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        [_checkBtn setTitle:@"已消费" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _checkBtn.tag = 20001;
    }
    
    [footerView addSubview:_checkBtn];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    if (_groupGoods[@"groupName"] != nil && ![_groupGoods[@"groupName"] isKindOfClass:[NSNull class]]) {
        title = [NSString stringWithFormat:@"%@%@", @"团购名称：",_groupGoods[@"groupName"]];
    }
    else
        title = @"团购名称： --";
    
    CGFloat titleHeight = [Util getHeightByWidth:SCREEN_WIDTH title:title font:[UIFont systemFontOfSize:15]];

    if (titleHeight < 44) {
        return 44;
    }
    else
        return titleHeight + 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [UIColor blackColor];
    
    if (_groupGoods[@"groupName"] != nil && ![_groupGoods[@"groupName"] isKindOfClass:[NSNull class]]) {
        title.text = [NSString stringWithFormat:@"%@%@", @"团购名称：",_groupGoods[@"groupName"]];
    }
    else
        title.text = @"团购名称： --";

    [headerView addSubview:title];
    [headerView addSubview:bottomLine];
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodslist.count + 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < _goodslist.count) {
        ScanTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ScanTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ScanTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ScanTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row %2 ==0) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.name.backgroundColor = [UIColor whiteColor];
        }
        else{
            cell.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
            cell.name.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        }
        
        if (_goodslist[indexPath.row][@"goodsName"] != nil && ![_goodslist[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
            cell.name.text = _goodslist[indexPath.row][@"goodsName"];
        }
        else
            cell.name.text = @"";
        
        cell.nameHeight.constant = [Util countTextHeight:cell.name.text];
        
        if (_goodslist[indexPath.row][@"goodsNum"] != nil && ![_goodslist[indexPath.row][@"goodsNum"] isKindOfClass:[NSNull class]]) {
            cell.number.text = [NSString stringWithFormat:@"%@%@", @"X", _goodslist[indexPath.row][@"goodsNum"]];
        }
        else
            cell.number.text = @"";
        
        if (_goodslist[indexPath.row][@"goodsNum"] != nil && ![_goodslist[indexPath.row][@"goodsNum"] isKindOfClass:[NSNull class]]) {
            cell.number.text = [NSString stringWithFormat:@"%@%@", @"X", _goodslist[indexPath.row][@"goodsNum"]];
        }
        else
            cell.number.text = @"--";
        
        if (_goodslist[indexPath.row][@"groupMoney"] != nil && ![_goodslist[indexPath.row][@"groupMoney"] isKindOfClass:[NSNull class]]) {
            cell.price.text = [NSString stringWithFormat:@"%@%@", @"￥", _goodslist[indexPath.row][@"groupMoney"]];
        }
        else
            cell.price.text = @"--";
        _shopPrice = cell.price.text;
        
        
        
        return cell;

    }
    else if(indexPath.row == _goodslist.count){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row %2 ==0) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else{
            cell.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        }

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH - 10, 44)];
        title.textAlignment = NSTextAlignmentRight;
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = [UIColor blackColor];
        
        if (_groupGoods[@"shopPrice"] != nil && ![_groupGoods[@"shopPrice"] isKindOfClass:[NSNull class]]) {
            title.text = [NSString stringWithFormat:@"%@%@", @"总计：",_groupGoods[@"shopPrice"]];
        }
        else
            title.text = @"总计： --";

        [cell addSubview:title];
        
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row %2 ==0) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else{
            cell.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        }
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, SCREEN_WIDTH, 44)];
        title.textAlignment = NSTextAlignmentLeft;
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        
        NSString *startTime = @"";
        NSString *endTime = @"";
        
        if (_groupGoods[@"startTime"] != nil && ![_groupGoods[@"startTime"] isKindOfClass:[NSNull class]]) {
            startTime = [NSString stringWithFormat:@"%@",_groupGoods[@"startTime"]];
            startTime = [startTime substringToIndex:11];
        }
        else
            startTime = @"";
        
        if (_groupGoods[@"endTime"] != nil && ![_groupGoods[@"endTime"] isKindOfClass:[NSNull class]]) {
            endTime = [NSString stringWithFormat:@"%@",_groupGoods[@"endTime"]];
            endTime = [startTime substringToIndex:11];
        }
        else
            endTime = @"";
        
        title.text = [NSString stringWithFormat:@"%@%@%@%@", @"有效期：", startTime, @" ~ ", endTime];
        
        [cell addSubview:title];
        
        return cell;

    }
    

    
}

//核销
-(void)checkBtnClick{
    if (_checkBtn.tag == 20000) {
        [self postComfirGoods];
    }
}


//获取团购商品信息
-(void)postGetGroupGoodsWithCode:(NSString *)code{
    NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/getGroupGoods"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"code":code};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"团购信息 %@", responseObject);
        if (responseObject != nil) {
            _groupGoods = responseObject;
            if (responseObject[@"goodslist"] != nil) {
                _goodslist = responseObject[@"goodslist"];
            }
            if (_groupGoods[@"orderId"] != nil && ![_groupGoods[@"orderId"] isKindOfClass:[NSNull class]]) {
                _orderId = [NSString stringWithFormat:@"%@", _groupGoods[@"orderId"]];
            }
            else
                _orderId = @"";
            
            [self.tableView reloadData];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取团购信息失败"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取团购商品信息失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//核销团购码
-(void)postComfirGoods{
    if ([_orderId isEqualToString:@""]) {
        [Util toastWithView:self.navigationController.view AndText:@"核销失败"];
        return ;
    }
    NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/comfirGoods"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"orderId":_orderId, @"shopPrice":_shopPrice};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"核销团购码 %@", responseObject);
        if (responseObject != nil) {
            NSString *start = responseObject[@"success"];
            if ([start isEqualToString:@"success"]) {
                [Util toastWithView:self.navigationController.view AndText:@"核销成功"];
                [_checkBtn setTitle:@"已消费" forState:UIControlStateNormal];
                [_checkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                _checkBtn.tag = 20001;
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"核销失败"];
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"核销失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"核销团购码失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StartScan" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LeaveView" object:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
