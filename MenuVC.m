//
//  MenuVC.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/13.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "MenuVC.h"
#import "activityMenuCell.h"

@interface MenuVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UILabel *menuName;

@end

@implementation MenuVC

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
    [self.tableView registerNib:[UINib nibWithNibName:@"activityMenuCell" bundle:nil] forCellReuseIdentifier:@"activityMenuCell"];
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
    if (_distopList[indexPath.row][@"goodsName"] != nil && ![_distopList[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
        goodsName = _distopList[indexPath.row][@"goodsName"];
    }
    else
        goodsName = @"--";
    
    return 80 + [Util countTextHeight:goodsName];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _distopList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    activityMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"activityMenuCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[activityMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"activityMenuCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    if (_distopList[indexPath.row][@"goodsName"] != nil && ![_distopList[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
        cell.goodsName.text = _distopList[indexPath.row][@"goodsName"];
    }
    else
        cell.goodsName.text = @"--";
    
    if (_distopList[indexPath.row][@"goodsStock"] != nil && ![_distopList[indexPath.row][@"goodsStock"] isKindOfClass:[NSNull class]]) {
        if ([_distopList[indexPath.row][@"goodsStock"] isEqualToString:@"-1"]) {
            cell.goodsSort.text = [NSString stringWithFormat:@"%@", @"库存：无限"];
        }
        else{
            cell.goodsSort.text = [NSString stringWithFormat:@"%@%@", @"库存：", _distopList[indexPath.row][@"goodsStock"]];
        }
    }
    else
        cell.goodsSort.text = @"库存：0";
    
    if (_distopList[indexPath.row][@"shopPrice"] != nil && ![_distopList[indexPath.row][@"shopPrice"] isKindOfClass:[NSNull class]]) {
        cell.shopPrice.text = [NSString stringWithFormat:@"%@%@", @"￥", _distopList[indexPath.row][@"shopPrice"]];
    }
    else
        cell.shopPrice.text = @"￥0.00";
    
    if (_distopList[indexPath.row][@"goodsThums"] != nil && ![_distopList[indexPath.row][@"goodsThums"] isKindOfClass:[NSNull class]]) {
        [cell.goodsThums sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_distopList[indexPath.row][@"goodsThums"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
    }
    else
        cell.goodsThums.image = [UIImage imageNamed:@"noimg"];
    
    cell.goodsNameHeight.constant = [Util countTextHeight:cell.goodsName.text] + 10;
    
    //都是上架商品，不用判断
    cell.stopLabel.hidden = YES;
//    if (_distopList[indexPath.row][@"isSale"] != nil && ![_distopList[indexPath.row][@"isSale"] isKindOfClass:[NSNull class]]) {
//        NSString *isSale = [NSString stringWithFormat:@"%@", _distopList[indexPath.row][@"isSale"]];
//        if ([isSale isEqualToString:@"0"]) {
//            cell.stopLabel.hidden = NO;
//        }
//        else{
//            cell.stopLabel.hidden = YES;
//        }
//    }
//    else{
//        cell.stopLabel.hidden = NO;
//    }
    
    if ([_activeType isEqualToString:@"团购活动"]) {
        cell.selectBtn.hidden = YES;
        cell.MultipleChoiceBtn.hidden = NO;
        cell.MultipleChoiceBtn.tag = indexPath.row;
        [cell.MultipleChoiceBtn addTarget:self action:@selector(MultipleChoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //判断是否选中,选中按钮为勾号，未选择为空白
        for (NSDictionary *dic in _selectGoods) {
            if ([dic[@"goodsId"] isEqual:_distopList[indexPath.row][@"goodsId"]]) {
                [cell.MultipleChoiceBtn setImage:[UIImage imageNamed:@"选中方块-1"] forState:UIControlStateNormal];
                break ;
            }
            else{
                [cell.MultipleChoiceBtn setImage:[UIImage imageNamed:@"方块未选-1"] forState:UIControlStateNormal];
            }
        }
    }
    else{
        cell.selectBtn.hidden = NO;
        cell.MultipleChoiceBtn.hidden = YES;
        cell.selectBtn.tag = indexPath.row;
        [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
   

    return cell;
}

//非团购活动按钮选中
-(void)selectBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *goodsName;
    if (_distopList[btn.tag][@"goodsName"] != nil && ![_distopList[btn.tag][@"goodsName"] isKindOfClass:[NSNull class]]) {
        goodsName = _distopList[btn.tag][@"goodsName"];
    }
    else
        goodsName = @"--";
    NSString *shopPrice;
    if (_distopList[btn.tag][@"shopPrice"] != nil && ![_distopList[btn.tag][@"shopPrice"] isKindOfClass:[NSNull class]]) {
        shopPrice = [NSString stringWithFormat:@"%@", _distopList[btn.tag][@"shopPrice"]];
    }
    else
        shopPrice = @"￥0.00";

    self.block(_distopList[btn.tag][@"goodsId"], goodsName, shopPrice);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissViewController" object:nil];

}

//团购活动选择
-(void)MultipleChoiceBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *goodsName;
    if (_distopList[btn.tag][@"goodsName"] != nil && ![_distopList[btn.tag][@"goodsName"] isKindOfClass:[NSNull class]]) {
        goodsName = _distopList[btn.tag][@"goodsName"];
    }
    else
        goodsName = @"--";
    NSString *shopPrice;
    if (_distopList[btn.tag][@"shopPrice"] != nil && ![_distopList[btn.tag][@"shopPrice"] isKindOfClass:[NSNull class]]) {
        shopPrice = [NSString stringWithFormat:@"%@", _distopList[btn.tag][@"shopPrice"]];
    }
    else
        shopPrice = @"￥0.00";
    
    activityMenuCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    //判断是否选中,选中按钮为勾号，未选择为空白
    //未选择则加入列表，选择的则从列表删除
    if (_selectGoods.count == 0) {
        [cell.MultipleChoiceBtn setImage:[UIImage imageNamed:@"选中方块-1"] forState:UIControlStateNormal];
        NSDictionary *dict = @{@"goodsId":_distopList[btn.tag][@"goodsId"], @"goodsName":goodsName, @"shopPrice":shopPrice, @"num":@"1"};
        [_selectGoods addObject:dict];
    }
    else{
        BOOL isIn = NO;   //判断是否选中  yes存在选中  no为未选
        for (int i = 0; i < _selectGoods.count; i++) {
            NSDictionary *dic = _selectGoods[i];
            if ([dic[@"goodsId"] isEqual:_distopList[btn.tag][@"goodsId"]]) {
                isIn = YES;
            }
            else{
                isIn = NO;
            }
        }
        //判断完成进行添加或者删除
        if (isIn) {
            [cell.MultipleChoiceBtn setImage:[UIImage imageNamed:@"方块未选-1"] forState:UIControlStateNormal];
            for (NSDictionary *dic in _selectGoods) {
                if ([dic[@"goodsId"] isEqual:_distopList[btn.tag][@"goodsId"]]) {
                    [_selectGoods removeObject:dic];
                    break;
                }
            }
        }
        else{
            [cell.MultipleChoiceBtn setImage:[UIImage imageNamed:@"选中方块-1"] forState:UIControlStateNormal];
            NSDictionary *dict = @{@"goodsId":_distopList[btn.tag][@"goodsId"], @"goodsName":goodsName, @"shopPrice":shopPrice, @"num":@"1"};
            [_selectGoods addObject:dict];
        }
    }
    
    //每次选择操作完成后回调数据，同步数据
    self.block_group(_selectGoods);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
