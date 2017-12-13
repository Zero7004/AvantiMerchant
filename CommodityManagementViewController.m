//
//  CommodityManagementViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/12.
//  Copyright © 2017年 Mac. All rights reserved.
//

///*商品管理*//


#import "CommodityManagementViewController.h"
#import "ClassificationCell.h"
#import "MenuViewController.h"
#import "AddMerchandiseViewController.h"
#import "EditMerchandiseViewController.h"
#import "EditClassificationViewController.h"


@interface CommodityManagementViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) MenuViewController *menuVC;
@property (strong, nonatomic) EditClassificationViewController *EditClassVC;
@property (strong, nonatomic) UIButton *editBnt;
@property (strong, nonatomic) UILabel *lable01;
@property (strong, nonatomic) UIButton *addNewBtn;

@property (strong, nonatomic) NSArray *dishesList;      //纯菜单列表
@property (strong, nonatomic) NSArray *goodsList;
@property (strong, nonatomic) NSMutableArray *languageList;    //语言列表
@property (strong, nonatomic) NSMutableArray *existLanguageList;
@property (strong, nonatomic) NSMutableArray *existLanguageArray;

@property (strong, nonatomic) UIView *languageView;
@property (strong, nonatomic) UIScrollView *languageScrollView;
@property (strong, nonatomic) NSString *languageId;     //使用语言的id
@property (strong, nonatomic) NSString *language;        //使用的语言
@property (strong, nonatomic) NSString *catId;           //当前选中菜单的catId
@property (strong, nonatomic) NSString *catName;           //当前选中菜单名
@property (strong, nonatomic) NSArray *selectDishesList;   //管理分类--选中语言下的菜单等信息

@property (strong, nonatomic) UIButton *chinaLanguageBtn;
@property (strong, nonatomic) UIButton *englishLanguageBtn;
@property CGFloat MaxWidth;     //语言按钮最大宽度
//导航栏右边按钮
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIButton *delBtn;
@property (strong, nonatomic) UIView *rightSelect;
@property (strong, nonatomic) UIButton *rightSelectBtn;
@property (assign, nonatomic) BOOL rightOut;
@property (strong, nonatomic) UIPickerView *rightPick;
@property (assign, nonatomic) NSInteger pickNow;
@property (strong, nonatomic) NSMutableArray *languageArray;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *pickFaView;
@property (assign, nonatomic) BOOL firstLoadRing;
@end

@implementation CommodityManagementViewController


//  导航栏右边按钮，新建语言
#pragma mark - 加载导航右边按钮
- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [_rightBtn setTitle:@"dian" forState:normal];
        [_rightBtn sizeToFit];
//        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 20, 0)];
//        _rightBtn.backgroundColor = [UIColor blackColor];
        [_rightBtn addTarget:self action:@selector(rightBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"三点-4"] forState:UIControlStateNormal];
        
    }
    return _rightBtn;
}

//初始化已经有的语言数组

- (NSMutableArray *)existLanguageArray
{
    if (_existLanguageArray == nil) {
        _existLanguageArray = [[NSMutableArray alloc]init];
    }
    return _existLanguageArray;
}

- (NSMutableArray *)existLanguageList
{
    if (_existLanguageList == nil) {
        _existLanguageList = [[NSMutableArray alloc]init];
    }
    return _existLanguageList;
}
// 滚轮数量
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// 滚轮行数
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (!self.firstLoadRing) {
//        NSLog(@"删除有多少%d",self.existLanguageArray.count);
        return self.existLanguageArray.count;
        
    }else
    return self.languageArray.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (!self.firstLoadRing) {
//        NSLog(@"存在语言%@",self.existLanguageArray);
        return self.existLanguageArray[row];
        
    }else
    return self.languageArray[row];
}


// 加载新建按钮
//- (UIButton *)rightSelectBtn
//{
//    if (_rightSelectBtn == nil) {
//        _rightSelectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////        [_rightSelectBtn sizeToFit];
//        [_rightSelectBtn setFrame:CGRectMake(0, 0, 80, 40)];
//        [_rightSelectBtn setTitle:@"新建语言" forState:UIControlStateNormal];
//        [_rightSelectBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
//        [_rightSelectBtn addTarget:self action:@selector(rightSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _rightSelectBtn;
//}
//点击新建
- (void)rightSelectBtnClick:(UIButton *)button
{
//    NSLog(@"222");
    self.firstLoadRing = YES;
    [self rightSelctRemove];
//    self.rightPick = nil;
//    self.languageArray = nil;
//    self.existLanguageArray = nil;
    [self.rightPick reloadAllComponents];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _pickFaView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
    }];
    
}

#pragma mark 点击删除
- (void)rightDelBtnClick:(UIButton *)button
{
    [self rightSelctRemove];
    self.firstLoadRing = NO;
//        [self.pickFaView reloadInputViews];
//    self.rightPick = nil;
    [self.rightPick reloadAllComponents];
//    NSLog(@"实在搞不懂%@",self.existLanguageArray);
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _pickFaView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
    }];
    
}
// 加载新建父视图
- (UIView *)rightSelect
{
    if (_rightSelect == nil) {
        _rightSelect = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 0, 100, 100)];
        _rightSelect.backgroundColor = [UIColor whiteColor];
        
        _rightSelectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        [_rightSelectBtn sizeToFit];
        [_rightSelectBtn setFrame:CGRectMake(0, 0, 100, 50)];
        [_rightSelectBtn setTitle:@"新建语言" forState:UIControlStateNormal];
        [_rightSelectBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
        [_rightSelectBtn addTarget:self action:@selector(rightSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _delBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        [_rightSelectBtn sizeToFit];
        [_delBtn setFrame:CGRectMake(0, 50, 100, 50)];
        [_delBtn setTitle:@"删除语言" forState:UIControlStateNormal];
        [_delBtn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(rightDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *centerLabel = [[UILabel alloc] init];
        centerLabel.frame = CGRectMake(0, 50, 100, 1);
        centerLabel.backgroundColor = [UIColor lightGrayColor];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.frame = CGRectMake(0, 100, 100, 1);
        bottomLabel.backgroundColor = [UIColor lightGrayColor];
        
        [_rightSelect addSubview:_rightSelectBtn];
        [_rightSelect addSubview:_delBtn];
        [_rightSelect addSubview:centerLabel];
        [_rightSelect addSubview:bottomLabel];
    }
    return _rightSelect;
}

// 弹出新建
- (void)rightSelctAdd
{
    [self.view addSubview:self.rightSelect];
     self.rightOut = YES;
    [self tapGesture];
//    [self pickTapGesture];
}
// 移除新建
- (void)rightSelctRemove
{
    [self.rightSelect removeFromSuperview];
    self.rightOut = NO;
}


//点击右边导航栏按钮
- (void)rightBtnclick:(UIButton *)button
{
//    NSLog(@"111");
    if (!self.rightOut) {
        [self rightSelctAdd];
//        self.rightSelectBtn.alpha = 1.0;
       
    }else
    {
        [self rightSelctRemove];
//        self.rightSelect.alpha = 0.0;
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _rightOut = NO;
    self.firstLoadRing = YES;
    self.title = @"阿凡提商家";
    _dishesList = [[NSArray alloc] init];
    _goodsList = [[NSArray alloc] init];
    _languageList = [[NSMutableArray alloc] init];
    _selectDishesList = [[NSArray alloc] init];
    _languageId = @"";
    _language = @"";

    [self initTopLanguageView];
    [self initLeftTableView];
    [self initRightTableView];
    [self initBottomVeiw];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn ]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn ];
    [self initPickView];

//    [self postGetSeeOrder];

}
#pragma mark 点击屏幕任意位置
- (void)tapGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightSelctRemove)];
    tapGesture.delegate = self;
//    [self.view addGestureRecognizer:tapGesture];
//    [self.view addGestureRecognizer:tapGesture];

}

- (void)hidePick
{
    [UIView animateWithDuration:0.5 animations:^{
        _pickFaView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
    }];
}
//滚轮初始化
- (void)initPickView
{
    _pickFaView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300)];
    
    
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _pickFaView.layer.bounds.size.width, 50)];
    UIButton *canceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _titleView.layer.bounds.size.height + 30, _titleView.layer.bounds.size.height)];
    [canceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canceBtn addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *DoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(_titleView.layer.bounds.size.width - _titleView.layer.bounds.size.height - 30, 0, _titleView.layer.bounds.size.height + 30, _titleView.layer.bounds.size.height)];
    [DoneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [DoneBtn addTarget:self action:@selector(DoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:canceBtn];
    [_titleView addSubview:DoneBtn];
    _titleView.backgroundColor = NAV_COLOR;
//    titleView.frame = CGRectMake(0, 0, pickFaView.layer.bounds.size.width, 50);
    [_pickFaView addSubview:_titleView];
    
    
    
//    rightPick.frame = CGRectMake(0, 50, pickFaView.layer.bounds.size.width, pickFaView.layer.bounds.size.height - 50);
    [_pickFaView addSubview:self.rightPick];
    


    [self.view addSubview:_pickFaView];
}

- (NSMutableArray *)languageArray
{
    if (_languageArray == nil) {
        _languageArray = [[NSMutableArray alloc]initWithObjects:@"中　文",@"粤语",@"English",@"O'zbek tili",@"Тоҷикӣ",@"Кыргызтили",@"түркмен дили",@"ئۇيغۇر",@"монгол хэл",@"བོད་ཡིག་",@"Қазақ тілі",@"Tiếng Việt",@"ᠮᠠᠨᠵᡠ ᡥᡝᡵᡤᡝᠨ",@"Sawcuengh",@"Miao lus",@"Алтай Хэлнүүд",@"조선말",@"日本語",@"한국어",@"Français",@"Español",@"ไทย",@"العربية",@"русский",@"Português",@"Deutsch",@"lingua italiana",@"Ελληνικά",@"Nederlands",@"Polski",@"български",@"Eesti keel",@"dansk",@"suomalainen",@"Česky",@"românesc",@"Slovenščina",@"Svenska",@"magyar",@"Tiếng Việt", nil];
//        NSLog(@"%@",_languageArray);
    }
    return _languageArray;
}


//懒加载rightPick
- (UIPickerView *)rightPick
{
    if (_rightPick == nil) {
        _rightPick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, _pickFaView.layer.bounds.size.width, _pickFaView.layer.bounds.size.height - 50)];
        
        //    NSMutableArray *changeLanguageArray = [[NSMutableArray alloc]init];
//        if (self.firstLoadRing) {
//            self.languageArray = nil;
//        }else{
//        NSLog(@"%d，%@",self.languageArray.count,self.languageArray);
//        NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:self.languageArray];
//        for (NSInteger i = 0; i < self.existLanguageArray.count; i++) {
//            for (NSInteger j = 0; j < arr.count; j++) {
//                if ([self.existLanguageArray[i] isEqualToString: arr[j]]) {
//                    if ([self.languageArray containsObject:self.existLanguageArray[i]]) {
//                        [self.languageArray removeObject:self.existLanguageArray[i]];
//                    }
//                }
//            }
//        }
//        }
        _rightPick.delegate = self;
        _rightPick.dataSource = self;
        _rightPick.showsSelectionIndicator = YES;
        _rightPick.backgroundColor = [UIColor whiteColor];
    }
    return _rightPick;
}
//、、点击滚轮取消
- (void)canceBtnClick
{
    [UIView animateWithDuration:0.5 animations:^{
        _pickFaView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark 点击滚轮确定
- (void)DoneBtnClick
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (self.firstLoadRing) {
    UIAlertController *alertSelect = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否创建语言" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertSelect animated:YES completion:nil];
    [alertSelect addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popViewControllerAnimated:YES];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }]];
    [alertSelect addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [UIView animateWithDuration:0.5 animations:^{
            _pickFaView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
        }];
        [self postNewLanguage:self.languageArray[self.pickNow]];
//        [self.languageScrollView removeFromSuperview];
//        [self configLanguageBtnWithList:self.languageList];
//        [self.languageView reloadInputViews];
//        [self.languageScrollView.refreshControl beginRefreshing];
    }]];}
    else{

        UIAlertController *alertSelect = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除语言" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertSelect animated:YES completion:nil];
        [alertSelect addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //        [self.navigationController popViewControllerAnimated:YES];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }]];
        [alertSelect addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [UIView animateWithDuration:0.5 animations:^{
                _pickFaView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
            }];
//            [self postNewLanguage:self.languageArray[self.pickNow]];
//            NSLog(@"删除的语言%@",self.languageArray[self.pickNow]);
            NSString *catId;
            for (NSInteger i = 0; i < self.languageList.count; i++) {
//                NSLog(@"查看能删除的清单%@---%@",self.languageList,self.existLanguageArray);
                if ([self.languageList[i][@"catName"] isEqualToString:self.existLanguageArray[self.pickNow]]) {
                    
                    catId = self.languageList[i][@"languageId"];
//                                NSLog(@"111111111111要删除的语言%@",self.languageList[i]);
                }
            }
//            NSLog(@"要删除的语言id%@",catId);
            [self postDelLanguage:catId];
            
            //        [self.languageScrollView removeFromSuperview];
            //        [self configLanguageBtnWithList:self.languageList];
            //        [self.languageView reloadInputViews];
            //        [self.languageScrollView.refreshControl beginRefreshing];
        }]];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGoods:) name:@"editGoods" object:nil];
    [self postGetSeeOrder];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView isKindOfClass:[self.rightPick class]]) {
        _pickNow = row;
    }
    
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
//- (UIScrollView *)languageScrollView
//{
//    if (_languageScrollView == nil) {
//        _languageScrollView = [[UIScrollView alloc] init];
//    }
//    return _languageScrollView;
//}
#pragma mark 初始化语言控件
-(void)configLanguageBtnWithList:(NSArray *)languageList{
    
//    if (self.languageScrollView != NULL) {
//        self.languageScrollView = nil;
//    }
//    if (_languageScrollView != nil) {
//        self.languageScrollView = nil;
//    }
    [_languageScrollView removeFromSuperview];
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
        
        if (_languageList[i][@"catName"] != nil && ![_languageList[i][@"catName"] isKindOfClass:[NSNull class]]) {
            [languageBtn setTitle:_languageList[i][@"catName"] forState:UIControlStateNormal];
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



//初始化左边视图
-(void)initLeftTableView{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 98, SCREEN_HEIGHT - 50)];
    leftView.backgroundColor = NAV_COLOR;
    leftView.layer.shadowColor =  [UIColor grayColor].CGColor;    // 阴影颜色//shadowColor阴影颜色
    leftView.layer.shadowOffset = CGSizeMake(2,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    leftView.layer.shadowOpacity = 0.5f;//阴影透明度，默认0
    leftView.layer.shadowRadius = 2.0f;//阴影半径，默认3
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 98, SCREEN_HEIGHT - 115) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BG_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassificationCell" bundle:nil] forCellReuseIdentifier:@"ClassificationCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 155, 100, 50)];
    bottomView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 20, 20)];
    imgView.image = [UIImage imageNamed:@"foodSum"];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, 50)];
    lable.text = @"管理分类";
    if (SCREEN_WIDTH == 320) {
        [lable setFont:[UIFont systemFontOfSize:12]];
        imgView.frame = CGRectMake(8, 19, 15, 15);
    }
    else if (SCREEN_WIDTH == 375){
        [lable setFont:[UIFont systemFontOfSize:13]];
        imgView.frame = CGRectMake(6, 18, 18, 18);
    }
    else{
        [lable setFont:[UIFont systemFontOfSize:14]];
        imgView.frame = CGRectMake(5, 15, 15, 15);
    }
    [lable setTextColor:[UIColor blackColor]];
    [bottomView addSubview:imgView];
    [bottomView addSubview:lable];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_leftBtn];
    
    [leftView addSubview:_tableView];
    [leftView addSubview:bottomView];
    [self.view addSubview:leftView];
}

//初始化右边视图
-(void)initRightTableView{
    _menuVC = [[MenuViewController alloc] init];
    _menuVC.view.frame = CGRectMake(100, 40, SCREEN_WIDTH-97, SCREEN_HEIGHT - 50);
    _menuVC.goodList = [[NSArray alloc] init];
    [_menuVC.tableView reloadData];
    [self.view addSubview:_menuVC.view];
}


//通知--编辑商品
-(void)editGoods:(NSNotification *)goods{
    NSDictionary * infoDic = [goods object];

    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    AddMerchandiseViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"AddMerchandise"];
    vc.guigeList = [NSMutableArray array];
    vc.guigeAttr = [NSMutableArray array];
    vc.languageList = [[NSArray alloc] init];
    vc.dishesList = [[NSArray alloc] init];
    //        vc.dishesList = _dishesList;
    vc.languageId = _languageId;
    vc.language = _language;
    //        vc.languageList = _languageList;
    vc.catId = _catId;
    vc.catName = _catName;
    vc.type = @"编辑";
    //传入商品信息
    vc.goods = [[NSDictionary alloc] init];
    vc.goods = infoDic;
    [self.navigationController pushViewController:vc animated:YES];
}



//初始化底部视图
-(void)initBottomVeiw{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(97, SCREEN_HEIGHT - 115, SCREEN_WIDTH - 97, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 20, 20)];
    leftImg.image = [UIImage imageNamed:@"上下箭头"];
    _lable01 = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 110, 50)];
    _lable01.text = @"排序&批量操作";
    if (SCREEN_WIDTH == 320) {
        [_lable01 setFont:[UIFont systemFontOfSize:12]];
        leftImg.frame = CGRectMake(10, 17, 15, 15);
    }
    else if (SCREEN_WIDTH == 375){
        [_lable01 setFont:[UIFont systemFontOfSize:13]];
        leftImg.frame = CGRectMake(10, 15, 18, 18);
    }
    else{
        [_lable01 setFont:[UIFont systemFontOfSize:14]];
        leftImg.frame = CGRectMake(10, 14, 20, 20);
    }

    [_lable01 setTextColor:[UIColor blackColor]];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 97 - 110, 14, 20, 20)];
    rightImg.image = [UIImage imageNamed:@"加号"];
    UILabel *lable02 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 97 - 90, 0, 100, 50)];
    lable02.text = @"新建商品";
    if (SCREEN_WIDTH == 320) {
        [lable02 setFont:[UIFont systemFontOfSize:12]];
        rightImg.frame = CGRectMake(SCREEN_WIDTH - 97 - 105, 17, 15, 15);
    }
    else if (SCREEN_WIDTH == 375){
        [lable02 setFont:[UIFont systemFontOfSize:13]];
        rightImg.frame = CGRectMake(SCREEN_WIDTH - 97 - 107, 15, 18, 18);
    }
    else{
        [lable02 setFont:[UIFont systemFontOfSize:14]];
        rightImg.frame = CGRectMake(SCREEN_WIDTH - 97 - 110, 14, 20, 20);
    }
    [lable02 setTextColor:[UIColor blackColor]];
    
    UILabel *centerLine = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 97)/2, 0, 1, 50)];
    centerLine.backgroundColor = [UIColor grayColor];
    
    _editBnt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 97)/2, 50)];
    _addNewBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 97)/2, 0, (SCREEN_WIDTH - 97)/2, 50)];
    [_editBnt addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_addNewBtn addTarget:self action:@selector(addNewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:leftImg];
    [bottomView addSubview:_lable01];
    [bottomView addSubview:rightImg];
    [bottomView addSubview:lable02];
    [bottomView addSubview:centerLine];
    [bottomView addSubview:_editBnt];
    [bottomView addSubview:_addNewBtn];
    [self.view addSubview:bottomView];
}

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
    if (_dishesList[indexPath.row][@"catName"] != nil && ![_dishesList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
        name = _dishesList[indexPath.row][@"catName"];
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
    if (_dishesList.count == 0) {
        _menuVC.menuStr = @"";
    }
    return _dishesList.count;
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
    
    if (_dishesList[indexPath.row][@"catName"] != nil && ![_dishesList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
        cell.name.text = _dishesList[indexPath.row][@"catName"];
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
    if (_dishesList[indexPath.row][@"catName"] != nil && ![_dishesList[indexPath.row][@"catName"] isKindOfClass:[NSNull class]]) {
        name = _dishesList[indexPath.row][@"catName"];
    }
    else
        name = @"--";
    
    _menuVC.menuStr = name;
    _menuVC.languageId = _languageId;

    //获取菜品
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"languageId":_languageId, @"catId":_dishesList[indexPath.row][@"catId"]};
    //存储catId
    _catId = _dishesList[indexPath.row][@"catId"];
    _catName = _dishesList[indexPath.row][@"catName"];
    
    _menuVC.catId = _catId;
    _menuVC.catName = _catName;
    _menuVC.language = _language;
    _menuVC.languageId = _languageId;

    [self postSeeGoodsWithParameters:dic CatId:_dishesList[indexPath.row][@"catId"]];
}


#pragma mark 语言选择按钮
-(void)languageBtnClick:(id)sender{
    UIButton *btn =(UIButton *)sender;
    
    for (int i = 0; i < 20; i++) {
        UIButton *btn2 = [(UIButton *)self.languageScrollView viewWithTag:(i + 1000)];
        if (btn.tag - 1000 == i) {
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:NAV_COLOR forState:UIControlStateNormal];
            
            _languageId = _languageList[btn.tag - 1000][@"languageId"];
            _language = _languageList[btn.tag - 1000][@"catName"];
            [self postChangeLanguageWithLanguageId:_languageId];
        }
        else{
            btn2.backgroundColor = NAV_COLOR;
            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}


//管理分类分类
-(void)leftBtnClick{
    _EditClassVC = [[EditClassificationViewController alloc] init];
    _EditClassVC.dishesList = [[NSMutableArray alloc] init];
    _EditClassVC.languageId = _languageId;
    _EditClassVC.language = _language;
    [self.navigationController pushViewController:_EditClassVC animated:YES];

    //获取数据
//    [self postGetAllSeeOrder];
}

//管理分类--获取全部商品（目前没其他接口，先这样写）
//-(void)postGetAllSeeOrder{
//    NSString *url = [API stringByAppendingString:@"shops/seeOrder"];
//    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
//    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"全部商品 %@", responseObject);
//        if (responseObject != nil) {
//            NSArray *shopList = [[NSArray alloc] init];
//            NSArray *dishesList = [[NSArray alloc] init];
//            shopList = responseObject;
//            for (int i = 0; i < shopList.count; i++) {
//                NSString *str = shopList[i][@"language"];
//                if ([str isEqualToString:_language]) {
//                    dishesList = shopList[i][@"dishes"];
//                    break;
//                }
//            }
//            if(dishesList != nil && ![dishesList isKindOfClass:[NSNull class]]){
////                _EditClassVC.dishesList = [dishesList mutableCopy];
////                _EditClassVC.languageId = _languageId;
////                [self.navigationController pushViewController:_EditClassVC animated:YES];
//            }
//            else{
////                _EditClassVC.dishesList = [@[] mutableCopy];
////                _EditClassVC.languageId = _language;
////                [self.navigationController pushViewController:_EditClassVC animated:YES];
//            }
//            
//        }
//        else{
////            _EditClassVC.dishesList = [@[] mutableCopy];
////            [self.navigationController pushViewController:_EditClassVC animated:YES];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"获取全部商品失败 %@", error);
//        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
//    }];
//}



//批量操作
-(void)editBtnClick{
    EditMerchandiseViewController *vc = [[EditMerchandiseViewController alloc] init];
    vc.goodList = [[NSMutableArray alloc] init];
    vc.dishesList = [[NSMutableArray alloc] init];
    vc.catId = _menuVC.catId;                        //当前菜单id
    vc.goodList = [_menuVC.goodList mutableCopy];    //当前商品列表
    vc.languageId = _languageId;                     //当前语言id
    vc.language = _language;                         //当前语言
    vc.dishesList = _dishesList;                     //当前菜单列表
    [vc.tableView reloadData];

    [self.navigationController pushViewController:vc animated:YES];
}

//新建商品
-(void)addNewBtnClick{
    if (_languageList.count == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请先创建语言"];
        return ;
    }
    if (_dishesList.count == 0) {
        [Util toastWithView:self.navigationController.view AndText:@"请先创建分类"];
        return ;
    }
    UIStoryboard *storeStoryboard = [UIStoryboard storyboardWithName:@"Store" bundle:[NSBundle mainBundle]];
    AddMerchandiseViewController *vc = [storeStoryboard instantiateViewControllerWithIdentifier:@"AddMerchandise"];
    vc.guigeList = [NSMutableArray array];
    vc.guigeAttr = [NSMutableArray array];
    vc.languageList = [[NSArray alloc] init];
    vc.dishesList = [[NSArray alloc] init];
    vc.dishesList = _dishesList;
    vc.languageId = _languageId;
    vc.language = _language;
    vc.languageList = _languageList;
    vc.catId = _catId;
    vc.catName = _catName;
    vc.type = @"新建";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 判断是否有语言
//查看语言菜单商品
-(void)postGetSeeOrder{
    [self rightSelctRemove];
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    NSString *url = [API stringByAppendingString:@"shops/seeOrders"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"菜单商品 %@", responseObject);
        [_hud hideAnimated:YES];
        if (responseObject != nil) {
            NSArray *dishes = responseObject[@"dishes"];
            NSArray *goods = responseObject[@"goods"];
            NSArray *language = responseObject[@"language"];
            
            NSLog(@"存在的语言清单%@",dishes);
            
//            NSLog(@"已有语言模型%@",language);
            
            
            NSLog(@"已经有的数组%@",self.existLanguageArray);
//            self.firstLoadRing = NO;
            [self.pickFaView reloadInputViews];
//            NSLog(@"%@",self.existLanguageArray);
            if (![dishes isKindOfClass:[NSNull class]]) {
                _dishesList = dishes;
                
            }
            if (![goods isKindOfClass:[NSNull class]]) {
                _goodsList = goods;
//                _menuVC.goodList = _goodsList;
            }
            if (![language isKindOfClass:[NSNull class]]) {
                self.existLanguageArray = nil;
                [self.existLanguageList addObjectsFromArray:language];
                for (NSInteger i = 0; i < language.count; i++) {
                    [self.existLanguageArray addObject:language[i][@"catName"]];//已经有的语言
                    //
                }
//                _languageList = language;
                _languageList = [[NSMutableArray alloc]initWithArray:language];
                _languageId = _languageList[0][@"languageId"];
                _language = _languageList[0][@"catName"];
                NSLog(@"语言清单%@",_languageList);
                [self configLanguageBtnWithList:_languageList];
//
                
            }
            else{
                UIAlertController *alertSelect = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否创建语言" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertSelect animated:YES completion:nil];
                [alertSelect addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [alertSelect addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                    [self.rightPick reloadAllComponents];
                    [UIView animateWithDuration:0.5 animations:^{
                        _pickFaView.frame = CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300);
                    }];
                }]];
            }

            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取菜单商品失败 %@", error);
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

//通过店铺、语言、分类查看商品
-(void)postSeeGoodsWithParameters:(NSDictionary *)parameters CatId:(NSString *)catId{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self rightSelctRemove];
    NSString *url = [API stringByAppendingString:@"shops/seeGoods"];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"查看商品 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            if (responseObject[@"goods"] != nil && ![responseObject[@"goods"] isKindOfClass:[NSNull class]]) {
                _menuVC.goodList = responseObject[@"goods"];
            }
            else
                _menuVC.goodList = @[];
            
            _menuVC.catId = catId;
            
            [_menuVC.tableView reloadData];
        }
        if (_menuVC.goodList.count == 0) {
            _lable01.textColor = [UIColor lightGrayColor];
            [_editBnt setUserInteractionEnabled:NO];
        }
        else{
            _lable01.textColor = [UIColor blackColor];
            [_editBnt setUserInteractionEnabled:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"查看商品失败 %@", error);
        [_hud hideAnimated:YES];

        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


//切换语言下的分类与菜单
-(void)postChangeLanguageWithLanguageId:(NSString *)languageId{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self rightSelctRemove];
    NSString *url = [API stringByAppendingString:@"shops/seeCats"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"languageId":languageId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"查看商品 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            NSArray *dishes = responseObject[@"dishes"];
            NSArray *goods = responseObject[@"goods"];
            
            if (![dishes isKindOfClass:[NSNull class]] && dishes != nil) {
                _dishesList = dishes;
            }
            else
                _dishesList = @[];
            
            if (![goods isKindOfClass:[NSNull class]] && goods != nil) {
                _menuVC.goodList = goods;
            }
            else
                _menuVC.goodList = @[];
            
            [self.tableView reloadData];
            [_menuVC.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"切换语言失败 %@", error);
        [_hud hideAnimated:YES];

        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}
#pragma mark 新建语言
- (void)postNewLanguage:(NSString *)language
{
    if ([self.existLanguageArray containsObject:language]) {
        UIAlertController *alertSelect = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经存在改语言" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertSelect animated:YES completion:nil];
        [alertSelect addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //        [self.navigationController popViewControllerAnimated:YES];
            self.navigationItem.rightBarButtonItem.enabled = YES;
//            self.existLanguageArray = nil;
        }]];
    }else{
    NSString *url = [API stringByAppendingString:@"shops/addLanguage"];
    NSDictionary *dic = @{@"language":language,@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject != nil) {
            if (responseObject[@"res"]) {
                [self.languageList addObject:language];
                //            NSLog(@"%@",language);
                //            [self.languageScrollView reloadInputViews];
                [self postGetSeeOrder];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];}
}


- (void)postDelLanguage:(NSString *)catId
{
//    BOOL exit = NO;
//    NSString *catId;
//    for (NSInteger i = 0; i < self.languageList.count; i++) {
//        if ([self.languageList[i][@"catName"] isEqualToString:catName]) {
//            catId = self.languageList[i][@"languageId"];
////            NSLog(@"111111111111要删除的语言%@",self.languageList[i]);
//        }
//    }
//    if (!exit) {
//        UIAlertController *alertSelect = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经存在改语言" preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:alertSelect animated:YES completion:nil];
//        [alertSelect addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            //        [self.navigationController popViewControllerAnimated:YES];
//            self.navigationItem.rightBarButtonItem.enabled = YES;
//        }]];
//    }else{
    
    NSString *url = [API stringByAppendingString:@"shops/deletelang"];
    NSDictionary *dic = @{@"catId":catId,@"shopId":[AppDelegate APP].user.shopId};
//    NSLog(@"%@",dic);
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject != nil) {
//               NSLog(@"返回%@",responseObject);
            if ([[responseObject[@"res"] stringValue] isEqualToString:@"1"]) {
//            [self.languageList removeObjectAtIndex:0];
//            NSLog(@"删除%@",catId);
//            [self.languageScrollView reloadInputViews];
             
                [self postGetSeeOrder];
            }else{
                UIAlertController *alertSelect = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除失败" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertSelect animated:YES completion:nil];
                [alertSelect addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
                }]];
//                   NSLog(@"返回%@",responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
//}
}
//离开视图控制器注销通知
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"editGoods" object:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
