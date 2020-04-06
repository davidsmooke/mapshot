//
//  TermsAndConditonsViewController.h
//  ArtMap
//
//  Created by Innoppl Technologies on 23/05/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndConditonsViewController : UIViewController<UIWebViewDelegate>
{
   IBOutlet UIWebView *termsAndConditionWebView;
}
-(IBAction)back:(id)sender;
@end
