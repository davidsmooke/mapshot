//
//  FollowerViewController.m
//  ArtMap
//
//  Created by sathish kumar on 11/8/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import "FollowerViewController.h"
#import "ImageViewController.h"
#import "UIImage+RoundedCorner.h"
#import "JSON.h"
//#import "FollowerTableViewController.h"
#import "UIImage+Alpha.h"
#import "MapViewController.h"
#import "ASIHTTPRequest.h"

#import "UIImage+Size.h"
#import "INAnnotation.h"
#import "AFNetworking.h"
//#import "ViewController.h"
#import "UserProfileViewController.h"
#import "SettingsViewController.h"
#import "FollowListViewController.h"


BOOL isfollow;
@interface FollowerViewController (){
    
    NSMutableArray *imageArr;
    NSString       *followingCountString;
    NSString       *followerCountString;
    NSArray        *followingCountArray;
    NSArray        *followerCountArray;
    NSArray        *sortingarr;
   IBOutlet UIScrollView   *scroll;
  
    UIImage        *resizeimg;
    
    NSMutableArray *imgUrl;
}

@end

@implementation FollowerViewController
@synthesize mapView;
@synthesize requestQueue;
@synthesize profileScroll;
@synthesize myPageControl;
@synthesize followerService;
@synthesize imagelikeSer;
@synthesize followingImageser;
@synthesize yesFromImageView;

BOOL regionWillChangeAnimatedCalled;
BOOL regionChangedBecauseAnnotationSelected;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         
    }
    return self;
}

- (void)viewDidLoad
{
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              UITextAttributeTextColor : [UIColor blackColor]
                                                              } forState:UIControlStateNormal];
    imageArr = [[NSMutableArray alloc] init];
    classarr = [[NSMutableArray alloc] init];

    [segmentedControl.layer setCornerRadius:5.0];
    
    scroll.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    progressView = [[ATMHud alloc] initWithDelegate:self];
	[[ArtMap_DELEGATE window] addSubview:progressView.view];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ProfileBackground.png"]]];
    
    UITapGestureRecognizer *pinchresult = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinchTriggered:)];
    pinchresult.numberOfTapsRequired=2;
    [scroll addGestureRecognizer:pinchresult] ;
    
    scroll.contentSize=CGSizeMake(scroll.frame.size.width,view_container.frame.size.height);
    profileScroll.contentSize=CGSizeMake(640,profileScroll.frame.size.height);
    profileScroll.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
    photoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
  //  photoView.hidden=NO;
    [profileScroll addSubview:photoView];
    
    bioView=[[UIView alloc] initWithFrame:CGRectMake(320,0, 320, 150)];
  //  bioView.hidden=YES;
    [profileScroll addSubview:bioView];
    
    
    twit = [[UIImageView alloc] initWithFrame:CGRectMake(110, 10, 100, 100)];
    twit.backgroundColor = [UIColor clearColor];
    [photoView addSubview:twit];
    
    followbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    followbtn.frame = CGRectMake(230, 50, 70, 30);
    followbtn.tag = 200;
    followbtn.backgroundColor=[UIColor grayColor];
    [followbtn addTarget:self action:@selector(FollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    followbtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    followbtn.titleLabel.textColor = [UIColor whiteColor];
    [photoView addSubview:followbtn];
    
    
    destxt = [[UITextView alloc] initWithFrame:CGRectMake(35, 15, 250, 75)];
    destxt.backgroundColor = [UIColor clearColor];
    destxt.editable = NO;
    destxt.autocorrectionType=NO;
    destxt.scrollEnabled=YES;
    destxt.textAlignment=NSTextAlignmentJustified;
    destxt.showsVerticalScrollIndicator=NO;
    destxt.textColor = [UIColor whiteColor];
    destxt.font=[UIFont fontWithName:@"Helvetica"size:14.0];
    [bioView addSubview:destxt];

    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [profileScroll addGestureRecognizer:swipeGesture];
    
    // listen for left swipe
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [profileScroll addGestureRecognizer:swipeGesture];
    
    
    [ArtMap_DELEGATE setUserDefault:@"Toggle_tag_anotherUser" setObject:@"102"];
    
    locationController=[[MyCLController alloc] init];
    locationController.delegate=self;
  
     share=[[ShareCustomClass alloc] init];
    
    [segmentedControl addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
    
    [super viewDidLoad];
   
}
-(void)viewDidAppear:(BOOL)animated
{
    if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
       // RHViewControllerDown();
        //[ArtMap_DELEGATE applicationDidBecomeActive:[UIApplication sharedApplication]];
    }
    
    appdel=ArtMap_DELEGATE;
    // [appdel.tabbarObject ShowNewTabBar];
    
    [mapView removeAnnotations:[mapView annotations]];
    
    [super viewWillAppear:YES];
    
    if (appdel.isImageLocate==YES)  {
        
        
        yesFromImageView=YES;
        [self setmapRegionFromImageView];
        
    }
    
    
    
     [self pickOne:segmentedControl];
//    NSString *buttontagString=[ArtMap_DELEGATE getUserDefault:@"Toggle_tag_anotherUser"];
//    int buttonTag=[buttontagString intValue];
//    
//    if (buttonTag==102)  {
//        yesFromImageView=NO;
//        [self uploadButtonSetImage];
//        [self followerViewService];
//        
//        
//    }
//    else if (buttonTag==103)  {
//        yesFromImageView=NO;
//        [self interactedButtonSetImage];
//        [self likedImageService];
//    }
//    else if (buttonTag==104)    {
//        yesFromImageView=NO;
//        [self followingButtonSetImage];
//        [self follwingImageService];
//        
//    }
}


-(void) viewWillAppear:(BOOL)animated
{
   // self.navigationController.navigationBarHidden = YES;
  
    if(appdel.isFromSearchView==YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void ) viewWillDisappear:(BOOL)animated   {
    [super viewWillDisappear:YES];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag == 101)
    {
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        myPageControl.currentPage=page;
    }
}


-(void) setmapRegionFromImageView   {
    
    //nslog(@"REGION SET IMAGE VIEW");
    double latiValz=[[ArtMap_DELEGATE getUserDefault:@"Image_latitude"] doubleValue];
    double longValz=[[ArtMap_DELEGATE getUserDefault:@"Image_longitude"] doubleValue];
    
    UserLocation=CLLocationCoordinate2DMake(latiValz, longValz);
    region = MKCoordinateRegionMakeWithDistance(UserLocation, 16093.4400f, 16093.4400f);
    [mapView setRegion:region animated:YES];
    
    appdel.isImageLocate=NO;
}


-(void ) uploadButtonSetImage   {
    
    [UploadedImagebutton setBackgroundImage:[UIImage imageNamed:@"ProfileTogglesel.png"] forState:UIControlStateNormal];
    [interactImageButton setBackgroundImage:[UIImage imageNamed:@"ProfiletoggleUnsel.png"] forState:UIControlStateNormal];
    [FollowingImagebutton setBackgroundImage:[UIImage imageNamed:@"ProfiletoggleUnsel.png"] forState:UIControlStateNormal];
    
}

-(void ) interactedButtonSetImage   {
    
    [UploadedImagebutton setBackgroundImage:[UIImage imageNamed:@"ProfiletoggleUnsel.png"] forState:UIControlStateNormal];
    [interactImageButton setBackgroundImage:[UIImage imageNamed:@"ProfileTogglesel.png"] forState:UIControlStateNormal];
    [FollowingImagebutton setBackgroundImage:[UIImage imageNamed:@"ProfiletoggleUnsel.png"] forState:UIControlStateNormal];
    
}
-(void) followingButtonSetImage {
    
    [UploadedImagebutton setBackgroundImage:[UIImage imageNamed:@"ProfiletoggleUnsel.png"] forState:UIControlStateNormal];
    [interactImageButton setBackgroundImage:[UIImage imageNamed:@"ProfiletoggleUnsel.png"] forState:UIControlStateNormal];
    [FollowingImagebutton setBackgroundImage:[UIImage imageNamed:@"ProfileTogglesel.png"] forState:UIControlStateNormal];
}



-(void) callUserProfileView
{
    appdel=ArtMap_DELEGATE;
//    [appdel.tabbarObject setSelectedIndex:4];
//    [appdel.tabbarObject selectTab:4];
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *)sender direction];
    
    switch (direction)
    {
            // left
        case UISwipeGestureRecognizerDirectionLeft:
            [self performSelector:@selector(bioFun)];
            break;
            // right
        case UISwipeGestureRecognizerDirectionRight:
            [self performSelector:@selector(PhotoFun)];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            break;
        case UISwipeGestureRecognizerDirectionUp:
            break;
    }
}


-(IBAction)shareMethod:(id)sender
{
    [ArtMap_DELEGATE Setscreenshot:[self captureView:mapView] forkey:ArtMapScreenShot];
    [ArtMap_DELEGATE  setUserDefault:@"screenShotName" setObject:@"Image Title"];
    [ArtMap_DELEGATE  setUserDefault:@"Share_Location" setObject:@"profile"];
    [ArtMap_DELEGATE  setUserDefault:@"Share_DialogueName" setObject:titlelbl.text];
    
   
    // test double
    
   /* [self presentViewController:[share ShareTapped] animated:YES completion:^{
        navController.view.superview.bounds = CGRectMake(0, 0, 250, 250);}];*/
    
    
    [self presentViewController:[share ShareTapped] animated:YES completion:^{
        [share ShareTapped].view.superview.bounds = CGRectMake(0, 0, 250, 250);}];
}


- (UIImage *)captureView:(UIView *)view {
    
    CGRect screenRect =self.view.bounds;
    UIGraphicsBeginImageContextWithOptions(screenRect.size, 1, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [self.view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(void) pickOne:(id)sender
{
    [mapView removeAnnotations:[mapView annotations]];
    
    UISegmentedControl *segmentedControl1 = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl1.selectedSegmentIndex;
    
    [ArtMap_DELEGATE setUserDefault:@"Toggle_tag" setObject:[NSString stringWithFormat:@"%ld",(long)selectedSegment]];
    if (selectedSegment == 0)
    {
        [self performSelectorInBackground:@selector(followerViewService) withObject:nil];
        //[self followerViewService];
    }
    else if (selectedSegment == 1)
    {
        [self performSelectorInBackground:@selector(likedImageService) withObject:nil];
       // [self likedImageService];
    }
    else
    {
          [self performSelectorInBackground:@selector(follwingImageService) withObject:nil];
       //  [self follwingImageService];
    }
    
}


-(void) FilterImageFunction:(UIButton*)sender
{
    //nslog(@"CLICKED TOGGLE BUTTON");
    //nslog(@"SENDER TAG %d ",sender.tag);
    
    [ArtMap_DELEGATE setUserDefault:@"Toggle_tag_anotherUser" setObject:[NSString stringWithFormat:@"%d",sender.tag]];
    
    [mapView removeAnnotations:[mapView annotations]];
    
    if (sender.tag==102)    {
        
         //nslog(@"UPLOADED IMAGES BY ANOTHER USER");
       
         [self uploadButtonSetImage];
         [self followerViewService];
        
    }
    
   else  if (sender.tag==103)    {
        
        //nslog(@"LIKED IMAGES BY ANOTHER USER");
       
        [self interactedButtonSetImage];
        [self likedImageService];
    }
    
   else    if (sender.tag==104)    {
        
          //nslog(@"FOLLOWING USER IMAGES BY ANOTHER USER");
      
          [self followingButtonSetImage];
          [self follwingImageService];
    }

}

-(void) followerViewService
{
    
    followerService=YES;
    imagelikeSer=NO;
    followingImageser=NO;
    
    
    
     BOOL internet= [AppDelegate hasConnectivity];
     //NSLog(@"inter is having %x",internet);
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)
     {
   
         
        // scroll.contentSize = CGSizeMake(320, 750);
         
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         NSString *secuserid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMapSecondaryuserid]];
         
         //nslog(@"user id  %@, seco id  in follower view %@ ",userid,secuserid);
         
         callWebservice *pro = [[callWebservice alloc] init];
         pro.delegate = self;
         [pro ProfileView:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"view_type\":\"1\",\"prfl_view_id\":\"%@\"}",userid,secuserid] forKey:@"data"]];
     }
     else{
     
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
     }
}


-(void) likedImageService
{
    
    followerService=NO;
    imagelikeSer=YES;
    followingImageser=NO;
    
     BOOL internet= [AppDelegate hasConnectivity];
   
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)
     {
    
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         NSString *secuserid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMapSecondaryuserid]];
         
         callWebservice *likedCommentedObj = [[callWebservice alloc] init];
         likedCommentedObj.delegate = self;
         [likedCommentedObj  commentedLikedImage:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"other_user_id\":\"%@\"}",userid,secuserid] forKey:@"data"]];
         
        
     }
     else{
     
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
     }
}

-(void) follwingImageService
{
    
    followerService=NO;
    imagelikeSer=NO;
    followingImageser=YES;
    
     BOOL internet= [AppDelegate hasConnectivity];
  
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)
     {
   
     NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
     NSString *secuserid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMapSecondaryuserid]];
         
    callWebservice *followingObj = [[callWebservice alloc] init];
    followingObj.delegate = self;
    [followingObj FollowingImageInCurrentProfile:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"other_user_id\":\"%@\"}",userid,secuserid] forKey:@"data"]];
         
       
     }
     else{
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
     }
}


-(void) bioFun
{
    //nslog(@" bio call ");
    CGRect frame;
    frame.origin.x = 320;
    frame.origin.y = 0;
    frame.size = self.profileScroll.frame.size;
    [self.profileScroll scrollRectToVisible:frame animated:YES];
    
     myPageControl.currentPage=0;
    
}
-(void) PhotoFun
{
    //nslog(@" photo call ");
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.profileScroll.frame.size;
    [self.profileScroll scrollRectToVisible:frame animated:YES];
    
    myPageControl.currentPage=1;
 }

-(IBAction) pageChangeFunction
{
    //nslog(@"u have touched ");
    CGRect frame;
    frame.origin.x = self.profileScroll.frame.size.width * self.myPageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.profileScroll.frame.size;
    [self.profileScroll scrollRectToVisible:frame animated:YES];
}


-(void)pinchTriggered:(UITapGestureRecognizer*)tap   {
    scroll.contentOffset =CGPointMake(0, 190);
    //nslog(@"profile function");
    [topButton setTitle:@"Profile" forState:UIControlStateNormal];
    topButton.tag=102;
}



-(IBAction)backoption:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

    
//    for(UIViewController *view in self.navigationController.viewControllers)
//        
//    {
//        //nslog(@"view controller %@",view);
//        
//        if ([view isKindOfClass:[ImageViewController class]])
//        {
//            [self.navigationController popToViewController:view animated:YES];
//        }
//        if ([view isKindOfClass:[FollowerViewController class]])
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//           
//        }
//    }
}

-(void) homeoption
{
    for(UIViewController *view in self.navigationController.viewControllers)
    {
        if ([view isKindOfClass:[MapViewController class]])
        {
            [self.navigationController popToViewController:view animated:YES];
        }
    }
    
}

-(void) FollowBtn:(id)sender
{
    //*-------Custom Progress View---------*/
        
    ////nslog(@"sender %d",[sender tag]);
    
    BOOL internet= [AppDelegate hasConnectivity];
 
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected)  {
        
  
        if([sender tag] == 200)
        {
            [progressView setFixedSize:CGSizeMake(150, 150)];
            [progressView setCaption:@"Please wait..."];
            [progressView setActivity:YES];
            [progressView setBlockTouches:NO];
            [progressView show];
            
            callWebservice *follow = [[callWebservice alloc] init];
            follow.delegate = self;
            NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
            NSString *followerUserid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMapSecondaryuserid]];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"follow_id\":\"%@\",\"status\":\"1\"}",userid,followerUserid],@"data",@"1",@"isfollow", nil];
            [follow performSelector:@selector(FollowService:) withObject:dict afterDelay:0.2];
            
        }
        else if([sender tag] == 300)
        {
            [progressView setFixedSize:CGSizeMake(150, 150)];
            [progressView setCaption:@"Please wait..."];
            [progressView setActivity:YES];
            [progressView setBlockTouches:NO];
            [progressView show];
            
            
            
            callWebservice *follow = [[callWebservice alloc] init];
            follow.delegate = self;
            NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
            NSString *secuserid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMapSecondaryuserid]];
            
            //followbtn=(UIButton*)[self.view viewWithTag:300];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"follow_id\":\"%@\",\"status\":\"0\"}",userid,secuserid],@"data",@"0",@"isfollow" ,nil];
            [follow performSelector:@selector(FollowService:) withObject:dict afterDelay:0.2];
        }
    }
    else{
        
        
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
    }
}



-(IBAction)FollowersAction:(id)sender
{
    if([followerCountString intValue] > 0 && [sender tag] == 101)
    {
    
        FollowListViewController *follow=[[FollowListViewController alloc] init];
        follow.followno=[sender tag];
        follow.userOrFolloUser=@"followUserprofile";
        [self.navigationController pushViewController:follow animated:YES];
        
       
    }
    else if([followingCountString intValue] > 0 && [sender tag]== 102)
    {
        
        FollowListViewController *follow=[[FollowListViewController alloc] init];
        follow.followno=[sender tag];
        follow.userOrFolloUser=@"followUserprofile";
        [self.navigationController pushViewController:follow animated:YES];
        
      
    }
}


//-(void)LogOutFunction:(UIButton*)sender
//{
//    topButton.frame=(topButton.tag==101)?CGRectMake(275 , 4,32, 30):CGRectMake(240, 5, 72, 28);
//    [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
//    
//    [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
//    
//    if (sender.tag==101)    {
//       
//        topButton.tag=102;
//        [self shareMethod];
//    }
//    if (sender.tag==102) {
//        
//         scroll.contentOffset=CGPointMake(0, 0);
//         topButton.tag=101;
//         
//    }
//    
//}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scroll.tag==405)    {
    
        if (scrollView.contentOffset.y>200) {
       
            //nslog(@"profile succ");
            topButton.tag=102;
            topButton.frame=(topButton.tag==101)?CGRectMake(275 , 4,32, 30):CGRectMake(240, 5, 72, 28);
            [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
            [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
            
        }
        if (scrollView.contentOffset.y<=200)    {
       
            //nslog(@"logout succ");
           
            topButton.tag=101;
            topButton.frame=(topButton.tag==101)?CGRectMake(275 , 4,32, 30):CGRectMake(240, 5, 72, 28);
            [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
            [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
        }
        
    }
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //nslog(@"scrollViewDidEndScrollingAnimation");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //nslog(@"scrollViewDidScroll - content off set y val  %f ",scrollView.contentOffset.y);
    
    if (scroll.tag==405)    {
    
        if (scrollView.contentOffset.y>200)
        {
            
            //nslog(@"profile succ");
            topButton.tag=102;
            topButton.frame=(topButton.tag==101)?CGRectMake(275 , 4,32, 30):CGRectMake(240, 5, 72, 28);
            [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
            [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
        }
        if (scrollView.contentOffset.y<=200)    {
            
        //nslog(@"logout succ");
        topButton.tag=101;
        topButton.frame=(topButton.tag==101)?CGRectMake(275 , 4,32, 30):CGRectMake(240, 5, 72, 28);
        [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
        [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
        }
    }
}


-(void) Capturephoto
{
    UIActionSheet *obj=[[UIActionSheet alloc]initWithTitle:@"Capture Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select photo from gallery",@"Take a photo", nil];
    [obj showInView:self.view];
    
    mapView.scrollEnabled = NO;
    [mapView setZoomEnabled:NO];

    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ////nslog(@"button index is %d",buttonIndex);
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.allowsEditing=YES;
    picker.delegate=self;
    if(buttonIndex==0)
    {
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
     
    }
    else if(buttonIndex==1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else    {
            
            UIAlertView *cameraAlert=[[UIAlertView alloc] initWithTitle:@"camera not found " message:@"please test with device" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [cameraAlert show];
            
        }
    }
    else{
        
    }
}
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    IMG = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    resizeimg = [IMG squareImageWithImage:IMG scaledToSize:CGSizeMake(640,600)];
    NSData *imgdata = UIImagePNGRepresentation(resizeimg);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    ////nslog(@"path %@",filePath);
    [imgdata writeToFile:filePath atomically:YES];
    
     [self dismissViewControllerAnimated:YES completion:nil];
    [uploadbut setTag:205];
    
    [self Asktitle];
  
   
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 200)     {
       
        // isUpload = YES;
        [progressView setFixedSize:CGSizeMake(150, 150)];
        [progressView setCaption:@"Uploading Please wait..."];
        [progressView setActivity:YES];
        [progressView setBlockTouches:NO];
        [progressView show];
        
        
        
    }
}
-(void) Asktitle
{
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"This is the uploaded image.\n\n\n\n\n\n\n\n\n" message:nil delegate:self cancelButtonTitle:@"Map Your Pic!" otherButtonTitles: nil];
    alt.tag = 200;
    [alt show];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(90,40, 100,100)];
    image.image = resizeimg;
    [alt addSubview:image];
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 250, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    title.text = @"Enter a title for the image.";
    [alt addSubview:title];
    
    titletxt = [[UITextField alloc] initWithFrame:CGRectMake(10, 190, 250, 30)];
    titletxt.borderStyle = UITextBorderStyleRoundedRect;
    titletxt.delegate = self;
    [alt addSubview:titletxt];
}






#pragma mark LocationController
- (void)locationUpdate:(CLLocation *)location {
    
    CLLocationCoordinate2D loc = location.coordinate;
   
    UserLocation = location.coordinate;
    region = MKCoordinateRegionMakeWithDistance(loc, 10000.0f, 10000.0f);
    [mapView setRegion:region];
       
    [[locationController locationManager] stopUpdatingLocation];
    
  
}
- (void)locationError:(NSError *)error {
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    
   INAnnotation *pointCheck=(INAnnotation*)annotation;
   MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    annotationView.tag = pointCheck.tag;
    annotationView.canShowCallout = YES;
    if([imageArr count]>0)
    {
    annotationView.image = [[imageArr objectAtIndex:[pointCheck.pointtag intValue]] objectForKey:@"imageData"];
    
    if(pointCheck.tag  != 1000)
    {
        // //nslog(@"Count %d dgf %d",[imageArr count],[pointCheck.pointtag intValue]);
        if(pointCheck.tag > 0)
        {
            annotationView.image = [[imageArr objectAtIndex:pointCheck.tag] objectForKey:@"imageData"];
        }
    }
    else
    {
        if(isUpload)
        {
            annotationView.image = [UIImage imageNamed:@"Pin.png"];
        }
    }

    }
    
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(writeSomething:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = pointCheck.tag ;
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = rightButton;
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    return annotationView;
}


-(void) writeSomething:(UIButton*)sender
{
   // self.navigationController.navigationBarHidden = NO;
    [requestQueue cancelAllOperations];
    [ASINetworkQueue  cancelPreviousPerformRequestsWithTarget:self];
    [AFHTTPClient cancelPreviousPerformRequestsWithTarget:self];
    [AFHTTPRequestOperation cancelPreviousPerformRequestsWithTarget:self];
    
    
    NSMutableArray *filterArray = [[NSMutableArray alloc] init];
    
    for (ImageSortingOrder *array in  sortingarr )
    {
        float thefloat = array.distance;
        int roundedup = ceilf(thefloat);
        int value = roundedup/1609.34;
        if(value <= 1)
        {
            ////nslog(@"maete %d",value);
            [filterArray addObject:array];
        }
    }
    //nslog(@"FIlter arr %@",filterArray);
     
  //  ImageViewController *image = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    ImageViewController *imageobj =[storyBoard  instantiateViewControllerWithIdentifier:@"imageobj"];
   // image.hidesBottomBarWhenPushed=NO;
    imageobj.IMGArray = filterArray;
    
//    UIImage *smallImage=[[imageArr objectAtIndex:sender.tag] objectForKey:@"imageData"];
//    image.imageview=smallImage;
//    
//    NSURL *largeimageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/large/%@",IMG_BASE_URL,[[imageArr objectAtIndex:sender.tag] objectForKey:@"image_name"]]];
//    image.uploadedImageUrl=largeimageUrl;
//    
//    image.titlestr = [[imageArr objectAtIndex:sender.tag] objectForKey:@"image_title"];
//    NSString *detstr = [[imageArr objectAtIndex:sender.tag] objectForKey:@"image_id"];
//    [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:detstr];
    
    
    if ([imageArr count]>0) {
        
        UIImage *smallImage=[[imageArr objectAtIndex:sender.tag] objectForKey:@"imageData"];
        imageobj.imageview=smallImage;
        
        NSURL *largeimageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/large/%@",IMG_BASE_URL,[[imageArr objectAtIndex:sender.tag] objectForKey:@"image_name"]]];
      
        imageobj.uploadedImageUrl=largeimageUrl;
        
        imageobj.titlestr = [[imageArr objectAtIndex:sender.tag] objectForKey:@"image_title"];
        NSString *detstr = [[imageArr objectAtIndex:sender.tag] objectForKey:@"image_id"];
        [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:detstr];
        [self.navigationController pushViewController:imageobj animated:YES];
    }

    
    
    
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}




- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
{
  
}

- (void)mapView:(MKMapView *)mapView1 didAddAnnotationViews:(NSArray *)views
{
    if(views.count<2)return;
    
   [self performSelectorOnMainThread:@selector(imageProcess:) withObject:mapView1 waitUntilDone:YES];
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    regionWillChangeAnimatedCalled = YES;
    regionChangedBecauseAnnotationSelected = NO;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
        
    if (!regionChangedBecauseAnnotationSelected) //note "!" in front
    {
        
    }
    
    //reset flags...
    regionWillChangeAnimatedCalled = NO;
    regionChangedBecauseAnnotationSelected = NO;
 }

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view1
{
    regionChangedBecauseAnnotationSelected = regionWillChangeAnimatedCalled;
    
    [self cancelRequest];
    if(view1.tag != 1000)
    {
        if([imageArr count]> 0)
        {
            //nslog(@"select %d Tag %d",[imageArr count],view.tag);
            //nslog(@"TAG Select  %@",[imageArr objectAtIndex:view.tag]);
            view1.image = [[imageArr objectAtIndex:view1.tag] objectForKey:@"highlightedimage"];
        }
    }
}
- (void)mapView:(MKMapView *)mapView1 didDeselectAnnotationView:(MKAnnotationView *)view1
{
    if(view1.tag != 1000)
    {
        if([imageArr count]> 0)
        {
            view1.image = [[imageArr objectAtIndex:view1.tag] objectForKey:@"imageData"];
          
            [self performSelectorOnMainThread:@selector(imageProcess:) withObject:mapView1 waitUntilDone:YES];
        }
    }
}
-(void)cancelRequest
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [requestQueue setSuspended:YES];
        
        [requestQueue cancelAllOperations];
        [AFHTTPClient cancelPreviousPerformRequestsWithTarget:self];
        [AFHTTPRequestOperation cancelPreviousPerformRequestsWithTarget:self];
    });
}




-(void) didFinishLoading:(ASIHTTPRequest*)request
{
    
    NSDictionary *resdict = [[request responseString] JSONValue];
    //nslog(@"response val %@",resdict);
    //nslog(@"status ****** %@",[resdict objectForKey:@"status"]);
    NSInteger StatusVariable=[[resdict objectForKey:@"status"] integerValue];
    //nslog(@"xxx %d",StatusVariable);

    if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"profileview"])
    {
        if (StatusVariable==1)
        {
        
       [self downloadImg:[[request responseString] JSONValue]];
        
        id checkfollwingcount=[[resdict objectForKey:@"info"] objectForKey:@"follow"];
        
        
        if ([checkfollwingcount isKindOfClass:[NSArray class]])
        {
              followingCountArray = [[resdict objectForKey:@"info"] objectForKey:@"follow"];
            
             for (NSDictionary *dicttt in followingCountArray)
             {
             followingCountString = [NSString stringWithFormat:@"%@",[dicttt objectForKey:@"count"]];
             followingCountlabel.text = followingCountString;
             }
        }
        else
        {
            followingCountlabel.text =@"0";
        }
        
        
        id checkfollowercount=[[resdict objectForKey:@"info"] objectForKey:@"follower"];
        
        if ([checkfollowercount isKindOfClass:[NSArray class]])
        {
            followerCountArray = [[resdict objectForKey:@"info"] objectForKey:@"follower"];
            for (NSDictionary *dicty in followerCountArray)
            {
                followerCountString = [NSString stringWithFormat:@"%@",[dicty objectForKey:@"count"]];
                followerCountlabel.text = followerCountString;
            }
        }
        else
        {
               followerCountlabel.text =@"0";
        }

        NSArray *usrarr = [[resdict objectForKey:@"info"] objectForKey:@"usr"];
        
            for (NSDictionary *dic in usrarr) {
            
                NSString *usrtxt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
                titlelbl.text = usrtxt;
                
                NSString *descriptionTxt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
                
                if (descriptionTxt.length>0)
                {
                    destxt.text=descriptionTxt;
                }
                else
                {
                    destxt.text = @"The user has not added any information about their self";
                }
                
                NSString *proflimgstr = [NSString stringWithFormat:@"%@/%@",ImagebaseUrl,[dic objectForKey:@"image_path"]];
            
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:proflimgstr]]; 
                UIImage *img = [UIImage imageWithData:data];
                twit.image = img;
            }
        
        
            NSMutableArray *resarr;
        
            if (followerService)
            {
                //nslog(@"YES followerprofile SERVICE");
                resarr = [[resdict objectForKey:@"info"] objectForKey:@"image_res"];
            }
            if (imagelikeSer)
            {
                //nslog(@"YES likedcommented  SERVICE");
                resarr = [[resdict objectForKey:@"info"] objectForKey:@"like_comment_images"];
            }
        
           if (followingImageser)
           {
             //nslog(@"YES followeruploded image   SERVICE");
             resarr = [[resdict objectForKey:@"info"] objectForKey:@"like_comment_images"];
           }

        
            [classarr removeAllObjects];
        
            @try
            {
                for(NSDictionary *dic in resarr)
                {
                    int Totalsize = [[dic objectForKey:@"comments"] intValue] * 10 + [[dic objectForKey:@"likes"] intValue] * 2 + 90;
                    
                    ImageSortingOrder *sort = [[ImageSortingOrder alloc] init];
                    sort.address = [dic objectForKey:@"address"];
                    sort.comments = [[dic objectForKey:@"comments"] integerValue];
                    sort.createdon = [[dic objectForKey:@"created_on"] integerValue];
                    sort.imageid = [[dic objectForKey:@"image_id"] integerValue];
                    sort.imagename = [dic objectForKey:@"image_name"];
                    sort.imagepath = [dic objectForKey:@"image_path"];
                   
                    sort.imagesize = [[dic objectForKey:@"image_size"] integerValue];
                    sort.imagetitle = [dic objectForKey:@"image_title"];
                    sort.imagetype = [dic objectForKey:@"image_type"];
                    sort.latitude = [[dic objectForKey:@"latitude"] integerValue];
                    sort.longitude = [[dic objectForKey:@"longitude"] integerValue];
                    sort.likes = [[dic objectForKey:@"likes"] integerValue];
                    //   sort.distance = [[dic objectForKey:@"distance"] floatValue];
                    sort.userid = [[dic objectForKey:@"user_id"] integerValue];
                    sort.totalsize = Totalsize;
                    //  //nslog(@"Totalsize %d",Totalsize);
                    
                    [classarr addObject:sort];
                }

            }
            @catch (NSException *exception) {
               
            }
           
            NSSortDescriptor *sortdest = [[NSSortDescriptor alloc] initWithKey:@"totalsize" ascending:YES];
            sortingarr = [[NSArray alloc] initWithArray:[classarr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortdest]]];
        
        int isFollow = [[[resdict objectForKey:@"info"] objectForKey:@"follow_status"] integerValue];
        //nslog(@"followcount %d",isFollow);
        
        if (isFollow == ART_FOLLOWSTATUS_FOLLOW)    {
            
            //followbtn.tag = 200;
            [followbtn setTitle:@"UnFollow" forState:UIControlStateNormal];
           // followbtn.titleLabel.textColor = [UIColor whiteColor];
            [followbtn setTag:300];
        }
        else if(isFollow == ART_FOLLOWSTATUS_UNFOLLOW)    {
            // followbtn.tag = 300;
            [followbtn setTitle:@"Follow" forState:UIControlStateNormal];
          //  followbtn.titleLabel.textColor = [UIColor whiteColor];
            [followbtn setTag:200];
            
        }
            
        }
        else if(StatusVariable==0)
        
        {
            //nslog(@"follower service problem");
        }
    }
    
     if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"upload"])
    {
        //nslog(@"IMAGE upload %@",[[request responseString] JSONValue]);
        
        if (StatusVariable==1)
        {
            [progressView setCaption:@"Uploaded Successfully.."];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.3];
            
            //*-------Custom Progress View---------
            [progressView setFixedSize:CGSizeMake(150, 150)];
            [progressView setCaption:@"Loading Please wait..."];
            [progressView setActivity:YES];
            [progressView setBlockTouches:NO];
            [progressView show];
            
            
            [self performSelector:@selector(followerViewService) withObject:nil afterDelay:0.2];
            
            [progressView setCaption:@""];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.3];
            
            
        }else if (StatusVariable==0)
        {
            [progressView setCaption:@""];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.3];
        }
        
    }
    
    if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"follow"])     {
        
       // //nslog(@"[request userInfo] %@",[request userInfo]);
        //nslog(@"followservice  testtt %@",[[request responseString] JSONValue]);
        NSDictionary *dic = [[request responseString] JSONValue];
        NSString *StatusMsg = [dic objectForKey:@"message"];
        
        
        [progressView setCaption:@""];
        [progressView setActivity:NO];
        [progressView update];
        [progressView hideAfter:0.3];
        
            if([[[request userInfo] objectForKey:@"isfollow"] integerValue] == 1)      {
                
                if (StatusVariable==2 || StatusVariable==1)
                {
                    [followbtn setTitle:@"UnFollow" forState:UIControlStateNormal];
                  //  followbtn.titleLabel.textColor = [UIColor clearColor];
                    
                    if([followbtn.titleLabel.text isEqualToString:@"UnFollow"])     {
                        
                        [followbtn setTag:300];
                    }
                    
                    [progressView setFixedSize:CGSizeMake(150, 150)];
                    [progressView setCaption:@"Loading Please wait..."];
                    [progressView setActivity:YES];
                    [progressView setBlockTouches:NO];
                    [progressView show];
                    
                    [self performSelector:@selector(followerViewService) withObject:nil afterDelay:0.2];
                    
                    [progressView setCaption:StatusMsg];
                    [progressView setActivity:NO];
                    [progressView update];
                    [progressView hideAfter:0.3];
                }
                
        }
        else if([[[request userInfo] objectForKey:@"isfollow"] integerValue] == 0)      {
            
            if (StatusVariable==0)
            {
                [followbtn setTitle:@"Follow" forState:UIControlStateNormal];
              //  followbtn.titleLabel.textColor = [UIColor whiteColor];
                
                if([followbtn.titleLabel.text isEqualToString:@"Follow"])   {
                    
                    [followbtn setTag:200];
                }
                
                [progressView setFixedSize:CGSizeMake(150, 150)];
                [progressView setCaption:@"Loading Please wait..."];
                [progressView setActivity:YES];
                [progressView setBlockTouches:NO];
                [progressView show];
                
                [self performSelector:@selector(followerViewService) withObject:nil afterDelay:0.2];
                
                [progressView setCaption:StatusMsg];
                [progressView setActivity:NO];
                [progressView update];
                [progressView hideAfter:0.3];
            }
                               
        }
    }
}

-(void) didFailWithError:(ASIHTTPRequest*)request
{
    //nslog(@"error occured in follower view %@",[request.error localizedDescription]);
    
    [progressView setCaption:@"error"];
    [progressView setActivity:NO];
    [progressView update];
    [progressView hideAfter:0.3];
}

-(void) downloadImg:(NSDictionary*)responseDict
{
    
    imagedictionary = [[NSDictionary alloc] initWithDictionary:responseDict];
    
    //nslog(@"image dict in download fun %@ ",imagedictionary);
    
    NSArray *image_res;
    
    if (followerService)
    {
        id isCheck = [[imagedictionary objectForKey:@"info"] objectForKey:@"image_res"];
        image_res = nil;
        
        if ([isCheck isKindOfClass:[NSArray class]]) {
            image_res = [[imagedictionary objectForKey:@"info"] objectForKey:@"image_res"];
            picCountlbl.text = [NSString stringWithFormat:@"%d",[image_res count]];
        }else{
             picCountlbl.text=@"0";
            return;
        }
        
        [[self requestQueue] cancelAllOperations];
        
        requestQueue = [ASINetworkQueue queue];
        [[self requestQueue] setDelegate:self];
        [requestQueue setRequestDidFinishSelector:@selector(Finished:)];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        
        [imageArr removeAllObjects];
        [imgUrl removeAllObjects];
        
        for (NSDictionary *dictVal in image_res)
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@",IMG_BASE_URL,[dictVal objectForKey:@"image_path"]];
            
            NSString* escapedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:
                                          NSASCIIStringEncoding];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
            [request setUserInfo:[NSDictionary dictionaryWithObject:dictVal forKey:@"data"]];
            [[self requestQueue] addOperation:request];
        }
        if (image_res)
            [[self requestQueue] go];
    }
    
    
    if (imagelikeSer)
    {
        id isCheck = [[imagedictionary objectForKey:@"info"] objectForKey:@"like_comment_images"];
        image_res = nil;
        
        if ([isCheck isKindOfClass:[NSArray class]]) {
            image_res = [[imagedictionary objectForKey:@"info"] objectForKey:@"like_comment_images"];
            picCountlbl.text = [NSString stringWithFormat:@"%d",[image_res count]];
        }else{
            picCountlbl.text=@"0";
            return;
        }
        
        [[self requestQueue] cancelAllOperations];
        
        requestQueue = [ASINetworkQueue queue];
        [[self requestQueue] setDelegate:self];
        [requestQueue setRequestDidFinishSelector:@selector(Finished:)];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        
        [imageArr removeAllObjects];
        [imgUrl removeAllObjects];
        
        for (NSDictionary *dictVal in image_res)
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@",IMG_BASE_URL,[dictVal objectForKey:@"image_path"]];
            
            NSString* escapedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:
                                          NSASCIIStringEncoding];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
            [request setUserInfo:[NSDictionary dictionaryWithObject:dictVal forKey:@"data"]];
            // [request setDidFinishSelector:@selector(Finished:)];
            [[self requestQueue] addOperation:request];
        }
        if (image_res)
            [[self requestQueue] go];
    }
    
    
    if (followingImageser)
    {
    id isCheck = [[imagedictionary objectForKey:@"info"] objectForKey:@"following_images"];
        image_res = nil;
        
        if ([isCheck isKindOfClass:[NSArray class]]) {
            image_res = [[imagedictionary objectForKey:@"info"] objectForKey:@"following_images"];
            picCountlbl.text = [NSString stringWithFormat:@"%d",[image_res count]];
        }
        else {
            picCountlbl.text=@"0";
            return;
        }
        //nslog(@"image follw res %@",image_res);
        
        [[self requestQueue] cancelAllOperations];
        
        requestQueue = [ASINetworkQueue queue];
        [[self requestQueue] setDelegate:self];
        [requestQueue setRequestDidFinishSelector:@selector(Finished:)];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        
        [imageArr removeAllObjects];
        [imgUrl removeAllObjects];
        
        for (NSDictionary *dictVal in image_res)
        {
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@",IMG_BASE_URL,[dictVal objectForKey:@"image_path"]];
            
            NSString* escapedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:
                                          NSASCIIStringEncoding];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
            [request setUserInfo:[NSDictionary dictionaryWithObject:dictVal forKey:@"data"]];
            [[self requestQueue] addOperation:request];
        }
        if (image_res)
            [[self requestQueue] go];
    }

}

- (void)Finished:(ASIHTTPRequest *)request
{
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[request userInfo] objectForKey:@"data"] copyItems:YES];
  
    //nslog(@"SUVI %@",dict);
    
    @autoreleasepool {
        
        UIImage *orgImg = [[UIImage alloc] initWithData:[request responseData]];
        NSString *cmntstr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comments"]];
        NSString *likstr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"likes"]];
        int Totalsize = [cmntstr intValue] * 10 + [likstr intValue] * 2 + 130;
        
        UIImage *resizeImg = [UIImage imageWithImage:orgImg  scaledToWidth:Totalsize alpha:0.4f];
        //[UIImage imageWithImage:orgImg scaledToSize:CGSizeMake(Totalsize, Totalsize) ];
        UIImage *resizeImg2 = [UIImage imageWithImage:orgImg  scaledToWidth:Totalsize alpha:1.0f];
        
        [dict setValue:resizeImg forKey:@"imageData"];
        [dict setValue:resizeImg2 forKey:@"highlightedimage"];
        [dict setValue:orgImg forKey:@"OriginalImage"];
        
        [imageArr addObject:dict];
        
        // You could release the queue here if you wanted
        if ([[self requestQueue] requestsCount] == 0)
        {
            
           // CLLocationCoordinate2D curentLoc;
            //lingam
           region = MKCoordinateRegionMakeWithDistance(UserLocation,  16093.44f,  16093.44f);
            //  [mapView setRegion:region];
        }
    }
    // //nslog(@"Request finished %@",imageArr);
}




- (void)requestFailed:(ASIHTTPRequest *)request {
     //nslog(@"fal %@",[(NSError*)[request error] localizedDescription]);
    
    // You could release the queue here if you wanted
    if ([[self requestQueue] requestsCount] == 0) {
    }
    // //nslog(@"Request failed");
}

-(void) removeAnnotation
{
    if ([self.mapView.annotations count] > 0)
    {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
}



-(void) addAnnotationToMapView
{
    int i =0;
    NSMutableArray *annotations=[[NSMutableArray alloc] init];
   
    for (NSDictionary *dict in imageArr)    {
        
        CLLocationCoordinate2D reg;
        reg.longitude = [[dict objectForKey:@"longitude"] floatValue];
        reg.latitude = [[dict objectForKey:@"latitude"] floatValue];
        
        @autoreleasepool
        {
            INAnnotation*   a1=[[INAnnotation alloc] initWithLocation:reg];
            a1.url=@"http://www.definingterms.com/wp-content/uploads/2008/03/circle.png";
            
            a1.title=[dict objectForKey:@"image_title"];
            
            a1.tag=i;
            
            [annotations addObject:a1];
            
            i++;
        }
        
    }
    
    [mapView addAnnotations:annotations];
}


- (void)queueFinished:(ASINetworkQueue *)queue
{
    
    
   
    
    // You could release the queue here if you wanted
    if ([[self requestQueue] requestsCount] == 0) {
        
    }
    
    //nslog(@"Queue finished imageArr%@",imageArr);
    
    [imageArr sortUsingComparator:^NSComparisonResult(id a,id b){
        NSDictionary *dict1=(NSDictionary*)a;
        NSDictionary *dict2=(NSDictionary*)b;
        if([(UIImage*)[dict1 valueForKey:@"imageData"] size].width>[(UIImage*)[dict2 valueForKey:@"imageData"] size].width) return NSOrderedAscending;
        else if([(UIImage*)[dict1 valueForKey:@"imageData"] size].width<[(UIImage*)[dict2 valueForKey:@"imageData"] size].width) return NSOrderedDescending;
        
        return NSOrderedSame;
        
    }];
    
    
    if (yesFromImageView==NO)
    {
       [self setregionBasedOnResponse];  
    }
    
    
   
    
    int i =0;
    
    if ([self.mapView.annotations count] > 0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    
    NSMutableArray *annotations=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in imageArr)
    {
        CLLocationCoordinate2D reg;
        reg.longitude = [[dict objectForKey:@"longitude"] floatValue];
        reg.latitude = [[dict objectForKey:@"latitude"] floatValue];
        
        @autoreleasepool {
            INAnnotation*  a1=[[INAnnotation alloc] initWithLocation:reg];
            
            
            a1.url=@"http://www.definingterms.com/wp-content/uploads/2008/03/circle.png";
            a1.title=[dict objectForKey:@"image_title"];
            a1.tag=i;
            
            [annotations addObject:a1];
        }
        i++;
    }
    [self.mapView addAnnotations:annotations];
    
}

-(void) setregionBasedOnResponse
{
    if([imageArr count]>0)
    {
    NSString *setMapLatitude=[[imageArr objectAtIndex:0] objectForKey:@"latitude"];
    NSString *setMapLongitude=[[imageArr objectAtIndex:0] objectForKey:@"longitude"];
    
    double latiValz=[setMapLatitude doubleValue];
    double longValz=[setMapLongitude doubleValue];
    
    UserLocation=CLLocationCoordinate2DMake(latiValz, longValz);
    region = MKCoordinateRegionMakeWithDistance(UserLocation, 16093.4400f, 16093.4400f);
    [mapView setRegion:region animated:YES];
    }
}



#pragma mark - IMAGE algorthim.

-(void)imageProcess:(MKMapView*)map
{
   
    NSMutableArray *viewObjects=[[NSMutableArray alloc] init];
    for(INAnnotation *ina in [map annotationsInMapRect:mapView.visibleMapRect])
    {
        if([mapView viewForAnnotation:ina]!=nil)
            
            [viewObjects addObject:[mapView viewForAnnotation:ina]];
    }
    
    NSArray *views=[NSArray arrayWithArray:viewObjects];
    if(views.count<2)return;
    
    
   
    views= [views sortedArrayUsingComparator:^NSComparisonResult(id a,id b){
        MKAnnotationView *annotation1=(MKAnnotationView*)a;
        MKAnnotationView *annotation2=(MKAnnotationView*)b;
        
        if (annotation1.image.size.width > annotation2.image.size.width)
            return NSOrderedAscending;
        else if (annotation1.frame.size.width < annotation2.frame.size.width)
            return NSOrderedDescending;
        return NSOrderedSame;
        
        
        
    }];
    
    
    NSMutableArray *annotations=[NSMutableArray arrayWithArray:views];
    
    for(int i=0;i<views.count;i++)//MKAnnotationView *ann1 in views)
    {
        MKAnnotationView *ann1=(MKAnnotationView*)[views objectAtIndex:i];
        [annotations removeObject:ann1];
        
        for(MKAnnotationView *ann2 in annotations)
        {
           
            CGRect rect;
           
            if(CGRectIntersectsRect(ann1.frame, ann2.frame))
            {
                
               
                rect=CGRectIntersection(ann1.frame, ann2.frame);
                
                
                CGRect remainder,slice,remainder1,slice1;
                slice.origin.y=0;
                slice.size.height=0;
                slice1.origin.x=0;
                slice1.size.width=0;
                
                if(ann2.frame.origin.y<ann1.frame.origin.y)
                    CGRectDivide(ann2.bounds, &slice, &remainder, rect.size.height, CGRectMaxYEdge);
                if(ann2.frame.origin.y>ann1.frame.origin.y)
                    CGRectDivide(ann2.bounds, &slice, &remainder, rect.size.height, CGRectMinYEdge);
                
                if(ann2.frame.origin.x<ann1.frame.origin.x)
                    CGRectDivide(ann2.bounds, &slice1, &remainder1, rect.size.width, CGRectMaxXEdge);
                if(ann2.frame.origin.x>ann1.frame.origin.x)
                    CGRectDivide(ann2.bounds, &slice1, &remainder1, rect.size.width, CGRectMinXEdge);
                
                               
                CGRect fin;
                CGFloat x1=0,y1=0,h1=0,w1=0;
                
                if(ann2.frame.origin.y<ann1.frame.origin.y)
                {
                    y1=slice.origin.y;
                    h1=slice.size.height;
                    
                }
                if(ann2.frame.origin.y>ann1.frame.origin.y)
                {
                    y1=slice.origin.y;
                    h1=slice.size.height;
                }
                
                if(ann2.frame.origin.x<ann1.frame.origin.x)
                {
                    x1=slice1.origin.x;
                    w1=slice1.size.width;
                }
                if(ann2.frame.origin.x>ann1.frame.origin.x)
                {
                    x1=slice1.origin.x;
                    w1=slice1.size.width;
                }
                
                fin=CGRectMake(x1,y1,w1,h1);
                
                {
                
                    [self clipimg:ann2 rect:fin];
                }
                
            }
            
            
        }
    }
}



-(void)clipimg:(MKAnnotationView*)ann rect:(CGRect)clipper
{
    
    if(CGRectIsEmpty(clipper))
    {
        return;
    }
    
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:clipper];
    // Create an image context containing the original UIImage.
    UIGraphicsBeginImageContext(ann.image.size);
   [ann.image drawAtPoint:CGPointZero];
    
// Clip to the bezier path and clear that portion of the image.
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(context==nil) return;
    CGContextAddPath(context,bezierPath.CGPath);
    CGContextClip(context);
    CGContextClearRect(context,CGRectMake(0,0,ann.image.size.width,ann.image.size.height));
    
    // Build a new UIImage from the image context.
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    ann.image = newImage;
    //CGContextRelease(context);
    UIGraphicsEndImageContext();
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == titletxt)
        [titletxt resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    destxt.editable = NO;
    [destxt resignFirstResponder];
}


-(UILabel*) customLabel:(NSString*)str initFrame:(CGRect)frame
{
	UILabel *customLabel = [[UILabel alloc] initWithFrame:frame];
	//customLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	customLabel.adjustsFontSizeToFitWidth = YES;
    customLabel.text = str;
    customLabel.backgroundColor=[UIColor clearColor];
    customLabel.font=[UIFont fontWithName:@"Helvetica"size:13.0];
    customLabel.textColor=[UIColor whiteColor];
    
	return customLabel;
}


- (void)didReceiveMemoryWarning
{
      [self resetAll];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetAll
{
    requestQueue=nil;
    [imageArr removeAllObjects];
     sortingarr=nil;
    imagedictionary=nil;
    [imgUrl removeAllObjects];
}





@end
