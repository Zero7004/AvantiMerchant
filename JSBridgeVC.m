//
//  JSBridgeVC.m
//  TestOC
//
//  Created by 李亚军 on 2017/2/5.
//  Copyright © 2017年 zyyj. All rights reserved.
//

#import "JSBridgeVC.h"
#import "WebViewJavascriptBridge.h"

@interface JSBridgeVC ()

@property WebViewJavascriptBridge* bridge;

@end

@implementation JSBridgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址选择";

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(OC2JS) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    //初始化  WebViewJavascriptBridge
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    
    //请求加载html，注意：这里h5加载完，会自动执行一个调用oc的方法
    [self loadExamplePage:webView];
    
    
    //申明js调用oc方法的处理事件，这里写了后，h5那边只要请求了，oc内部就会响应
//    [self JS2OC];
    
//    [self OC2JS];
    //模拟操作：2秒后，oc会调用js的方法
    //注意：这里厉害的是，我们不需要等待html加载完成，就能处理oc的请求事件；此外，webview的request 也可以在这个请求后面执行（可以把上面的[self loadExamplePage:webView]放到[self OC2JS]后面执行，结果是一样的）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self OC2JS];
        
    });

    
}


/**
 JS  调用  OC
 */
//-(void)JS2OC{
    /*
     含义：JS调用OC
     @param registerHandler 要注册的事件名称(比如这里我们为loginAction)
     @param handel 回调block函数 当后台触发这个事件的时候会执行block里面的代码
     */
//    [_bridge registerHandler:@"loginAction" handler:^(id data, WVJBResponseCallback responseCallback) {
//        // data js页面传过来的参数  假设这里是用户名和姓名，字典格式
//        NSLog(@"JS调用OC，并传值过来");
//        
//        // 利用data参数处理自己的逻辑
//        NSDictionary *dict = (NSDictionary *)data;
//        NSString *str = [NSString stringWithFormat:@"用户名：%@  姓名：%@",dict[@"userId"],dict[@"name"]];
//        [self renderButtons:str];
//        
//        // responseCallback 给后台的回复
//        responseCallback(@"报告，oc已收到js的请求");
//    }];

//}

/**
 OC  调用  JS
 */
-(void)OC2JS{
    /*
     含义：OC调用JS
     @param callHandler 商定的事件名称,用来调用网页里面相应的事件实现
     @param data id类型,相当于我们函数中的参数,向网页传递函数执行需要的参数
     注意，这里callHandler分3种，根据需不需要传参数和需不需要后台返回执行结果来决定用哪个
     */
    
//    [_bridge callHandler:@"registerAction" data:@"请求地址回调"];
    [_bridge callHandler:@"registerAction" data:@"请求地址回调" responseCallback:^(id responseData) {
        NSLog(@"选择的地址信息：%@",responseData);
        if (responseData == nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未选择地址" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            self.block(responseData);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}


//- (void)renderButtons:(NSString *)str {
//   NSLog(@"JS调用OC，取到参数为： %@",str);
//
//}

- (void)disableSafetyTimeout {
    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}


- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSString *htmlPath = @"https://apis.map.qq.com/tools/locpicker?search=1&type=1&key=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77&referer=myapp";
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]]];
}

@end
