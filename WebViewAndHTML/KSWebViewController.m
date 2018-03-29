//
//  KSWebViewController.m
//  WebViewAndHTML
//
//  Created by aDu on 2018/3/29.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "KSWebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface KSWebViewController ()

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation KSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"web页面";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [self.bridge setWebViewDelegate:self];
    
    //原生界面定义一个callNative方法，供H5调用
    [_bridge registerHandler:@"showNativeAlert" handler:^(id data, WVJBResponseCallback responseCallback) {
        //H5调用了之后，原生需要如何处理，这里面写代码逻辑
        [self callNative:data];
    }];
    [self loadHTML:webView];
    
    //导航栏上面的原生按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点击" style:UIBarButtonItemStyleDone target:self action:@selector(callHtml)];
}

//打开的web界面
- (void)loadHTML:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"WebView" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

//H5调用原生之后，我实现的是弹框
- (void)callNative:(NSDictionary *)data {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:data[@"message"] delegate:nil cancelButtonTitle:@"取消 "otherButtonTitles:@"确定", nil];
    [alert show];
}

//点击导航栏按钮，去掉用H5的方法
- (void)callHtml {
    //原生调用H5的showHTMLAlert方法
    [_bridge callHandler:@"showHtmlAlert" data:@{@"message":@"原生调用了H5的方法"}];
}

@end
