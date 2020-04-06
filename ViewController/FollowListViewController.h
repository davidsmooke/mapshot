//
//  FollowListViewController.h
//  ArtMap
//
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
