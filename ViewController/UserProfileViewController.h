//
//  UserProfileViewController.h
//  ArtMap
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPonit.h"
#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"
#import "ATMHud.h"
#import "MyCLController.h"
#import "ShareCustomClass.h"

@interface UserProfileViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,CLLocationManagerDelegate>        {
    
    UIAlertView *errAlertView;
    AppDelegate *deleg;
 
    IBOutlet UIScrollView *ScrollerOuter;
    IBOutlet UIScrollView *profileScroll;
    IBOutlet UIPageControl *myPageControl;
    UIView *photoView;
    UIView *bioView;
    UIButton  *editbtn,*donebtn;
    UITextView *destxt;
    IBOutlet UIView *view_container;
    
    MyCLController         *locationController;
    CLLocationCoordinate2D UserLocation;
    
 
    ATMHud                 *progressView;
    MKCoordinateRegion region;
    UITextField *titletxt;
    
    IBOutlet UILabel    *picCountlbl;
    IBOutlet UILabel    *follwCountlbl;
    IBOutlet UILabel    *folwgcntlbl;
    IBOutlet UILabel    *userNameLabel;
    UILabel *Headerlbl;
   
    UIButton    *profimg;
    UIButton *topButton;
    UIButton   *followerbtn;
    UIButton   *followingbtn;
    

    UIImage     *IMG;
    
    NSString       *folwstr;
    NSString       *followingstr;
    NSString    *currentadds;
    
    NSDictionary *imagedictionary;
    
    BOOL isProfile;
    BOOL profileservice;
    BOOL imagelikeSer;
    BOOL followingImageser;
    AppDelegate *appdel;
     BOOL yesFromImageViewInproifileview;
    
    ShareCustomClass *share;
    NSMutableArray *classarr ;
    IBOutlet UISegmentedControl *segmentedControl;
}

@property (retain) ASINetworkQueue         *requestQueue;
@property (nonatomic,retain) UIScrollView  *profileScroll;
@property (nonatomic,retain) UIPageControl *myPageControl;
@property (nonatomic,retain) NSString      *folwstr;
@property (nonatomic,retain) NSString      *followingstr;
@property (nonatomic,retain) IBOutlet MKMapView   *mapView;
@property (nonatomic,retain) UIImage       *twitterimg;

@property (nonatomic,assign)  BOOL profileservice;
@property (nonatomic,assign)  BOOL imagelikeSer;
@property (nonatomic,assign)  BOOL followingImageser;
@property(nonatomic,assign) BOOL yesFromImageViewInproifileview;


-(void) ProfileViewService;
//-(void) ProfImgUpload;
-(void) AddDescription;
//-(void) imageupload;
//-(void) UploadAlert;
-(void)cancelRequest;

-(UILabel*) customLabel:(NSString*)str initFrame:(CGRect)frame;
//- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)captureView:(UIView *)view;

-(IBAction)FollowersAction:(UIButton*)sender ;
-(IBAction) shareMethod;
-(IBAction)settingsAction:(id)sender;
-(IBAction) pageChangeFunction;
@end
