//
//  OpenShopTreasureViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/10/16.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OpenShopTreasureViewController.h"
#import "OpenShopSelectViewController.h"

@interface OpenShopTreasureViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIScrollView * scrollview;
@property (nonatomic,assign) BOOL zoomOut_In;

@end

@implementation OpenShopTreasureViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"阿凡提商家";
    [self initUI];
    [self initBottomView];
}

//设置底部按钮
-(void)initBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 105, SCREEN_WIDTH, 40)];
//    bottomView.backgroundColor = [UIColor colorWithRed:242/255.0 green:181/255.0 blue:83/255.0 alpha:1];
    bottomView.backgroundColor = NAV_COLOR;

    UIButton *bottomBtn = [[UIButton alloc] init];
    bottomBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [bottomBtn setTitle:@"我有实体店，我要合作" forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:bottomBtn];
    [self.view addSubview:bottomView];
}

//点击进入选择
-(void)bottomBtnClick{
    OpenShopSelectViewController *vc = [[OpenShopSelectViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//图片的大小与屏幕大小相同
-(CGSize)imageViewSize
{
    CGFloat imageWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [self getImage].size;
    CGFloat imageHeight = imageWidth / size.width * size.height;
    return CGSizeMake(imageWidth, imageHeight);
}
//获取图像
- (UIImage *)getImage
{
    //UIImage *img = [UIImage imageNamed:@"us@2x.png"];
    // UIImageView *imgview = [[UIImageView alloc] init];
    // imgview.image = img;
    // imgview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"us@2x.png" ofType:nil];//图像的路径
    UIImage *image = [UIImage imageNamed:@"sjrz"];
    return image;
}

-(void)initUI{
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
    _scrollview.backgroundColor = [UIColor whiteColor];
    _scrollview.delegate = self;
    [self.view addSubview:_scrollview];
    
    CGSize newSize = [self imageViewSize];//矩形的大小和图片大小相同
    [_scrollview setContentSize:newSize];
    
    //图片视图
    _imageView = [[UIImageView alloc] initWithImage:[self getImage]];
    [_imageView setFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
    [_scrollview addSubview:_imageView];
    
    //手势识别
    UITapGestureRecognizer* tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];//给imageview添加tap手势
    tap.numberOfTapsRequired = 2;//双击图片执行tapGesAction
    _imageView.userInteractionEnabled=YES;//同意响应事件
    [_imageView addGestureRecognizer:tap];
    
    //设置放大缩小的比例
    [_scrollview setMinimumZoomScale:1.0];//设置最小的缩放大小
    _scrollview.maximumZoomScale = 2.0;//设置最大的缩放大小
    
    _zoomOut_In = YES;//控制点击图片放大或缩小
    
}

-(void)tapGesAction:(UIGestureRecognizer*)gestureRecognizer//手势执行事件
{
    float newscale=0.0;
    if (_zoomOut_In) {
        newscale = 2*1.5;
        _zoomOut_In = NO;
    }else
    {
        newscale = 1.0;
        _zoomOut_In = YES;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
//    NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
    [ _scrollview zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
    
}
//当UIScrollView尝试进行缩放的时候调用
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
//当缩放完毕的时候调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //    NSLog(@"结束缩放 - %f", scale);
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //    NSLog(@"正在缩放.....");
}

//比对点击处的中心X与原来图片尺寸的差值，然后传递给Scrollview进行缩放
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [_scrollview frame].size.height / scale;
    zoomRect.size.width  = [_scrollview frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
