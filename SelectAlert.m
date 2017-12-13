//
//  SelectAlert.m
//  LearningTreasure
//
//  Created by 陈德锋 on 16/01/11.
//  Copyright © 2016年 陈德锋. All rights reserved.

#import "SelectAlert.h"

@interface SelectAlertCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SelectAlertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end


@interface SelectAlert ()

@property (nonatomic, assign) BOOL showCloseButton;//是否显示关闭按钮
@property (nonatomic, strong) UIView *alertView;//弹框视图
@property (nonatomic, strong) UITableView *selectTableView;//选择列表

@end

@implementation SelectAlert
{
    float alertHeight;//弹框整体高度，默认200
}

+ (SelectAlert *)showWithTitle:(NSString *)title
                        titles:(NSArray *)titles
                   selectIndex:(SelectIndex)selectIndex
                   selectValue:(SelectValue)selectValue
               showCloseButton:(BOOL)showCloseButton {
    SelectAlert *alert = [[SelectAlert alloc] initWithTitle:title titles:titles selectIndex:selectIndex selectValue:selectValue showCloseButton:showCloseButton];
    return alert;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];

    }
    return _alertView;
}

- (UITableView *)selectTableView {
    if (!_selectTableView) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
    }
    return _selectTableView;
}

- (instancetype)initWithTitle:(NSString *)title titles:(NSArray *)titles selectIndex:(SelectIndex)selectIndex selectValue:(SelectValue)selectValue showCloseButton:(BOOL)showCloseButton {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        if (titles.count <= 8) {
            alertHeight = 50 * titles.count;
        }
        else{
            alertHeight = 50 * 8;
        }
        
        self.titleLabel.text = title;
        _titles = titles;
        _selectIndex = [selectIndex copy];
        _selectValue = [selectValue copy];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.selectTableView];

        [self initUI];
        
        [self show];
    }
    return self;
}

- (void)show {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.alertView.alpha = 1;
    }];
}

- (void)initUI {
    self.alertView.frame = CGRectMake(50, ([UIScreen mainScreen].bounds.size.height-alertHeight)/2.0 - 50, [UIScreen mainScreen].bounds.size.width-100, alertHeight);
    self.alertView.layer.cornerRadius = 5;
    self.alertView.layer.masksToBounds = YES;
    self.selectTableView.frame = CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height);
}


#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    float real = (alertHeight - 40)/(float)_titles.count;
//    return real<=40?40:real;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectcell"];
    if (!cell) {
        cell = [[SelectAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectcell"];
    }
//    NSDictionary *dic = _titles[indexPath.row];
//    cell.titleLabel.text = [NSString stringWithFormat: @"%@", dic[@"name"]];
    
    if ([_titleLabel.text isEqualToString:@"菜单"]) {
        if (_titles[indexPath.row][@"catName"] != nil && ![_titles[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
            cell.titleLabel.text = [NSString stringWithFormat: @"%@", _titles[indexPath.row][@"catName"]];
        }
        else
            cell.titleLabel.text = @"";

    }
    else{
        if (_titles[indexPath.row][@"language"] != nil && ![_titles[indexPath.row][@"language"] isKindOfClass:[NSNull class]]) {
            cell.titleLabel.text = [NSString stringWithFormat: @"%@", _titles[indexPath.row][@"language"]];
        }
        else
            cell.titleLabel.text = @"";
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dic = _titles[indexPath.row];
    if (self.selectIndex) {
        self.selectIndex(indexPath.row);
    }
    if (self.selectValue) {
//        self.selectValue([NSString stringWithFormat: @"%@", dic[@"name"]]);
        if ([_titleLabel.text isEqualToString:@"菜单"]) {
            self.selectValue([NSString stringWithFormat: @"%@", _titles[indexPath.row][@"catName"]]);
        }
        else{
            self.selectValue([NSString stringWithFormat: @"%@", _titles[indexPath.row][@"language"]]);
        }
    }
    
    [self closeAction];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.block();
    
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.alertView frame], pt) && !_showCloseButton) {
        [self closeAction];
    }
}

- (void)closeAction {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
//    NSLog(@"SelectAlert被销毁了");
}

@end
