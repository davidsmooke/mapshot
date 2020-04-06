//
//  TermsAndConditonsViewController.h
//  ArtMap
//
//

#import <UIKit/UIKit.h>

@interface TermsAndConditonsViewController : UIViewController<UIWebViewDelegate>
{
   IBOutlet UIWebView *termsAndConditionWebView;
}
-(IBAction)back:(id)sender;
@end
