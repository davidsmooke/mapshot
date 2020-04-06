//
//  ImageViewController.h
//  ArtMap
//
//  Created by sathish kumar on 10/1/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCommentViewController.h"
#import "FollowerViewController.h"
#import "ATMHud.h"
#import "CommentsControl.h"
#import "UserProfileViewController.h"
#import "ImageSortingOrder.h"
#import <QuartzCore/CALayer.h>
#import "ShareCustomClass.h"

@interface ImageViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    
    UIAlertView *errAlertView;
    UILabel *noOfCommentsLbl;
    UILabel *imageLikeLbl;
    UILabel *mnthlbl;
    UILabel *countrylbl;
    IBOutlet UILabel *userNamelabel;
    
    ATMHud      *progressView;
    UIImageView *imgview;
     UIImageView *uploadedImageView;
    
    UIButton *leftnav;
    UIButton *rightnav;
    UIButton *uploadbut;
    UIButton *sharebut;
    UIButton *homebtn;
    UIButton *imageLikeBtn;
    UIButton *uploadedUserNameBtn;
    UIButton *greylikbtn;
    
    UIImage      *IMG;
    UITextField  *titletxt;
    UITableView  *tableview;
    IBOutlet UIScrollView *photoCommentScrollView;
    UIView       *commentview;
    
    NSURL *uploadedImageUrl;
    UIView *commentsPanelView ;
    
    NSString *userIdstr;
    NSString *imageIdStr;
    
    NSString *currentUserLIKedStr;
    NSDictionary *imagedetailsdict;
    UIAlertView *flagDescriptionAlert;
    UILabel *FlagDetailLabel;
    AppDelegate *appdel;
    NSString *titlestring ;
    NSString *share_Imagetitle;
    UIButton *moreButton;
    UIButton *zoomButton;
    UIView *popUpview;
  
    ShareCustomClass *share;
    BOOL isFlagButtonPresent;
    BOOL isDeleteButtonPresent;
    UIButton *deletebtn;
    UIImageView *shareImageView;
    UIImage *passImage;
}
@property(nonatomic,retain) UIImageView *uploadedImageView;
@property(nonatomic,retain) NSString *currentads;
@property(nonatomic,retain) NSString *typestr;
@property(strong,nonatomic) UIImage  *imageview;
@property(nonatomic,retain) NSString *titlestr;
@property(nonatomic,retain) NSMutableArray  *IMGArray;
@property(nonatomic) float           latitude;
@property(nonatomic) float           longitude;
@property(nonatomic,retain) NSURL *uploadedImageUrl;
@property(nonatomic,retain) NSString *currentUserLIKedStr;
@property(nonatomic,assign)  BOOL isFlagButtonPresent;
@property(nonatomic,assign)  BOOL isDeleteButtonPresent;


//-(void) DetailService;
//-(void) ButtonEnabled;
//-(void) DisplayImages;
//-(void) UploadAlert;
//-(void) Asktitle;
//-(void) imageupload;
//-(void) callcommentfun;

//- (void)showPopupMenu:(id)sender;

-(NSString*) Dateformate:(NSString*)str;
- (UIImage *)captureView:(UIView *)view;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

-(void) moreFunction:(UIButton*) sender;
-(IBAction)backoption:(id)sender;
-(IBAction)shareMethod:(id)sender;

@end
