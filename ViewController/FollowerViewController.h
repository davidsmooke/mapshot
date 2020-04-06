//
//  FollowerViewController.h
//  ArtMap
//
//  Created by sathish kumar on 11/8/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapPonit.h"
#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"
#import "ATMHud.h"
#import "MyCLController.h"
#import "ShareCustomClass.h"


@interface FollowerViewController : UIViewController<MKReverseGeocoderDelegate,MKMapViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>
{
   // FBProfilePictureView   *profilePictureView;
    MyCLController         *locationController;
    CLLocationCoordinate2D UserLocation;
  //  MKReverseGeocoder      *geoCoder;
    ATMHud                 *progressView;
    
    IBOutlet UILabel *picCountlbl;
    IBOutlet  UILabel *followerCountlabel;
    IBOutlet UILabel *followingCountlabel;
    IBOutlet UILabel *titlelbl;
    
    UIButton *followerbtn;
    UIButton *followingbtn;
    UIButton *editbtn;
    UIButton *topButton;
    UIButton *donebtn;
    UIButton *uploadbut;
    IBOutlet UIButton *sharebut;
    UIButton *homebtn;
    UIButton *followbtn;

    UIImageView *twit;
    UITextView  *destxt;
    UIImage     *IMG;
    UITextField *titletxt;
    NSString    *currentadds;
    NSMutableArray *classarr;
    
    AppDelegate *appdel;
    
    UIView *photoView;
    UIView *bioView;
    MKCoordinateRegion region;
    NSDictionary *imagedictionary;
    IBOutlet UIScrollView *profileScroll;
    IBOutlet UIPageControl *myPageControl;
    UIButton *filterButton;
    UILabel *Headerlbl;
    
    BOOL followerService;
    BOOL imagelikeSer;
    BOOL followingImageser;
    BOOL isProfile;
    BOOL yesFromImageView;
    
     ShareCustomClass *share;
    UIButton *FollowingImagebutton;
    UIButton *interactImageButton;
    UIButton *UploadedImagebutton;
    
    IBOutlet UISegmentedControl *segmentedControl;
     IBOutlet UIView *view_container;
}
@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (retain) ASINetworkQueue *requestQueue;
@property(nonatomic,retain) UIScrollView *profileScroll;
@property(nonatomic,retain) UIPageControl *myPageControl;
@property(nonatomic,assign)  BOOL followerService;
@property(nonatomic,assign)  BOOL imagelikeSer;
@property(nonatomic,assign) BOOL followingImageser;
@property(nonatomic,assign) BOOL yesFromImageView;


//-(void) ProfileViewService;
//-(void) UploadAlert;
-(void) Asktitle;

//- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)captureView:(UIView *)view;

-(IBAction)FollowersAction:(id)sender;
-(IBAction)backoption:(id)sender;
-(IBAction)shareMethod:(id)sender;
-(IBAction) pageChangeFunction;

@end
