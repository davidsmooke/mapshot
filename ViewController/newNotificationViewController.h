//
//  newNotificationViewController.h
//  ArtMap
//
//

#import <UIKit/UIKit.h>
#import "ImageSortingOrder.h"
#import "MNMBottomPullToRefreshManager.h"
#import "SVProgressHUD.h"

@interface newNotificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MNMBottomPullToRefreshManagerClient> {
    IBOutlet UITableView *UploadedImageFeedsTable;
    NSInteger  startValue;
    UIRefreshControl *refreshControl;
    NSInteger noOFSections;
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    NSUInteger reloads_;
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubltTap;
    NSInteger currentUserLIKedStr;
    NSInteger sectioncount;
    int sectionSelectedWhileDoubleTap;
      UIAlertView *errAlertView;
}

-(void) getnotificationservice;
//-(void) UidesignPart;
//-(void) refresh:(UIRefreshControl *)ref;
-(void) singleTapFunction:(UITapGestureRecognizer*) sender;
-(void) doubleTapFunction:(UITapGestureRecognizer *)sender;
@end
