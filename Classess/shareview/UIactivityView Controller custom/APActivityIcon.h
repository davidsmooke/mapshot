//
//  APActivityIcon.h
//  ArtMap
//
//  Created by Innoppl Technologies on 05/06/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMResizerViewController.h"


@interface APActivityIcon : UIActivity <UIActivityItemSource,DMResizerDelegate,UIDocumentInteractionControllerDelegate>
{
    UINavigationController *nav;
    UIActivityItemProvider *items;
   
}

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareString;
@property (nonatomic, strong) NSArray *backgroundColors;
@property (readwrite) BOOL includeURL;

@property (nonatomic, strong) UIBarButtonItem *presentFromButton;
// overwritten if shareImage is non-square, because the document-interaction-controller is presented in the resize view.

@property (nonatomic, strong) DMResizerViewController *resizeController;

@property (nonatomic, strong) UIDocumentInteractionController *documentController;



@end
