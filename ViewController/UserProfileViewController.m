
//
//  UserProfileViewController.m
//  ArtMap
//
//  Created by sathish kumar on 11/5/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import "UserProfileViewController.h"
#import "JSON.h"
#import "NSString+UrlEncode.h"
#import "UIImage+RoundedCorner.h"
#import "ImageViewController.h"
#import  "UIImage+Alpha.h"
#import "FollowerViewController.h"
#import "MapViewController.h"
#import "ASIHTTPRequest.h"

#import "INAnnotation.h"
#import "UIImage+Size.h"
#import "AFNetworking.h"
//#import "ViewController.h"
#import "SettingsViewController.h"
#import "ShareCustomClass.h"
#import "FollowListViewController.h"

@interface UserProfileViewController ()<UIScrollViewDelegate>
{
    UIButton       *profileButton;
    UIImage        *resizeimg;
    UIScrollView   *scroll;
    NSMutableArray *imgUrl;
    NSArray        *sortingorder;
    NSMutableArray *Imgarr;
}

@end

@implementation UserProfileViewController

@synthesize mapView;
@synthesize requestQueue;
@synthesize twitterimg;
@synthesize profileScroll;
@synthesize myPageControl;
@synthesize folwstr;
@synthesize followingstr;
@synthesize profileservice;
@synthesize followingImageser;
@synthesize imagelikeSer;
@synthesize yesFromImageViewInproifileview;


BOOL regionWillChangeAnimatedCalled;
BOOL regionChangedBecauseAnnotationSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              UITextAttributeTextColor : [UIColor blackColor]
                                                              } forState:UIControlStateNormal];

    
    [segmentedControl.layer setCornerRadius:5.0];
    
    deleg = MAPDELEGA;
    errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [ScrollerOuter addSubview:view_container];
    ScrollerOuter.contentSize=CGSizeMake(ScrollerOuter.frame.size.width,view_container.frame.size.height);
    profileScroll.contentSize=CGSizeMake(640,profileScroll.frame.size.height);
    ScrollerOuter.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    photoView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    // photoView.hidden=NO;
    profileScroll.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    [profileScroll addSubview:photoView];
    
    bioView=[[UIView alloc] initWithFrame:CGRectMake(330, 0, 290, 130)];
    // bioView.hidden=YES;
    [profileScroll addSubview:bioView];
    
    
    destxt = [[UITextView alloc] initWithFrame:CGRectMake(25, 15, 225, 50)];
    destxt.backgroundColor = [UIColor clearColor];
    destxt.autocorrectionType=NO;
    destxt.spellCheckingType=NO;
    destxt.textAlignment=NSTextAlignmentJustified;
    destxt.editable = NO;
    destxt.scrollEnabled=YES;
    destxt.showsVerticalScrollIndicator=NO;
    destxt.textColor = [UIColor whiteColor];
    destxt.font=[UIFont fontWithName:@"Helvetica"size:14.0];
    [bioView addSubview:destxt];
    
    
    editbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editbtn.frame = CGRectMake(255, 60, 55, 33);
    [editbtn setBackgroundImage:[UIImage imageNamed:@"PencilEdit.png"] forState:UIControlStateNormal];
    [editbtn setBackgroundColor:[UIColor clearColor]];
    [editbtn addTarget:self action:@selector(EDIT) forControlEvents:UIControlEventTouchUpInside];
    [bioView addSubview:editbtn];
    
    donebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [donebtn setTitle:@"Done" forState:UIControlStateNormal];
    [donebtn setBackgroundColor:[UIColor grayColor]];
    donebtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    [donebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    donebtn.hidden = YES;
    [donebtn addTarget:self action:@selector(Done) forControlEvents:UIControlEventTouchUpInside];
    donebtn.frame = CGRectMake(253, 60, 50, 30);
    [bioView addSubview:donebtn];
    
   
     [super viewDidLoad];
 
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setUIDesign];
    });

    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag == 101)
    {
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        myPageControl.currentPage=page;
    }
}



-(void) setUIDesign  {
    
    
   classarr = [[NSMutableArray alloc] init];
    

    locationController=[[MyCLController alloc] init];
    locationController.delegate=self;
     [locationController.locationManager startUpdatingLocation];
 
    Imgarr=[NSMutableArray array];
    
    [ArtMap_DELEGATE setUserDefault:@"Toggle_tag" setObject:@"102"];
    
    [segmentedControl addTarget:self action:@selector(pickOne:)forControlEvents:UIControlEventValueChanged];
    
    share=[[ShareCustomClass alloc] init];
}

-(void) pickOne:(id)sender{
    
    [mapView removeAnnotations:[mapView annotations]];
    
    UISegmentedControl *segmentedControl1 = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl1.selectedSegmentIndex;
    
    [ArtMap_DELEGATE setUserDefault:@"Toggle_tag" setObject:[NSString stringWithFormat:@"%ld",(long)selectedSegment]];
    if (selectedSegment == 0) {
       
        [self setUploadBoolVar];
           [self performSelectorInBackground:@selector(ProfileViewService) withObject:nil];

    }
    else if (selectedSegment == 1){
      
        [self  setInteractedBoolVar];
        [self performSelectorInBackground:@selector(likedImageService) withObject:nil];
    }
    else
    {
      
        [self setFollowingBoolVar];
        [self performSelectorInBackground:@selector(follwingImageService) withObject:nil];
       
    }
    
}

-(void) viewWillAppear:(BOOL)animated   {
  
    self.navigationController.navigationBarHidden = YES;
    //191113 Lingam - Placed here instead of viewwillapear,Each time loading before
    appdel=ArtMap_DELEGATE;
    [self setMapviewBasedOnfilter];
    [super viewWillAppear:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
        if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
        {
           // RHViewControllerDown();
        }
}
-(void) setMapviewBasedOnfilter {
 
    if (appdel.isImageLocate==YES)  {
        
        yesFromImageViewInproifileview=YES;
        [self setmapRegionFromImageView];
    }
    

    NSString *activeORnot=[ArtMap_DELEGATE getUserDefault:ArtMapUserActive];
    
    if ([activeORnot isEqualToString:@"0"])     {
        
        [self settingsFunction];
    }
    else    {
       
      [mapView removeAnnotations:[mapView annotations]];
        yesFromImageViewInproifileview=NO;
        
        [self pickOne:segmentedControl];
        
        [self setprofilePicture];
    }

    
}

-(void) fromBacKButtonFromImageVIew
{
    if (appdel.isImageLocate==YES)  {
        
        [self setmapRegionFromImageView];
        
    }
    else  {
        
        [locationController.locationManager startUpdatingLocation];
    }
}



-(void) viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO];
    [super viewDidDisappear:YES];
}


-(void) setmapRegionFromImageView   {
    
   
    double latiValz=[[ArtMap_DELEGATE getUserDefault:@"Image_latitude"] doubleValue];
    double longValz=[[ArtMap_DELEGATE getUserDefault:@"Image_longitude"] doubleValue];
    
    UserLocation=CLLocationCoordinate2DMake(latiValz, longValz);
    region = MKCoordinateRegionMakeWithDistance(UserLocation, 16093.4400f, 16093.4400f);
    [mapView setRegion:region animated:YES];
    
    appdel.isImageLocate=NO;
}


-(void) setprofilePicture   {
    
    NSString *fbstr = [ArtMap_DELEGATE getUserDefault:ArtMapFBType];
    if(fbstr)   {
    }
    
    NSString *imgstr = [ArtMap_DELEGATE getUserDefault:ArtMapActionType];
    
  
    
    if (imgstr)  {
        
        // twitter pictures 
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"profileimage.png"];
        
       NSData *imgdata = [[NSData alloc] initWithContentsOfFile:filePath];
        UIImage *img = [UIImage imageWithData:imgdata];
        
        UIImageView *twit = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 130, 130)];
        twit.image = img;
        [photoView addSubview:twit];
    }

    
}

-(IBAction) shareMethod {
    
    [ArtMap_DELEGATE Setscreenshot:[self captureView:self.view] forkey:ArtMapScreenShot];
    [ArtMap_DELEGATE  setUserDefault:@"screenShotName" setObject:@"Image Title"];
    [ArtMap_DELEGATE  setUserDefault:@"Share_Location" setObject:@"profile"];
    [ArtMap_DELEGATE  setUserDefault:@"Share_DialogueName" setObject:userNameLabel.text];
    
    
    [self presentViewController:[share ShareTapped] animated:YES completion:^{
        [share ShareTapped].view.superview.bounds = CGRectMake(0, 0, 250, 250);}];
}

- (UIImage *)captureView:(UIView *)view
{
  
    CGRect screenRect = self.view.bounds;
     UIGraphicsBeginImageContextWithOptions(screenRect.size, 1, 0.0f);
//    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //[[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [self.view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    return newImage;
}

-(IBAction)settingsAction:(id)sender
{
    [self settingsFunction];
}
-(void) settingsFunction
{
    [requestQueue cancelAllOperations];
//    [ASINetworkQueue  cancelPreviousPerformRequestsWithTarget:self];
//    [AFHTTPClient cancelPreviousPerformRequestsWithTarget:self];
//    [AFHTTPRequestOperation cancelPreviousPerformRequestsWithTarget:self];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    SettingsViewController *optionObj =[storyBoard  instantiateViewControllerWithIdentifier:@"settings"];
   [self.navigationController pushViewController:optionObj animated:YES];
    
}

#pragma mark - action method calls 

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *)sender direction];
    
    switch (direction)  {
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

 -(void) bioFun  {
     
     //left swipe 
     
     CGRect frame;
     frame.origin.x = 320;
     frame.origin.y = 0;
     frame.size = self.profileScroll.frame.size;
     [self.profileScroll scrollRectToVisible:frame animated:YES];
     
      myPageControl.currentPage=0;
  }

 -(void) PhotoFun  {
     
     //Right swipe 
     
     CGRect frame;
     frame.origin.x = 0;
     frame.origin.y = 0;
     frame.size = self.profileScroll.frame.size;
     [self.profileScroll scrollRectToVisible:frame animated:YES];
    
      myPageControl.currentPage=1;
 }

-(IBAction) pageChangeFunction  {
    
    CGRect frame;
    frame.origin.x = self.profileScroll.frame.size.width * self.myPageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.profileScroll.frame.size;
    [self.profileScroll scrollRectToVisible:frame animated:YES];
     
}

-(void)pinchTriggered:(UITapGestureRecognizer*)tap   {
    
    //profile function

    scroll.contentOffset =CGPointMake(0, 190);
    [topButton setTitle:@"Profile" forState:UIControlStateNormal];
    topButton.tag=102;
}


-(void)LogOutFunction:(UIButton*)sender {
    
   [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];

    [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
     topButton.frame=(topButton.tag==101)?CGRectMake(277 , 3,32, 30):CGRectMake(240, 5, 72, 28);
    
    if (sender.tag==101)    {
        
       [self shareMethod];
    }
    if (sender.tag==102)   {
        
        //profile button 
        scroll.contentOffset=CGPointMake(0, 0);
        topButton.tag=101;
       
    }
}



-(void) setUploadBoolVar    {
   
    profileservice=YES;
    imagelikeSer=NO;
    followingImageser=NO;
    
}
-(void) setInteractedBoolVar    {
    
    profileservice=NO;
    imagelikeSer=YES;
    followingImageser=NO;
    
}
-(void) setFollowingBoolVar    {
    
    profileservice=NO;
    imagelikeSer=NO;
    followingImageser=YES;
    
}


-(void) ProfileViewService  {
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet == internetIsConnected) {
        
        scroll.contentSize = CGSizeMake(320, 750);
        callWebservice *pro = [[callWebservice alloc] init];
        pro.delegate = self;
        NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        
        [NSThread detachNewThreadSelector:@selector(ProfileView:) toTarget:pro withObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"view_type\":\"\",\"prfl_view_id\":\"\"}",userid] forKey:@"data"]];
    }

   else{
    
       [self showAlertForInternetConnectionDown];
  
   }
}

-(void) showAlertForInternetConnectionDown
{
    UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [noInternetAlert show];
}



#pragma mark - liked image  service call

-(void) likedImageService   {
    
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected) {
        
        callWebservice *likedCommentedObj = [[callWebservice alloc] init];
        likedCommentedObj.delegate = self;
        NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        [likedCommentedObj  commentedLikedImage:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"other_user_id\":\"\"}",userid] forKey:@"data"]];
    }
    
    else{
        
         [self showAlertForInternetConnectionDown];
    }

    
    
}

-(void) follwingImageService    {
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected) {
        
        callWebservice *followingObj = [[callWebservice alloc] init];
        followingObj.delegate = self;
        NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        [followingObj FollowingImageInCurrentProfile:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"other_user_id\":\"\"}",userid] forKey:@"data"]];
    }
    
    else{
        
         [self showAlertForInternetConnectionDown];
    }
}

#pragma mark - scroll view  delegates 

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
 
   
    if (scroll.tag==405)
    {
              if (scrollView.contentOffset.y>200)       {
                  
                 
                 topButton.tag=102;
                   topButton.frame=(topButton.tag==101)?CGRectMake(277 , 3,32, 30):CGRectMake(240, 5, 72, 28);
                 [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
                [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
              }
              else if (scrollView.contentOffset.y<=200)      {
         
                topButton.tag=101;
                topButton.frame=(topButton.tag==101)?CGRectMake(277 , 3,32, 30):CGRectMake(240, 5, 72, 28);
                [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
                [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
              }
    }
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    
    if (scroll.tag==405)  {
    
    if (scrollView.contentOffset.y>200)     {
        
      //  profile succ
       
        topButton.tag=102;
         topButton.frame=(topButton.tag==101)?CGRectMake(277 , 3,32, 30):CGRectMake(240, 5, 72, 28);
        [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
         [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
    }
    if (scrollView.contentOffset.y<=200)     {
     
     
        topButton.tag=101;
        topButton.frame=(topButton.tag==101)?CGRectMake(277 , 3,32, 30):CGRectMake(240, 5, 72, 28);
        [topButton setBackgroundImage:(topButton.tag==101)?[UIImage imageNamed:@"sharenewshare.png"]:[UIImage imageNamed:@"back(1).png"] forState:UIControlStateNormal];
         [topButton setTitle:(topButton.tag==101)?@"":@"profile" forState:UIControlStateNormal];
    }
        
    }
}

#pragma mark - edit functionality 

-(void) EDIT
{
    profileScroll.scrollEnabled=NO;
    destxt.editable = YES;
    destxt.backgroundColor = [UIColor whiteColor];
    destxt.textColor=[UIColor blackColor];
    editbtn.hidden = YES;
    donebtn.hidden = NO;
    
    if([destxt.text isEqualToString:@"Use edit to tell us about yourself."])
    {
        destxt.text=@"";
    }
    [destxt becomeFirstResponder];
    
}
-(void) Done
{
        [progressView setFixedSize:CGSizeMake(150, 150)];
        [progressView setCaption:@"Uploading Please wait..."];
        [progressView setActivity:YES];
        [progressView setBlockTouches:NO];
        [progressView show];
        destxt.backgroundColor = [UIColor blackColor];
        destxt.textColor=[UIColor whiteColor];

    
        [self AddDescription];
        
        profileScroll.scrollEnabled=YES;
        editbtn.hidden = NO;
        donebtn.hidden = YES;
        destxt.editable=NO;
    
    if ([destxt.text length]==0)
    {
        destxt.text = @"Use edit to tell us about yourself.";
    }
    [destxt resignFirstResponder];
 }


-(void) AddDescription  {
    
    
    BOOL internet= [AppDelegate hasConnectivity];
   
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected) {
        
             callWebservice *add = [[callWebservice alloc] init];
        add.delegate = self;
        NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        NSString *text = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE emptystr:destxt.text]];
       // [add AddDescription:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"description\":\"%@\"}",userid,text] forKey:@"data"]];
        
        [NSThread detachNewThreadSelector:@selector(AddDescription:) toTarget:add withObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"description\":\"%@\"}",userid,text] forKey:@"data"]];
    }
    else{
        
        [progressView setCaption:@""];
        [progressView setActivity:NO];
        [progressView update];
        [progressView hideAfter:0.5];
        
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
    }
    
    
    
   
}

-(IBAction)FollowersAction:(UIButton*)sender  {
    
   
    
    if([folwstr intValue] > 0 && [sender tag] == 101)
    {
        
        
        FollowListViewController *follow=[[FollowListViewController alloc] init];
        follow.hidesBottomBarWhenPushed=NO;
        follow.followno=[sender tag];
        follow.userOrFolloUser=@"fromUserProfile";
        [self.navigationController pushViewController:follow animated:YES];
    }
    else if([followingstr intValue] > 0 && [sender tag]== 102)
    {
        
        FollowListViewController *follow=[[FollowListViewController alloc] init];
        follow.hidesBottomBarWhenPushed=NO;
        follow.followno=[sender tag];
        follow.userOrFolloUser=@"fromUserProfile";
        [self.navigationController pushViewController:follow animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
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



#pragma mark - table view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    INAnnotation *pointCheck=(INAnnotation*)annotation;
    
    MKAnnotationView *annotationView =[mapview dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(annotationView==nil)
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    annotationView.tag = pointCheck.tag;
    annotationView.canShowCallout = YES;
   
    
    if(pointCheck.tag  != 1000)
    {
        
        if(pointCheck.tag > 0)
        {
            annotationView.image = [[Imgarr objectAtIndex:pointCheck.tag] objectForKey:@"imageData"];
        }
    }
    else{
        if(isUpload)
        {
            annotationView.image = [UIImage imageNamed:@"Pin.png"];
        }
    }
    
   
   
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(writeSomething:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag =  pointCheck.tag;//[pointCheck.pointtag intValue];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    annotationView.rightCalloutAccessoryView = rightButton;
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;
    return annotationView;
    
}

-(void) writeSomething:(UIButton*)sender    {
    
    
     NSMutableArray *filterArray = [[NSMutableArray alloc] init];

    [requestQueue cancelAllOperations];
    [ASINetworkQueue  cancelPreviousPerformRequestsWithTarget:self];
    [AFHTTPClient cancelPreviousPerformRequestsWithTarget:self];
    [AFHTTPRequestOperation cancelPreviousPerformRequestsWithTarget:self];
      dispatch_async(dispatch_get_main_queue(), ^(void){

          
          
    for (ImageSortingOrder *array in  sortingorder )
    {
        float thefloat = array.distance;
        int roundedup = ceilf(thefloat);
        int value = roundedup/1609.34;
        if(value <= 1)
        {
           
            [filterArray addObject:array];
        }
    }
                    
      });

    
       
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    ImageViewController *imageobj =[storyBoard  instantiateViewControllerWithIdentifier:@"imageobj"];
       imageobj.IMGArray = filterArray;
       
       UIImage *smallImage=[[Imgarr objectAtIndex:sender.tag] objectForKey:@"imageData"];
       imageobj.imageview=smallImage;
       
       NSURL *largeimageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/large/%@",IMG_BASE_URL,[[Imgarr objectAtIndex:sender.tag] objectForKey:@"image_name"]]];
       
       imageobj.uploadedImageUrl=largeimageUrl;
       imageobj.titlestr = [[Imgarr objectAtIndex:sender.tag] objectForKey:@"image_title"];
       
       NSString *imageIdVal = [[Imgarr objectAtIndex:sender.tag] objectForKey:@"image_id"];
       
       [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:imageIdVal];
       [self.navigationController pushViewController:imageobj animated:YES];

       
    
}


#pragma mark - MApView Delegate

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
    
    regionWillChangeAnimatedCalled = NO;
    regionChangedBecauseAnnotationSelected = NO;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    regionChangedBecauseAnnotationSelected = regionWillChangeAnimatedCalled;
    
    [self cancelRequest];
    
    if(view.tag != 1000)
    {
        if([Imgarr count]> 0)
        {
           view.image = [[Imgarr objectAtIndex:view.tag] objectForKey:@"highlightedimage"];
        }
    }
}
- (void)mapView:(MKMapView *)mapView1 didDeselectAnnotationView:(MKAnnotationView *)view
{
    if(view.tag != 1000)
    {
        if([Imgarr count]> 0)
        {
            view.image = [[Imgarr objectAtIndex:view.tag] objectForKey:@"imageData"];
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

#pragma mark - webservice response

-(void) didFinishLoading:(ASIHTTPRequest*)request
{
    
    if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"profileview"])
    {
        NSDictionary *resdict = [[request responseString] JSONValue];
        
       
      
        NSInteger StatusVariable=[[resdict objectForKey:@"status"] integerValue];
        
        if (StatusVariable==1)
        {
            [self downloadImg:[[request responseString] JSONValue]];
            id checkfollwingcount=[[resdict objectForKey:@"info"] objectForKey:@"follow"];
            
            
            if ([checkfollwingcount isKindOfClass:[NSArray class]])
            {
                NSArray *follwingCount = [[resdict objectForKey:@"info"] objectForKey:@"follow"];
                
                for (NSDictionary *dicttt in follwingCount)
                {
                    followingstr = [NSString stringWithFormat:@"%@",[dicttt objectForKey:@"count"]];
                    folwgcntlbl.text = followingstr;
                }
            }
            else
            {
                folwgcntlbl.text =@"0";
            }
            
           
            id checkfollowercount=[[resdict objectForKey:@"info"] objectForKey:@"follower"];
            
            if ([checkfollowercount isKindOfClass:[NSArray class]])
            {
                NSArray *follwerCount = [[resdict objectForKey:@"info"] objectForKey:@"follower"];
                
                
                for (NSDictionary *dicty in follwerCount)
                {
                    folwstr = [NSString stringWithFormat:@"%@",[dicty objectForKey:@"count"]];
                    follwCountlbl.text = folwstr;
                }
            }
            else
            {
                follwCountlbl.text =@"0";
            }
           
            
            NSArray *usrarr = [[resdict objectForKey:@"info"] objectForKey:@"usr"];
            
            for (NSDictionary *dic in usrarr)
            {
                NSString *usrtxt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
                NSString *descriptionTxt = [NSString stringWithFormat:@"%@",[dic objectForKey:@"description"]];
                userNameLabel.text = usrtxt;
                
                if ([descriptionTxt isEqualToString:@"120 Character Biography of the user will be here.These will be uploaded by the user when he/ she registers."])
                {
                    descriptionTxt=@"";
                }
                
                if (descriptionTxt.length>0)
                {
                    destxt.text=descriptionTxt;
                }
                else
                {
                    destxt.text = @"Use edit to tell us about yourself.";
                }
                
                NSString *myStr=[NSString stringWithFormat:@"%@%@",ImagebaseUrl,[dic objectForKey:@"image_path"]];
                
                NSData *imgdata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:myStr] ];
                UIImage *img = [UIImage imageWithData:imgdata];
                
                UIImageView *twit = [[UIImageView alloc] initWithFrame:CGRectMake(95, 5, 130, 130)];
                twit.image = img;
                [photoView addSubview:twit];
            }
            
            NSArray *resarray;
            
            if (profileservice)
            {
                if ([[[resdict objectForKey:@"info"] objectForKey:@"image_res"] isKindOfClass:[NSArray class]])
                {
                    resarray = [[resdict objectForKey:@"info"] objectForKey:@"image_res"];
                }
                else
                { 
                picCountlbl.text = @"0";
                    
                }
                
            }
            if (imagelikeSer)
            {
                if ([[[resdict objectForKey:@"info"] objectForKey:@"like_comment_images"] isKindOfClass:[NSArray class]])
                {
                     resarray = [[resdict objectForKey:@"info"] objectForKey:@"like_comment_images"];
                }
                else{
                      picCountlbl.text = @"0";
                }
                
               
              
            }
            
            if (followingImageser)
            {
                
                if ([[[resdict objectForKey:@"info"] objectForKey:@"following_images"] isKindOfClass:[NSArray class]])
                {
                   resarray = [[resdict objectForKey:@"info"] objectForKey:@"following_images"]; 
                    
                }
                else{
                      picCountlbl.text = @"0";
                }               
                
            }
            
            [classarr removeAllObjects];
        
        for(NSDictionary *dic in resarray)
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
               
                
                [classarr addObject:sort];
            }
            
                   
            NSSortDescriptor *sortdest = [[NSSortDescriptor alloc] initWithKey:@"totalsize" ascending:YES];
            sortingorder = [[NSArray alloc] initWithArray:[classarr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortdest]]];
           
            
            [progressView setCaption:@"profile view details success ."];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.5];
            
        }
        else
        {
            [progressView setCaption:@""];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.5];
            
            
            
        }
    }
   
    else if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"upload"])
    {
    
     
      NSDictionary *tempdic=[[request responseString] JSONValue];
      NSInteger statusVar=[[tempdic objectForKey:@"status"] integerValue];
     
       
        if (statusVar==1)   {
            
            [progressView setCaption:@"Uploaded Successfully.."];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.5];
            
            //*-------Custom Progress View---------
            [progressView setFixedSize:CGSizeMake(150, 150)];
            [progressView setCaption:@"Loading Please wait..."];
            [progressView setActivity:YES];
            [progressView setBlockTouches:NO];
            [progressView show];
            
            profileservice=YES;
            [self performSelector:@selector(ProfileViewService) withObject:nil afterDelay:0.5];
            isUpload=NO;
        }
        
        else   {
            
            [progressView setCaption:@""];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.5];
            isUpload=NO;
            
            
            
        }
    }
   
    
    
    else if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"adddescription"])  {
        
        NSDictionary *rexdict=[[request responseString] JSONValue];
        NSInteger Statusval=[[rexdict objectForKey:@"status"] integerValue];
        
        if (Statusval==1)
        {
            [progressView setCaption:@"Description added successfully"];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.5];
        }
       else {
            [progressView setCaption:@""];
            [progressView setActivity:NO];
            [progressView update];
            [progressView hideAfter:0.5];
        }
    }
    
}



-(void) didFailWithError:(ASIHTTPRequest*)request
{
   
    
    [progressView setCaption:@""];
    [progressView setActivity:NO];
    [progressView update];
    [progressView hideAfter:0.5];
    
    NSString *errorString=[(NSError*)[request error] localizedDescription];
    
    UIAlertView *ErrorAlert=[[UIAlertView alloc] initWithTitle:@"Error Occured" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [ErrorAlert show];
}

#pragma mark - download image function 

-(void) downloadImg:(NSDictionary*)responseDict
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
     imagedictionary = [[NSDictionary alloc] initWithDictionary:responseDict];
    
    if ([imagedictionary allKeys].count >0)
    {
        NSArray *image_res;
        
        if (profileservice==YES)
        {
           
            
            id isCheck = [[imagedictionary objectForKey:@"info"] objectForKey:@"image_res"];
            image_res = nil;
            
            if ([isCheck isKindOfClass:[NSArray class]])    {
                
                image_res = [[imagedictionary objectForKey:@"info"] objectForKey:@"image_res"];
                picCountlbl.text = [NSString stringWithFormat:@"%d",[image_res count]];
                
            }
            else
            {
                
                return;
            }
            
            [[self requestQueue] cancelAllOperations];
            
            requestQueue = [ASINetworkQueue queue];
            [[self requestQueue] setDelegate:self];
            [requestQueue setRequestDidFinishSelector:@selector(Finished:)];
            [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
            [requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
            [imgUrl removeAllObjects];
            [Imgarr removeAllObjects];
            
            for (NSDictionary *dictVal in image_res)    {
               
                NSString *urlStr = [NSString stringWithFormat:@"%@/%@",IMG_BASE_URL,[dictVal objectForKey:@"image_path"]];
                
                NSString* escapedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:
                                              NSASCIIStringEncoding];
              
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
                [request setUserInfo:[NSDictionary dictionaryWithObject:dictVal forKey:@"data"]];
                [request setDidFinishSelector:@selector(Finished:)];
                [[self requestQueue] addOperation:request];
            }
            
            
            if (image_res)
                [[self requestQueue] go];
            
            
        }
        
        if (imagelikeSer==YES)
        {
            
            
            
            id isCheck = [[imagedictionary objectForKey:@"info"] objectForKey:@"like_comment_images"];
            image_res = nil;
            
            if ([isCheck isKindOfClass:[NSArray class]])    {
                
                image_res = [[imagedictionary objectForKey:@"info"] objectForKey:@"like_comment_images"];
                picCountlbl.text = [NSString stringWithFormat:@"%d",[image_res count]];
                
            }
            else    {
                
                return;
            }
            
            [[self requestQueue] cancelAllOperations];
            
            requestQueue = [ASINetworkQueue queue];
            [[self requestQueue] setDelegate:self];
            [requestQueue setRequestDidFinishSelector:@selector(Finished:)];
            [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
            [requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
            [imgUrl removeAllObjects];
            [Imgarr removeAllObjects];
            
            for (NSDictionary *dictVal in image_res)    {
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/%@",IMG_BASE_URL,[dictVal objectForKey:@"image_path"]];
                
                NSString* escapedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:
                                              NSASCIIStringEncoding];
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
                [request setUserInfo:[NSDictionary dictionaryWithObject:dictVal forKey:@"data"]];
                [request setDidFinishSelector:@selector(Finished:)];
                [[self requestQueue] addOperation:request];
            }
            
            
            if (image_res)
                [[self requestQueue] go];
            
            
        }
        
        if (followingImageser==YES)
        {
           
            
            id isCheck = [[imagedictionary objectForKey:@"info"] objectForKey:@"following_images"];
            image_res = nil;
            
            if ([isCheck isKindOfClass:[NSArray class]])    {
                
                image_res = [[imagedictionary objectForKey:@"info"] objectForKey:@"following_images"];
                picCountlbl.text = [NSString stringWithFormat:@"%d",[image_res count]];
                
            }
            else    {
                
                return;
            }
            
            [[self requestQueue] cancelAllOperations];
            
            requestQueue = [ASINetworkQueue queue];
            [[self requestQueue] setDelegate:self];
            [requestQueue setRequestDidFinishSelector:@selector(Finished:)];
            [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
            [requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
            [imgUrl removeAllObjects];
            [Imgarr removeAllObjects];
            
            for (NSDictionary *dictVal in image_res)    {
                
                NSString *urlStr = [NSString stringWithFormat:@"%@/%@",IMG_BASE_URL,[dictVal objectForKey:@"image_path"]];
                
                NSString* escapedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:
                                              NSASCIIStringEncoding];
               
                
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
                [request setUserInfo:[NSDictionary dictionaryWithObject:dictVal forKey:@"data"]];
                [request setDidFinishSelector:@selector(Finished:)];
                [[self requestQueue] addOperation:request];
            }
            
            
            if (image_res)
                [[self requestQueue] go];
            
            
        }
    }
}

- (void)Finished:(ASIHTTPRequest *)request
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[request userInfo] objectForKey:@"data"] copyItems:YES];
   
 
    
    @autoreleasepool {
        
        UIImage *orgImg = [[UIImage alloc] initWithData:[request responseData]];
        
        
        
        NSString *cmntstr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comments"]];
        NSString *likstr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"likes"]];
        int Totalsize = [cmntstr intValue] * 10 + [likstr intValue] * 2 + 130;
        
        UIImage *resizeImg = [UIImage imageWithImage:orgImg  scaledToWidth:Totalsize alpha:0.4f];
       
        UIImage *resizeImg2 = [UIImage imageWithImage:orgImg  scaledToWidth:Totalsize alpha:1.0f];
        
        [dict setValue:resizeImg forKey:@"imageData"];
        [dict setValue:resizeImg2 forKey:@"highlightedimage"];
        [dict setValue:orgImg forKey:@"OriginalImage"];
        
        [Imgarr addObject:dict];
        
        // You could release the queue here if you wanted
        if ([[self requestQueue] requestsCount] == 0)
        {
            
//            [progressView setCaption:@"Updated.."];
//            [progressView setActivity:NO];
//            [progressView update];
//            [progressView hideAfter:0.5];
            
           // CLLocationCoordinate2D curentLoc;
           
            //
            region = MKCoordinateRegionMakeWithDistance(UserLocation,  16093.44f,  16093.44f);
            
        }
    }
   
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    // You could release the queue here if you wanted
    if ([[self requestQueue] requestsCount] == 0) {
        
        
    }
    
    //... Handle failure
   
}
- (void)queueFinished:(ASINetworkQueue *)queue
{
    // You could release the queue here if you wanted
    if ([[self requestQueue] requestsCount] == 0) {
        
    }
   
 
    
    
    [Imgarr sortUsingComparator:^NSComparisonResult(id a,id b){
        NSDictionary *dict1=(NSDictionary*)a;
        NSDictionary *dict2=(NSDictionary*)b;
        
        if([(UIImage*)[dict1 valueForKey:@"imageData"] size].width>[(UIImage*)[dict2 valueForKey:@"imageData"] size].width) return NSOrderedAscending;
        else if([(UIImage*)[dict1 valueForKey:@"imageData"] size].width<[(UIImage*)[dict2 valueForKey:@"imageData"] size].width) return NSOrderedDescending;
        
        return NSOrderedSame;
        
    }];
    
  
    
    if (yesFromImageViewInproifileview==NO)
    {
        [self setregionBasedOnResponse];
    }
    
    int i =0;
    
    if ([self.mapView.annotations count] > 0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }

    
    
    NSMutableArray *annotations=[[NSMutableArray alloc] init];
  
    for (NSDictionary *dict in Imgarr)
    {
        CLLocationCoordinate2D reg;
        reg.longitude = [[dict objectForKey:@"longitude"] floatValue];
        reg.latitude = [[dict objectForKey:@"latitude"] floatValue];
        
        @autoreleasepool {
            INAnnotation*   a1=[[INAnnotation alloc] initWithLocation:reg];
            a1.url=@"http://www.definingterms.com/wp-content/uploads/2008/03/circle.png";
            a1.title=[dict objectForKey:@"image_title"];
            a1.tag=i;
            [annotations addObject:a1];
        }
        i++;
    }
    [mapView addAnnotations:annotations];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

}

-(void) setregionBasedOnResponse
{
    if (Imgarr .count>0)
    {
        NSString *setMapLatitude=[[Imgarr objectAtIndex:0] objectForKey:@"latitude"];
        NSString *setMapLongitude=[[Imgarr objectAtIndex:0] objectForKey:@"longitude"];
        
        double latiValz=[setMapLatitude doubleValue];
        double longValz=[setMapLongitude doubleValue];
        
        UserLocation=CLLocationCoordinate2DMake(latiValz, longValz);
        region = MKCoordinateRegionMakeWithDistance(UserLocation, 16093.4400f, 16093.4400f);
        [mapView setRegion:region animated:YES];
    }
    
    
    
    
}

//-------------------------18/01/14--------------------------------------
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0f);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//---------------------------------------------------------------------

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    destxt.editable = NO;
    [destxt resignFirstResponder];
}
-(UILabel*) customLabel:(NSString*)str initFrame:(CGRect)frame
{
	UILabel *customLabel = [[UILabel alloc] initWithFrame:frame];
	customLabel.adjustsFontSizeToFitWidth = YES;
    customLabel.text = str;
    customLabel.backgroundColor=[UIColor clearColor];
    customLabel.font=[UIFont fontWithName:@"Helvetica"size:13.0];
    customLabel.textColor=[UIColor orangeColor];
    
	return customLabel;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == titletxt)
        [titletxt resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetAll
{
    requestQueue=nil;
    [Imgarr removeAllObjects];
    sortingorder=nil;
    imagedictionary=nil;
    [imgUrl removeAllObjects];
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
    
    
    // MKAnnotationView *ann=(MKAnnotationView*)[views objectAtIndex:0];
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
    UIGraphicsBeginImageContext(ann.image.size);
    [ann.image drawAtPoint:CGPointZero];
    
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


@end
