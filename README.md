#WebViewJavascriptBridge：OC与H5的交互
![OC与H5的交互.gif](http://upload-images.jianshu.io/upload_images/1840399-1d26bebee33f2404.gif?imageMogr2/auto-orient/strip)

OC与H5的交互代码如下，里面有详细的解释
####OC代码
```
#import "WebViewController.h"
#import "WebViewJavascriptBridge.h"

@interface WebViewController ()

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation WebViewController

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
    [_bridge registerHandler:@"callNative" handler:^(id data, WVJBResponseCallback responseCallback) {
        //H5调用了之后，原生需要如何处理，这里面写代码逻辑
        [self callNative:data];
    }];
    [self loadHTML:webView];
    
    //导航栏上面的原生按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点击" style:UIBarButtonItemStyleDone target:self action:@selector(callHTML)];
}

//打开的web界面
- (void)loadHTML:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"webview" ofType:@"html"];
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
- (void)callHTML {
    //原生调用H5的showHTMLAlert方法
    [_bridge callHandler:@"showHTMLAlert" data:@{@"message":@"原生调用了H5的弹框"}];
}

@end

```

####JS代码如下，里面有相关的解释
```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>H5页面</title>
	<script type="text/javascript">
        //使用WebViewJavascriptBridge必须写的
		function setupWebViewJavascriptBridge(callback) {
			if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
			if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
			window.WVJBCallbacks = [callback];
			var WVJBIframe = document.createElement('iframe');
			WVJBIframe.style.display = 'none';
			WVJBIframe.src = 'https://__bridge_loaded__';
			document.documentElement.appendChild(WVJBIframe);
			setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
		}
    
        //在这里面写入相互调用的代码
		setupWebViewJavascriptBridge(function(bridge) {
            //H5调用原生的方法
			var callNative = document.getElementById('callNative');
	        callNative.onclick = function() {
                //H5调用了原生注册的callNative方法
            	bridge.callHandler('callNative', {'message': 'H5调用了原生的方法'}, function(response) {
                    
	            })
	        }
            
            //showHTMLAlert是H5提供给原生的调用方法
			bridge.registerHandler('showHTMLAlert', function(data) {
				alert(data.message);
			})
		})

	</script>
</head>
<body>
	<button style="margin-top: 100px; margin-left: 20px;" id="callNative">我是H5的button，点我、点我</button>
</body>
</html>
```
