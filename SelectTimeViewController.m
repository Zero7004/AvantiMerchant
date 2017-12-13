//
//  SelectTimeViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/12.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*选择时间*//

#import "SelectTimeViewController.h"
#import "SelectTimeCell.h"

@interface SelectTimeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"阿凡提商家";
    [self initTableView];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectTimeCell" bundle:nil] forCellReuseIdentifier:@"SelectTimeCell"];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectTimeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SelectTimeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SelectTimeCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.time.text = [NSString stringWithFormat:@"%ld%@", (indexPath.row + 1) * 5,@"分钟"];
    
    if ([_time isEqualToString:cell.time.text]) {
        cell.img.hidden = NO;
    }
    else
        cell.img.hidden = YES;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectTimeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.block(cell.time.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
