//
//  MapViewController.h
//  ArtMap
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPonit.h"
#import "ASINetworkQueue.h"
#import "ASIDownloadCache.h"
//#import "ATMHud.h"
#import "MyCLController.h"
#import "UserProfileViewController.h"
#import "ImageSortingOrder.h"

#import <QuartzCore/CALayer.h>
#import "SDSegmentedControl.h"
#import "ShareCustomClass.h"
#import "ImageViewController.h"
#import "JSON.h"
#import "NSString+UrlEncode.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"
#import "UIImageView+AFNetworking.h"
#import "ASIHTTPRequest.h"
#import "INAnnotation.h"
#import "INAnnotationView.h"
#import "INOverlay.h"
#import "INOverlayView.h"
#import "UIImage+Size.h"
#import "AFNetworking.h"
#import "UIImage+Resize.h"
#import "UIImage+FixOrientation.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIProgressDelegate.h"
#import "SettingsViewController.h"
#import "MultiImageUploadViewController.h"



BOOL isUpload;

@interface MapViewController : UIViewController <UIApplicationDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,MKMapViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{

    UIAlertView *errAlertView;
    AppDelegate *deleg;
    
    AppDelegate *appdel;
    //ATMHud *progressView;
    
    MyCLController *locationController;
    
    ASINetworkQueue *networkQueue;
    MKReverseGeocoder *geoCoder;
    
    CLLocationCoordinate2D UserLocation;
    
    UIImagePickerController *imagePicker;
    MKCoordinateRegion region;
    
    CGFloat currentLongitude;
    CGFloat currentLatitude;
    CGFloat precurrentlat;
    CGFloat precurrentlon;
    CGFloat center;
   
    NSData *imgdata;
    NSData *imagedataresize;
    
    NSMutableData  *receivedData;

    UITextField *searchfield;
    UITextField *titletxt;
    NSString    *currentadds;
    NSString    *latstr;
    NSString    *lonstr;
    NSString    *newlocat;
    
    UIImage  *IMG;
    UIImage *scaledImage;
    UIImage *croppedImage;
    UIImage *testimage;
    
    UIButton *mem;
    UIButton *uploadbut;
    UIButton *cancelbtn;
    UIButton *homebtn;
    UIButton *searchbutton;
    UIButton *user;
   
    UILabel  *memcount;
    UILabel  *usrlbl;
   
    
   // NSMutableArray *locCod;
    
    NSMutableArray *imgArr;
    
    
    NSUserDefaults *defaults;
    
    ShareCustomClass *share;
    BOOL isImageLocateMap;
    
    NSDictionary   *imagedictionary;
    NSMutableArray *imgArray;
    NSMutableArray *imageArr;
    NSMutableArray *comparearr;
    
    INAnnotation   *previousPoint;
    UIButton       *sharebut;
    NSArray        *SortArray;
    NSMutableArray *imgUrl;
    NSMutableDictionary *staticImageDictionary;
    NSDictionary *metadatadic;
    
    UITapGestureRecognizer *singleTap;
    NSString *userLatitude;
    NSString *userLongitude;
    
    UIImage *resizeimg;
    CLGeocoder *myGeocoder;
    NSString *Latitudeval;
    NSString *longitudeVal;
    ALAssetRepresentation *rep;
    CLLocation *myImageLoc;

}

@property (nonatomic,retain) IBOutlet MKMapView  *mapView;
@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic)CLLocationCoordinate2D    UserLocation;
@property (retain) ASINetworkQueue            *requestQueue;
@property (nonatomic,assign) BOOL isImageLocateMap;

//-(void) Webservice;
//-(void) imageupload;
//-(void) Asktitle;
//-(void) UploadAlert;
-(void) updatebadgecount;
//-(void) SearchFunction;
-(void) ToptenimageService:(NSNumber*)dist;
//-(void) uploadImageAtLocation;
//-(void) uploadimageAllfromDevice;
-(void) downloadImg:(NSDictionary*)responseDict;
//-(void) MembersNotify:(UIButton*)btn;

//-(void) settingsFunction;

//- (NSString *)urlencode;

//- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)captureView:(UIView *)view;
//- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage;
//+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
//- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

// Functions 
-(UILabel*) customLabel:(NSString*)str initFrame:(CGRect)frame totallines:(int)lines;
-(UITextField*) customTextfield:(NSString*)fieldType textName:(NSString*)str initFrame:(CGRect)frame;

-(IBAction)shareMethod:(id)sender;
@end
