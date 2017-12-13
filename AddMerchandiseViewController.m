//
//  AddMerchandiseViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/26.
//  Copyright © 2017年 Mac. All rights reserved.
//

//**添加商品**//

#import "AddMerchandiseViewController.h"
#import "SelectAlert.h"
#import "XLPhotoBrowser.h"
#import "propertyCell02.h"
#import "propertyCell03.h"
#import "propertyCell05.h"
#import "propertyCell06.h"
#import "propertyCell09.h"
#import "AddEditViewController.h"
#import "EditAttributeViewController.h"


@interface AddMerchandiseViewController ()<UITextViewDelegate, VPImageCropperDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource, UITextFieldDelegate>{
    
    MBProgressHUD *hud;

}

//@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
//- (IBAction)switchBtnChanged:(id)sender;

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UITextView *describeTView;   //商品描述
@property (weak, nonatomic) IBOutlet UITextField *name;           //商品名称
//@property (weak, nonatomic) IBOutlet UITextField *price;          //商品价格
//@property (weak, nonatomic) IBOutlet UITextField *inventoryNum;   //库存数量
//@property (weak, nonatomic) IBOutlet UITextField *boxNum;         //餐盒数量
//@property (weak, nonatomic) IBOutlet UITextField *boxPrice;       //餐盒价格
@property (weak, nonatomic) IBOutlet UITextField *unit;           //商品单位
//@property (weak, nonatomic) IBOutlet UITextField *minimum;        //最小购买量


@property (weak, nonatomic) IBOutlet UIButton *foodClassBtn;      //商品类型按钮
@property (weak, nonatomic) IBOutlet UIButton *selectLanguageBtn;  //选择语言按钮

@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;   //图片
@property (strong, nonatomic) UIImage *OldImg;   //图片样板

@property (weak, nonatomic) IBOutlet UIButton *taocanBtn;    //套餐按钮
@property (weak, nonatomic) IBOutlet UIButton *zhaopaiBtn;   //招牌按钮

@property (strong, nonatomic) UIView *footerView;

@property BOOL isTaocan;
@property BOOL isZhaopai;
//@property BOOL isChangeImage;      //是否改变图片

@property (strong, nonatomic) UIButton *btn01;   //底部按钮
@property (strong, nonatomic) UIButton *btn02;   //底部按钮
@property (strong, nonatomic) UIButton *senderBtn;


@end

@implementation AddMerchandiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"阿凡提商家";
    _isTaocan = NO;
    _isZhaopai = NO;
    _describeTView.delegate = self;
    _name.delegate = self;
    _OldImg = [UIImage imageNamed:@"加号-2"];
    //设置tableView键盘返回样式--很方便
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
    [self initView];
    [self initViewBtn];
    [self PostLanguageAddTitle];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell02" bundle:nil] forCellReuseIdentifier:@"propertyCell02"];
    [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell03" bundle:nil] forCellReuseIdentifier:@"propertyCell03"];
    [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell05" bundle:nil] forCellReuseIdentifier:@"propertyCell05"];
    [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell06" bundle:nil] forCellReuseIdentifier:@"propertyCell06"];
    [self.tableView registerNib:[UINib nibWithNibName:@"propertyCell09" bundle:nil] forCellReuseIdentifier:@"propertyCell09"];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    //为编辑的时，添加信息
    if ([_type isEqualToString:@"编辑"]) {
        if (_goods[@"goodsName"] != nil && ![_goods[@"goodsName"] isKindOfClass:[NSNull class]]) {
            _name.text = _goods[@"goodsName"];
        }
        else{
            _name.text = @"";
        }
        if (_goods[@"goodsImg"] != nil && ![_goods[@"goodsImg"] isKindOfClass:[NSNull class]]) {
            [_imgView sd_setImageWithURL:[NSURL URLWithString:[API_IMG stringByAppendingString:_goods[@"goodsImg"]]] placeholderImage:[UIImage imageNamed:@"加号-2"]];
            _OldImg = _imgView.image;
        }
        else
            _imgView.image = [UIImage imageNamed:@"加号-2"];
        
        if (_goods[@"goodsUnit"] != nil && ![_goods[@"goodsUnit"] isKindOfClass:[NSNull class]]) {
            _unit.text = _goods[@"goodsUnit"];
        }
        else{
            _unit.text = @"";
        }
        if (_goods[@"goodsDesc"] != nil && ![_goods[@"goodsDesc"] isKindOfClass:[NSNull class]]) {
            _describeTView.text = _goods[@"goodsDesc"];
            _placeHolderLabel.text = @"";
        }
        else{
            _describeTView.text = @"";
            _placeHolderLabel.text = @"介绍一下你的产品吧，200个字以内就可以哦";
        }

        //根据attr属性获取商品的规格和属性 attr = 0则不用获取
        if ([_goods[@"attr"] isEqualToString:@"0"] || [_goods[@"attr"] isEqualToString:@"2"]) {
            propertyCell03 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            if (_goods[@"shopPrice"] != nil && ![_goods[@"shopPrice"] isKindOfClass:[NSNull class]]) {
                cell.shopPrice.text = _goods[@"shopPrice"];
            }
            else{
                cell.shopPrice.text = @"";
            }
            if (_goods[@"goodsSort"] != nil && ![_goods[@"goodsSort"] isKindOfClass:[NSNull class]]) {
                cell.goodsStock.text = _goods[@"goodsSort"];
            }
            else{
                cell.goodsStock.text = @"";
            }

            //判断是否有属性
            if ([_goods[@"attr"] isEqualToString:@"2"]) {
                [self postGoodsGuigeAndAttrWith:_goods[@"goodsId"] Attr:_goods[@"attr"]];
            }
            
            [self.tableView reloadData];
        }
        else{
            //获取规格、属性
            [self postGoodsGuigeAndAttrWith:_goods[@"goodsId"] Attr:_goods[@"attr"]];
        }
        
        
        //改变底部按钮样式
        [_btn01 setTitle:@"删除" forState:UIControlStateNormal];
        [_btn01 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        if ([_goods[@"isSale"] isEqualToString:@"1"]) {
            [_btn02 setTitle:@"下架" forState:UIControlStateNormal];
        }
        else{
            [_btn02 setTitle:@"上架" forState:UIControlStateNormal];
            
        }
        
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

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addSubview:_footerView];


}


-(void)pressBack{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出后修改内容将不被保存，是否退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//添加点击事件
-(void)initViewBtn{
    [_foodClassBtn setTitle:_catName forState:UIControlStateNormal];
    [_selectLanguageBtn setTitle:_language forState:UIControlStateNormal];
    [_foodClassBtn addTarget:self action:@selector(foodClassBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_selectLanguageBtn addTarget:self action:@selector(selectLanguageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_imgBtn addTarget:self action:@selector(imgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _isTaocan = NO;
    _isZhaopai = NO;
    _taocanBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _taocanBtn.layer.borderWidth = 1;
    [_taocanBtn.layer setCornerRadius:3];
    _zhaopaiBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _zhaopaiBtn.layer.borderWidth = 1;
    [_zhaopaiBtn.layer setCornerRadius:3];
    [_taocanBtn addTarget:self action:@selector(taocanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_zhaopaiBtn addTarget:self action:@selector(zhaopaiBtnClick) forControlEvents:UIControlEventTouchUpInside];

}


-(void)initView{
    //添加返回按钮事件
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 40, 40);
    button.imageView.contentMode = UIViewContentModeLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnLeft = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnLeft;

    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    //添加textview的place属性
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.text = @"介绍一下你的产品吧，200个字以内就可以哦";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_describeTView addSubview:_placeHolderLabel];
    
    //底部按钮
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _footerView.backgroundColor = [UIColor whiteColor];
    _btn01 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
    _btn01.backgroundColor = [UIColor whiteColor];
    [_btn01 setTitle:@"保存并继续新建" forState:UIControlStateNormal];
    [_btn01 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn01.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btn01 addTarget:self action:@selector(btn01Click) forControlEvents:UIControlEventTouchUpInside];
    
    _btn02 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
    _btn02.backgroundColor = [UIColor colorWithRed:87/255.0 green:190/255.0 blue:174/255.0 alpha:1];
    [_btn02 setTitle:@"保存并返回" forState:UIControlStateNormal];
    _btn02.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btn02 addTarget:self action:@selector(btn02Click) forControlEvents:UIControlEventTouchUpInside];

    [_footerView addSubview:_btn01];
    [_footerView addSubview:_btn02];

    [self.navigationController.view addSubview:_footerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    switch (indexPath.section) {
        case 1:{
            if (_guigeList.count == 0 || _guigeList.count == 1) {
                return 130 + 40;
            }
            else{
                if (indexPath.row == 0) {
                    return 54;
                }
                else
                    return 125;
            }
        }
            break;
        case 2:{
            if (_guigeAttr.count == 0) {
                return 54;
            }
            else{
                if (indexPath.row == 0) {
                    return 54;
                }
                else
                    return 120;
            }
        }
            break;
//        case 3:{
//            if (indexPath.row == 2) {
//                if (_isTaocan) {
//                    return 44;
//                }
//                else
//                    return 0;
//            }
//            else
//                return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//
//        }
//            break;


        default:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            break;
    }
    
    return 0;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            if (_guigeList.count == 1) {
                return 1;
            }
            else
                return 1 + _guigeList.count;
        }
            break;
        case 2:{
            return 1 + _guigeAttr.count;
        }
            break;
        case 3:
            return 5;
            break;

            
        default:
            break;
    }
    return [super tableView:tableView numberOfRowsInSection:section];

}


//静态、动态cell混用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:{
            //规格cell
            //如果是多规格--加载规格头部
            if (_guigeList.count == 0) {
                propertyCell03 *cell = [tableView dequeueReusableCellWithIdentifier:@"propertyCell03" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[propertyCell03 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell03"];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                cell.addBtn.tag = indexPath.row;
                [cell.addBtn addTarget:self action:@selector(addGuigeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.swichNumber addTarget:self action:@selector(IsSwichNumber:) forControlEvents:UIControlEventValueChanged];
                [cell.swichNumber setOn:NO];
                cell.goodsStock.enabled = true;
                
                return cell;
            }
            else if (_guigeList.count == 1){
                propertyCell03 *cell = [tableView dequeueReusableCellWithIdentifier:@"propertyCell03" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[propertyCell03 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell03"];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                cell.addBtn.tag = indexPath.row;
                [cell.addBtn addTarget:self action:@selector(addGuigeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if (_guigeList[0][@"price"] != nil && ![_guigeList[0][@"price"] isKindOfClass:[NSNull class]]) {
                    cell.shopPrice.text = [NSString stringWithFormat:@"%@", _guigeList[0][@"price"]];
                }
                else{
                    cell.shopPrice.text = @"";
                }

                if (_guigeList[0][@"kucun"] != nil && ![_guigeList[0][@"kucun"] isKindOfClass:[NSNull class]]) {
                    if ([_guigeList[0][@"kucun"] isEqualToString:@"-1"]) {
                        cell.goodsStock.text = @"无限";
                        [cell.swichNumber setOn:YES];
                        cell.goodsStock.enabled = false;
                    }
                    else{
                        cell.goodsStock.text = [NSString stringWithFormat:@"%@", _guigeList[0][@"kucun"]];
                        [cell.swichNumber setOn:NO];
                        cell.goodsStock.enabled = true;
                    }
                }
                else{
                    cell.goodsStock.text = @"";
                    [cell.swichNumber setOn:NO];
                    cell.goodsStock.enabled = true;
                }
                
                [cell.swichNumber addTarget:self action:@selector(IsSwichNumber:) forControlEvents:UIControlEventValueChanged];
                
                return cell;
            }
            else{
                if (indexPath.row == 0) {
                    propertyCell09 *cell = [tableView dequeueReusableCellWithIdentifier:@"propertyCell09" forIndexPath:indexPath];
                    if (cell == nil) {
                        cell = [[propertyCell09 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell09"];
                        
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    cell.topVeiw.backgroundColor = [UIColor whiteColor];
                    cell.titleName.text = @"商品规格";
                    [cell.editType setTitle:@"编辑规格" forState:UIControlStateNormal];
                    [cell.editType addTarget:self action:@selector(editTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
                else{
                    propertyCell06 *cell = [tableView dequeueReusableCellWithIdentifier:@"propertyCell06" forIndexPath:indexPath];
                    if (cell == nil) {
                        cell = [[propertyCell06 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell06"];
                        
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    cell.number.text = [NSString stringWithFormat:@"%@%ld", @"规格", (long)indexPath.row];
                    
                    if (_guigeList[indexPath.row - 1][@"guigeName"] != nil && ![_guigeList[indexPath.row - 1][@"guigeName"] isKindOfClass:[NSNull class]]) {
                        cell.guigeName.text = [NSString stringWithFormat:@"%@%@", @"商品名称：", _guigeList[indexPath.row - 1][@"guigeName"]];
                    }
                    else{
                        cell.guigeName.text = @"商品名称：";
                    }
                    
                    if (_guigeList[indexPath.row - 1][@"price"] != nil && ![_guigeList[indexPath.row - 1][@"price"] isKindOfClass:[NSNull class]]) {
                        cell.price.text = [NSString stringWithFormat:@"%@%@", @"价格：", _guigeList[indexPath.row - 1][@"price"]];
                    }
                    else{
                        cell.price.text = @"价格：";
                    }

                    if (_guigeList[indexPath.row - 1][@"kucun"] != nil && ![_guigeList[indexPath.row - 1][@"kucun"] isKindOfClass:[NSNull class]]) {
                        if ([_guigeList[indexPath.row - 1][@"kucun"] isEqualToString:@"-1"]) {
                            cell.kucun.text = @"库存：无限";
                        }
                        else{
                            cell.kucun.text = [NSString stringWithFormat:@"%@%@", @"库存：", _guigeList[indexPath.row - 1][@"kucun"]];
                        }
                    }
                    else{
                        cell.kucun.text = @"库存：";
                    }
                    
                    cell.delectBtn.tag = indexPath.row;
                    [cell.delectBtn addTarget:self action:@selector(guigeDelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                }
            }

        }
            break;
        case 2:{
            //属性cell
            //添加编辑属性标题
            if (indexPath.row == 0) {
                propertyCell02 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"propertyCell02" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[propertyCell02 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell02"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.editType addTarget:self action:@selector(addAttributeBtnClick) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            //属性
            else{
                propertyCell05 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"propertyCell05" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[propertyCell05 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"propertyCell05"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title.text = [NSString stringWithFormat:@"%@%ld", @"属性", (long)indexPath.row];
                
                if (_guigeAttr[indexPath.row - 1][@"attrName"] != nil && ![_guigeAttr[indexPath.row - 1][@"attrName"] isKindOfClass:[NSNull class]]) {
                    cell.attrName.text = [NSString stringWithFormat:@"%@%@", @"属性名称：", _guigeAttr[indexPath.row - 1][@"attrName"]];
                }
                else{
                    cell.attrName.text = @"属性名称：";
                }
                
                if (_guigeAttr[indexPath.row - 1][@"attrContent"] != nil && ![_guigeAttr[indexPath.row - 1][@"attrContent"] isKindOfClass:[NSNull class]]) {
                    cell.attrContent.text = [NSString stringWithFormat:@"%@%@", @"属性标签：", _guigeAttr[indexPath.row - 1][@"attrContent"]];
                }
                else{
                    cell.attrName.text = @"属性标签：";
                }

                cell.attrDelectBtn.tag = indexPath.row;
                [cell.attrDelectBtn addTarget:self action:@selector(attrDelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.attrDelectBtn.hidden = YES;
                
                return cell;
            }
        }
            break;
            
        default:
            break;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

    
}


//需要实现该协议
//cell的缩进级别，动态静态cell必须重写，否则会造成崩溃
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(1 == indexPath.section){ //（动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:1]];
    }
    if(2 == indexPath.section){ //（动态cell）
        return [super tableView:tableView indentationLevelForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection:2]];
    }

    return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   
}





//是否库存无限
-(void)IsSwichNumber:(id)sender{
    UISwitch *switchNum = (UISwitch *)sender;
    propertyCell03 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if ([switchNum isOn]) {
        cell.goodsStock.text = @"无限";
        cell.goodsStock.enabled = false;
    }
    else{
        cell.goodsStock.text = @"";
        cell.goodsStock.enabled = true;
    }
}





-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _name) {
        if (_name.text.length > 20) {
            [Util toastWithView:self.navigationController.view AndText:@"名字长度不能大于20个字"];
        }
    }
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHolderLabel.text = @"";
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0 ){
        _placeHolderLabel.text = @"介绍一下你的产品吧，200个字以内就可以哦";
    }
    else{
        _placeHolderLabel.text = @"";
    }
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 200) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"最多输入200字" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:cancelAction];
        [self presentViewController:alter animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)switchBtnChanged:(id)sender {
//    if ([_switchBtn isOn]) {
//        NSLog(@"kai");
//        [self.tableView reloadData];
//    }
//    else{
//        NSLog(@"kguan");
//        [self.tableView reloadData];
//    }
//}


//底部按钮--保存并继续新建---或者删除
-(void)btn01Click{
    if ([_type isEqualToString:@"编辑"]) {
        //点击删除
        [self postDeleteCatWithGoodsId:_goods[@"goodsId"]];
    }
    else{
        if ([_name.text isEqualToString:@""] || [UIImagePNGRepresentation(_imgView.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"加号-2"])]) {
            [Util toastWithView:self.navigationController.view AndText:@"标红项不能为空！"];
            return ;
        }
        
        //判断图片大小
        NSData *data = UIImageJPEGRepresentation(_imgView.image, 1);
        NSLog(@"大小 = %lu", [data length]/1000);
        if ([data length]/1000 > 2 *1024) {
            [Util toastWithView:self.navigationController.view AndText:@"图片大小不能大于2M"];
            return ;
        }

        NSDictionary *infor = [[NSDictionary alloc] init];
        NSArray *guige = [[NSArray alloc] init];
        NSDictionary *guigeAttr = [[NSDictionary alloc] init];
        
        //是否有规格属性 0为没有 1为有规格 2为有属性 3为两者都有
        NSString *attr = @"0";
        if (_guigeList.count < 2) {
            if (_guigeAttr.count != 0) {
                attr = @"2";
            }
            else
                attr = @"0";
        }
        else{
            if (_guigeAttr.count != 0) {
                attr = @"3";
            }
            else
                attr = @"1";
        }
        
        //判断是否为多规格
        if (_guigeList.count < 2) {
            //单规格
            //获取对应的cell
            propertyCell03 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            if ([cell.shopPrice.text isEqualToString:@""] || [cell.goodsStock.text isEqualToString:@""]) {
                [Util toastWithView:self.navigationController.view AndText:@"标红项不能为空！"];
                return ;
            }
            else{
                
                infor = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsName":_name.text, @"shopCatId1":_languageId, @"shopCatId2":_catId, @"shopPrice":cell.shopPrice.text, @"goodsStock":[cell.goodsStock.text isEqualToString:@"无限"]?@"-1":cell.goodsStock.text, @"goodsUnit":_unit.text, @"goodsDesc":_describeTView.text, @"attr":attr};
            }
            
        }
        else{
            //多规格
            infor = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsName":_name.text, @"shopCatId1":_languageId, @"shopCatId2":_catId, @"shopPrice":_guigeList[0][@"price"], @"goodsStock":_guigeList[0][@"kucun"], @"goodsUnit":_unit.text, @"goodsDesc":_describeTView.text, @"attr":attr};
            guige = [_guigeList copy];
        }
        
        if (guigeAttr.count != 0) {
            guigeAttr = @{@"shopId":_guigeAttr[0][@"shopId"], @"attrName":_guigeAttr[0][@"attrName"], @"attrContent":_guigeAttr[0][@"attrContent"]};
        }
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        //接口调用
        //ender: 1：继续创建  0：保存退出
        [self postAddGoodsWithData:infor Guige:guige GuigeAttr:guigeAttr Ender:@"1"];

    }
    
}

//保存并返回---或者上架下架
-(void)btn02Click{
    if ([_type isEqualToString:@"编辑"]) {
        //判断是上架还是下架
        if ([_goods[@"isSale"] isEqualToString:@"1"]) {
            NSString *url = [API stringByAppendingString:@"shops/xiaJia"];
            [self postSoldOutWithUrl:url GoodeId:_goods[@"goodsId"]];
        }
        else{
            NSString *url = [API stringByAppendingString:@"shops/shangJia"];
            [self postPutAwayWithUrl:url GoodeId:_goods[@"goodsId"]];
        }
    }
    else{
        if ([_name.text isEqualToString:@""] || [UIImagePNGRepresentation(_imgView.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"加号-2"])]) {
            [Util toastWithView:self.navigationController.view AndText:@"标红项不能为空！"];
            return ;
        }
        
        //判断图片大小
        NSData *data = UIImageJPEGRepresentation(_imgView.image, 1);
        NSLog(@"大小 = %lu", [data length]/1000);
        if ([data length]/1000 > 2 *1024) {
            [Util toastWithView:self.navigationController.view AndText:@"图片大小不能大于2M"];
            return ;
        }
        
        NSDictionary *infor = [[NSDictionary alloc] init];
        NSArray *guige = [[NSArray alloc] init];
        NSDictionary *guigeAttr = [[NSDictionary alloc] init];
        
        //是否有规格属性 0为没有 1为有规格 2为有属性 3为两者都有
        NSString *attr = @"0";
        if (_guigeList.count < 2) {
            if (_guigeAttr.count != 0) {
                attr = @"2";
            }
            else
                attr = @"0";
        }
        else{
            if (_guigeAttr.count != 0) {
                attr = @"3";
            }
            else
                attr = @"1";
        }
        
        //判断是否为多规格
        if (_guigeList.count < 2) {
            //单规格
            //获取对应的cell
            propertyCell03 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            if ([cell.shopPrice.text isEqualToString:@""] || [cell.goodsStock.text isEqualToString:@""]) {
                [Util toastWithView:self.navigationController.view AndText:@"标红项不能为空！"];
                return ;
            }
            else{
                
                infor = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsName":_name.text, @"shopCatId1":_languageId, @"shopCatId2":_catId, @"shopPrice":cell.shopPrice.text, @"goodsStock":cell.goodsStock.text, @"goodsUnit":_unit.text, @"goodsDesc":_describeTView.text, @"attr":attr};
            }
            
        }
        else{
            //多规格
            infor = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsName":_name.text, @"shopCatId1":_languageId, @"shopCatId2":_catId, @"shopPrice":_guigeList[0][@"price"], @"goodsStock":_guigeList[0][@"kucun"], @"goodsUnit":_unit.text, @"goodsDesc":_describeTView.text, @"attr":attr};
            guige = [_guigeList copy];
        }
        if (_guigeAttr.count != 0) {
            guigeAttr = @{@"shopId":_guigeAttr[0][@"shopId"], @"attrName":_guigeAttr[0][@"attrName"], @"attrContent":_guigeAttr[0][@"attrContent"]};
        }
        
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        //接口调用
        //ender: 1：继续创建  0：保存退出
        [self postAddGoodsWithData:infor Guige:guige GuigeAttr:guigeAttr Ender:@"0"];

    }

}

//点击套餐按钮
-(void)taocanBtnClick{
    _isTaocan = !_isTaocan;
    if (_isTaocan) {
        _taocanBtn.layer.borderColor = Nav_color.CGColor;
        [_taocanBtn setTitleColor:Nav_color forState:UIControlStateNormal];
        _taocanBtn.backgroundColor = [UIColor whiteColor];
        [self.tableView reloadData];

    }
    else{
        _taocanBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_taocanBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _taocanBtn.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:242/255.0 alpha:1];
        [self.tableView reloadData];
    }

}

//点击招牌按钮
-(void)zhaopaiBtnClick{
    _isZhaopai = !_isZhaopai;
    if (_isZhaopai) {
        _zhaopaiBtn.layer.borderColor = Nav_color.CGColor;
        [_zhaopaiBtn setTitleColor:Nav_color forState:UIControlStateNormal];
        _zhaopaiBtn.backgroundColor = [UIColor whiteColor];
    }
    else{
        _zhaopaiBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_zhaopaiBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _zhaopaiBtn.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:242/255.0 alpha:1];
    }
}


//选择商品分类
-(void)foodClassBtnClick{
    [self.tableView endEditing:YES];
    self.tableView.scrollEnabled = NO;
    if (_dishesList.count == 0) {
        return ;
    }
    SelectAlert *alert = [SelectAlert showWithTitle:@"菜单" titles:_dishesList selectIndex:^(NSInteger selectIndex) {
        self.tableView.scrollEnabled = YES;
        //更改标记的分类id
        _catId = _dishesList[selectIndex][@"catId"];
        _catName = _dishesList[selectIndex][@"catName"];
    } selectValue:^(NSString *selectValue) {
        [_foodClassBtn setTitle:selectValue forState:UIControlStateNormal];
        NSLog(@"%@", selectValue);
    } showCloseButton:YES];
    
    //回调，开启视图滚动功能
    alert.block = ^{
        self.tableView.scrollEnabled = YES;
    };
    
    __weak AddMerchandiseViewController *weakSelf = self;
    [weakSelf.view addSubview:alert];
}


//选择语言类型
-(void)selectLanguageBtnClick{
    [self.tableView endEditing:YES];
    self.tableView.scrollEnabled = NO;
    if (_languageList.count == 0) {
        return ;
    }
    SelectAlert *alert = [SelectAlert showWithTitle:@"语言" titles:_languageList selectIndex:^(NSInteger selectIndex) {
        self.tableView.scrollEnabled = YES;
        //更改标记的语言id
        _languageId = _languageList[selectIndex][@"languageId"];
        if (_languageList[selectIndex][@"dishes"] != nil) {
            _dishesList = _languageList[selectIndex][@"dishes"];
            _catId = _dishesList[0][@"catId"];
            _catName = _dishesList[0][@"catName"];
            [_foodClassBtn setTitle:_catName forState:UIControlStateNormal];

        }
        else{
            _dishesList = @[];
            _catId = @"";
            _catName = @"";
            [_foodClassBtn setTitle:_catName forState:UIControlStateNormal];
        }
        
        
    } selectValue:^(NSString *selectValue) {
        
        [_selectLanguageBtn setTitle:selectValue forState:UIControlStateNormal];
        NSLog(@"%@", selectValue);
        
    } showCloseButton:YES];
    
    //回调，开启视图滚动功能
    alert.block = ^{
        self.tableView.scrollEnabled = YES;
    };
    
    __weak AddMerchandiseViewController *weakSelf = self;
    [weakSelf.view addSubview:alert];

}


//添加规格
-(void)addGuigeBtnClick:(id)sender{
    NSLog(@"添加规格");
    UIButton *btn = (UIButton *)sender;
    AddEditViewController *vc = [[AddEditViewController alloc] init];
    propertyCell03 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:1]];
    vc.shopPrice = cell.shopPrice.text;
    if ([cell.swichNumber isOn]) {
        vc.goodsStock = @"-1";
    }
    else{
        vc.goodsStock = cell.goodsStock.text;
    }
    vc.type = @"添加规格";
    vc.guigeList = [NSMutableArray array];
    if (_guigeList.count < 2) {
        [_guigeList removeAllObjects];
    }
    vc.guigeList = [_guigeList mutableCopy];
    vc.block = ^(NSMutableArray *guigeList) {
        _guigeList = guigeList;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

//编辑规格
-(void)editTypeBtnClick:(id)sender{
//    UIButton *btn = (UIButton *)sender;
    AddEditViewController *vc = [[AddEditViewController alloc] init];
    vc.guigeList = [NSMutableArray array];
    vc.type = @"编辑规格";
    vc.guigeList = [_guigeList mutableCopy];
    vc.block = ^(NSMutableArray *guigeList) {
        _guigeList = guigeList;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//删除规格按钮
-(void)guigeDelectBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [_guigeList removeObjectAtIndex:btn.tag - 1];
    [self.tableView reloadData];
}


//编辑属性
-(void)addAttributeBtnClick{
    EditAttributeViewController *vc = [[EditAttributeViewController alloc] init];
    vc.guigeAttr = [NSMutableArray array];
    vc.guigeAttr = [_guigeAttr mutableCopy];
    vc.block = ^(NSMutableArray *AttributeArray) {
//        [_guigeAttr removeAllObjects];
        _guigeAttr = AttributeArray;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//删除属性
-(void)attrDelectBtnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [_guigeAttr removeObjectAtIndex:btn.tag - 1];
    [self.tableView reloadData];
}


//点击保存--编辑时
-(void)senderBtnClick{
    if ([_name.text isEqualToString:@""] || [UIImagePNGRepresentation(_imgView.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"加号-2"])]) {
        [Util toastWithView:self.navigationController.view AndText:@"标红项不能为空！"];
        return ;
    }
    
    //判断图片大小
    NSData *data = UIImageJPEGRepresentation(_imgView.image, 1);
    NSLog(@"大小 = %lu", [data length]/1000);
    if ([data length]/1000 > 2 *1024) {
        [Util toastWithView:self.navigationController.view AndText:@"图片大小不能大于2M"];
        return ;
    }

    NSDictionary *infor = [[NSDictionary alloc] init];
    NSArray *guige = [[NSArray alloc] init];
    NSDictionary *guigeAttr = [[NSDictionary alloc] init];

    //是否有规格属性 0为没有 1为有规格 2为有属性 3为两者都有
    NSString *attr = @"0";
    if (_guigeList.count < 2) {
        if (_guigeAttr.count != 0) {
            attr = @"2";
        }
        else
            attr = @"0";
    }
    else{
        if (_guigeAttr.count != 0) {
            attr = @"3";
        }
        else
            attr = @"1";
    }
    
    //判断是否为多规格
    if (_guigeList.count < 2) {
        //单规格
        //获取对应的cell
        propertyCell03 *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if ([cell.shopPrice.text isEqualToString:@""] || [cell.goodsStock.text isEqualToString:@""]) {
            [Util toastWithView:self.navigationController.view AndText:@"标红项不能为空！"];
            return ;
        }
        else{
            infor = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":_goods[@"goodsId"],@"goodsName":_name.text, @"shopCatId1":_languageId, @"shopCatId2":_catId, @"shopPrice":cell.shopPrice.text, @"goodsStock":[cell.goodsStock.text isEqualToString:@"无限"]?@"-1":cell.goodsStock.text, @"goodsUnit":_unit.text, @"goodsDesc":_describeTView.text, @"attr":attr};
        }
        
    }
    else{
        //多规格
        infor = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":_goods[@"goodsId"],@"goodsName":_name.text, @"shopCatId1":_languageId, @"shopCatId2":_catId, @"shopPrice":_guigeList[0][@"price"], @"goodsStock":_guigeList[0][@"kucun"], @"goodsUnit":_unit.text, @"goodsDesc":_describeTView.text, @"attr":attr};
        guige = [_guigeList copy];
    }
    
    if (_guigeAttr.count != 0) {
        if (_guigeAttr[0][@"attrId"] == nil) {
            guigeAttr = @{@"shopId":_guigeAttr[0][@"shopId"], @"attrName":_guigeAttr[0][@"attrName"], @"attrContent":_guigeAttr[0][@"attrContent"]};
        }
        else
            guigeAttr = @{@"shopId":_guigeAttr[0][@"shopId"], @"attrId":_guigeAttr[0][@"attrId"], @"attrName":_guigeAttr[0][@"attrName"], @"attrContent":_guigeAttr[0][@"attrContent"]};

    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    //接口调用
    if ([_type isEqualToString:@"编辑"]) {
        //判断图片是否被修改
        if ([UIImagePNGRepresentation(_imgView.image) isEqual:UIImagePNGRepresentation(_OldImg)]) {
            [self postEditSenderWithDataButNoImage:infor Guige:guige GuigeAttr:guigeAttr];
        }
        else{
            [self postEditSenderWithData:infor Guige:guige GuigeAttr:guigeAttr];
        }
    }
    else{
        //ender: 1：继续创建  0：保存退出
        [self postAddGoodsWithData:infor Guige:guige GuigeAttr:guigeAttr Ender:@"0"];
    }


}



//选择图片
-(void)imgBtnClick{
    [_footerView removeFromSuperview];
    
    UIAlertController *actionsheetController = [[UIAlertController alloc]init];
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    UIAlertAction *canceAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self.navigationController.view addSubview:_footerView];
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate=self;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        
        else {
            
            [Util toastWithView:self.view AndText:@"不支持相机"];
        }
    }];
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate=self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    
    [actionsheetController addAction: canceAction];
    [actionsheetController addAction:takePhotoAction];
    [actionsheetController addAction:selectAction];
    [self presentViewController:actionsheetController animated:true completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    //通过key值获取到图片
    //    image =info[UIImagePickerControllerOriginalImage];
    [self showEditImageController:info[UIImagePickerControllerOriginalImage]];
    
    //判断数据源类型
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        NSLog(@"在相机中选择图片");
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)showEditImageController:(UIImage *)image {
    CGFloat y = (self.view.bounds.size.height - self.view.bounds.size.width) / 2.0;
    VPImageCropperViewController *imageCropper = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, y-50, self.view.bounds.size.width, self.view.bounds.size.width) limitScaleRatio:3.0];
    imageCropper.delegate = self;
    [self.navigationController pushViewController:imageCropper animated:YES];
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController.navigationController popViewControllerAnimated:YES];
    _imgView.image = editedImage;
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //选完图片将底部视图显示出来
    [self.navigationController.view addSubview:_footerView];
    
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_footerView removeFromSuperview];
}


#pragma mark - 接口--添加商品



-(void)postAddGoodsWithData:(NSDictionary *)infor Guige:(NSArray *)guige GuigeAttr:(NSDictionary *)guigeAttr Ender:(NSString *)ender{
    NSString *url = [API stringByAppendingString:@"UploadFood/addGoods"];
    NSDictionary *dic = [[NSDictionary alloc] init];

    if ([infor[@"attr"] isEqualToString:@"3"]) {
        dic = @{@"data":[Util convertToJSONData:infor], @"guige":[Util arrayToJSONString:guige], @"guigeAttr":[Util convertToJSONData:guigeAttr]};
        
    }
    else if([infor[@"attr"] isEqualToString:@"2"]){
        dic = @{@"data":[Util convertToJSONData:infor], @"guigeAttr":[Util convertToJSONData:guigeAttr]};

    }
    else if([infor[@"attr"] isEqualToString:@"1"]){
        dic = @{@"data":[Util convertToJSONData:infor], @"guige":[Util arrayToJSONString:guige]};

    }
    else{
        dic = @{@"data":[Util convertToJSONData:infor]};

    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSData *data = UIImageJPEGRepresentation(_imgView.image, 0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        NSLog(@"新建商品 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"商品创建成功"];
                if ([ender isEqualToString:@"1"]) {
                    _name.text = @"";
                    _imgView.image = [UIImage imageNamed:@"加号-2"];
                    _guigeList = [@[] mutableCopy];
                    _guigeAttr = [@[] mutableCopy];
                    _unit.text = @"";
                    _describeTView.text = @"";
                    [self.tableView reloadData];
                }
                else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else if ([res isEqualToString:@"3"]){
                [Util toastWithView:self.navigationController.view AndText:@"未检测到图片中包含食物，请重新选择.."];
            }
            else{
                if (responseObject[@"msg"] != nil) {
                    [Util toastWithView:self.navigationController.view AndText:@"图片规格不符合，请重新上传图片"];
                }
                else{
                    [Util toastWithView:self.navigationController.view AndText:@"商品创建失败"];
                }
            }
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"商品创建失败"];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商品创建失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];
}



//编辑时获取商品规格、属性
-(void)postGoodsGuigeAndAttrWith:(NSString *)goodsId Attr:(NSString *)attr{
    NSString *url = [API stringByAppendingString:@"Setshop/seeGoodsAttr"];
    NSDictionary *dic = @{@"goodsId":goodsId, @"attr":attr};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取商品规格属性 %@", responseObject);
        if (responseObject != nil) {
            NSMutableArray *guige = [NSMutableArray array];
            NSDictionary *guigeAttr = [[NSDictionary alloc] init];
            
            guige = responseObject[@"guige"];
            guigeAttr = responseObject[@"guigeAttr"];
            
            if (guige != nil && ![guige isKindOfClass:[NSNull class]]) {
                _guigeList = [guige mutableCopy];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                for (int i = 0; i < _guigeList.count; i++) {
                    dic = [_guigeList[i] mutableCopy];
                    [dic removeObjectForKey:@"goodsId"];
                    [dic removeObjectForKey:@"guigeId"];
                    [_guigeList removeObjectAtIndex:i];
                    [_guigeList insertObject:dic atIndex:i];
                }
            }
            if (guigeAttr != nil && ![guigeAttr isKindOfClass:[NSNull class]]) {
                [_guigeAttr addObject:guigeAttr];
            }
            
            [self.tableView reloadData];
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取规格属性失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取规格属性失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
    
}



//上架接口
-(void)postPutAwayWithUrl:(NSString *)url GoodeId:(NSString *)goodsIds{
    NSDictionary *dit = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsIds};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上架商品 %@", responseObject);
        //        OperationCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"上架成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else{
                [Util toastWithView:self.navigationController.view AndText:@"上架成功"];
            }
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"上架成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"操作失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

//下架接口
-(void)postSoldOutWithUrl:(NSString *)url GoodeId:(NSString *)goodsIds{
    NSDictionary *dit = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsIds};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dit progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下架商品 %@", responseObject);
        //        OperationCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"下架成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"下架失败"];
            
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"下架失败"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"操作失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}

//删除商品
-(void)postDeleteCatWithGoodsId:(NSString *)goodsIdStr{
    NSString *url = [API stringByAppendingString:@"shops/deleteGoods"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId, @"goodsId":goodsIdStr};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除商品 %@", responseObject);
        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
                [Util toastWithView:self.navigationController.view AndText:@"删除失败"];
            
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"删除失败"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"删除商品失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        
    }];
}


//编辑后保存商品
-(void)postEditSenderWithData:(NSDictionary *)infor Guige:(NSArray *)guige GuigeAttr:(NSDictionary *)guigeAttr{
    NSString *url = [API stringByAppendingString:@"UploadFood/saveGoods"];
    NSDictionary *dic = [[NSDictionary alloc] init];

    if ([infor[@"attr"] isEqualToString:@"3"]) {
        dic = @{@"data":[Util convertToJSONData:infor], @"guige":[Util arrayToJSONString:guige], @"guigeAttr":[Util convertToJSONData:guigeAttr]};
        
    }
    else if([infor[@"attr"] isEqualToString:@"2"]){
        dic = @{@"data":[Util convertToJSONData:infor], @"guigeAttr":[Util convertToJSONData:guigeAttr]};
        
    }
    else if([infor[@"attr"] isEqualToString:@"1"]){
        dic = @{@"data":[Util convertToJSONData:infor], @"guige":[Util arrayToJSONString:guige]};
        
    }
    else{
        dic = @{@"data":[Util convertToJSONData:infor]};
        
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"image/jpg",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        NSData *data=UIImagePNGRepresentation(image);
        if (![UIImagePNGRepresentation(_imgView.image) isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"加号-2"])]){
            
        }
        
        NSData *data = UIImageJPEGRepresentation(_imgView.image, 0.7);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        NSLog(@"编辑保存商品 %@", responseObject);

        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"]) {
                [Util toastWithView:self.navigationController.view AndText:@"保存成功"];

                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([res isEqualToString:@"3"]){
                [Util toastWithView:self.navigationController.view AndText:@"未检测到图片中包含食物，请重新选择.."];
            }
            else{
                if (responseObject[@"msg"] != nil) {
                    [Util toastWithView:self.navigationController.view AndText:@"图片规格不符合，请重新上传图片"];
                }
                else{
                    [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
                }
            }
        }
        else
            [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"商品编辑失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
        [hud hideAnimated:YES];
        
        return ;
    }];

}

//编辑保存--无图片
-(void)postEditSenderWithDataButNoImage:(NSDictionary *)infor Guige:(NSArray *)guige GuigeAttr:(NSDictionary *)guigeAttr{
    NSString *url = [API stringByAppendingString:@"UploadFood/saveGoods"];
    NSDictionary *dic = [[NSDictionary alloc] init];
    
    if ([infor[@"attr"] isEqualToString:@"3"]) {
        dic = @{@"data":[Util convertToJSONData:infor], @"guige":[Util arrayToJSONString:guige], @"guigeAttr":[Util convertToJSONData:guigeAttr]};
        
    }
    else if([infor[@"attr"] isEqualToString:@"2"]){
        dic = @{@"data":[Util convertToJSONData:infor], @"guigeAttr":[Util convertToJSONData:guigeAttr]};
        
    }
    else if([infor[@"attr"] isEqualToString:@"1"]){
        dic = @{@"data":[Util convertToJSONData:infor], @"guige":[Util arrayToJSONString:guige]};
        
    }
    else{
        dic = @{@"data":[Util convertToJSONData:infor]};
        
    }
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"编辑保存，无图片 %@", responseObject);
        [hud hideAnimated:YES];

        if (responseObject != nil) {
            NSString *res = [NSString stringWithFormat:@"%@", responseObject[@"res"]];
            if ([res isEqualToString:@"1"] || [res isEqualToString:@"2"]) {
                [Util toastWithView:self.navigationController.view AndText:@"保存成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                if (responseObject[@"msg"] != nil) {
                    [Util toastWithView:self.navigationController.view AndText:@"图片规格不符合，请重新上传图片"];
                }
                else{
                    [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
                }
            }
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"保存失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"保存无图片商品失败 %@", error);
        [hud hideAnimated:YES];
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];

}


//获取语言和分类
-(void)PostLanguageAddTitle{
    NSString *url = [API stringByAppendingString:@"shops/seeTitle"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取语言和分类 %@", responseObject);
        if (responseObject != nil) {
            _languageList = responseObject;
        }
        else{
            [Util toastWithView:self.navigationController.view AndText:@"获取语言和分类失败"];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取语言和分类失败 %@", error);
        [Util toastWithView:self.navigationController.view AndText:@"网络连接异常"];
    }];
}


@end
