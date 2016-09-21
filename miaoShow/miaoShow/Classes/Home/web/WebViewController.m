//
//  WebViewController.m
//  miaoShow
//
//  Created by 汪凯 on 16/9/21.
//  Copyright © 2016年 汪凯. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
/** webView */
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation WebViewController

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:web];
        web.delegate = self;
        _webView = web;
    }
    return _webView;
}
- (instancetype)initWithUrlStr:(NSString *)url
{
    if (self = [self init]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self showGifLoding:nil inView:self.view];
    }
    return self;
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
//- (void)webViewDidStartLoad:(UIWebView *)webView;
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error;
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self hideGifLoding];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setTitleTextAttributes:
//  @{NSFontAttributeName:[UIFont systemFontOfSize:13],
//    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
