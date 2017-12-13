//
//  ActiveTableViewCell.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/18.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ActiveTableViewCell.h"

@interface ActiveTableViewCell()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ActiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [Border_COLOR CGColor];
    
    [self.cancelBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [self.cancelBtn.layer setBorderWidth:1.0];
    
    if (SCREEN_WIDTH == 320) {
        _width01.constant = 5;
        _width02.constant = -5;
    }
    else if (SCREEN_WIDTH == 375){
        _width01.constant = 15;
        _width02.constant = -15;
    }
    else{
        _width01.constant = 30;
        _width02.constant = -30;
    }
    
    _goodsNameTableView.delegate = self;
    _goodsNameTableView.dataSource = self;
    self.goodsNameTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsNameTableView.scrollEnabled = NO;
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _goodsName.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 18;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 17)];
    if (_goodsName[indexPath.row] != nil && ![_goodsName[indexPath.row] isKindOfClass:[NSNull class]]) {
        goodsName.text = [NSString stringWithFormat:@"%@", _goodsName[indexPath.row]];
    }
    else{
        goodsName.text = @"--";
    }
    goodsName.textColor = [UIColor lightGrayColor];
    goodsName.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:goodsName];
    
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
