//
//  EditClassificationViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/30.
//  Copyright © 2017年 Mac. All rights reserved.
//



//**管理分类**//

#import "EditClassificationViewController.h"
#import "ClassificationCell01.h"
#import "ClassificationCell02.h"
#import "EditDescriptionViewController.h"
#import "AddMerchandiseViewController.h"

@interface EditClassificationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *editBnt;
@property (strong, nonatomic) UIButton *addNewBtn;
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UIButton *senderBtn;

@property (strong, nonatomic) NSMutableArray *delectCatIdArr;   //

@property (strong, nonatomic) NSMutableArray *sequenceList;     //顺序标记数组

@property BOOL isEdit;
@property BOOL isChange;     //是否修改，是否保存

@end

@implementation EditClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"阿凡提商家";
    _isEdit = NO;
    _isChange = NO;
    _delectCatIdArr = [[NSMutableArray alloc] init];
    _sequenceList = [[NSMutableArray alloc] init];
    
    [self initTableView];
    [self initBottomVeiw];
    [self initTopBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self postGetAllSeeOrder];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassificationCell01" bundle:nil] forCellReuseIdentifier:@"ClassificationCell01"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassificationCell02" bundle:nil] forCellReuseIdentifier:@"ClassificationCell02"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    
    [self.view addSubview:_tableView];
    
    NSLog(@"00 %@",_dishesList);
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
    
    //取消按钮
    _cancelBtn = [[UIButton alloc] init];
    _cancelBtn.bounds = CGRectMake(-10, 0, 50, 40);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //保存按钮
    _senderBtn = [[UIButton alloc] init];
    _senderBtn.bounds = CGRectMake(0, 0, 50, 40);
    [_senderBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _senderBtn.hidden = YES;
    [_senderBtn addTarget:self action:@selector(senderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *senderBtn = [[UIBarButtonItem alloc] initWithCustomView:_senderBtn];
    self.navigationItem.rightBarButtonItem = senderBtn;
}


-(void)initBottomVeiw{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 115, SCREEN_WIDTH, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 55, 14, 20, 20)];
    leftImg.image = [UIImage imageNamed:@"上下箭头"];
    UILabel *lable01 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 35, 0, 110, 50)];
    lable01.text = @"排序&批量操作";
    [lable01 setFont:[UIFont systemFontOfSize:14]];
    [lable01 setTextColor:[UIColor blackColor]];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH*3)/4 - 35, 14, 20, 20)];
    rightImg.image = [UIImage imageNamed:@"加号"];
    UILabel *lable02 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH * 3)/4 - 15, 0, 100, 50)];
    lable02.text = @"新建分类";
    [lable02 setFont:[UIFont systemFontOfSize:14]];
    [lable02 setTextColor:[UIColor blackColor]];
    
    UILabel *centerLine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 1, 50)];
    centerLine.backgroundColor = [UIColor lightGrayColor];
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    
    _editBnt = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH/2, 49)];
    _addNewBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 1, SCREEN_WIDTH/2, 49)];
    [_editBnt addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_addNewBtn addTarget:self action:@selector(addNewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:leftImg];
    [_bottomView addSubview:lable01];
    [_bottomView addSubview:rightImg];
    [_bottomView addSubview:lable02];
    [_bottomView addSubview:centerLine];
    [_bottomView addSubview:topLine];
    [_bottomView addSubview:_editBnt];
    [_bottomView addSubview:_addNewBtn];
    [self.view addSubview:_bottomView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_isEdit) {
        return 70;
    }
    else
        return 115;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_isEdit) {
        UIView *footrerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        footrerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        return footrerView;    }
    else
    {
        UIView *footrerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 115)];
        footrerView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        return footrerView;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dishesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isEdit) {
        ClassificationCell01 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ClassificationCell01" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ClassificationCell01 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ClassificationCell01"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];

        if (_dishesList[indexPath.row][@"catName"] != nil && ![_dishesList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
            cell.catName.text = [NSString stringWithFormat:@"%@", _dishesList[indexPath.row][@"catName"]];
        }
        else
            cell.catName.text = @"";

        NSArray *distop = [[NSArray alloc] init];    //暂时存放菜单
        distop = _dishesList[indexPath.row][@"distop"];
        if (distop != nil && ![distop isKindOfClass:[NSNull class]]) {
            cell.FoodCount.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)distop.count, @"个商品"];
        }
        else
            cell.FoodCount.text = @"0个商品";
        
        cell.editBtn.tag = indexPath.row;
        [cell.editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.addNewBtn.tag = indexPath.row;
        [cell.addNewBtn addTarget:self action:@selector(addNewGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else{
        ClassificationCell02 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ClassificationCell02" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ClassificationCell02 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ClassificationCell02"];
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];

        if (_dishesList[indexPath.row][@"catName"] != nil && ![_dishesList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
            cell.catName.text = [NSString stringWithFormat:@"%@", _dishesList[indexPath.row][@"catName"]];
        }
        else
            cell.catName.text = @"";
        
        if (indexPath.row == 0) {
            cell.toTopBtn.hidden = YES;
        }
        else
            cell.toTopBtn.hidden = NO;
        
        cell.toTopBtn.tag = indexPath.row;
        [cell.toTopBtn addTarget:self action:@selector(toTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *distop = [[NSArray alloc] init];    //暂时存放菜单
        distop = _dishesList[indexPath.row][@"distop"];
        if (distop != nil && ![distop isKindOfClass:[NSNull class]]) {
            cell.FoodCount.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)distop.count, @"个商品"];
        }
        else
            cell.FoodCount.text = @"0个商品";
        

        //标记菜单顺序
        NSDictionary *order = @{@"catId":_dishesList[indexPath.row][@"catId"], @"catSort":[NSString stringWithFormat:@"%lu", _dishesList.count - indexPath.row]};
        [_sequenceList addObject:order];
        
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




//开启移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//移动结束调用
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    _isChange = YES;
//    NSLog(@"%ld to %ld", (long)sourceIndexPath.row, (long)destinationIndexPath.row);
    //虽然没有显示，但是已经记录了选中的cell，重排后记录也自动更新
//    NSLog(@"选中 %@", self.tableView.indexPathsForSelectedRows);
    NSLog(@"顺序 %@", _sequenceList);
    //交换数据源顺序
//    [_dishesList exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    NSDictionary *temp = _dishesList[sourceIndexPath.row];
    [_dishesList removeObjectAtIndex:sourceIndexPath.row];
    [_dishesList insertObject:temp atIndex:destinationIndexPath.row];
    //清除之前的标记
    [_sequenceList removeAllObjects];
    [self.tableView reloadData];
}

//设置编辑样式   UITableViewCellEditingStyleInsert 插入
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

//修改删除文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:{
            NSLog(@"删除");
            _isChange = YES;
            NSArray *distop = [[NSArray alloc] init];    //暂时存放菜单
            distop = _dishesList[indexPath.row][@"distop"];
            //有商品的不能删除
            if (distop != nil && ![distop isKindOfClass:[NSNull class]]) {
            }
            else
                distop = @[];

            if (distop.count != 0) {
                [Util toastWithView:self.navigationController.view AndText:@"该分类下有商品，不可删除"];
                //清除之前的标记
                [_sequenceList removeAllObjects];
                [self.tableView reloadData];
            }
            else{
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"是否删除该分类？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //删除分类--处理数据源--记录需要删除的catId
                    [_delectCatIdArr addObject:_dishesList[indexPath.row][@"catId"]];
                    [_dishesList removeObjectAtIndex:indexPath.row];
                    //清除之前的标记
                    [_sequenceList removeAllObjects];
                    [self.tableView reloadData];

                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //清除之前的标记
                    [_sequenceList removeAllObjects];
                    [self.tableView reloadData];
                }];
                [alter addAction:cancelAction];
                [alter addAction:okAction];
                [self presentViewController:alter animated:YES completion:nil];
            }
        }
            break;
            
        default:
            break;
    }

}


//点击编辑按钮
-(void)editBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UIStoryboard *storeStotyboatd = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    EditDescriptionViewController *vc = [storeStotyboatd instantiateViewControllerWithIdentifier:@"EditDescription"];
    vc.catDic = [[NSDictionary alloc] init];
    vc.catDic = _dishesList[btn.tag];
    vc.Type = @"编辑";
    [self.navigationController pushViewController:vc animated:YES];
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
    
    NSDictionary *temp = _dishesList[btn.tag];
    [_dishesList removeObjectAtIndex:btn.tag];
    [_dishesList insertObject:temp atIndex:0];
    //清除之前的标记
    [_sequenceList removeAllObjects];
    [self.tableView reloadData];
}



//批量操作
-(void)editBtnClick{
    _isEdit = !_isEdit;
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithCustomView:_cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    _senderBtn.hidden = NO;
    //开启编辑模式
    [self.tableView setEditing:YES animated:YES];
    // 允许在编辑模式进行多选操作
    //    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50);
    [UIView commitAnimations];
    //清除之前的标记
    [_sequenceList removeAllObjects];
    [self.tableView reloadData];
}



//新建分类
-(void)addNewBtnClick{
    UIStoryboard *storeStotyboatd = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    EditDescriptionViewController *vc = [storeStotyboatd instantiateViewControllerWithIdentifier:@"EditDescription"];
    vc.catDic = [[NSDictionary alloc] init];
    vc.Type = @"新建";
    vc.languageId = _languageId;
    [self.navigationController pushViewController:vc animated:YES];

}


//新建商品
-(void)addNewGoodsBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    AddMerchandiseViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"AddMerchandise"];
    vc.guigeList = [[NSMutableArray alloc] init];
    vc.guigeAttr = [[NSMutableArray alloc] init];
    vc.languageList = [[NSArray alloc] init];
    vc.dishesList = [[NSArray alloc] init];
//    vc.dishesList = _dishesList;
    vc.languageId = _languageId;
    vc.language = _language;
//    vc.languageList = _languageList;
    vc.catId = _dishesList[btn.tag][@"catId"];
    vc.catName = _dishesList[btn.tag][@"catName"];
    vc.type = @"新建";
    [self.navigationController pushViewController:vc animated:YES];
}


//退出视图
-(void)pressBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击取消
-(void)cancelBtnClick{
    //判断是否修改
    if (_isChange) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"退出后修改的内容将不被保存，是否退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _isEdit = !_isEdit;
            UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
            self.navigationItem.leftBarButtonItem = backBtn;
            _senderBtn.hidden = YES;
            [self.tableView setEditing:NO animated:YES];
            //设置动画
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 115, SCREEN_WIDTH, 50);
            [UIView commitAnimations];
            //清除之前的标记
            [_sequenceList removeAllObjects];
            [self.tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //清除之前的标记
            [_sequenceList removeAllObjects];
            [self.tableView reloadData];
        }];
        [alter addAction:cancelAction];
        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
    else{
        _isEdit = !_isEdit;
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem = backBtn;
        _senderBtn.hidden = YES;
        [self.tableView setEditing:NO animated:YES];
        //设置动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 115, SCREEN_WIDTH, 50);
        [UIView commitAnimations];
        //清除之前的标记
        [_sequenceList removeAllObjects];
        [self.tableView reloadData];
    }


    
}

//点击保存
-(void)senderBtnClick{
    if (_isChange) {
        NSString *delectStr = @"";
        for (int i = 0; i < _delectCatIdArr.count; i++) {
            if (i == 0) {
                delectStr = [NSString stringWithFormat:@"%@", _delectCatIdArr[i]];
            }
            else
                delectStr = [NSString stringWithFormat:@"%@%@%@", delectStr, @",",_delectCatIdArr[i]];
        }
        
        [self postCatPxWithDelectStr:delectStr];
    }
    else{
        _isEdit = !_isEdit;
        _isChange = NO;
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem = backBtn;
        _senderBtn.hidden = YES;
        [self.tableView setEditing:NO animated:YES];
        //设置动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 115, SCREEN_WIDTH, 50);
        [UIView commitAnimations];
        //清除之前的标记
        [_sequenceList removeAllObjects];
        [self.tableView reloadData];
    }
}


//管理分类--获取全部商品（目前没其他接口，先这样写）
-(void)postGetAllSeeOrder{
    NSString *url = [API stringByAppendingString:@"shops/seeOrder"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"全部商品 %@", responseObject);
        if (responseObject != nil) {
            NSArray *shopList = [[NSArray alloc] init];
            NSArray *dishesList = [[NSArray alloc] init];
            shopList = responseObject;
            for (int i = 0; i < shopList.count; i++) {
                NSString *str = shopList[i][@"language"];
                if ([str isEqualToString:_language]) {
                    dishesList = shopList[i][@"dishes"];
                    break;
                }
            }
            if(dishesList != nil && ![dishesList isKindOfClass:[NSNull class]]){
                _dishesList = [dishesList mutableCopy];
            }
            else{
                _dishesList = [@[] mutableCopy];
            }
            
        }
        else{
            _dishesList = [@[] mutableCopy];
        }
        //清除之前的标记
        [_sequenceList removeAllObjects];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取全部商品失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}



//删除分类
//-(void)postDeleteCatWithCatId{
//    NSString *url = [API stringByAppendingString:@"shops/deleteCat"];
//    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"catId":@""};
//    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"删除分类 %@", responseObject);
//        if (responseObject != nil) {
//            [Util toastWithView:self.navigationController.view AndText:@"删除分类成功"];
//        }
//        else
//            [Util toastWithView:self.navigationController.view AndText:@"删除分类失败"];
//            
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"删除分类失败 %@", error);
//        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
//
//    }];
//}

//批量排序与删除
-(void)postCatPxWithDelectStr:(NSString *)delectStr{
    if (_sequenceList == nil) {
        _isEdit = !_isEdit;
        _isChange = NO;
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem = backBtn;
        _senderBtn.hidden = YES;
        [self.tableView setEditing:NO animated:YES];
        //设置动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 115, SCREEN_WIDTH, 50);
        [UIView commitAnimations];
        //清除之前的标记
        [_sequenceList removeAllObjects];
        [self.tableView reloadData];

        return ;
    }
    NSString *url = [API stringByAppendingString:@"Setshop/catPx"];
    NSDictionary *dic = @{@"catpx":[Util convertToJSONData:_sequenceList], @"deleteId":delectStr};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"批量排序 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"分类保存成功"];
                _isEdit = !_isEdit;
                _isChange = NO;
                UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
                self.navigationItem.leftBarButtonItem = backBtn;
                _senderBtn.hidden = YES;
                [self.tableView setEditing:NO animated:YES];
                //设置动画
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationDelay:0];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 115, SCREEN_WIDTH, 50);
                [UIView commitAnimations];
                //清除之前的标记
                [_sequenceList removeAllObjects];
                [self.tableView reloadData];

            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"分类保存失败"];
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"分类保存失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"分类保存失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
