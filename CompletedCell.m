//
//  CompletedCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "CompletedCell.h"
#import "goodListCell.h"

@interface CompletedCell()<UITableViewDelegate, UITableViewDataSource>

@end


@implementation CompletedCell

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

    [self.userName setTextColor:NAV_COLOR];
    [self.userPhone setTextColor:NAV_COLOR];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSLog(@"goodList = %lu",(unsigned long)_goodlist.count);
    return _goodlist.count + 2;
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
    else if (indexPath.row == _goodlist.count+1){
        cell.goodsName.text = @"    配送费";
        cell.goodsAttrName.text = @"";
        cell.goodsNums.text = @"";
        cell.goodsPrice.text = [NSString stringWithFormat:@"%@%@", @"￥",_dsm];
        
    }
    
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
