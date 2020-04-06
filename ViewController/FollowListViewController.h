//
//  FollowListViewController.h
//  ArtMap
//
//  Created by Innoppl Technologies on 13/06/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"
#import "Config.h"

@interface FollowListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    ATMHud *progressView;
    NSInteger followno;
    NSString *userOrFolloUser;
    NSMutableArray *arr;
    
    AppDelegate *appDel;
    UITableView *listTableView;
}

@property(nonatomic) NSInteger followno;
@property(nonatomic,retain) NSString *userOrFolloUser;

-(void) Getfollow;
-(void)CancelFunction;
@end
