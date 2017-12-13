//
//  MenuViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

//**分类**//
#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "AddMerchandiseViewController.h"

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic)UILabel *menuName;


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTableView];
    [self initFooterView];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(-3, 0, SCREEN_WIDTH-97, SCREEN_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuTableViewCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.view addSubview:_tableView];
}

-(void)initFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 97, 200)];
    footerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    
    UILabel *footerLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH-97, 40)];
    footerLable.text = @"该分类下商品暂无更多商品了";
    [footerLable setFont:[UIFont systemFontOfSize:12]];
    footerLable.textAlignment = NSTextAlignmentCenter;
    [footerLable setTextColor:[UIColor grayColor]];
    
    [footerView addSubview:footerLable];
    
    self.tableView.tableFooterView = footerView;
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 97, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    _menuName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_HEIGHT -115, 40)];
    [_menuName setText:_menuStr];
    _menuName.textColor = [UIColor blackColor];
    [_menuName setFont:[UIFont systemFontOfSize:14]];
    
    [headerView addSubview:_menuName];
    return headerView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *goodsName;
    if (_goodList[indexPath.row][@"goodsName"] != nil && ![_goodList[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
        goodsName = _goodList[indexPath.row][@"goodsName"];
    }
    else
        goodsName = @"--";

    return 120 + [Util countTextHeight:goodsName];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodList.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MenuTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (_goodList[indexPath.row][@"goodsName"] != nil && ![_goodList[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
        cell.goodsName.text = _goodList[indexPath.row][@"goodsName"];
    }
    else
        cell.goodsName.text = @"--";
    
    if (_goodList[indexPath.row][@"goodsStock"] != nil && ![_goodList[indexPath.row][@"goodsStock"] isKindOfClass:[NSNull class]]) {
        if ([_goodList[indexPath.row][@"goodsStock"] isEqualToString:@"-1"]) {
            cell.goodsSort.text = [NSString stringWithFormat:@"%@", @"库存：无限"];
        }
        else{
            cell.goodsSort.text = [NSString stringWithFormat:@"%@%@", @"库存：", _goodList[indexPath.row][@"goodsStock"]];
        }
    }
    else
        cell.goodsSort.text = @"库存：0";

    if (_goodList[indexPath.row][@"shopPrice"] != nil && ![_goodList[indexPath.row][@"shopPrice"] isKindOfClass:[NSNull class]]) {
        cell.shopPrice.text = [NSString stringWithFormat:@"%@%@", @"￥", _goodList[indexPath.row][@"shopPrice"]];
    }
    else
        cell.shopPrice.text = @"￥0.00";

    if (_goodList[indexPath.row][@"goodsImg"] != nil && ![_goodList[indexPath.row][@"goodsImg"] isKindOfClass:[NSNull class]]) {
        [cell.goodsThums sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_goodList[indexPath.row][@"goodsImg"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
    }
    else
        cell.goodsThums.image = [UIImage imageNamed:@"noimg"];
    
    cell.goodsNameHeight.constant = [Util countTextHeight:cell.goodsName.text] + 10;
    
    if (_goodList[indexPath.row][@"isSale"] != nil && ![_goodList[indexPath.row][@"isSale"] isKindOfClass:[NSNull class]]) {
        NSString *isSale = [NSString stringWithFormat:@"%@", _goodList[indexPath.row][@"isSale"]];
        if ([isSale isEqualToString:@"0"]) {
            cell.stopLabel.hidden = NO;
            [cell.cancelBtn setTitle:@"上架" forState:UIControlStateNormal];
        }
        else{
            [cell.cancelBtn setTitle:@"下架" forState:UIControlStateNormal];
            cell.stopLabel.hidden = YES;
        }
    }
    else{
        cell.stopLabel.hidden = NO;
        [cell.cancelBtn setTitle:@"上架" forState:UIControlStateNormal];
    }

    cell.cancelBtn.tag = indexPath.row;
    cell.editBtn.tag = indexPath.row;
    
    [cell.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}


//上架下架按钮
-(void)cancelBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (_goodList[btn.tag][@"isSale"] != nil && ![_goodList[btn.tag][@"isSale"] isKindOfClass:[NSNull class]]) {
        NSString *isSale = [NSString stringWithFormat:@"%@", _goodList[btn.tag][@"isSale"]];
        if ([isSale isEqualToString:@"0"]) {
            NSString *url = [API stringByAppendingString:@"shops/shangJia"];
            [self postPutAwayWithUrl:url GoodeId:_goodList[btn.tag][@"goodsId"] WithBtnTag:btn.tag];
        }
        else{
            NSString *url = [API stringByAppendingString:@"shops/xiaJia"];
            [self postSoldOutWithUrl:url GoodeId:_goodList[btn.tag][@"goodsId"] WithBtnTag:btn.tag];
        }
    }
    else{
        CGPoint point = CGPointMake(self.view.frame.size.width/2 , self.view.frame.size.height/2);
        [Util toastWithView:self.view AndPoint:&point AndText:@"操作失败"];
    }
}

//编辑按钮
-(void)editBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    //调通知编辑商品
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editGoods" object:_goodList[btn.tag]];

}


//上架接口
-(void)postPutAwayWithUrl:(NSString *)url GoodeId:(NSString *)goodsId WithBtnTag:(NSInteger)btnTag{
    NSDictionary *dit = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上架商品 %@", responseObject);
        MenuTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        CGPoint point = CGPointMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.view AndPoint:&point AndText:@"上架成功"];
                cell.stopLabel.hidden = YES;
                [cell.cancelBtn setTitle:@"下架" forState:UIControlStateNormal];
                [self postSeeGoods];

            }
            else{
                [Util toastWithView:self.view AndPoint:&point AndText:@"上架失败"];
            }

        }
        else
            [Util toastWithView:self.view AndPoint:&point AndText:@"上架失败"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"操作失败 %@", error);
        CGPoint point = CGPointMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50);
        [Util toastWithView:self.view AndPoint:&point AndText:@"网络连接异常"];
    }];
}

//下架接口
-(void)postSoldOutWithUrl:(NSString *)url GoodeId:(NSString *)goodsId WithBtnTag:(NSInteger)btnTag{
    NSDictionary *dit = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下架商品 %@", responseObject);
        MenuTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        CGPoint point = CGPointMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.view AndPoint:&point AndText:@"下架成功"];
                cell.stopLabel.hidden = NO;
                [cell.cancelBtn setTitle:@"上架" forState:UIControlStateNormal];
                [self postSeeGoods];
            }
            else
                [Util toastWithView:self.view AndPoint:&point AndText:@"下架失败"];

        }
        else
            [Util toastWithView:self.view AndPoint:&point AndText:@"下架失败"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"操作失败 %@", error);
        CGPoint point = CGPointMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50);
        [Util toastWithView:self.view AndPoint:&point AndText:@"网络连接异常"];
    }];
}


//通过店铺、语言、分类查看商品
-(void)postSeeGoods{
    NSString *url = [API stringByAppendingString:@"shops/seeGoods"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"languageId":_languageId, @"catId":_catId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"查看商品 %@", responseObject);

        if (responseObject != nil) {
            if (responseObject[@"goods"] != nil && ![responseObject[@"goods"] isKindOfClass:[NSNull class]]) {
                _goodList = responseObject[@"goods"];
            }
            else
                _goodList = @[];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"查看商品失败 %@", error);
        CGPoint point = CGPointMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 50);
        [Util toastWithView:self.view AndPoint:&point AndText:@"网络连接异常"];
    }];
}



@end
