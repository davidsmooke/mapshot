//
//  CameraViewController.h
//  MapShot
//
//  Created by Innoppl Technologies on 20/11/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBarViewClass.h"
#import "AppDelegate.h"
#import "UIImage+Size.h"
#import "MapPonit.h"
#import "SettingsViewController.h"
#import "PECropViewController.h"
#import "AFHTTPClient.h"
#import "MyCLController.h"
#import "SVProgressHUD.h"

@interface CameraViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UITextViewDelegate,MKReverseGeocoderDelegate>
{
    UIAlertView *errAlertView;
    AppDelegate *deleg;
    ToolBarViewClass *toolObject;
    UIImage  *IMG;
    UIImage *resizeimg;
    NSData *imagedataresize;
  
    NSString *limitedString;
    PECropViewController *cropController;
    
    IBOutlet UIView *viewAlertRound;
    IBOutlet UIView *view_alert;
    IBOutlet UIImageView *alertImage;
    IBOutlet UITextField *titletxt;
    
    UIImagePickerController *picker;
    
    MyCLController *locationController;
   
    MKReverseGeocoder *geoCoder;
    CLLocationCoordinate2D UserLocation;
    NSString    *currentadds;
    NSString *userLatitude;
    NSString *userLongitude;

    AppDelegate *appDel;
  
}
- (void)openEditor;
-(IBAction)buttonAction:(UIButton*)sender;

-(IBAction)mapPic:(id)sender;
@end
