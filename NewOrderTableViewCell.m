//
//  NewOrderTableViewCell.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/6.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "NewOrderTableViewCell.h"
#import "goodListCell.h"

@interface NewOrderTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NewOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (SCREEN_WIDTH == 320) {
        _orderNo.font = [UIFont systemFontOfSize:12];
        _createTime.font = [UIFont systemFontOfSize:12];
    }
    else if (SCREEN_WIDTH == 375){
        _orderNo.font = [UIFont systemFontOfSize:13];
        _createTime.font = [UIFont systemFontOfSize:13];
    }
    else{
        _orderNo.font = [UIFont systemFontOfSize:14];
        _createTime.font = [UIFont systemFontOfSize:14];
    }

    
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [Border_COLOR CGColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"goodListCell" bundle:nil]forCellReuseIdentifier:@"goodListCell"];
    self.tableView.separatorStyle = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;

    
    //计算textview高度
    _addressConstraintHeight.constant = [Util countTextHeight:_address.text];
    
    //设置按钮边框
    [self.cancelOrderBtn.layer setBorderColor:NAV_COLOR.CGColor];
    [self.cancelOrderBtn.layer setBorderWidth:1.0];
    [self.cancelOrderBtn.layer setCornerRadius:5];
//    self.cancelOrderBtn.layer.masksToBounds = YES;
    [self.mealsOnWheelsBtn.layer setBorderColor:NAV_COLOR.CGColor];
    [self.mealsOnWheelsBtn.layer setBorderWidth:1.0];
    [self.mealsOnWheelsBtn.layer setCornerRadius:5];
//    self.mealsOnWheelsBtn.layer.masksToBounds = YES;
    
    [self.cancelOrderBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
    [self.mealsOnWheelsBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];

    [self.userName setTextColor:NAV_COLOR];
    [self.userPhone setTextColor:NAV_COLOR];
    
    
}
- (void)isCompOpe
{
    if (self.isComp) {
        self.userAddress = nil;
        self.distance = nil;
        self.daohangBtn = nil;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodlist.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    goodListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"goodListCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[goodListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"goodListCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row <= _goodlist.count-1) {
        
        if (_goodlist[indexPath.row][@"goodsAttrName"] != nil && ![_goodlist[indexPath.row][@"goodsAttrName"] isKindOfClass:[NSNull class]]) {
            cell.goodsAttrName.text = _goodlist[indexPath.row][@"goodsAttrName"];
        }
        else
            cell.goodsAttrName.text = @"";

        if (_goodlist[indexPath.row][@"goodsName"] != nil && ![_goodlist[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
            cell.goodsName.text = [NSString stringWithFormat:@"%@%@%@",@"·  ", _goodlist[indexPath.row][@"goodsName"], cell.goodsAttrName.text];
        }
        else
            cell.goodsName.text = @"";
        
        if (_goodlist[indexPath.row][@"goodsAttrName"] != nil && ![_goodlist[indexPath.row][@"goodsAttrName"] isKindOfClass:[NSNull class]]) {
            cell.goodsAttrName.text = _goodlist[indexPath.row][@"goodsAttrName"];
        }
        else
            cell.goodsAttrName.text = @"";
        
        if (_goodlist[indexPath.row][@"goodsNums"] != nil && ![_goodlist[indexPath.row][@"goodsNums"] isKindOfClass:[NSNull class]]) {
            cell.goodsNums.text = [NSString stringWithFormat:@"%@%@", @"×", _goodlist[indexPath.row][@"goodsNums"]];
        }
        else
            cell.goodsAttrName.text = @"×0";
        
        if (_goodlist[indexPath.row][@"goodsPrice"] != nil && ![_goodlist[indexPath.row][@"goodsPrice"] isKindOfClass:[NSNull class]]) {
            cell.goodsPrice.text = [NSString stringWithFormat:@"%@%@", @"￥", _goodlist[indexPath.row][@"goodsPrice"]];
        }
        else
            cell.goodsPrice.text = @"￥0";
    }
    else if(indexPath.row == _goodlist.count){
        cell.goodsName.text = @"    餐盒费";
        cell.goodsAttrName.text = @"";
        cell.goodsNums.text = @"";
        cell.goodsPrice.text = [NSString stringWithFormat:@"%@%@", @"￥", _boxFee];
    }
    
    return cell;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
