//
//  SettingVC.m
//  zjtSinaWeiboClient
//
//  Created by Jianting Zhu on 12-4-25.
//  Copyright (c) 2012年 ZUST. All rights reserved.
//

#import "SettingVC.h"
#import "OAuthWebView.h"
#import "WeiBoMessageManager.h"
#import "User.h"
#import "ZJTHotRepostViewController.h"

//sections
enum{
    kStatusSection = 0,
    kAccountSection,
    kSectionsCount,
};

//rows

//status
enum{
    kHotStatus = 0,
    kHotRetwitted,
    kStatusRowsCount,
};

//kAccountSection
enum {
    kCurrentUser = 0,
    kChangeAccount,  
    kAboutMe,
    kAccountRowsCount,
};

@interface SettingVC ()

@end

@implementation SettingVC

-(void)dealloc
{  
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多...";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:)    name:MMSinaGotUserInfo          object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMSinaGotUserInfo          object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    [[WeiBoMessageManager getInstance] getUserInfoWithUserID:[userID longLongValue]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == kStatusSection) {
        return kStatusRowsCount;
    }
    else if (section == kAccountSection) {
        return kAccountRowsCount;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
    
    if (section == kAccountSection) {
        if (row == kCurrentUser) {
            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_NAME];
            cell.textLabel.text = [NSString stringWithFormat:@"当前登陆账号：%@",name];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (row == kChangeAccount) {
            cell.textLabel.text = @"更换账号";
        }
        
        else if (row == kAboutMe) {
            cell.textLabel.text = @"关于";
        }
    }
    
    else if (section == kStatusSection) {
        if (row == kHotStatus) {
            cell.textLabel.text = @"今日热门评论";
        }
        
        else if (row == kHotRetwitted) {
            cell.textLabel.text = @"今日热门转发";
        }
    }
    return cell;
}

-(void)logout
{
    OAuthWebView *webV = [[OAuthWebView alloc]initWithType:kTencentMicroBlog];;
    webV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webV animated:YES];
    [webV release];
}

-(void)didGetUserInfo:(NSNotification*)sender
{
    User *user = sender.object;
    [[NSUserDefaults standardUserDefaults] setObject:user.screenName forKey:USER_STORE_USER_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSIndexPath *p = [NSIndexPath indexPathForRow:kCurrentUser inSection:kAccountSection];
    NSArray *arr = [NSArray arrayWithObject:p];
    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if (section == kAccountSection ) {
        if (row == kCurrentUser) {
            
        }
        
        else if (row == kChangeAccount) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要更换账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更换", nil];
            [alert show];
            [alert release];
        }
        
        else if (row == kAboutMe) {
        }
    }
    
    else if (section == kStatusSection) {
        if (row == kHotStatus) {        
            ZJTHotRepostViewController *h = [[ZJTHotRepostViewController alloc] initWithType:kHotCommentDaily];
            h.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:h animated:YES];
            [h release];
        }
        
        else if (row == kHotRetwitted) {
            ZJTHotRepostViewController *h = [[ZJTHotRepostViewController alloc] initWithType:kHotRepostDaily];
            h.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:h animated:YES];
            [h release];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self logout];
    }
}
@end
