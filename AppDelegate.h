//
//  AppDelegate.h
//  MapShot
//
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "config.h"
#import <CoreLocation/CoreLocation.h>

#import "TabBarClassConViewController.h"
#import  "SignInViewController.h"

#import "FbGraph.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    UIImage   *twitterImg;
    UIView *spinnerView;
    UIActivityIndicatorView *indicator;
    UILabel *messageLabel;
    NSMutableDictionary *Screenshotdic;
    BOOL isfacebook;
    NSTimeInterval startInterval, stopInterval, elapsedTime;
    FbGraph *fbGraph;
    
}
@property (strong, nonatomic) TabBarClassConViewController *tabBarCon;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ACAccountStore *myAccountStore;
@property(nonatomic,retain) __block ACAccount *twitterAccount;
@property (nonatomic,assign)  BOOL isImageLocate;
@property (nonatomic,assign)  BOOL  isFromSearchView;
@property (nonatomic, strong, readonly) NSMutableDictionary *logStartTimer;
@property (nonatomic, retain) FbGraph *fbGraph;


-(void) setTwitImg:(UIImage*)img;
-(NSString *)emptystr:(NSString *)txt;
- (NSString*) getUserDefault:(NSString*)key;
+ (BOOL)hasConnectivity;
+ (void)setStatusbar;

-(NSDictionary*)convertToJSON:(id)data;
-(void) setUserDefault:(NSString*)key setObject:(NSString*)myString;
-(void) setUserDefault:(NSString*)key setImage:(UIImage *)myImage;
-(void) Setscreenshot:(UIImage*)arr forkey:(NSString*)key;
-(UIImage*) Getscreenshot:(NSString*)key;
- (void)applicationDidBecomeActive:(UIApplication *)application;
@property (nonatomic, retain) __block ACAccount *faceBookAccount;
-(void)openingScreen;
@end
