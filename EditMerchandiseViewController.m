//
//  EditMerchandiseViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//


//**商品--排序&批量操作**//


#import "EditMerchandiseViewController.h"
#import "OperationCell.h"
#import "SelectAlert.h"

@interface EditMerchandiseViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *titleImg;
@property (strong, nonatomic) UIImageView *allSelectImg;
@property (strong, nonatomic) UIButton *selectTitelBtn;

@property (strong, nonatomic) NSMutableArray *orderDistop;    //语言下--菜单下--商品列表
@property (strong, nonatomic) NSMutableArray *sequenceList;     //顺序标记数组

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *senderBtn;

@property BOOL isAllSelect;      //是否全选
@property BOOL isSelectTitel;    //是否选择菜单
@property BOOL isChange;     //是否修改，是否保存


@end

@implementation EditMerchandiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isAllSelect = NO;
    _isSelectTitel = NO;
    _isChange = NO;
    _orderDistop = [[NSMutableArray alloc] init];
    _sequenceList = [[NSMutableArray alloc] init];
    
    [self initTableView];
    [self initTopView];
    [self initFooterView];
    [self initTopBtn];

    //获取全部数据
//    [self postGetAllSeeOrder];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self postGetAllSeeOrder];
}

-(void)initTopBtn{
    //添加返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.bounds = CGRectMake(0, 0, 40, 40);
    _backBtn.imageView.contentMode = UIViewContentModeLeft;
    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    //保存按钮
    _senderBtn = [[UIButton alloc] init];
    _senderBtn.bounds = CGRectMake(0, 0, 50, 40);
    [_senderBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _senderBtn.hidden = NO;
    [_senderBtn addTarget:self action:@selector(senderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *senderBtn = [[UIBarButtonItem alloc] initWithCustomView:_senderBtn];
    self.navigationItem.rightBarButtonItem = senderBtn;
}


-(void)initTopView{
//    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    _topView.layer.borderWidth = 1;
//    _topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _topView.layer.cornerRadius = 2;
//    
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 30)];
//    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
//    _titleLabel.textColor = [UIColor whiteColor];
    
    //重新计算宽度
//    _titleLabel.frame = CGRectMake(10, 0, titleLableWidth + 5, 30);
//    _topView.frame = CGRectMake(0, 0, _titleLabel.frame.size.width + 30, 30);
    
//    _titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(_topView.frame.size.width - 25, 5, 20, 20)];
//    _titleImg.image = [UIImage imageNamed:@"向下实心箭头"];
    
    _selectTitelBtn = [[UIButton alloc] init];
    _selectTitelBtn.frame = CGRectMake(0, 0, 80, 30);
    _selectTitelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _selectTitelBtn.layer.borderWidth = 1;
    _selectTitelBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [_selectTitelBtn addTarget:self action:@selector(selectTitelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%@", _dishesList);
    //添加数据
    for (int i = 0; i < _dishesList.count; i++) {
        NSString *catId = [NSString stringWithFormat:@"%@", _dishesList[i][@"catId"]];
        if ([catId isEqualToString:_catId]) {
            if (_dishesList[i][@"catName"] != nil && ![_dishesList[i][@"catName"] isKindOfClass:[NSNull class]]) {
                [_selectTitelBtn setTitle:[NSString stringWithFormat:@"%@", _dishesList[i][@"catName"]] forState:UIControlStateNormal];
            }
            else
                [_selectTitelBtn setTitle:@"--" forState:UIControlStateNormal];
        }
    }
    //重新计算宽度
    CGFloat titleLableWidth = [Util getWidthWithTitle:_selectTitelBtn.titleLabel.text font:_selectTitelBtn.titleLabel.font];
    _selectTitelBtn.frame = CGRectMake(0, 0, titleLableWidth + 10, 30);

    self.navigationItem.titleView = _selectTitelBtn;
}


-(void)initFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 116, SCREEN_WIDTH, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLabel.backgroundColor = [UIColor lightGrayColor];
    
    for (int i = 0; i < 3; i++) {
        UILabel *line= [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * (i+1) - 1, 0, 1, 50)];
        line.backgroundColor = [UIColor lightGrayColor];
        [footerView addSubview:line];
    }
    
    
    _allSelectImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
    if (_isAllSelect) {
        _allSelectImg.image = [UIImage imageNamed:@"选中方块-1"];
    }
    else
        _allSelectImg.image = [UIImage imageNamed:@"方块未选-1"];
    UILabel *allSelLa = [[UILabel alloc] initWithFrame:CGRectMake(35, 12, 40, 25)];
    allSelLa.text = @"全部";
    UILabel *del = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4)*1 + SCREEN_WIDTH/8 - 18, 12, 40, 25)];
    del.text = @"删除";
    del.textColor = [UIColor redColor];
    UILabel *shangjia = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4)*2 + SCREEN_WIDTH/8 - 18, 12, 40, 25)];
    shangjia.text = @"上架";
    shangjia.textColor = Nav_color;
    UILabel *xiajia = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4)*3 + SCREEN_WIDTH/8 - 18, 12, 40, 25)];
    xiajia.text = @"下架";
    xiajia.textColor = Nav_color;
    
    for (int j = 0; j < 4; j++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * j, 0, SCREEN_WIDTH/4, 50)];
        btn.tag = j;
        [btn addTarget:self action:@selector(BootomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
    }

    
    [footerView addSubview:topLabel];
    [footerView addSubview:_allSelectImg];
    [footerView addSubview:allSelLa];
    [footerView addSubview:del];
    [footerView addSubview:shangjia];
    [footerView addSubview:xiajia];
    [self.view addSubview:footerView];
}



-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"OperationCell" bundle:nil] forCellReuseIdentifier:@"OperationCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    //开启编辑模式
    [self.tableView setEditing:YES animated:YES];
    // 允许在编辑模式进行多选操作
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *goodsName;
    if (_goodList[indexPath.row][@"goodsName"] != nil && ![_goodList[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
        goodsName = _goodList[indexPath.row][@"goodsName"];
    }
    else
        goodsName = @"--";
    
    return 80 + [Util countTextHeight:goodsName];}

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OperationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OperationCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[OperationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OperationCell"];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;  //这行代码会把选中效果屏蔽了，所以选中才没调用celll里面的layoutSubviews方法
    //去掉原本选中出现的蓝色背景效果
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    if (_goodList[indexPath.row][@"goodsName"] != nil && ![_goodList[indexPath.row][@"goodsName"] isKindOfClass:[NSNull class]]) {
        cell.goodsName.text = _goodList[indexPath.row][@"goodsName"];
    }
    else
        cell.goodsName.text = @"--";
    
    if (_goodList[indexPath.row][@"shopPrice"] != nil && ![_goodList[indexPath.row][@"shopPrice"] isKindOfClass:[NSNull class]]) {
        cell.shopPrice.text = [NSString stringWithFormat:@"%@%@", @"￥", _goodList[indexPath.row][@"shopPrice"]];
    }
    else
        cell.shopPrice.text = @"￥0.00";
    
    if (_goodList[indexPath.row][@"goodsThums"] != nil && ![_goodList[indexPath.row][@"goodsThums"] isKindOfClass:[NSNull class]]) {
        [cell.goodsThums sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_goodList[indexPath.row][@"goodsThums"]]] placeholderImage:[UIImage imageNamed:@"noimg"]];
    }
    else
        cell.goodsThums.image = [UIImage imageNamed:@"noimg"];
    
    if (_goodList[indexPath.row][@"isSale"] != nil && ![_goodList[indexPath.row][@"isSale"] isKindOfClass:[NSNull class]]) {
        NSString *isSale = [NSString stringWithFormat:@"%@", _goodList[indexPath.row][@"isSale"]];
        if ([isSale isEqualToString:@"0"]) {
            cell.stopLabel.hidden = NO;
//            cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        }
        else{
            cell.stopLabel.hidden = YES;
//            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    else{
        cell.stopLabel.hidden = NO;
//        cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    }

    cell.goodsNameHeight.constant = [Util countTextHeight:cell.goodsName.text] + 10;

    if (indexPath.row == 0) {
        cell.toTopBtn.hidden = YES;
    }
    else
        cell.toTopBtn.hidden = NO;
    
    cell.toTopBtn.tag = indexPath.row;
    [cell.toTopBtn addTarget:self action:@selector(toTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //标记菜单顺序
    NSDictionary *order = @{@"goodsId":_goodList[indexPath.row][@"goodsId"], @"goodsSort":[NSString stringWithFormat:@"%lu", _goodList.count - indexPath.row]};
    [_sequenceList addObject:order];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //这样刷新不行
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    if (_isAllSelect) {
        _isAllSelect = !_isAllSelect;
        _allSelectImg.image = [UIImage imageNamed:@"方块未选-1"];
    }
    
    if (tableView.isEditing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//开启移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//移动结束调用
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
//    NSLog(@"%ld to %ld", (long)sourceIndexPath.row, (long)destinationIndexPath.row);
//    //虽然没有显示，但是已经记录了选中的cell，重排后记录也自动更新
//    NSLog(@"选中 %@", self.tableView.indexPathsForSelectedRows);
    //NSMutableArray交换数据的一个方法
//    [_goodList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    //修改数据源
    _isChange = YES;
    NSDictionary *temp = _goodList[sourceIndexPath.row];
    [_goodList removeObjectAtIndex:sourceIndexPath.row];
    [_goodList insertObject:temp atIndex:destinationIndexPath.row];
    //刷新前存储选中项
    NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
    //清除之前的标记
    [_sequenceList removeAllObjects];
    //刷新后选中数组会被刷新
    [self.tableView reloadData];
    //将选中项加入选中数组
    for (NSIndexPath *indexPath in selectRows) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


//点击置顶按钮
-(void)toTopBtnClick:(id)sender{
    _isChange = YES;
    UIButton *btn = (UIButton *)sender;
    //    NSLog(@"%ld",(long)btn.tag);
    //交换数据位置
    //exchangeObjectAtIndex:需要交换的元素位置.
    //withObjectAtIndex:交换到哪个元素的位置.
    //    [_dishesList exchangeObjectAtIndex:btn.tag withObjectAtIndex:0];
    
    //改变数据源
    NSDictionary *temp = _goodList[btn.tag];
    [_goodList removeObjectAtIndex:btn.tag];
    [_goodList insertObject:temp atIndex:0];
    //移动cell--调用该方法移动cell可以使得indexPathsForSelectedRows选中的cell数组更新
    [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForItem:btn.tag inSection:0] toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    //存储选中项
    NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
    //清除之前的标记
    [_sequenceList removeAllObjects];
    //刷新后选中数组会被刷新
    [self.tableView reloadData];
    //将选中项加入选中数组
    for (NSIndexPath *indexPath in selectRows) {
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}


//点击选择菜单列表
-(void)selectTitelBtnClick{
//    _isSelectTitel = !_isSelectTitel;
//    if (_isSelectTitel) {
//    }

    self.tableView.scrollEnabled = NO;
    SelectAlert *alert = [SelectAlert showWithTitle:@"菜单" titles:_dishesList selectIndex:^(NSInteger selectIndex) {
        //获取商品列表
        NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"languageId":_languageId, @"catId":_dishesList[selectIndex][@"catId"]};
        [self postSeeGoodsWithParameters:dic CatId:_dishesList[selectIndex][@"catId"]];
        //存储catId
        _catId = _dishesList[selectIndex][@"catId"];
        
        self.tableView.scrollEnabled = YES;
    } selectValue:^(NSString *selectValue) {
        
        self.navigationItem.titleView = [UIView new];
        
        [_selectTitelBtn setTitle:selectValue forState:UIControlStateNormal];
        //重新计算宽度
        CGFloat titleLableWidth = [Util getWidthWithTitle:_selectTitelBtn.titleLabel.text font:_selectTitelBtn.titleLabel.font];
        _selectTitelBtn.frame = CGRectMake(0, 0, titleLableWidth + 10, 30);
        self.navigationItem.titleView = _selectTitelBtn;

        NSLog(@"%@", selectValue);
        
    } showCloseButton:YES];
    
    //回调，开启视图滚动功能
    alert.block = ^{
        self.tableView.scrollEnabled = YES;
    };
    
    __weak EditMerchandiseViewController *weakSelf = self;
    [weakSelf.view addSubview:alert];

}



//通过店铺、语言、分类查看商品
-(void)postSeeGoodsWithParameters:(NSDictionary *)parameters CatId:(NSString *)catId{
    NSString *url = [API stringByAppendingString:@"shops/seeGoods"];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"查看商品 %@", responseObject);
        if (responseObject != nil) {
            if (responseObject[@"goods"] != nil && ![responseObject[@"goods"] isKindOfClass:[NSNull class]]) {
                _goodList = responseObject[@"goods"];
            }
            else{
                _goodList = [@[] mutableCopy];
                [Util toastWithView:self.navigationController.view AndText:@"该分类下没有商品"];
            }
        }
        else{
            _goodList = [@[] mutableCopy];
            [Util toastWithView:self.navigationController.view AndText:@"该分类下没有商品"];
        }
        //清除之前的标记
        [_sequenceList removeAllObjects];
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"查看商品失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}




//点击底部按钮--批量操作
-(void)BootomBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%ld", (long)btn.tag);
    
//    [self.listData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//    }];
    
    switch (btn.tag) {
            //全选
        case 0:{
            _isAllSelect = !_isAllSelect;
            if (_isAllSelect) {
                _allSelectImg.image = [UIImage imageNamed:@"选中方块-1"];
                //遍历全选
                for (int i = 0; i < _goodList.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                }
//                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            else{
                //全不选
                _allSelectImg.image = [UIImage imageNamed:@"方块未选-1"];
                [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.tableView deselectRowAtIndexPath:obj animated:NO];
                }];
            }
        }
            break;
        //删除
        case 1:{
            NSString *goodsIdStr = @"";
            NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
            for (int i = 0; i < selectRows.count; i++) {
                if (i == 0) {
                    goodsIdStr = [NSString stringWithFormat:@"%@", _goodList[i][@"goodsId"]];
                }
                else
                    goodsIdStr = [NSString stringWithFormat:@"%@%@%@", goodsIdStr, @",",_goodList[i][@"goodsId"]];
            }
            [self postDeleteCatWithGoodsId:goodsIdStr];
        }
            
            break;
        //上架
        case 2:{
            NSString *url = [API stringByAppendingString:@"shops/shangJia"];
            NSString *goodsIdStr = @"";
            //遍历循环获取goodsId,先判断商品目前状态
            NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
            for (NSIndexPath *indexPath in selectRows) {
                if (_goodList[indexPath.row][@"isSale"] != nil && ![_goodList[indexPath.row][@"isSale"] isKindOfClass:[NSNull class]]) {
                    NSString *isSale = [NSString stringWithFormat:@"%@", _goodList[indexPath.row][@"isSale"]];
                    if ([isSale isEqualToString:@"0"]) {
                        if ([goodsIdStr isEqualToString:@""]) {
                            goodsIdStr = [NSString stringWithFormat:@"%@", _goodList[indexPath.row][@"goodsId"]];
                        }
                        else{
                            goodsIdStr = [NSString stringWithFormat:@"%@%@%@", goodsIdStr, @",", _goodList[indexPath.row][@"goodsId"]];
                        }
                    }
                }
                else{
                    if ([goodsIdStr isEqualToString:@""]) {
                        goodsIdStr = [NSString stringWithFormat:@"%@", _goodList[indexPath.row][@"goodsId"]];
                    }
                    else{
                        goodsIdStr = [NSString stringWithFormat:@"%@%@%@", goodsIdStr, @",", _goodList[indexPath.row][@"goodsId"]];
                    }
                }
            }
//            NSLog(@"goodsid shangjia = %@",goodsIdStr);
            [self postPutAwayWithUrl:url GoodeId:goodsIdStr];
        }
            break;
        //下架
        case 3:{
            NSString *url = [API stringByAppendingString:@"shops/xiaJia"];
            NSString *goodsIdStr = @"";
            //遍历循环获取goodsId,先判断商品目前状态
            NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
            for (NSIndexPath *indexPath in selectRows) {
                if (_goodList[indexPath.row][@"isSale"] != nil && ![_goodList[indexPath.row][@"isSale"] isKindOfClass:[NSNull class]]) {
                    NSString *isSale = [NSString stringWithFormat:@"%@", _goodList[indexPath.row][@"isSale"]];
                    if ([isSale isEqualToString:@"1"]) {
                        if ([goodsIdStr isEqualToString:@""]) {
                            goodsIdStr = [NSString stringWithFormat:@"%@", _goodList[indexPath.row][@"goodsId"]];
                        }
                        else{
                            goodsIdStr = [NSString stringWithFormat:@"%@%@%@", goodsIdStr, @",", _goodList[indexPath.row][@"goodsId"]];
                        }
                    }
                }
                else{

                }
            }
//            NSLog(@"goodsid xiajia = %@",goodsIdStr);
            [self postSoldOutWithUrl:url GoodeId:goodsIdStr];
        }
            
            break;

        default:
            break;
    }
}


//退出视图
-(void)pressBack{
    //判断是否修改
    if (_isChange) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"退出后修改的内容将不被保存，是否退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];

        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alter addAction:cancelAction];
        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}


//点击保存--保存顺序
-(void)senderBtnClick{
    [self PostgoodsPx];
}



//上架接口
-(void)postPutAwayWithUrl:(NSString *)url GoodeId:(NSString *)goodsIds{
    NSDictionary *dit = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsIds};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上架商品 %@", responseObject);
//        OperationCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 50);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.view AndPoint:&point AndText:@"上架成功"];
                NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"languageId":_languageId, @"catId":_catId};
                [self postSeeGoodsWithParameters:dic CatId:_catId];
                
            }
            else{
                [Util toastWithView:self.view AndPoint:&point AndText:@"上架失败"];
            }
            
        }
        else
            [Util toastWithView:self.view AndPoint:&point AndText:@"上架失败"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"操作失败 %@", error);
        CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 50);
        [Util toastWithView:self.view AndPoint:&point AndText:@"网络连接异常"];
    }];
}

//下架接口
-(void)postSoldOutWithUrl:(NSString *)url GoodeId:(NSString *)goodsIds{
    NSDictionary *dit = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsIds};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下架商品 %@", responseObject);
//        OperationCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 50);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.view AndPoint:&point AndText:@"下架成功"];
                NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"languageId":_languageId, @"catId":_catId};
                [self postSeeGoodsWithParameters:dic CatId:_catId];
            }
            else
                [Util toastWithView:self.view AndPoint:&point AndText:@"下架失败"];
            
        }
        else
            [Util toastWithView:self.view AndPoint:&point AndText:@"下架失败"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"操作失败 %@", error);
        CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 50);
        [Util toastWithView:self.view AndPoint:&point AndText:@"网络连接异常"];
    }];
}


//删除商品
-(void)postDeleteCatWithGoodsId:(NSString *)goodsIdStr{
    NSString *url = [API stringByAppendingString:@"shops/deleteGoods"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsIdStr};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除商品 %@", responseObject);
        CGPoint point = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 50);
        if (responseObject != nil) {            
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.view AndPoint:&point AndText:@"删除成功"];
                NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"languageId":_languageId, @"catId":_catId};
                [self postSeeGoodsWithParameters:dic CatId:_catId];
            }
            else
                [Util toastWithView:self.view AndPoint:&point AndText:@"删除失败"];

        }
        else
            [Util toastWithView:self.view AndPoint:&point AndText:@"删除失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除商品失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];
}


//批量排序与删除
-(void)PostgoodsPx{
    if (_sequenceList == nil) {
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    NSString *url = [API stringByAppendingString:@"Setshop/goodsPx"];
    NSDictionary *dic = @{@"goodspx":[Util convertToJSONData:_sequenceList]};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"商品排序排序 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"保存失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];
    
}


@end
