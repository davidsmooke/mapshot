//
//  AddCommentViewController.h
//  ArtMap
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"

@interface AddCommentViewController : UIViewController<UITextViewDelegate>
{
    UITextView *textview;
    UIAlertView *errAlertView;
}

@end
