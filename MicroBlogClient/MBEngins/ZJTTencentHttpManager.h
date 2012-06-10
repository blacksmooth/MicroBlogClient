//
//  ZJTTencentHttpManager.h
//  MicroBlogClient
//
//  Created by Jianting Zhu on 12-6-10.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "StringUtil.h"
#import "NSStringAdditions.h"
#import "ZJTStatusBarAlertWindow.h"
#import "ZJTGloble.h"

#ifndef __SOMEFILE_H__
#define __SOMEFILE_H__
    #include "IPAdress.h"
#endif

#define TENCENT_V2_DOMAIN              @"https://open.t.qq.com/api/"
#define TENCENT_API_AUTHORIZE          @"https://open.t.qq.com/cgi-bin/oauth2/authorize"
#define TENCENT_API_ACCESS_TOKEN       @"https://open.t.qq.com/cgi-bin/oauth2/access_token"

#define TENCENT_APP_KEY                @"801094787"
#define TENCENT_APP_SECRET             @"75ee06251d0daa89c280cc9e9ecfb924"

#define TENCENT_REQUEST_TYPE           @"tencentRequestType"

#define TENCENT_STORE_ACCESS_TOKEN     @"tencentAccessToken"
#define TENCENT_STORE_EXPIRATION_DATE  @"tencentExpirationDate"
#define TENCENT_STORE_USER_ID          @"tencentUserID"
#define TENCENT_STORE_USER_NAME        @"tencentUserName"
#define TENCENT_OBJECT                 @"tencent_USER_OBJECT"
#define TENCENT_NeedToReLogin          @"tencentNeedToReLogin"

#define MMtencentRequestFailed         @"MMtencentRequestFailed"

typedef enum {
    TencentGetOauthCode = 100,
    TencentGetOauthtoken,
    TencentGetRefreshToken,
    TencentGetUserID,
    TencentGetUserInfo,
}TencentRequestType;

@class ASINetworkQueue;
@class Status;
@class User;

@protocol TencentHttpDelegate <NSObject>

@optional
//获取登陆用户的UID
-(void)didTencentGetUserID:(NSString*)userID;

//获取任意一个用户的信息
-(void)didTencentGetUserInfo:(User*)user;

@end

@interface ZJTTencentHttpManager : NSObject
{
    ASINetworkQueue *requestQueue;
    id<TencentHttpDelegate> delegate;
    
    NSString *authCode;
    NSString *authToken;
    NSString *userId;
}

@property (nonatomic,retain) ASINetworkQueue *requestQueue;
@property (nonatomic,assign) id<TencentHttpDelegate> delegate;
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *authToken;
@property (nonatomic,copy) NSString *userId;

- (id)initWithDelegate:(id)theDelegate;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;

//留给webview用
-(NSURL*)getTencentOauthCodeUrl;

@end
