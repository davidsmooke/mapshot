//
//  AddCommentViewController.h
//  ArtMap
//
//  Created by sathish kumar on 10/29/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
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
