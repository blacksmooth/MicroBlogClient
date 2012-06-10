//
//  OAuthWebView.m
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "OAuthWebView.h"
#import "WeiBoMessageManager.h"
#import "SHKActivityIndicator.h"
#import "ZJTStatusBarAlertWindow.h"
#import "ZJTTencentMessageManager.h"
#import "ZJTHelpler.h"

@implementation OAuthWebView
@synthesize webV;
@synthesize MBType = _MBType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithType:(MicroBlogType)mbType
{
    self = [self initWithNibName:@"OAuthWebView" bundle:nil];
    if (self) {
        self.MBType = mbType;
    }
    return self;
}

//剥离出url中的access_token的值
- (void) dialogDidSucceed:(NSURL*)url {
    NSString *q = [url absoluteString];
    token = [ZJTHelpler getStringFromUrl:q needle:@"access_token="];
    
    //用户点取消 error_code=21330
    NSString *errorCode = [ZJTHelpler getStringFromUrl:q needle:@"error_code="];
    if (errorCode != nil && [errorCode isEqualToString: @"21330"]) {
        NSLog(@"Oauth canceled");
    }
    
    NSString *refreshToken  = [ZJTHelpler getStringFromUrl:q needle:@"refresh_token="];
    NSString *expTime       = [ZJTHelpler getStringFromUrl:q needle:@"expires_in="];
    NSString *uid           = [ZJTHelpler getStringFromUrl:q needle:@"uid="];
    NSString *remindIn      = [ZJTHelpler getStringFromUrl:q needle:@"remind_in="];
    
    NSDate *expirationDate =nil;
    NSLog(@"jtone \n\ntoken=%@\nrefreshToken=%@\nexpTime=%@\nuid=%@\nremindIn=%@\n\n",token,refreshToken,expTime,uid,remindIn);
    if (expTime != nil) {
        int expVal = [expTime intValue] - 3600;
        if (expVal == 0) 
        {
            
        } else {
            expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			NSLog(@"jtone time = %@",expirationDate);
        } 
    } 
    
    if (_MBType == kSinaMicroBlog) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:USER_STORE_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:USER_STORE_USER_ID];
        [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:USER_STORE_EXPIRATION_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    else if (_MBType == kTencentMicroBlog) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:TENCENT_STORE_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:TENCENT_STORE_USER_ID];
        [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:TENCENT_STORE_EXPIRATION_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (token) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_GET_TOKEN_IN_WEB_VIEW object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登陆";
    self.navigationItem.hidesBackButton = YES;
    webV.delegate = self;
    NSURL *url = nil;
    
    if (_MBType == kSinaMicroBlog) 
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_USER_ID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_STORE_EXPIRATION_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        WeiBoHttpManager *weiboHttpManager = [WeiBoMessageManager getInstance].httpManager;
        url = [weiboHttpManager getOauthCodeUrl];
    }
    else if(_MBType == kTencentMicroBlog)
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TENCENT_STORE_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TENCENT_STORE_USER_ID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:TENCENT_STORE_EXPIRATION_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ZJTTencentHttpManager *tencentHttpManager = [ZJTTencentMessageManager getInstance].httpManager;
        url = [tencentHttpManager getTencentOauthCodeUrl];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
	[webV loadRequest:request];
    [request release];
}

- (void)viewDidUnload
{
    [self setWebV:nil];
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.selectedIndex = 0;
}

- (void)dealloc {
    [webV release];
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	//这里是几个重定向，将每个重定向的网址遍历，如果遇到＃号，则重定向到自己申请时候填写的网址，后面会附上access_token的值
//    UIApplication *app = [UIApplication sharedApplication];
//    UIWindow *window = nil;
//    for (UIWindow *win in app.windows) {
//        if (win.tag == 1) {
//            window = win;
//            window.windowLevel = UIWindowLevelNormal;
//        }
//        if (win.tag == 0) {
//            [win makeKeyAndVisible];
//        }
//    }
    
	NSURL *url = [request URL];
    NSLog(@"webview's url = %@",url);
	NSArray *array = [[url absoluteString] componentsSeparatedByString:@"#"];
	if ([array count]>1) {
		[self dialogDidSucceed:url];
		return NO;
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[SHKActivityIndicator currentIndicator] displayActivity:@"正在载入..." inView:self.view];
//    [[ZJTStatusBarAlertWindow getInstance] showWithString:@"正在载入，请稍后..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[SHKActivityIndicator currentIndicator] hide];
//    [[ZJTStatusBarAlertWindow getInstance] hide];
}

@end
