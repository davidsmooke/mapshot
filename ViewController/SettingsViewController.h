//
//  SettingsViewController.h
//  MapShot
//
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"
#import "config.h"
#import "MyCLController.h"
#import "JSON.h"

#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UIViewController<UITextFieldDelegate,MFMailComposeViewControllerDelegate>
{
    IBOutlet UITextField *oldPasswordAlertTextField;
    IBOutlet UITextField *newPasswordAlertTextField;
    IBOutlet UITextField *confirmPasswordAlertTextField;
    IBOutlet UIButton *PushOnOffButton;
    IBOutlet UIButton *GeoOnOffButton;
    IBOutlet UIButton *deactiveButton;
    
    IBOutlet UIButton *mailButton;
   
    
    
    MyCLController *locationController;
    IBOutlet UIView *view_changePassword;
    UIAlertView *errAlertView;
    
    
}
-(IBAction)back:(id)sender;
-(IBAction)signOut:(id)sender;
-(IBAction)changePassword:(id)sender;
-(IBAction)changePasswordWebService:(id)sender;
-(IBAction)cancel_changePassword:(id)sender;
-(IBAction)pushnotification:(UIButton*)sender;
-(IBAction)GeobuttonFunction:(UIButton*)senderval;

-(IBAction)deActivate:(id)sender;

-(IBAction)mailFunction:(UIButton*)sender;

-(IBAction)termsAndCondition:(UIButton*)sender;

@end
