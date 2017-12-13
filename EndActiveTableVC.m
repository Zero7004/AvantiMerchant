//
//  EndActiveTableVC.m
//  AvantiMerchant
//
//  Created by Mac on 2017/9/8.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "EndActiveTableVC.h"
#import "EndActiveCell.h"

@interface EndActiveTableVC ()

@end

@implementation EndActiveTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EndActiveCell" bundle:nil] forCellReuseIdentifier:@"EndActiveCell"];

    self.tableView.separatorStyle = NO; //隐藏分割线

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *kj = [[NSArray alloc] init];
    NSArray *ms = [[NSArray alloc] init];
    NSArray *tg = [[NSArray alloc] init];
    NSArray *yjq = [[NSArray alloc] init];
    NSArray *zk = [[NSArray alloc] init];

    if (_activeList[@"kj"] != nil && ![_activeList[@"kj"] isKindOfClass:[NSNull class]]) {
        kj = _activeList[@"kj"];
    }
    if (_activeList[@"ms"] != nil && ![_activeList[@"ms"] isKindOfClass:[NSNull class]]) {
        ms = _activeList[@"ms"];
    }
    if (_activeList[@"tg"] != nil && ![_activeList[@"tg"] isKindOfClass:[NSNull class]]) {
        tg = _activeList[@"tg"];
    }
    if (_activeList[@"yjq"] != nil && ![_activeList[@"yjq"] isKindOfClass:[NSNull class]]) {
        yjq = _activeList[@"yjq"];
    }
    if (_activeList[@"zk"] != nil && ![_activeList[@"zk"] isKindOfClass:[NSNull class]]) {
        zk = _activeList[@"zk"];
    }

    return kj.count + ms.count + tg.count + yjq.count + zk.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EndActiveCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EndActiveCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[EndActiveCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EndActiveCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *kj = [[NSArray alloc] init];
    NSArray *ms = [[NSArray alloc] init];
    NSArray *tg = [[NSArray alloc] init];
    NSArray *yjq = [[NSArray alloc] init];
    NSArray *zk = [[NSArray alloc] init];
    
    if (_activeList[@"kj"] != nil && ![_activeList[@"kj"] isKindOfClass:[NSNull class]]) {
        kj = _activeList[@"kj"];
    }
    if (_activeList[@"ms"] != nil && ![_activeList[@"ms"] isKindOfClass:[NSNull class]]) {
        ms = _activeList[@"ms"];
    }
    if (_activeList[@"tg"] != nil && ![_activeList[@"tg"] isKindOfClass:[NSNull class]]) {
        tg = _activeList[@"tg"];
    }
    if (_activeList[@"yjq"] != nil && ![_activeList[@"yjq"] isKindOfClass:[NSNull class]]) {
        yjq = _activeList[@"yjq"];
    }
    if (_activeList[@"zk"] != nil && ![_activeList[@"zk"] isKindOfClass:[NSNull class]]) {
        zk = _activeList[@"zk"];
    }
    
    if (indexPath.row < kj.count) {
        NSInteger row = indexPath.row;
        if (kj[row][@"name"] != nil && ![kj[row][@"name"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", kj[row][@"name"]];
        }
        else
            cell.name.text = @"砍价活动";
        cell.activeType.text = @"砍价活动";
        if (kj[row][@"startTime"] != nil && ![kj[row][@"startTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", kj[row][@"startTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (kj[row][@"endTime"] != nil && ![kj[row][@"endTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", kj[row][@"endTime"]];
        }
        else
            cell.validEndTime.text = @"";


    }else if (indexPath.row < kj.count + ms.count){
        NSInteger row = indexPath.row - kj.count;
        if (ms[row][@"name"] != nil && ![ms[row][@"name"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", ms[row][@"name"]];
        }
        else
            cell.name.text = @"满减活动";
        cell.activeType.text = @"满减活动";
        if (ms[row][@"startTime"] != nil && ![ms[row][@"startTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", ms[row][@"startTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (ms[row][@"endTime"] != nil && ![ms[row][@"endTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", ms[row][@"endTime"]];
        }
        else
            cell.validEndTime.text = @"";

    }else if (indexPath.row < kj.count + ms.count + tg.count){
        NSInteger row = indexPath.row - kj.count - ms.count;
        if (tg[row][@"name"] != nil && ![tg[row][@"name"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", tg[row][@"name"]];
        }
        else
            cell.name.text = @"团购活动";
        cell.activeType.text = @"团购活动";
        if (tg[row][@"startTime"] != nil && ![tg[row][@"startTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", tg[row][@"startTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (tg[row][@"endTime"] != nil && ![tg[row][@"endTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", tg[row][@"endTime"]];
        }
        else
            cell.validEndTime.text = @"";

    }else if (indexPath.row < kj.count + ms.count + tg.count + yjq.count){
        NSInteger row = indexPath.row - kj.count - ms.count - tg.count;
        if (yjq[row][@"name"] != nil && ![yjq[row][@"name"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", yjq[row][@"name"]];
        }
        else
            cell.name.text = @"优惠卷活动";
        cell.activeType.text = @"优惠卷活动";
        if (yjq[row][@"sendStartTime"] != nil && ![yjq[row][@"sendStartTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", yjq[row][@"sendStartTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (yjq[row][@"sendEndTime"] != nil && ![yjq[row][@"sendEndTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", yjq[row][@"sendEndTime"]];
        }
        else
            cell.validEndTime.text = @"";

    }else{
        NSInteger row = indexPath.row - kj.count - ms.count - tg.count - yjq.count;
        if (zk[row][@"name"] != nil && ![zk[row][@"name"] isKindOfClass:[NSNull class]]) {
            cell.name.text = [NSString stringWithFormat:@"%@", zk[row][@"name"]];
        }
        else
            cell.name.text = @"折扣活动";
        cell.activeType.text = @"折扣活动";
        if (zk[row][@"startTime"] != nil && ![zk[row][@"startTime"] isKindOfClass:[NSNull class]]) {
            cell.validStartTime.text = [NSString stringWithFormat:@"%@", zk[row][@"startTime"]];
        }
        else
            cell.validStartTime.text = @"";
        
        if (zk[row][@"endTime"] != nil && ![zk[row][@"endTime"] isKindOfClass:[NSNull class]]) {
            cell.validEndTime.text = [NSString stringWithFormat:@"%@", zk[row][@"endTime"]];
        }
        else
            cell.validEndTime.text = @"";

    }

    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
