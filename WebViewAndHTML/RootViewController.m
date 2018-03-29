//
//  RootViewController.m
//  WebViewAndHTML
//
//  Created by aDu on 2018/3/29.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import "KSWebViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原生根视图";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 45);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"跳转到web界面" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpWebPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)jumpWebPage {
    KSWebViewController *webVC = [[KSWebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
