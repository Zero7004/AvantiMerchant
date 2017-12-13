//
//  MerchantServiceCentreViewController.m
//  AvantiMerchant
//
//  Created by 王健龙 on 2017/9/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

//*商户服务中心*//

#import "MerchantServiceCentreViewController.h"
#import "QuestionViewController.h"


@interface MerchantServiceCentreViewController ()<UIWebViewDelegate>



@end

@implementation MerchantServiceCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"阿凡提商家";

    NSString *strUrl = @"http://www.aftdc.com/shopAppH5/help.html";
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    web.delegate = self;
    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    web.dataDetectorTypes = UIDataDetectorTypeAll;//自动检测网页上的电话号码，单击可以拨打
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
    [self.view addSubview:web];
    
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    UIWebView *web = webView;
//    NSString *allHtml = @"document.documentElement.innerHTML";
//    NSString *htmlTitle = @"document.title";
//    NSString *htmlNum = @"document.getElementById('title').innerText";
//    
//    NSString *allHtmlInfo = [web stringByEvaluatingJavaScriptFromString:allHtml];
//
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










@end
