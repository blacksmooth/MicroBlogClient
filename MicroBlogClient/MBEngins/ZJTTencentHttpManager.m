//
//  ZJTTencentHttpManager.m
//  MicroBlogClient
//
//  Created by Jianting Zhu on 12-6-10.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTTencentHttpManager.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "Status.h"
#import "JSON.h"
#import "Comment.h"
#import "ZJTHelpler.h"

@implementation ZJTTencentHttpManager
@synthesize requestQueue;
@synthesize delegate;
@synthesize authCode;
@synthesize authToken;
@synthesize userId;
@synthesize openID;

-(void)dealloc
{
    self.userId = nil;
    self.authToken = nil;
    self.authCode = nil;
    self.requestQueue = nil;
    self.openID = nil;
    [super dealloc];
}

//初始化
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    if (self) {
        requestQueue = [[ASINetworkQueue alloc] init];
        [requestQueue setDelegate:self];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        [requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestQueue setShowAccurateProgress:YES];
        self.delegate = theDelegate;
    }
    return self;
}

#pragma mark - Methods
- (void)setGetUserInfo:(ASIHTTPRequest *)request withRequestType:(TencentRequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:TENCENT_REQUEST_TYPE];
    [request setUserInfo:dict];
    [dict release];
}

- (void)setPostUserInfo:(ASIFormDataRequest *)request withRequestType:(TencentRequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:TENCENT_REQUEST_TYPE];
    [request setUserInfo:dict];
    [dict release];
}

-(void)setTencentGetParams:(NSMutableDictionary*)dic
{
    [dic setObject:TENCENT_APP_KEY forKey:@"oauth_consumer_key"];
    [dic setObject:self.authToken forKey:@"access_token"];
//    [dic setObject:self.authToken forKey:@"openid"];
}

#pragma mark - Operate queue
- (BOOL)isRunning
{
	return ![requestQueue isSuspended];
}

- (void)start
{
	if( [requestQueue isSuspended])
		[requestQueue go];
}

- (void)pause
{
	[requestQueue setSuspended:YES];
}

- (void)resume
{
	[requestQueue setSuspended:NO];
}

- (void)cancel
{
	[requestQueue cancelAllOperations];
}


//留给webview用
-(NSURL*)getTencentOauthCodeUrl
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   TENCENT_APP_KEY,                    @"client_id",       //申请的appkey
								   @"token",                        @"response_type",   //access_token
								   @"http://hi.baidu.com/jt_one",   @"redirect_uri",    //申请时的重定向地址
								   @"wap2.0",                       @"wap",         //web页面的显示方式
                                   nil];
	
	NSURL *url = [ZJTHelpler generateURL:TENCENT_API_AUTHORIZE params:params];
	NSLog(@"url= %@",url);
    return url;
}

//获取登陆用户的info
-(void)getTencentSelfInfo
{
    //http://open.t.qq.com/api/user/info
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_STORE_ACCESS_TOKEN];
    NSMutableDictionary     *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       authToken,   @"access_token",
                                       nil];
    NSString    *baseUrl = @"http://open.t.qq.com/api/user/info";
    NSURL       *url = [ZJTHelpler generateURL:baseUrl params:params];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:TencentGetSelfInfo];
    [requestQueue addOperation:request];
    [request release];
}

@end
