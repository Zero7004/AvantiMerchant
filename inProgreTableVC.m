//
//  inProgreTableVC.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "inProgreTableVC.h"
#import "inProgreTableVCCell.h"
#import "inProgreCell.h"
#import "ActiveTableViewCell.h"

@interface inProgreTableVC ()


@end

@implementation inProgreTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"inProgreTableVCCell" bundle:nil] forCellReuseIdentifier:@"inProgreTableVCCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"inProgreCell" bundle:nil] forCellReuseIdentifier:@"inProgreCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActiveTableViewCell"];

    self.tableView.separatorStyle = NO; //隐藏分割线


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *conList = [[NSArray alloc] init];
    NSArray *bargain = [[NSArray alloc] init];
    NSArray *seckill = [[NSArray alloc] init];
    NSArray *tk = [[NSArray alloc] init];
    NSArray *zk = [[NSArray alloc] init];

    if (_activeList[@"coupon"] != nil && ![_activeList[@"coupon"] isKindOfClass:[NSNull class]]) {
        conList = _activeList[@"coupon"];
    }
    if (_activeList[@"bargain"] != nil && ![_activeList[@"bargain"] isKindOfClass:[NSNull class]]) {
        bargain = _activeList[@"bargain"];
    }
    if (_activeList[@"seckill"] != nil && ![_activeList[@"seckill"] isKindOfClass:[NSNull class]]) {
        seckill = _activeList[@"seckill"];
    }
    if (_activeList[@"tk"] != nil && ![_activeList[@"tk"] isKindOfClass:[NSNull class]]) {
        tk = _activeList[@"tk"];
    }
    if (_activeList[@"zk"] != nil && ![_activeList[@"zk"] isKindOfClass:[NSNull class]]) {
        zk = _activeList[@"zk"];
    }

    if (indexPath.row < conList.count) {
        return 365;
    }
    else if (indexPath.row < conList.count + bargain.count + seckill.count){
        return 365 + 27;
    }
    else if(indexPath.row < conList.count + bargain.count + seckill.count + tk.count){
        //团购活动   需要计算高度
        NSInteger row = indexPath.row - conList.count - bargain.count - seckill.count;
        NSArray *goods = [[NSArray alloc] init];
        goods = tk[row][@"goodsName"];
        return 375 + 17 * goods.count;
    }
    else if (indexPath.row < conList.count + bargain.count + seckill.count + tk.count + zk.count){
        return 332;
    }
    else if (indexPath.row == conList.count + bargain.count + seckill.count + tk.count + zk.count){
        if (_activeList[@"mj"] != nil && ![_activeList[@"mj"] isKindOfClass:[NSNull class]]) {
            return 295;
        }
        else
            return 0;
    }
    else{
        if (_activeList[@"newCou"] != nil && ![_activeList[@"newCou"] isKindOfClass:[NSNull class]]) {
            if ([_activeList[@"newCou"][@"newCou"] isKindOfClass:[NSNull class]] || [_activeList[@"newCou"][@"newCou"] isEqualToString:@"0"]) {
                return 0;
            }
            else{
                return 295;
            }
        }
        else
            return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //根据数据格式计算返回的个数
    NSInteger rows = 0;
    NSArray *conList = [[NSArray alloc] init];
    NSArray *bargain = [[NSArray alloc] init];
    NSArray *seckill = [[NSArray alloc] init];
    NSArray *tk = [[NSArray alloc] init];
    NSArray *zk = [[NSArray alloc] init];

    if (_activeList[@"coupon"] != nil && ![_activeList[@"coupon"] isKindOfClass:[NSNull class]]) {
        conList = _activeList[@"coupon"];
    }
    if (_activeList[@"bargain"] != nil && ![_activeList[@"bargain"] isKindOfClass:[NSNull class]]) {
        bargain = _activeList[@"bargain"];
    }
    if (_activeList[@"seckill"] != nil && ![_activeList[@"seckill"] isKindOfClass:[NSNull class]]) {
        seckill = _activeList[@"seckill"];
    }
    if (_activeList[@"tk"] != nil && ![_activeList[@"tk"] isKindOfClass:[NSNull class]]) {
        tk = _activeList[@"tk"];
    }
    if (_activeList[@"zk"] != nil && ![_activeList[@"zk"] isKindOfClass:[NSNull class]]) {
        zk = _activeList[@"zk"];
    }


    rows = conList.count + bargain.count + seckill.count + tk.count + zk.count + 2 ;
    return rows;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSArray *conList = [[NSArray alloc] init];
    NSArray *bargain = [[NSArray alloc] init];
    NSArray *seckill = [[NSArray alloc] init];
    NSArray *tk = [[NSArray alloc] init];
    NSArray *zk = [[NSArray alloc] init];

    if (_activeList[@"coupon"] != nil && ![_activeList[@"coupon"] isKindOfClass:[NSNull class]]) {
        conList = _activeList[@"coupon"];
    }
    if (_activeList[@"bargain"] != nil && ![_activeList[@"bargain"] isKindOfClass:[NSNull class]]) {
        bargain = _activeList[@"bargain"];
    }
    if (_activeList[@"seckill"] != nil && ![_activeList[@"seckill"] isKindOfClass:[NSNull class]]) {
        seckill = _activeList[@"seckill"];
    }
    if (_activeList[@"tk"] != nil && ![_activeList[@"tk"] isKindOfClass:[NSNull class]]) {
        tk = _activeList[@"tk"];
    }
    if (_activeList[@"zk"] != nil && ![_activeList[@"zk"] isKindOfClass:[NSNull class]]) {
        zk = _activeList[@"zk"];
    }


    if (indexPath.row < conList.count) {
        inProgreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inProgreCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[inProgreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inProgreCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name.text = @"商家优惠券";
        
        if (conList[indexPath.row][@"days"] != nil && ![conList[indexPath.row][@"days"] isKindOfClass:[NSNull class]]) {
            cell.state.text = [NSString stringWithFormat:@"%@%@", conList[indexPath.row][@"days"], @"天"];
        }
        else
            cell.state.text = @"--天";
        
        if (conList[indexPath.row][@"allCount"] != nil && ![conList[indexPath.row][@"allCount"] isKindOfClass:[NSNull class]]) {
            cell.allCount.text = [NSString stringWithFormat:@"%@", conList[indexPath.row][@"allCount"]];
        }
        else
            cell.allCount.text = @"0";
        
        if (conList[indexPath.row][@"allPay"] != nil && ![conList[indexPath.row][@"allPay"] isKindOfClass:[NSNull class]]) {
            cell.allPay.text = [NSString stringWithFormat:@"%@", conList[indexPath.row][@"allPay"]];
        }
        else
            cell.allPay.text = @"0";
        
        if (conList[indexPath.row][@"lastCount"] != nil && ![conList[indexPath.row][@"lastCount"] isKindOfClass:[NSNull class]]) {
            cell.lastCount.text = [NSString stringWithFormat:@"%@", conList[indexPath.row][@"lastCount"]];
        }
        else
            cell.lastCount.text = @"0";
        
        if (conList[indexPath.row][@"lastPay"] != nil && ![conList[indexPath.row][@"lastPay"] isKindOfClass:[NSNull class]]) {
            cell.lastPay.text = [NSString stringWithFormat:@"%@", conList[indexPath.row][@"lastPay"]];
        }
        else
            cell.lastPay.text = @"0";
        
        cell.activeType.text = @"商家优惠卷 ";

        if (conList[indexPath.row][@"couponMoney"] != nil && ![conList[indexPath.row][@"couponMoney"] isKindOfClass:[NSNull class]] && conList[indexPath.row][@"spendMoney"] != nil && ![conList[indexPath.row][@"spendMoney"] isKindOfClass:[NSNull class]]) {
            cell.activeRule.text = [NSString stringWithFormat:@"%@%@%@%@%@", @"满",conList[indexPath.row][@"couponMoney"], @"减", conList[indexPath.row][@"spendMoney"], @"优惠券"];
        }
        else
            cell.activeRule.text = @"";
        
        if (conList[indexPath.row][@"validStartTime"] != nil && ![conList[indexPath.row][@"validStartTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", conList[indexPath.row][@"validStartTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (conList[indexPath.row][@"validEndTime"] != nil && ![conList[indexPath.row][@"validEndTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", conList[indexPath.row][@"validEndTime"]];
        }
        else
            cell.validEndTime.text = @"";
        
        [cell.cancelBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        cell.goodsName.hidden = YES;
        cell.cancelBtn.tag = indexPath.row + 10000;
        [cell.cancelBtn addTarget:self action:@selector(shangjiayouhuiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    else if (indexPath.row < conList.count + bargain.count){
        inProgreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inProgreCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[inProgreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inProgreCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger row = indexPath.row - conList.count;
        
        if (bargain[row][@"name"] != nil && ![bargain[row][@"name"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", bargain[row][@"name"]];
        }
        else
            cell.name.text = @"砍价活动";

        cell.state.text = @"";
        cell.activeStste.text = @"进行中";
        
        if (bargain[row][@"allCount"] != nil && ![bargain[row][@"allCount"] isKindOfClass:[NSNull class]]) {
            cell.allCount.text = [NSString stringWithFormat:@"%@", bargain[row][@"allCount"]];
        }
        else
            cell.allCount.text = @"0";
        
        if (bargain[row][@"allPay"] != nil && ![bargain[row][@"allPay"] isKindOfClass:[NSNull class]]) {
            cell.allPay.text = [NSString stringWithFormat:@"%@", bargain[row][@"allPay"]];
        }
        else
            cell.allPay.text = @"0";
        
        if (bargain[row][@"lastCount"] != nil && ![bargain[row][@"lastCount"] isKindOfClass:[NSNull class]]) {
            cell.lastCount.text = [NSString stringWithFormat:@"%@", bargain[row][@"lastCount"]];
        }
        else
            cell.lastCount.text = @"0";
        
        if (bargain[row][@"lastPay"] != nil && ![bargain[row][@"lastPay"] isKindOfClass:[NSNull class]]) {
            cell.lastPay.text = [NSString stringWithFormat:@"%@", bargain[row][@"lastPay"]];
        }
        else
            cell.lastPay.text = @"0";
        
        cell.activeType.text = @"砍价活动 ";
        
        cell.activeRule.text = @"砍价活动的商品不享受其他优惠活动";

        
        if (bargain[row][@"startTime"] != nil && ![bargain[row][@"startTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", bargain[row][@"startTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (bargain[row][@"endTime"] != nil && ![bargain[row][@"endTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", bargain[row][@"endTime"]];
        }
        else
            cell.validEndTime.text = @"";
        
        cell.goodsName.hidden = NO;
        if (bargain[row][@"goodsName"] != nil && ![bargain[row][@"goodsName"] isKindOfClass:[NSNull class]]) {
            cell.goodsName.text = [NSString stringWithFormat:@"%@%@", @"活动商品：", bargain[row][@"goodsName"][0]];
        }
        else
            cell.goodsName.text = @"活动商品：";

        [cell.cancelBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        cell.cancelBtn.tag = row + 20000;
        [cell.cancelBtn addTarget:self action:@selector(kanjiaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    else if (indexPath.row < conList.count + bargain.count + seckill.count){
        inProgreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inProgreCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[inProgreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inProgreCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger row = indexPath.row - conList.count - bargain.count;
        
        if (seckill[row][@"name"] != nil && ![seckill[row][@"name"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", seckill[row][@"name"]];
        }
        else
            cell.name.text = @"秒杀活动";
        
        
        cell.state.text = @"";
        cell.activeStste.text = @"进行中";
        
        if (seckill[row][@"allCount"] != nil && ![seckill[row][@"allCount"] isKindOfClass:[NSNull class]]) {
            cell.allCount.text = [NSString stringWithFormat:@"%@", seckill[row][@"allCount"]];
        }
        else
            cell.allCount.text = @"0";
        
        if (seckill[row][@"allPay"] != nil && ![seckill[row][@"allPay"] isKindOfClass:[NSNull class]]) {
            cell.allPay.text = [NSString stringWithFormat:@"%@", seckill[row][@"allPay"]];
        }
        else
            cell.allPay.text = @"0";
        
        if (seckill[row][@"lastCount"] != nil && ![seckill[row][@"lastCount"] isKindOfClass:[NSNull class]]) {
            cell.lastCount.text = [NSString stringWithFormat:@"%@", seckill[row][@"lastCount"]];
        }
        else
            cell.lastCount.text = @"0";
        
        if (seckill[row][@"lastPay"] != nil && ![seckill[row][@"lastPay"] isKindOfClass:[NSNull class]]) {
            cell.lastPay.text = [NSString stringWithFormat:@"%@", seckill[row][@"lastPay"]];
        }
        else
            cell.lastPay.text = @"0";
        
        cell.activeType.text = @"秒杀活动 ";
        
        cell.activeRule.text = @"秒杀活动的商品不享受其他优惠活动";
        
        
        if (seckill[row][@"startTime"] != nil && ![seckill[row][@"startTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", seckill[row][@"startTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (seckill[row][@"endTime"] != nil && ![seckill[row][@"endTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", seckill[row][@"endTime"]];
        }
        else
            cell.validEndTime.text = @"";
        
        cell.goodsName.hidden = NO;
        if (seckill[row][@"goodsName"] != nil && ![seckill[row][@"goodsName"] isKindOfClass:[NSNull class]]) {
            cell.goodsName.text = [NSString stringWithFormat:@"%@%@", @"活动商品：", seckill[row][@"goodsName"][0]];
        }
        else
            cell.goodsName.text = @"活动商品：";

        [cell.cancelBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        cell.cancelBtn.tag = row + 30000;
        [cell.cancelBtn addTarget:self action:@selector(miaoshaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    else if (indexPath.row < conList.count + bargain.count + seckill.count + tk.count){
        ActiveTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ActiveTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ActiveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ActiveTableViewCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger row = indexPath.row - conList.count - bargain.count - seckill.count;
        
        if (tk[row][@"groupName"] != nil && ![tk[row][@"groupName"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", tk[row][@"groupName"]];
        }
        else
            cell.name.text = @"团购商品活动";

        cell.activeStste.text = @"进行中";
        
        if (tk[row][@"allCount"] != nil && ![tk[row][@"allCount"] isKindOfClass:[NSNull class]]) {
            cell.allCount.text = [NSString stringWithFormat:@"%@", tk[row][@"allCount"]];
        }
        else
            cell.allCount.text = @"0";
        
        if (tk[row][@"allPay"] != nil && ![tk[row][@"allPay"] isKindOfClass:[NSNull class]]) {
            cell.allPay.text = [NSString stringWithFormat:@"%@", tk[row][@"allPay"]];
        }
        else
            cell.allPay.text = @"0";
        
        if (tk[row][@"lastCount"] != nil && ![tk[row][@"lastCount"] isKindOfClass:[NSNull class]]) {
            cell.lastCount.text = [NSString stringWithFormat:@"%@",tk[row][@"lastCount"]];
        }
        else
            cell.lastCount.text = @"0";
        
        if (tk[row][@"lastPay"] != nil && ![tk[row][@"lastPay"] isKindOfClass:[NSNull class]]) {
            cell.lastPay.text = [NSString stringWithFormat:@"%@",tk[row][@"lastPay"]];
        }
        else
            cell.lastPay.text = @"0";
        
        cell.activeType.text = @"团购商品活动";
        
        cell.activeRule.text = @"团购的商品不享受其他优惠活动";
        
        if (tk[row][@"startTime"] != nil && ![tk[row][@"startTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", tk[row][@"startTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (tk[row][@"endTime"] != nil && ![tk[row][@"endTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", tk[row][@"endTime"]];
        }
        else
            cell.validEndTime.text = @"";
        
        [cell.cancelBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        cell.cancelBtn.tag = row + 40000;
        [cell.cancelBtn addTarget:self action:@selector(tkCheckBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //添加商品信息
        NSArray *goods = [[NSArray alloc] init];
        goods = tk[row][@"goodsName"];
        cell.goodsName = goods;
        [cell.goodsNameTableView reloadData];
        cell.TableViewHeight.constant = 18 * goods.count;
        
        return cell;
    }
    else if (indexPath.row < conList.count + bargain.count + seckill.count + tk.count + zk.count){
        inProgreTableVCCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inProgreTableVCCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[inProgreTableVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inProgreTableVCCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSInteger row = indexPath.row - conList.count - bargain.count - seckill.count - tk.count;

        cell.name.text = @"折扣商品活动";
        cell.state.text = @"进行中";
        
        if (zk[row][@"allCount"] != nil && ![zk[row][@"allCount"] isKindOfClass:[NSNull class]]) {
            cell.allCount.text = [NSString stringWithFormat:@"%@", zk[row][@"allCount"]];
        }
        else
            cell.allCount.text = @"0";
        
        if (zk[row][@"allPay"] != nil && ![zk[row][@"allPay"] isKindOfClass:[NSNull class]]) {
            cell.allPay.text = [NSString stringWithFormat:@"%@", zk[row][@"allPay"]];
        }
        else
            cell.allPay.text = @"0";
        
        if (zk[row][@"lastCount"] != nil && ![zk[row][@"lastCount"] isKindOfClass:[NSNull class]]) {
            cell.lastCount.text = [NSString stringWithFormat:@"%@", zk[row][@"lastCount"]];
        }
        else
            cell.lastCount.text = @"0";
        
        if (zk[row][@"lastPay"] != nil && ![zk[row][@"lastPay"] isKindOfClass:[NSNull class]]) {
            cell.lastPay.text = [NSString stringWithFormat:@"%@", zk[row][@"lastPay"]];
        }
        else
            cell.lastPay.text = @"0";
        
        cell.activeType.text = @"折扣商品活动";
        
        cell.activeRule.text = @"折扣的商品不享受其他优惠活动";
        
        cell.goodsName.hidden = NO;
        if (zk[row][@"goodsName"] != nil && ![zk[row][@"goodsName"] isKindOfClass:[NSNull class]]) {
            cell.goodsName.text = [NSString stringWithFormat:@"%@%@", @"活动商品：", zk[row][@"goodsName"][0]];
        }
        else
            cell.goodsName.text = @"活动商品：";

        cell.checkDetailsBtn.hidden = YES;
        cell.cancelBtn.hidden = NO;
        [cell.cancelBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        cell.cancelBtn.tag = row + 50000;
        [cell.cancelBtn addTarget:self action:@selector(zkCheckBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    else if(indexPath.row == conList.count + bargain.count + seckill.count + tk.count + zk.count){
        if (_activeList[@"mj"] != nil && ![_activeList[@"mj"] isKindOfClass:[NSNull class]]) {
            inProgreTableVCCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inProgreTableVCCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[inProgreTableVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inProgreTableVCCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.name.text = @"满减活动";
            cell.state.text = @"进行中";
            
            if (_activeList[@"mj"][@"allCount"] != nil && ![_activeList[@"mj"][@"allCount"] isKindOfClass:[NSNull class]]) {
                cell.allCount.text = [NSString stringWithFormat:@"%@", _activeList[@"mj"][@"allCount"]];
            }
            else
                cell.allCount.text = @"0";
            
            if (_activeList[@"mj"][@"allPay"] != nil && ![_activeList[@"mj"][@"allPay"] isKindOfClass:[NSNull class]]) {
                cell.allPay.text = [NSString stringWithFormat:@"%@", _activeList[@"mj"][@"allPay"]];
            }
            else
                cell.allPay.text = @"0";
            
            if (_activeList[@"mj"][@"lastCount"] != nil && ![_activeList[@"mj"][@"lastCount"] isKindOfClass:[NSNull class]]) {
                cell.lastCount.text = [NSString stringWithFormat:@"%@", _activeList[@"mj"][@"lastCount"]];
            }
            else
                cell.lastCount.text = @"0";
            
            if (_activeList[@"mj"][@"lastPay"] != nil && ![_activeList[@"mj"][@"lastPay"] isKindOfClass:[NSNull class]]) {
                cell.lastPay.text = [NSString stringWithFormat:@"%@", _activeList[@"mj"][@"lastPay"]];
            }
            else
                cell.lastPay.text = @"0";
            
            cell.activeType.text = @"减满活动";
            
            if (_activeList[@"mj"][@"youhui"] != nil && ![_activeList[@"mj"][@"youhui"] isKindOfClass:[NSNull class]]) {
                cell.activeRule.text = [NSString stringWithFormat:@"%@", _activeList[@"mj"][@"youhui"]];
            }
            else
                cell.activeRule.text = @"0";
            
            cell.goodsName.hidden = YES;
            
            cell.checkDetailsBtn.hidden = YES;
            [cell.cancelBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            cell.cancelBtn.hidden = NO;
            [cell.cancelBtn addTarget:self action:@selector(mjCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;

        }
        else{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
            return cell;
        }

    }
    else if (indexPath.row == conList.count + bargain.count + seckill.count + tk.count + zk.count + 1){
        if (_activeList[@"newCou"] != nil && ![_activeList[@"newCou"] isKindOfClass:[NSNull class]]) {
            
            if ([_activeList[@"newCou"][@"newCou"] isKindOfClass:[NSNull class]] || [_activeList[@"newCou"][@"newCou"] isEqualToString:@"0"]) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
                return cell;
            }

            inProgreTableVCCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"inProgreTableVCCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[inProgreTableVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"inProgreTableVCCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.name.text = @"新用户立减";
            cell.state.text = @"进行中";
            
            if (_activeList[@"newCou"][@"allCount"] != nil && ![_activeList[@"newCou"][@"allCount"] isKindOfClass:[NSNull class]]) {
                cell.allCount.text = [NSString stringWithFormat:@"%@", _activeList[@"newCou"][@"allCount"]];
            }
            else
                cell.allCount.text = @"0";
            
            if (_activeList[@"newCou"][@"allPay"] != nil && ![_activeList[@"newCou"][@"allPay"] isKindOfClass:[NSNull class]]) {
                cell.allPay.text = [NSString stringWithFormat:@"%@", _activeList[@"newCou"][@"allPay"]];
            }
            else
                cell.allPay.text = @"0";
            
            if (_activeList[@"newCou"][@"lastCount"] != nil && ![_activeList[@"newCou"][@"lastCount"] isKindOfClass:[NSNull class]]) {
                cell.lastCount.text = [NSString stringWithFormat:@"%@", _activeList[@"newCou"][@"lastCount"]];
            }
            else
                cell.lastCount.text = @"0";
            
            if (_activeList[@"newCou"][@"lastPay"] != nil && ![_activeList[@"newCou"][@"lastPay"] isKindOfClass:[NSNull class]]) {
                cell.lastPay.text = [NSString stringWithFormat:@"%@", _activeList[@"newCou"][@"lastPay"]];
            }
            else
                cell.lastPay.text = @"0";
            
            cell.activeType.text = @"新用户立减";
            
            if (_activeList[@"newCou"][@"newCou"] != nil && ![_activeList[@"newCou"][@"newCou"] isKindOfClass:[NSNull class]]) {
                cell.activeRule.text = [NSString stringWithFormat:@"%@%@%@", @"新用户立减首单立减", _activeList[@"newCou"][@"newCou"], @"元"];
            }
            else
                cell.activeRule.text = @"新用户立减首单立减--元";
            
            cell.goodsName.hidden = YES;
            
            cell.checkDetailsBtn.hidden = YES;
            [cell.cancelBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            cell.cancelBtn.hidden = NO;
            [cell.cancelBtn addTarget:self action:@selector(newCouCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        else{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
            return cell;
        }
        
    }
    
    return cell;

}


//撤销商家优惠券
-(void)shangjiayouhuiBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSArray *conList = _activeList[@"coupon"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销该活动？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        NSString *url = [API stringByAppendingString:@"AdminShop/closeCoupon"];
        NSDictionary *dic = @{@"id":conList[btn.tag - 10000][@"couponId"]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"撤销优惠券 %@", responseObject);
            if (responseObject != nil) {
                NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopEndActivity" object:nil];
                }
                else{
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                }

             }
            else{
                [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"撤销优惠券失败 %@", error);
            [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"网络连接异常"];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//撤销砍价活动
-(void)kanjiaBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;

    NSMutableArray *bargain = [NSMutableArray array];
    bargain = _activeList[@"bargain"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销该活动？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/closeBargain"];
        NSDictionary *dic = @{@"id":bargain[btn.tag - 20000][@"id"], @"shopId":[AppDelegate APP].user.shopId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"撤销砍价活动 %@", responseObject);
            if (responseObject != nil) {
                NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopEndActivity" object:nil];
                }
                else{
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                }
            }
            else{
                [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"撤销砍价活动失败 %@", error);
            [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"网络连接异常"];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}

//撤销秒杀活动
-(void)miaoshaBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
   
    NSArray *seckill = _activeList[@"seckill"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销该活动？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [API stringByAppendingString:@"AdminShop/closeSeckill"];
        NSDictionary *dic = @{@"id":seckill[btn.tag - 30000][@"id"], @"shopId":[AppDelegate APP].user.shopId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"撤销秒杀活动 %@", responseObject);
            if (responseObject != nil) {
                NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopEndActivity" object:nil];
                }
                else{
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                }
            }
            else{
                [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"撤销秒杀失败 %@", error);
            [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"网络连接异常"];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}


//撤销团购
-(void)tkCheckBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSArray *tk = _activeList[@"tk"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销该活动？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/closeGroups"];
        NSDictionary *dic = @{@"groupId":tk[btn.tag - 40000][@"groupId"], @"shopId":[AppDelegate APP].user.shopId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"撤销团购活动 %@", responseObject);
            if (responseObject != nil) {
                NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopEndActivity" object:nil];
                }
                else{
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                }
            }
            else{
                [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"撤销团购活动失败 %@", error);
            [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"网络连接异常"];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


//撤销满减活动
-(void)mjCancelBtnClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销该活动？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/closeMj"];
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"撤销满减 %@", responseObject);
            if (responseObject != nil) {
                NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopEndActivity" object:nil];
                }
                else{
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                }
            }
            else{
                [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"撤销优满减失败 %@", error);
            [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"网络连接异常"];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}


//撤销新用户立减活动
-(void)newCouCancelBtnClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销该活动？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/closeLj"];
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"撤销新客立减 %@", responseObject);
            if (responseObject != nil) {
                NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopEndActivity" object:nil];
                }
                else{
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                }
            }
            else{
                [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"撤销新客立减失败 %@", error);
            [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"网络连接异常"];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];


}





//撤销折扣活动
-(void)zkCheckBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSArray *zk = _activeList[@"zk"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定撤销该活动？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [API_ReImg stringByAppendingString:@"AdminShop/closeDiscount"];
        NSDictionary *dic = @{@"id":zk[btn.tag - 50000][@"id"], @"shopId":[AppDelegate APP].user.shopId};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"撤销折扣活动 %@", responseObject);
            if (responseObject != nil) {
                NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
                if ([res isEqualToString:@"1"]) {
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopActivity" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getShopEndActivity" object:nil];
                }
                else{
                    [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                }
                
            }
            else{
                [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"活动撤销失败"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"撤销折扣活动失败 %@", error);
            [Util toastWithView:[UIApplication sharedApplication].keyWindow AndText:@"网络连接异常"];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
