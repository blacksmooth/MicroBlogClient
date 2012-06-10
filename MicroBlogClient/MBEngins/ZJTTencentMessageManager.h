//
//  ZJTTencentMessageManager.h
//  MicroBlogClient
//
//  Created by Jianting Zhu on 12-6-10.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJTTencentHttpManager.h"




@interface ZJTTencentMessageManager : NSObject
{
    ZJTTencentHttpManager *httpManager;
}
@property (nonatomic,retain)ZJTTencentHttpManager *httpManager;

+(ZJTTencentMessageManager*)getInstance;

//查看Token是否过期
- (BOOL)isNeedToRefreshTheToken;

//留给webview用
-(NSURL*)getTencentOauthCodeUrl;

@end
