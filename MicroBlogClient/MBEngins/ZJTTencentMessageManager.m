//
//  ZJTTencentMessageManager.m
//  MicroBlogClient
//
//  Created by Jianting Zhu on 12-6-10.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTTencentMessageManager.h"
#import "Status.h"
#import "User.h"

static ZJTTencentMessageManager * instance=nil;

@implementation ZJTTencentMessageManager
@synthesize httpManager;

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        httpManager = [[ZJTTencentHttpManager alloc] initWithDelegate:self];
        [httpManager start];
    }
    return self;
}

+(ZJTTencentMessageManager*)getInstance
{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[ZJTTencentMessageManager alloc] init];
        }
    }
    return instance;
}

- (BOOL)isNeedToRefreshTheToken
{
    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults]objectForKey:TENCENT_STORE_EXPIRATION_DATE];
    if (expirationDate == nil)  return YES;
    
    BOOL boolValue1 = !(NSOrderedDescending == [expirationDate compare:[NSDate date]]);
    BOOL boolValue2 = (expirationDate != nil);
    
    return (boolValue1 && boolValue2);
}

//留给webview用
-(NSURL*)getTencentOauthCodeUrl
{
    return [httpManager getTencentOauthCodeUrl];
}

@end
