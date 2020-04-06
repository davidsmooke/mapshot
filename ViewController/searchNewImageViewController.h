//
//  searchNewImageViewController.h
//  ArtMap
//
//

#import <UIKit/UIKit.h>
#import "ATMHud.h"
#import "AsyncImageView.h"
#import "SDSegmentedControl.h"
#import "SVProgressHUD.h"


@interface searchNewImageViewController : UIViewController<UITableViewDelegate,UITextFieldDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>   {
    
    IBOutlet UITableView *searchListTable;
    IBOutlet UISearchBar *sbar;
    UIButton *searchbutton;
    ATMHud *progressView;
    SDSegmentedControl *segmentObject;
    NSMutableArray *searchResultArray;
    NSMutableArray *searchlistarr;
    NSMutableArray *searchlistarrTITLE;
    NSMutableArray *searchlistarrLOCATION;
    NSMutableArray *searchlistarrLOCATIONImages;
    NSMutableArray *searchlistarrUSER;
    
    UIAlertView *errAlertView;
    AppDelegate *deleg;
     IBOutlet UISegmentedControl *segmentedControl;
}

@property   (nonatomic,retain) NSString *srchtext;
@property   (nonatomic,retain) NSString *keyText;

-(void) SearchFunction;

@end
