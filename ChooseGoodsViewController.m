//
//  ChooseGoodsViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/11/13.
//  Copyright © 2017年 Mac. All rights reserved.
//


////***砍价、折扣商品选择***///

#import "ChooseGoodsViewController.h"
#import "ClassificationCell.h"
#import "MenuVC.h"

@interface ChooseGoodsViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MenuVC *menuVC;

@property (strong, nonatomic) UIView *languageView;
@property (strong, nonatomic) UIScrollView *languageScrollView;


@property CGFloat MaxWidth;     //语言按钮最大宽度

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *senderBtn;

@property (strong, nonatomic) NSString *selectGoodsId;   //选中的商品id
@property (strong, nonatomic) NSString *selectGoodsName;   //选中的商品名称
@property (strong, nonatomic) NSString *selectPrice;   //选中的商品原价

@property (strong, nonatomic) NSArray *AllGoodsList;      //全部列表
@property (strong, nonatomic) NSArray *GoodsList;      //对应菜单列表
@property (strong, nonatomic) NSArray *shopList;      //对应商品列表



@end

@implementation ChooseGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"阿凡提商家";
    
    _AllGoodsList = [[NSArray alloc] init];
    _GoodsList = [[NSArray alloc] init];
    _shopList = [[NSArray alloc] init];

    _selectGoodsId = @"";
    _selectGoodsName = @"";
    
    [self initTopLanguageView];
    [self initLeftTableView];
    [self initRightTableView];
    if ([_activeType isEqualToString:@"团购活动"]) {
        [self initTopBtn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissViewController) name:@"dismissViewController" object:nil];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self postGetSeeOrder];
    [self PostGetAllGoods];
}

//顶部语言视图
-(void)initTopLanguageView{
    _languageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _languageView.backgroundColor = NAV_COLOR;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = [UIColor whiteColor];
    
    [_languageView addSubview:topLine];
    [self.view addSubview:_languageView];
}


//初始化语言控件
-(void)configLanguageBtnWithList:(NSArray *)languageList{
    _languageScrollView = [[UIScrollView alloc] init];
    _languageScrollView.frame = CGRectMake(5, 1, SCREEN_WIDTH, 40);
    //取消弹动效果
    _languageScrollView.bounces = YES;
    //是否滚动
    _languageScrollView.scrollEnabled = YES;
    //是否开启横向滚动
    _languageScrollView.alwaysBounceHorizontal = YES;
    //是否显示横向滚动条
    _languageScrollView.showsHorizontalScrollIndicator = YES;
    
    //是否允许通过点击屏幕让滚动视图响应事件
    //YES：滚懂视图可以接收触碰事件
    //NO：不接收触屏事件
    _languageScrollView.userInteractionEnabled = YES;
    //设置画布大小，横向效果
    _MaxWidth = 0;
    _languageScrollView.contentSize = CGSizeMake(_MaxWidth * languageList.count, 40);
    
    //添加视图
    for (int i = 0; i < languageList.count; i++) {
        UIButton *languageBtn = [[UIButton alloc] init];
        languageBtn.frame =CGRectMake(_MaxWidth + 10, 5, 60, 30);
        languageBtn.selected = YES;
        if (i == 0) {
            [languageBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
            [languageBtn setBackgroundColor:[UIColor whiteColor]];
        }
        else{
            [languageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [languageBtn setBackgroundColor:NAV_COLOR];
        }
        languageBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [languageBtn addTarget:self action:@selector(languageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        languageBtn.tag = i + 1000;
        languageBtn.layer.cornerRadius = 10;
        
        if (languageList[i][@"language"] != nil && ![languageList[i][@"language"] isKindOfClass:[NSNull class]]) {
            [languageBtn setTitle:languageList[i][@"language"] forState:UIControlStateNormal];
        }
        else{
            [languageBtn setTitle:@"--" forState:UIControlStateNormal];
        }
        //        NSLog(@"99 %@", languageBtn.titleLabel.text);
        //宽度自适应
        CGSize titleSize = [languageBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:languageBtn.titleLabel.font.fontName size:languageBtn.titleLabel.font.pointSize]}];
        
        languageBtn.frame =CGRectMake(_MaxWidth + 10, 5, titleSize.width + 15, 30);
        //位置叠加--计算下一个按钮x位置和画布长度
        _MaxWidth = _MaxWidth + 10 + titleSize.width + 15;
        [_languageScrollView addSubview:languageBtn];
    }
    //重新设置画布宽度
    _languageScrollView.contentSize = CGSizeMake(_MaxWidth + 10, 40);
    
    //取消按页滚动效果
    _languageScrollView.pagingEnabled = NO;
    
    //滚动视图画布的移动位置，偏移位置
    _languageScrollView.contentOffset = CGPointMake(0, 0);
    _languageScrollView.delegate = self;
    
    [_languageView addSubview:_languageScrollView];
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

//退出视图
-(void)pressBack{
    //判断是否修改
    if (1) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"退出后选择的内容将不被保存，是否退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:cancelAction];
        [alter addAction:okAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
//    else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    
}


//点击保存--保存   回传数据
-(void)senderBtnClick{
    self.block_group(_selectGoods);
    //退出视图控制器
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化左边视图
-(void)initLeftTableView{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 98, SCREEN_HEIGHT - 50)];
    leftView.backgroundColor = [UIColor whiteColor];
    leftView.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    leftView.layer.shadowOffset = CGSizeMake(2,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    leftView.layer.shadowOpacity = 0.5f;//阴影透明度，默认0
    leftView.layer.shadowRadius = 2.0f;//阴影半径，默认3
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 98, SCREEN_HEIGHT - 115) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassificationCell" bundle:nil] forCellReuseIdentifier:@"ClassificationCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [leftView addSubview:_tableView];
//    [leftView addSubview:bottomView];
    [self.view addSubview:leftView];
}

//初始化右边视图
-(void)initRightTableView{
    _menuVC = [[MenuVC alloc] init];
    _menuVC.view.frame = CGRectMake(100, 40, SCREEN_WIDTH-97, SCREEN_HEIGHT - 50);
    _menuVC.distopList = [[NSArray alloc] init];
    _menuVC.activeType = _activeType;
    _menuVC.selectGoods = [NSMutableArray array];
    _menuVC.selectGoods = _selectGoods;
    [_menuVC.tableView reloadData];
    _menuVC.block = ^(NSString *selectId, NSString *selctName, NSString *selectPrice) {
        _selectGoodsId = selectId;
        _selectGoodsName = selctName;
        _selectPrice = selectPrice;
    };
    
    //团购活动同步选中商品
    _menuVC.block_group = ^(NSMutableArray *selctGroup) {
        _selectGoods = selctGroup;
    };
    [self.view addSubview:_menuVC.view];
}




//获取全部商品（不包含多规格商品）
-(void)PostGetAllGoods{
    NSString *url = [API stringByAppendingString:@"Setshop/goodsList"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"无规格商品 %@", responseObject);
        if (responseObject != nil) {
            
            _AllGoodsList = responseObject;
            
            //初始化语言
            [self configLanguageBtnWithList:_AllGoodsList];
            
            //初始化菜单列表（选择第一个）
            if (_AllGoodsList.count > 0) {
                _GoodsList = _AllGoodsList[0][@"dishes"];
                [self.tableView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取无规格商品失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
    
}


//语言选择-切换菜单
-(void)languageBtnClick:(id)sender{
    UIButton *btn =(UIButton *)sender;
    //修改按钮样式
    for (int i = 0; i < _AllGoodsList.count; i++) {
        UIButton *btn2 = [(UIButton *)self.languageScrollView viewWithTag:(i + 1000)];
        if (btn.tag - 1000 == i) {
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
            
            //切换菜单
            _GoodsList = _AllGoodsList[i][@"dishes"];
            [self.tableView reloadData];
        }
        else{
            btn2.backgroundColor = NAV_COLOR;
            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}



#pragma mark - tableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 98, 40)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name;
    if (_GoodsList[indexPath.row][@"catName"] != nil && ![_GoodsList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
        name = _GoodsList[indexPath.row][@"catName"];
    }
    else
        name = @"--";
    
    //动态计算cell高度
    int temp = (int)name.length/5;
    if (temp == 0) {
        return 50;
    }
    return 25 * (temp + 1);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _GoodsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassificationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ClassificationCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ClassificationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ClassificationCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //设置cell点击样式
    UIView *selView = [[UIView alloc] initWithFrame:cell.frame];
    UIView *lefView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height/2 - 10, 5, 20)];
    lefView.backgroundColor = NAV_COLOR;
    [selView addSubview:lefView];
    cell.selectedBackgroundView = selView;
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    if (_GoodsList[indexPath.row][@"catName"] != nil && ![_GoodsList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
        cell.name.text = _GoodsList[indexPath.row][@"catName"];
    }
    else
        cell.name.text = @"--";
    
    //选中第一行   （设置默认选中第一行会遍历cell，防止初始化时多次请求）加个判断
    if (indexPath.row == 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];//实现点击第一行所调用的方法
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name;
    if (_GoodsList[indexPath.row][@"catName"] != nil && ![_GoodsList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
        name = _GoodsList[indexPath.row][@"catName"];
    }
    else
        name = @"--";
    
    //对应菜单下的商品传过去
    _menuVC.menuStr = name;
    _menuVC.distopList = _GoodsList[indexPath.row][@"distop"];
    [_menuVC.tableView reloadData];
    
}


-(void)dismissViewController{
    //传值回调
    self.block(_selectGoodsId, _selectGoodsName, _selectPrice);
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissViewController" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
