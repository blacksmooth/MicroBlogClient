//
//  ZJTViewController.m
//  MicroBlogClient
//
//  Created by Jianting Zhu on 12-6-9.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "ZJTViewController.h"
#import "OAuthWebView.h"
#import "WeiBoMessageManager.h"
#import "ZJTHomeViewController.h"

@interface ZJTViewController ()

@end

@implementation ZJTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)loginBtnClicked:(id)sender {
    OAuthWebView *o = [[OAuthWebView alloc] initWithNibName:@"OAuthWebView" bundle:nil];
    [self presentModalViewController:o animated:YES];
    [o release];
}
- (IBAction)userInfo:(id)sender {
    WeiBoMessageManager *m = [WeiBoMessageManager getInstance];
    [m getUserID];
}
- (IBAction)home:(id)sender {
    ZJTHomeViewController *h = [[ZJTHomeViewController alloc] init];
    [self.navigationController pushViewController:h animated:YES];
    [h release];
}

@end
