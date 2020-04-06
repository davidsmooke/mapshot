//
//  SignInViewController.h
//  MapShot
//
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "config.h"
#import "ATMHud.h"
#import "SVProgressHUD.h"

#import "FbGraph.h"
#import "FbGraphResponse.h"
#import "AppDelegate.h"
#import "TermsAndConditonsViewController.h"

#import "callWebservice.h"

#import "CustomAlertViewController.h"

@interface SignInViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,CustomAlertViewControllerDelegate>
{
    UIAlertView *noAccessGrantedAlert;
    IBOutlet UIView *view_title;
    IBOutlet UIView *view_Facebook;
    BOOL isfacebook;
    BOOL isInstagram;
    BOOL istwitter;
   
    UIAlertView *errAlertView;
    IBOutlet UITextField *txt_username;
    IBOutlet UITextField *txt_password;
     ATMHud       *progressView;
    
     IBOutlet UIView *view_forgotPassword;
    IBOutlet UITextField *txt_forgotUsername;
    IBOutlet UITextField *txt_forgotEmail;
    
    IBOutlet UIButton *newUserBUtton;
   
   
    UIImageView *loginpage;
    NSString *userstr;
    NSDictionary *signUpDict;
    
    
    
    FbGraphResponse *fbResponse;
   
    
   
    
    
    //UIAlertView *newUserAlert;
  
    
}


@property (nonatomic, retain) FbGraphResponse *fbResponse;


-(IBAction)signIn:(id)sender;
-(IBAction)SignUp:(id)sender;
-(IBAction)twitter:(id)sender;
-(IBAction)faceBook:(id)sender;
-(IBAction)forgotClose:(id)sender;
-(IBAction)forgotSend:(id)sender;
-(IBAction)forgotPasswordAction:(id)sender;


- (void)fbGraphCallback;
@end
