//
//  StatisticsViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/27.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*评价统计*//


#import "StatisticsViewController.h"

@interface StatisticsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *zcping;  //中差评

@property (weak, nonatomic) IBOutlet UIView *sjBView;
@property (weak, nonatomic) IBOutlet UIView *kwBView;
@property (weak, nonatomic) IBOutlet UIView *bzBView;

@property (weak, nonatomic) IBOutlet UIView *sj;    //商家
@property (weak, nonatomic) IBOutlet UILabel *sjNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sjWidth;

@property (weak, nonatomic) IBOutlet UIView *kw;    //口味
@property (weak, nonatomic) IBOutlet UILabel *kwNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kwWidth;

@property (weak, nonatomic) IBOutlet UIView *bz;    //包装
@property (weak, nonatomic) IBOutlet UILabel *bzNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bzWith;

//@property (weak, nonatomic) IBOutlet UILabel *onTime;    //准时送达
//@property (weak, nonatomic) IBOutlet UILabel *quick;     //送货快
//@property (weak, nonatomic) IBOutlet UILabel *food;      //食材不新鲜
//@property (weak, nonatomic) IBOutlet UILabel *keepWarm;  //保温不到位
@property (weak, nonatomic) IBOutlet UIView *tagView;   //标签视图
@property (strong, nonatomic) NSArray *tagArray;

@property (weak, nonatomic) IBOutlet UILabel *allcount;   //总评价数
//分数
@property (weak, nonatomic) IBOutlet UILabel *WordOfMouth;    //评价口碑4.8，3.0
@property (weak, nonatomic) IBOutlet UILabel *shopAvg;        //商家评分
@property (weak, nonatomic) IBOutlet UITextView *shopCount;   //百分比
@property (weak, nonatomic) IBOutlet UILabel *tasteScore;     //口味评分
@property (weak, nonatomic) IBOutlet UILabel *warpScore;      //包装评分
@property (weak, nonatomic) IBOutlet UILabel *timeScore;      //配送评分
@property (weak, nonatomic) IBOutlet UILabel *dsm;            //配送时间

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    _sjBView.layer.cornerRadius = 7.5;
    _kwBView.layer.cornerRadius = 7.5;
    _bzBView.layer.cornerRadius = 7.5;
    _sj.layer.cornerRadius = 7.5;
    _kw.layer.cornerRadius = 7.5;
    _bz.layer.cornerRadius = 7.5;

    //实现富文本
    //NSMakeRange 参数1：从哪个开始   参数2：多少个字符
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_zcping.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:191/255.0 blue:125/255.0 alpha:1] range:NSMakeRange(5, 2)];
    _zcping.attributedText = str;
    
    
    //获取评价信息
    [self postShopPlCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        if (_tagArray.count <= 3) {
            return 40;
        }
        else
            return 25 * (_tagArray.count % 3 + 1);
    }
    else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

//获取评论统计
-(void)postShopPlCount{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *url = [API stringByAppendingString:@"Setshop/shopPlCount"];
    NSDictionary *dic = @{@"shopId":[AppDelegate APP].user.shopId};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取评价统计 %@", responseObject);
        [_hud hideAnimated:YES];

        if (responseObject != nil) {
            
            //总评价数
            if (responseObject[@"allcount"] != nil && ![responseObject[@"allcount"] isKindOfClass:[NSNull class]]) {
                _allcount.text = [NSString stringWithFormat:@"%@%@", @"总评价数:", responseObject[@"allcount"]];
            }
            else{
                _allcount.text = @"总评价数：";
            }
            
            //分数
            NSDictionary *score = responseObject[@"score"];
            if (score != nil && ![score isKindOfClass:[NSNull class]]) {
                if (score[@"shopAvg"] != nil && ![score[@"shopAvg"] isKindOfClass:[NSNull class]]) {
                    _shopAvg.text = [NSString stringWithFormat:@"%@", score[@"shopAvg"]];
                    //判断口碑等级
                    float Score = [score[@"shopAvg"] floatValue];
                    if (Score >= 4.8) {
                        _WordOfMouth.text = @"优秀";
                    }
                    else if (Score < 3.0){
                        _WordOfMouth.text = @"差";
                    }
                    else{
                        _WordOfMouth.text = @"一般";
                    }
                }
                else{
                    _shopAvg.text = @"--";
                    _WordOfMouth.text = @"一般";
                }
                
                if (score[@"shopCount"] != nil && ![score[@"shopCount"] isKindOfClass:[NSNull class]]) {
                    _shopCount.text = [NSString stringWithFormat:@"%@%@%@", @"商家评分超过", score[@"shopCount"], @"%同行，关注评价建议可改善口碑哦"];
                }
                else{
                    _shopCount.text = @"商家评分超过0%同行，关注评价建议可改善口碑哦";
                }
                if (score[@"tasteScore"] != nil && ![score[@"tasteScore"] isKindOfClass:[NSNull class]]) {
                    _tasteScore.text = [NSString stringWithFormat:@"%@", score[@"tasteScore"]];
                }
                else{
                    _tasteScore.text = @"--";
                }
                if (score[@"timeScore"] != nil && ![score[@"timeScore"] isKindOfClass:[NSNull class]]) {
                    _timeScore.text = [NSString stringWithFormat:@"%@", score[@"timeScore"]];
                }
                else{
                    _timeScore.text = @"--";
                }
                if (score[@"warpScore"] != nil && ![score[@"warpScore"] isKindOfClass:[NSNull class]]) {
                    _warpScore.text = [NSString stringWithFormat:@"%@", score[@"warpScore"]];
                }
                else{
                    _warpScore.text = @"--";
                }

            }
            else{
                _shopAvg.text = @"--";
                _tasteScore.text = @"--";
                _timeScore.text = @"--";
                _warpScore.text = @"--";
                _shopCount.text = @"提升空间巨大！商家评分只超过0%同行，关注评价建议可改善口碑哦";
            }
            
            //配送时间
            if (responseObject[@"dsm"] != nil && ![responseObject[@"dsm"] isKindOfClass:[NSNull class]]) {
                _dsm.text = [NSString stringWithFormat:@"%@%@", responseObject[@"dsm"], @"min"];
            }
            else{
                _dsm.text = @"0min";
            }
            
            //标签
            _tagArray = responseObject[@"tag"];
            if (_tagArray.count > 0) {
                if (_tagArray != nil && ![_tagArray isKindOfClass:[NSNull class]]) {
//                    _onTime.text = [NSString stringWithFormat:@"%@%@%@%@", tag[0][@"name"] ,@"(", tag[0][@"count"], @")"];
//                    _quick.text = [NSString stringWithFormat:@"%@%@%@%@", tag[1][@"name"] ,@"(", tag[1][@"count"], @")"];
//                    _food.text = [NSString stringWithFormat:@"%@%@%@%@", tag[2][@"name"] ,@"(", tag[2][@"count"], @")"];
//                _keepWarm.text = [NSString stringWithFormat:@"%@%@%@%@", tag[3][@"name"] ,@"(", tag[3][@"count"], @")"];
                   
                    for (int i = 0,j = 0; i < _tagArray.count; i++, j++) {
                        if (j > 2) {
                            j = 0;
                        }
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + (SCREEN_WIDTH-20)/3 * j, 10 + 20 * i%3 , (SCREEN_WIDTH-20)/3, 15)];
                        label.text = [NSString stringWithFormat:@"%@%@%@%@", _tagArray[i][@"name"] ,@"(", _tagArray[i][@"count"], @")"];
                        label.font = [UIFont systemFontOfSize:13];
                        label.textColor = [UIColor darkGrayColor];
                        [_tagView addSubview:label];
                    }
                    
                }
                else{
                    
                }
            }
            
            //中差评
            NSDictionary *bad = responseObject[@"bad"];
            _sjNum.text = [NSString stringWithFormat:@"%@%@", bad[@"shopbad"], @"条"];
            _kwNum.text = [NSString stringWithFormat:@"%@%@", bad[@"tastebad"], @"条"];
            _bzNum.text = [NSString stringWithFormat:@"%@%@", bad[@"warpbad"], @"条"];
            
            //进度条
            float sjCount = [bad[@"shopbad"] intValue];
            float kwCount = [bad[@"tastebad"] intValue];
            float bzCount = [bad[@"warpbad"] intValue];
            float count = sjCount + kwCount + bzCount;
            if (count != 0) {
                _sjWidth.constant = (sjCount/count) * _sjBView.frame.size.width;
                _kwWidth.constant = (kwCount/count) * _kwBView.frame.size.width;
                _bzWith.constant = (bzCount/count) * _bzBView.frame.size.width;
            }
            else{
                _sjWidth.constant = 0;
                _kwWidth.constant = 0;
                _bzWith.constant = 0;
            }

        }
        else{
//            [Util toastWithView:self.navigationController.view AndText:@"获取信息失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取评价统计失败 %@", error);
        [_hud hideAnimated:YES];

        [Util toastWithView:self.view AndText:@"网络连接异常"];
    }];
    
    
}



@end
