//
//  CustomAlertViewController.h
//  MapShot
//
//

#import <UIKit/UIKit.h>
#import "TermsAndConditonsViewController.h"

@protocol CustomAlertViewControllerDelegate;


@interface CustomAlertViewController : UIViewController <UITextFieldDelegate>{
      IBOutlet UIButton *okBUtton;
      IBOutlet UIButton *cancelBUtton;
      IBOutlet UIView *contentView;
    
    UITextField *newuserTextField;
    UIButton *checkMarkButton;
    UILabel *agreeLabel;
    UILabel *linkLabel;
    UIButton *agreeButton;
    
    UILabel *newUserLabel;
}

@property (nonatomic, weak) id<CustomAlertViewControllerDelegate> delegate;

-(IBAction) okAction:(UIButton*) sender;
-(IBAction) cancelAction:(UIButton*) sender;
-(IBAction)termsAndCondition:(UIButton*)sender;

@end


@protocol CustomAlertViewControllerDelegate <NSObject>

- (void)customalertOK:(CustomAlertViewController*)viewController
               button:(UIButton*)sender  textFieldValue:(NSString*)valueString;
- (void)customalertCancel:(CustomAlertViewController*)viewController
               button:(UIButton*)sender;



@end



