//
//  OAuthWebView.h
//  test
//
//  Created by jianting zhu on 11-12-31.
//  Copyright (c) 2011年 Dunbar Science & Technology. All rights reserved.
//

#import "ZJTGloble.h"

@interface OAuthWebView : UIViewController<UIWebViewDelegate>{
    UIWebView *webV;
    NSString *token;
    MicroBlogType _MBType;
}
@property (retain, nonatomic) IBOutlet UIWebView *webV;
@property (assign,nonatomic) MicroBlogType MBType;

-(id)initWithType:(MicroBlogType)mbType;

@end
