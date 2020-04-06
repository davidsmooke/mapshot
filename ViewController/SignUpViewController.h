//
//  SignUpViewController.h
//  MapShot
//
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "AFNetworking.h"
#import "JSON.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *txt_username;
    IBOutlet UITextField *txt_firstname;
    IBOutlet UITextField *txt_lastname;
    IBOutlet UITextField *txt_email;
    IBOutlet UITextField *txt_password;
    UIAlertView *errAlertView;
    
    IBOutlet UIButton *checkMarkButton;
    IBOutlet UIButton *termsAndConditionButton;
}
-(IBAction)Cancel:(id)sender;
-(IBAction)signUp:(id)sender;

-(IBAction)checkMarkButtonAction:(UIButton*)sender;
-(IBAction)termsAndCondition:(UIButton*)sender;

@end
