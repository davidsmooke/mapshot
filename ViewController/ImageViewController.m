//
//  ImageViewController.m
//  ArtMap
//
//  Created by sathish kumar on 10/1/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import "ImageViewController.h"
#import "JSON.h"
#import "AsyncImageView.h"

#import "MapViewController.h"
#import "ASIHTTPRequest.h"
#import "UIImage+Size.h"
#import "UIImage+FixOrientation.h"
#import "UIImageView+AFNetworking.h"
#import "SettingsViewController.h"
#import "SVProgressHUD.h"
#import "ImageZoomController.h"

@interface ImageViewController (){
    
    NSMutableArray *commentsarr;
    NSDictionary *commentsdic;
    NSDictionary *likecounts;
    NSDictionary *imageContent;
    NSDictionary *profileimagedic;
    
    NSString *usertxt;
    NSString *liketxt;
    NSString *datestr;
    NSString *commentid;
   
    UITapGestureRecognizer *pinchresult,*pinchresultZoom;
    UITextView * descrptionTextView ;
    UIButton *flagButton;
    UIButton *likeButton;
    UIButton *countryButton;
   
}

@end

@implementation ImageViewController

@synthesize imageview;
@synthesize titlestr;
@synthesize IMGArray;
@synthesize typestr;
@synthesize isFlagButtonPresent;
@synthesize isDeleteButtonPresent;
@synthesize uploadedImageView;

@synthesize uploadedImageUrl;
@synthesize currentUserLIKedStr;


int arrayindex =0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}
- (void)viewDidLoad 
{
    
    progressView = [[ATMHud alloc] initWithDelegate:self];
	[[ArtMap_DELEGATE window] addSubview:progressView.view];
    
    errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
 
    [self setUIView];
    
    [super viewDidLoad];
    
}

-(void) setUIView  {
   
   
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    [ArtMap_DELEGATE  setUserDefault:@"Share_Location" setObject:@""];
    
    share=[[ShareCustomClass alloc] init];
    
    photoCommentScrollView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    photoCommentScrollView.scrollEnabled = YES;
    photoCommentScrollView.minimumZoomScale=1.0;
    photoCommentScrollView.maximumZoomScale=4.0;
    photoCommentScrollView.delegate=self;
   
    [self.view addSubview:photoCommentScrollView];
    
    uploadedImageView = [[UIImageView alloc] init];
    uploadedImageView.contentMode=UIViewContentModeScaleAspectFit;
    uploadedImageView.frame=CGRectMake(0,50 , 320, 237);
    uploadedImageView.userInteractionEnabled = YES;
    
    shareImageView=[[UIImageView alloc] init];
    shareImageView.frame=CGRectMake(0,0, 320,320);
    
    zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zoomButton.frame = CGRectMake(uploadedImageView.frame.origin.x+uploadedImageView.frame.size.width-70, 0, 30, 30);
    
    [uploadedImageView addSubview:zoomButton];

    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame=CGRectMake(0, 0, 40, 40);
    activityIndicator.center=uploadedImageView.center;
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    
    [uploadedImageView addSubview:activityIndicator];
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected)  {
        
        [uploadedImageView setImageWithURLRequest:[NSURLRequest requestWithURL:uploadedImageUrl] placeholderImage:imageview success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             [activityIndicator setHidden:YES];
             [activityIndicator stopAnimating];
             
             uploadedImageView.image = image;
             
             passImage=image;
             shareImageView.image=image;
         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             //nslog(@"fails");
             [activityIndicator setHidden:YES];
             [activityIndicator stopAnimating];
         }];
    }
    else{
        
        
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
        
    }
    
    
    // listen for right swipe
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [uploadedImageView addGestureRecognizer:swipeGesture];
    
    // listen for left swipe
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [uploadedImageView addGestureRecognizer:swipeGesture];
    
    
    [photoCommentScrollView addSubview:uploadedImageView];
    
    //------------- imageZoom --------------------------------------------------------
    


    
    pinchresult = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(pinchTriggered:)];
    pinchresult.numberOfTapsRequired=2;
    
    [uploadedImageView addGestureRecognizer:pinchresult] ;
    
    
    
    //--------------------------------------------------------------------------------
    
  
    
    
    userNamelabel.text = titlestr;
    titlestring=titlestr;

    
    uploadedUserNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadedUserNameBtn.frame = CGRectMake(0, 25, 125, 20);
    uploadedUserNameBtn.backgroundColor = [UIColor clearColor];
    [uploadedUserNameBtn addTarget:self action:@selector(NameOfUser) forControlEvents:UIControlEventTouchUpInside];
    [[uploadedUserNameBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [uploadedUserNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [photoCommentScrollView addSubview:uploadedUserNameBtn];
    
    countryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    countryButton.frame = CGRectMake(125, 25, 150, 20);
    countryButton.backgroundColor = [UIColor clearColor];
    [countryButton addTarget:self action:@selector(callMapLocation) forControlEvents:UIControlEventTouchUpInside];
    [[countryButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:13.0]];
    [countryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [photoCommentScrollView addSubview:countryButton];
    
    FlagDetailLabel=[[UILabel alloc] init];
    FlagDetailLabel.frame=CGRectMake(0, 217, 320,20 );
    FlagDetailLabel.hidden=YES;
    FlagDetailLabel.textAlignment=NSTextAlignmentCenter;
    FlagDetailLabel.backgroundColor=[UIColor blackColor];
    FlagDetailLabel.textColor=[UIColor orangeColor];
    FlagDetailLabel.text=@"You have already flagged this image";
    FlagDetailLabel.font=[UIFont fontWithName:@"Helvetica" size:11.0];
  
    [uploadedImageView addSubview:FlagDetailLabel];
    
    
    
    
    UIImageView *bottomView=[[UIImageView alloc] init];
    bottomView.frame=CGRectMake(0, 298, 320,30);
    [bottomView setImage:[UIImage imageNamed:@"likeComentdatebackground.png"]];
  
    [photoCommentScrollView addSubview:bottomView];
    
    imageLikeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,80, 30)];
    imageLikeLbl.backgroundColor= [UIColor clearColor];
    imageLikeLbl.textColor = [UIColor whiteColor];
    imageLikeLbl.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [bottomView addSubview:imageLikeLbl];
    
    mnthlbl = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 110, 30)];
    mnthlbl.textColor  = [UIColor whiteColor];
    mnthlbl.backgroundColor = [UIColor clearColor];
    mnthlbl.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    [bottomView addSubview:mnthlbl];
    
    commentsPanelView = [[UIView alloc] initWithFrame:CGRectMake(0,330,320, 30)];
    commentsPanelView.backgroundColor = [UIColor clearColor];
    
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //  likeButton.tag=101;
    [likeButton setTitle:@"Like" forState:UIControlStateNormal];
    likeButton.frame = CGRectMake(155, 3,50, 25);
    likeButton.backgroundColor=[UIColor grayColor];
    // [likeButton setTitle:@"Like" forState:UIControlStateNormal];
    [[likeButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [likeButton addTarget:self action:@selector(likeFunction:) forControlEvents:UIControlEventTouchUpInside];
    [commentsPanelView addSubview:likeButton];
    
    UILabel *commentTextlabel=[[UILabel alloc] init];
    commentTextlabel.frame=CGRectMake(50, 3, 65, 25);
    commentTextlabel.backgroundColor=[UIColor clearColor];
    commentTextlabel.text=@"Comments";
    commentTextlabel.font=[UIFont fontWithName:@"Helvetica" size:12.0];
    commentTextlabel.textColor=[UIColor whiteColor];
    [commentsPanelView addSubview:commentTextlabel];
    
    
    UIButton *addCommentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addCommentsBtn.frame = CGRectMake(210, 3,50, 25);
    addCommentsBtn.backgroundColor=[UIColor grayColor];
    [addCommentsBtn setTitle:@"Comment" forState:UIControlStateNormal];
    [[addCommentsBtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [addCommentsBtn addTarget:self action:@selector(addcomments) forControlEvents:UIControlEventTouchUpInside];
    [commentsPanelView addSubview:addCommentsBtn];
    
    
    moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(265, 3, 50, 25);
    moreButton.tag=202;
    moreButton.backgroundColor=[UIColor grayColor];
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [[moreButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    moreButton.tag=222;
    [moreButton addTarget:self action:@selector(moreFunction:) forControlEvents:UIControlEventTouchUpInside];
    [commentsPanelView addSubview:moreButton];
    
    [photoCommentScrollView addSubview:commentsPanelView];
    
    popUpview=[[UIView alloc] init];
    popUpview.frame=CGRectMake(210, 190, 100, 140);
    popUpview.backgroundColor=[UIColor grayColor];
    popUpview.hidden=YES;
    
    [photoCommentScrollView addSubview:popUpview];
    
    flagButton=[UIButton buttonWithType:UIButtonTypeCustom];
    flagButton.frame=CGRectMake(15,20,70,40);
    [flagButton setTitle:@"Flag" forState:UIControlStateNormal];
    [flagButton setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    flagButton.tag=333;
    [flagButton addTarget:self action:@selector(flagFunction:) forControlEvents:UIControlEventTouchUpInside];
   
    [popUpview addSubview:flagButton];
    
    deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deletebtn.frame = CGRectMake(15, 70, 70, 40);
    deletebtn.hidden=YES;
    [deletebtn setTitle:@"Delete" forState:UIControlStateNormal];
    [deletebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deletebtn addTarget:self action:@selector(deleteImageFunction) forControlEvents:UIControlEventTouchUpInside];
  
    [popUpview addSubview:deletebtn];
    [popUpview bringSubviewToFront:deletebtn];
    
    


}

-(void) setImageWithUrl
{
    
}







-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
   
    appdel=ArtMap_DELEGATE;
   // [appdel.tabbarObject  ShowNewTabBar];
    
    
    if(appdel.isFromSearchView==YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
   
    
    int index = 0;
    NSString *imageIdVal = [ArtMap_DELEGATE getUserDefault:ArtMap_detail];
    
    for (ImageSortingOrder *cls in IMGArray)
    {
        if(cls.imageid == [imageIdVal intValue])  {
            arrayindex = index;
            userIdstr=[NSString stringWithFormat:@"%d",cls.userid];
            imageIdStr=[NSString stringWithFormat:@"%d",cls.imageid];
        }
        index++;
        
    }
    
    
    [self performSelector:@selector(DetailService:) withObject:nil afterDelay:0.2];
    
    
    // delete image by current user
    
    NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
    
    if ([userid isEqualToString:userIdstr])  {
        // delete button present
        
        deletebtn.hidden=NO;
        isDeleteButtonPresent=YES;
    }
    else{
        // delete button NO
        deletebtn.hidden=YES;
        isDeleteButtonPresent=NO;
    }
    
   
    
    [super viewWillAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
   
        if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
           // RHViewControllerDown();
            //[ArtMap_DELEGATE applicationDidBecomeActive:[UIApplication sharedApplication]];
        }
   
    [super viewDidAppear:animated];
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"addcomments" object:nil];
    [super viewWillDisappear:YES];
}
-(void) viewDidUnload
{
  
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addcomments" object:nil];
}




-(IBAction)shareMethod:(id)sender
{
    //------------------Change 18/01/14 ----------------------------------------
    
    [ArtMap_DELEGATE Setscreenshot:[self captureView:uploadedImageView] forkey:ArtMapScreenShot];
    [ArtMap_DELEGATE  setUserDefault:@"screenShotName" setObject:titlestring];
    
    
    [self presentViewController:[share ShareTapped] animated:YES completion:^{
        [share ShareTapped].view.superview.bounds = CGRectMake(0, 0, 250, 250);}];
    
    //-----------------------------------------------------------------------------
}

- (UIImage *)captureView:(UIView *)view
{
    CGRect screenRect = CGRectMake(0, 0, 320,237);
    UIGraphicsBeginImageContextWithOptions(screenRect.size, 1, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - flag Function

-(void)flagFunction:(UIButton*) sender
{
    ImageSortingOrder *sortorder = (ImageSortingOrder*) [IMGArray objectAtIndex:arrayindex];
    NSString *imageIdVal = [NSString stringWithFormat:@"%d",sortorder.imageid];

    [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:imageIdVal];
    
    flagDescriptionAlert=[[UIAlertView alloc] initWithTitle:@"Flag Descriptions" message:@"please enter details \n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
    flagDescriptionAlert.tag=560;
    if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
    {
        flagDescriptionAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    }

    
    descrptionTextView = [[UITextView alloc] init];
    [descrptionTextView setFrame:CGRectMake(12.0,50, 260.0, 100)];
    descrptionTextView.tag = 40;
    [flagDescriptionAlert addSubview:descrptionTextView];
    [flagDescriptionAlert show];
    [descrptionTextView becomeFirstResponder];
}

-(void) flagWebServiceCall
{
     BOOL internet= [AppDelegate hasConnectivity];
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected) {
    
         
//         [SVProgressHUD showWithStatus:DefaultHudText maskType:SVProgressHUDMaskTypeGradient];
//         callWebservice *webObj=[[callWebservice alloc] init];
//         webObj.delegate=self;
         
         NSString *userIdValy=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
         NSString *imageIdValy=[ArtMap_DELEGATE getUserDefault:ArtMap_detail];
         NSString *DescriptionText=descrptionTextView.text;
         
         
         
         NSDictionary *flagdic=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"image_id\":\"%@\",\"comments\":\"%@\",\"flag_status\":\"1\"}",userIdValy,imageIdValy,DescriptionText] forKey:@"data"];
         
        
         
        // [webObj flagFunctionWebService:flagdic];
         AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ArtMap_Flag_Image]];
         [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
         
         NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ArtMap_Flag_Image parameters:flagdic];
         AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
         //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
         
         [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
          {
             [SVProgressHUD dismiss];
            
           
             if ([operation.response statusCode] == 200)
             {
                 NSInteger statusString=[[responseObject objectForKey:@"status"] integerValue];
                 NSString *messageString=[responseObject objectForKey:@"message"];
                 
                 if (statusString==1)
                 {
                     UIAlertView *messageAlert=[[UIAlertView alloc] initWithTitle:@"Flag Alert" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                     [messageAlert show];
                     
                     
                     isFlagButtonPresent=NO;
                     [self setNoFlagButton];
                 }
                 else if (statusString==0)
                 {
                     isFlagButtonPresent=YES;
                     [self setFlagButton];
                     
                     UIAlertView *messageAlert=[[UIAlertView alloc] initWithTitle:@"Flag Alert" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                     [messageAlert show];
                     
                 }
                 
             }
             else
             {
                 // [self resignKeyboard];
                UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 errAlertView1.message = [responseObject objectForKey:@"message"];
                 [errAlertView1 show];
                 
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD dismiss];
            
             NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
             id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSString *messageString=[json  objectForKey:@"message"];
               UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             errAlertView1.message = messageString;
             [errAlertView1 show];
            }];
         [operation start];

     }
     else{
     
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
     }

}



#pragma mark- profile view or another profile  view 
-(void) NameOfUser
{
    NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
    NSString *secusr = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMapSecondaryuserid]];
    
    if([userid isEqualToString:secusr])
    {
        
//        [appdel.tabbarObject setSelectedIndex:4];
//        [appdel.tabbarObject selectTab:4];
    }
    else
    {
        [self callAnotherProfileView];
    }
}


#pragma mark - view calls 


-(void) callAnotherProfileView
{
    //FollowerViewController *follow = [[FollowerViewController alloc] initWithNibName:@"FollowerViewController" bundle:nil];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    FollowerViewController *follow =[storyBoard  instantiateViewControllerWithIdentifier:@"Followers"];
    follow.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:follow animated:YES];
}

#pragma mark -  alertview delegates 


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==560 && buttonIndex==1)   {
        
        if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
        {
            descrptionTextView.text = [alertView textFieldAtIndex:0].text;
        }
        [self flagWebServiceCall];
    }
    if(alertView.tag == 999 && buttonIndex == 1)    {
       
        [self deleteWebService];
    }
    else if(alertView.tag == 666 && buttonIndex == 0)
    {
        [self afterDeleteGo];
    }
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



-(void ) afterDeleteGo {
   [self.navigationController popToRootViewControllerAnimated:YES];
}

UIButton *tempBtn;

-(void)imageZooming
{
  // titlestring
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    ImageZoomController *imageZoom =[storyBoard  instantiateViewControllerWithIdentifier:@"ImageZoomControllerID"];
    imageZoom.getimageName=titlestring;
   imageZoom.getImage = passImage;
//    crop.delegate=self;
    [self.navigationController pushViewController:imageZoom animated:YES];
}



-(void)pinchTriggered:(UITapGestureRecognizer*)tap   {
  
        
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
    [im setImage:[UIImage imageNamed:@"globe.png"]];
    im.transform = CGAffineTransformScale(im.transform, 0.1, 0.1);
    
    im.center = CGPointMake(160, 180);
    
    
    [self.view addSubview:im];
    
    [UIView animateWithDuration:1.0 animations:^(void){
        
        im.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationCurveEaseOut animations:^(void){
            im.alpha = 0.0;
        } completion:^(BOOL finished) {
            [im removeFromSuperview];
        }];
    }];
    tempBtn = imageLikeBtn;
    
    [self eventHome:tempBtn];
    
}
-(void)eventHome:(UIButton*)sender {
    
  [self performSelector:@selector(GreenButtonLikes:) withObject:sender afterDelay:0.2];
    
 }

-(void) likeFunction :(UIButton*) sender
{
     [SVProgressHUD showWithStatus:DefaultHudText maskType:SVProgressHUDMaskTypeGradient];
     [self performSelector:@selector(GreenButtonLikes:) withObject:sender afterDelay:0.2];
}

-(void) GreenButtonLikes:(id)sender
{
   
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected)  {
    
        if([currentUserLIKedStr intValue] == 0)  {
             
//            callWebservice *likes = [[callWebservice alloc] init];
//            likes.delegate = self;
            
            NSString *imageId = [ArtMap_DELEGATE getUserDefault:ArtMap_detail];
            NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
             
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\",\"current_user_like_status\":\"1\"}",[ArtMap_DELEGATE emptystr:imageId],userid],@"data",@"1",@"islike", nil];
             
             [self performSelector:@selector(GreenLikes:) withObject:dict afterDelay:0.5];
        }
         if([currentUserLIKedStr intValue] == 1) {
      
//             callWebservice *likes = [[callWebservice alloc] init];
//             likes.delegate = self;
             NSString *str = [ArtMap_DELEGATE getUserDefault:ArtMap_detail];
             NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
             
             NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\",\"current_user_like_status\":\"0\"}",[ArtMap_DELEGATE emptystr:str],userid],@"data",@"0",@"islike", nil];
             
             [self performSelector:@selector(GreenLikes:) withObject:dict afterDelay:0.5];
         }

     }
     else{
     
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
         
     }
}
-(void) GreenLikes:(NSDictionary*)Likes
{
  //  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"imagelikes",@"action",[Likes objectForKey:@"islike"],@"islike", nil];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ArtMapImgaeLikes]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ArtMapImgaeLikes parameters:Likes];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         [SVProgressHUD dismiss];
       
        
        
        // NSDictionary *JSON=[ArtMap_DELEGATE convertToJSON:responseObject];
      
        if ([operation.response statusCode] == 200)
        {
//            NSInteger statusString=[[responseObject objectForKey:@"status"] integerValue];
//            NSString *messageString=[responseObject objectForKey:@"message"];
//            
//            NSDictionary *dic = [[request responseString] JSONValue];
            
          //  NSString *statusString=[responseObject objectForKey:@"status"];
            
            currentUserLIKedStr=[responseObject objectForKey:@"current_user_like_status"];
            
            
            if([currentUserLIKedStr intValue] == 0)       {
                
                [likeButton setTitle:@"Like" forState:UIControlStateNormal];
            }
            else if([currentUserLIKedStr intValue] == 1)    {
                
                [likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
            }
            
            int LikeCount=[[responseObject objectForKey:@"likes"] integerValue];
            imageLikeLbl.text = [NSString stringWithFormat:@"%d likes ",LikeCount];
        }
        else
        {
            // [self resignKeyboard];
            UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            errAlertView1.message = [responseObject objectForKey:@"message"];
            [errAlertView1 show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        //NSLog(@"response in options %@",[operation responseString]);
        NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        NSString *messageString=[json  objectForKey:@"message"];
        errAlertView1.message = messageString;
        [errAlertView1 show];
    }];
    [operation start];

}

#pragma mark - swipe functionality

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
 UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *)sender direction];
    
        switch (direction)
        {
                // left
            case UISwipeGestureRecognizerDirectionLeft:
                [self performSelector:@selector(next)];
                break;
                // right
            case UISwipeGestureRecognizerDirectionRight:
                [self performSelector:@selector(previousimage)];
                break;
            case UISwipeGestureRecognizerDirectionDown:
                break;
            case UISwipeGestureRecognizerDirectionUp:
                break;
        }
}

-(void)previousimage   {
    
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected)  {
        
        arrayindex=arrayindex-1;
        
        if (arrayindex==-1) {
            arrayindex=[IMGArray count]-1;
        }
        
        if(arrayindex >=0 && arrayindex < [IMGArray count ])  {
         
            
            ImageSortingOrder *sortorder = (ImageSortingOrder*) [IMGArray objectAtIndex:arrayindex];
           
        //   dispatch_async(dispatch_get_main_queue(), ^{
                
                
                
                NSString *imageidVal=[NSString stringWithFormat:@"%d",sortorder.imageid];
                [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:imageidVal];
                
                NSString *LargeUrl = [NSString stringWithFormat:@"%@/uploads/large/%@",ImagebaseUrl,sortorder.imagename];
                 
                
                NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:LargeUrl]];
               UIImage *img  = [UIImage imageWithData:imagedata];
               
               uploadedImageView.image = img;
               
               [UIView beginAnimations:nil context:nil];
               [UIView setAnimationDelay:0.2f];
               [UIView setAnimationDuration:1.0f];
               [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:uploadedImageView cache:NO];
               
               
               
            //   });
                
                
                titlestring = [NSString stringWithFormat:@"%@",sortorder.imagetitle];
                //nslog(@"titl string while swipe %@",titlestring);
                userNamelabel.text = titlestring;
                
                [UIView commitAnimations];
                
                
            
            
            [self performSelector:@selector(DisplayImages:) withObject:nil afterDelay:0.1];
        }

    }
    else{
        
        
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
    }
}
-(void)next {
    
     BOOL internet= [AppDelegate hasConnectivity];
     BOOL internetIsConnected=1;
    
     if (internet ==internetIsConnected)  {
     
         arrayindex = arrayindex+1;
         if (arrayindex==[IMGArray count]) {
             arrayindex=0;
         }
         
         if (arrayindex<[IMGArray count] && arrayindex >=0) {
             
         ImageSortingOrder *sortorder = (ImageSortingOrder*) [IMGArray objectAtIndex:arrayindex];
             
            // dispatch_async(dispatch_get_main_queue(), ^{
                 
               
                 NSString *imageidVal=[NSString stringWithFormat:@"%d",sortorder.imageid];
                 [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:imageidVal];
                 
                 NSString *imgstr = [NSString stringWithFormat:@"%@/uploads/large/%@",ImagebaseUrl,sortorder.imagename];
                 NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgstr]];
                 UIImage *img = [UIImage imageWithData:imagedata];
                 
                 uploadedImageView.image = img;
                 
                 [UIView beginAnimations:nil context:nil];
                 [UIView setAnimationDuration:1.0f];
                 [UIView setAnimationDelay:0.3f];
                 [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:uploadedImageView cache:NO ];
                
           //  });

             
             titlestring = [NSString stringWithFormat:@"%@",sortorder.imagetitle];
             userNamelabel.text = titlestring;
             
             [UIView commitAnimations];
             
            [self performSelector:@selector(DisplayImages:) withObject:nil afterDelay:0.1];
         }

     }
     else{
     
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
         
     }
}

-(void) DisplayImages:(id)sender
{
           
         callWebservice *detail = [[callWebservice alloc] init];
         detail.delegate = self;
         
         ImageSortingOrder *cls = (ImageSortingOrder*)[IMGArray objectAtIndex:arrayindex];
         NSString *imageIdVal = [NSString stringWithFormat:@"%d",cls.imageid];
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         NSString *arrayIndex = [NSString stringWithFormat:@"%d",[sender tag]];
         
         NSDictionary *dictn = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\"}",[ArtMap_DELEGATE emptystr:imageIdVal],[ArtMap_DELEGATE emptystr:userid]],arrayIndex, nil] forKeys:[NSArray arrayWithObjects:@"data",@"index", nil]];
         
         [detail getImageDetails:dictn];
         
}

//-------------------------------------

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return 0;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollV withView:(UIView *)view atScale:(float)scale
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    ImageZoomController *imageZoom =[storyBoard  instantiateViewControllerWithIdentifier:@"ImageZoomControllerID"];
    imageZoom.getimageName=titlestring;
    imageZoom.getImage = passImage;
    //    crop.delegate=self;
    [self.navigationController pushViewController:imageZoom animated:YES];

}



-(void)updatecomments:(NSNotification*)ntn
{
    [self performSelector:@selector(DetailService:) withObject:nil afterDelay:0.6f];
}


-(void) callMapLocation
{
    //nslog(@"callmap location ");
    appdel.isImageLocate=YES;
    appdel=ArtMap_DELEGATE;
    if(self.tabBarController.selectedIndex==1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    else
    {
        [self.tabBarController setSelectedIndex:1];
    }
    
}

    
   
-(IBAction)backoption:(id)sender
{
    
   // self.navigationController.navigationBarHidden=NO;
    appdel=ArtMap_DELEGATE;
    
    [self.navigationController popViewControllerAnimated:YES];

    
//    for (UIViewController *uiview  in self.navigationController.viewControllers)    {
//        
//        //nslog(@"uiview are %@",uiview);
//      
//        if ([uiview isKindOfClass:[MapViewController class]])
//        {
//            appdel.isImageLocate=YES;
//           // [appdel.tabbarObject selectTab:1];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//       else if ([uiview isKindOfClass:[UserProfileViewController class]])
//       {
//            appdel.isImageLocate=YES;
//          //  [appdel.tabbarObject selectTab:4];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//       else if ([uiview isKindOfClass:[FollowerViewController class]])
//       {
//           
//           
//          appdel.isImageLocate=YES;
//          [self.navigationController popViewControllerAnimated:YES];
//        }
//        else if ([uiview isKindOfClass:[HomeViewController class]])
//       {
//        
//           [self.navigationController popToRootViewControllerAnimated:YES];
//       }
//       else 
//       {
//           [self.navigationController popViewControllerAnimated:YES];
//       }
//        
//    }
    
 
}
-(void) individualCommentLike:(id)sender
{
    //*-------Custom Progress View---------*/
  //  [SVProgressHUD showWithStatus:DefaultHudText maskType:SVProgressHUDMaskTypeGradient];
    
    CommentsControl *comCls = [commentsarr objectAtIndex:[sender tag]];
    NSString *commentId = [NSString stringWithFormat:@"%d",comCls.commentid];
    
 
    
    NSString *arrayIndex = [NSString stringWithFormat:@"%d",[sender tag]];
  
    NSString *str = [ArtMap_DELEGATE getUserDefault:ArtMap_detail];
    NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
    
    NSInteger iscom = comCls.iscommentlike;
    
   
    
    callWebservice *like = [[callWebservice alloc] init];
    like.delegate = self;
    
    if(iscom == 0)
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"image_id\":\"%@\",\"comment_id\":\"%@\",\"status\":\"1\"}",[ArtMap_DELEGATE emptystr:userid],[ArtMap_DELEGATE emptystr:str],[ArtMap_DELEGATE emptystr:commentId]],arrayIndex, nil] forKeys:[NSArray arrayWithObjects:@"data",@"index", nil]];
        
        [like GreyLikes:dict];
    }
    if (iscom >0)
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"image_id\":\"%@\",\"comment_id\":\"%@\",\"status\":\"0\"}",[ArtMap_DELEGATE emptystr:userid],[ArtMap_DELEGATE emptystr:str],[ArtMap_DELEGATE emptystr:commentId]],arrayIndex, nil] forKeys:[NSArray arrayWithObjects:@"data",@"index", nil]];
        
        [like GreyLikes:dict];

    }
}

#pragma mark- delete functionality

-(void) deleteImageFunction
{
    UIAlertView *deleteAlert=[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Are you sure?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    deleteAlert.tag=999;
    [deleteAlert show];
}


-(void) deleteWebService {
  
    BOOL internet= [AppDelegate hasConnectivity];
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)
     {
         [SVProgressHUD showWithStatus:DefaultHudText maskType:SVProgressHUDMaskTypeGradient];
         
         callWebservice *delete = [[callWebservice alloc] init];
         delete.delegate = self;
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         
         [delete deleteImage:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\"}",[ArtMap_DELEGATE emptystr:imageIdStr],[ArtMap_DELEGATE emptystr:userid]] forKey:@"data"]];
     }
     else
     {
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
         
         
     }
}

-(void)addcomments
{
    ImageSortingOrder *sortorder = (ImageSortingOrder*) [IMGArray objectAtIndex:arrayindex];
    NSString *imageIdVal = [NSString stringWithFormat:@"%d",sortorder.imageid];
    

    [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:imageIdVal];
  
    AddCommentViewController *add = [[AddCommentViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:add];
    [self presentViewController:nav animated:YES completion:nil];
}




-(void) moreFunction:(UIButton*) sender
{
   
   // dispatch_sync(dispatch_get_main_queue(), ^{
        //Your code goes in here
    
        
        if (sender.tag==222)
        {
            popUpview.hidden=NO;
            
            if (isFlagButtonPresent==YES)
            {
                [self setFlagButton];
            }
            else if (isFlagButtonPresent==NO)
            {
                [self setNoFlagButton];
            }
            
            moreButton.tag=111;
        }
        else if (sender.tag==111)
        {
            popUpview.hidden=YES;
            moreButton.tag=222;
        }
  //  });
}

-(void) DetailService:(id)sender    {
    
     BOOL internet= [AppDelegate hasConnectivity];
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)
     {
         
       //   [SVProgressHUD showWithStatus:DefaultHudText maskType:SVProgressHUDMaskTypeGradient];
         
         callWebservice *detail = [[callWebservice alloc] init];
         detail.delegate = self;
         
         NSString *arrayIndex = [NSString stringWithFormat:@"%d",[sender tag]];
         
         NSString *imageIdVal = [ArtMap_DELEGATE getUserDefault:ArtMap_detail];
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         
         NSDictionary *dictn = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\"}",[ArtMap_DELEGATE emptystr:imageIdVal],[ArtMap_DELEGATE emptystr:userid]],arrayIndex, nil] forKeys:[NSArray arrayWithObjects:@"data",@"index", nil]];
         
         [detail getImageDetails:dictn];
     }
     else{
        
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
     
     }
    
    
    
}




-(void) setFlagButton
{
    flagButton.hidden=NO;
    FlagDetailLabel.hidden=YES;
   
    if (isDeleteButtonPresent==YES)
    {
        popUpview.frame=CGRectMake(210, 190, 100, 140);
        flagButton.frame=CGRectMake(15,20,70,40);
        deletebtn.frame = CGRectMake(15, 70, 70, 40);
        deletebtn.hidden=NO;
    }
    else
    {
        popUpview.frame=CGRectMake(210, 250, 100, 80);
        flagButton.frame=CGRectMake(15,20,70,40);
        deletebtn.hidden=YES;
    }
}

-(void) setNoFlagButton
{
    flagButton.hidden=YES;
    FlagDetailLabel.hidden=NO;
    
    if (isDeleteButtonPresent==YES)
    {
        popUpview.frame=CGRectMake(210, 250, 100,80);
        deletebtn.frame = CGRectMake(15, 20, 70, 40);
        deletebtn.hidden=NO;
    }
    else
    {
        popUpview.frame=CGRectMake(0, 0, 0, 0);
        deletebtn.hidden=YES;
    }

}




#pragma  mark- didFinishloading

-(void) didFinishLoading:(ASIHTTPRequest*)request   {
    
    //NSString *statusMsg = @"";
  
    
    [SVProgressHUD dismiss];
      
    if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"load"])
    {
        imagedetailsdict=[[request responseString] JSONValue];
       
        // flag button enable or disable 
        NSString *flagButtonEnableDisable=[NSString stringWithFormat:@"%@",[imagedetailsdict objectForKey:@"flag_status"]];
               
        if ([flagButtonEnableDisable isEqualToString:@"0"])
        {   isFlagButtonPresent=YES;
            [self setFlagButton];
        }
        else
        {
            isFlagButtonPresent=NO;
            [self setNoFlagButton];
        }
       
        
        [commentview removeFromSuperview];
         commentsarr = nil;
       
      
        usertxt = [[imagedetailsdict objectForKey:@"username"]objectForKey:@"username" ];
        [uploadedUserNameBtn setTitle:usertxt forState:UIControlStateNormal];
         [ArtMap_DELEGATE  setUserDefault:@"Share_DialogueName" setObject:usertxt];
        
        likecounts = [imagedetailsdict objectForKey:@"image_likes_total"];
        liketxt = [likecounts objectForKey:@"likes"];
        imageLikeLbl.text = [NSString stringWithFormat:@"%d likes ",[liketxt intValue]];
        
        imageContent= [imagedetailsdict objectForKey:@"image"];
        
        if(![imageContent objectForKey:@"date"])
        {
            //NSLog(@"null ");
            datestr=@"No date";
            
        }
        else
        {
            datestr = [self Dateformate:[imageContent objectForKey:@"date"]];
        }
        mnthlbl.text = datestr;
        
        [ArtMap_DELEGATE setUserDefault:ArtMapSecondaryuserid setObject:[imageContent objectForKey:@"user_id"]];
      
         NSString *countryButtonTitle = [NSString stringWithFormat:@"near %@",[imageContent objectForKey:@"address"]];
      
        [countryButton setTitle:countryButtonTitle forState:UIControlStateNormal];
        
        [ArtMap_DELEGATE setUserDefault:@"Image_latitude" setObject:[NSString stringWithFormat:@"%@",[imageContent objectForKey:@"latitude"]]];
       
       
        [ArtMap_DELEGATE setUserDefault:@"Image_longitude" setObject:[NSString stringWithFormat:@"%@",[imageContent objectForKey:@"longitude"]]];
        
        [ArtMap_DELEGATE setUserDefault:@"Share_Location" setObject:[NSString stringWithFormat:@"%@",[imageContent objectForKey:@"address"]]];
        
        currentUserLIKedStr= [[[request responseString] JSONValue] objectForKey:@"current_user_like_status"];
        
       
     
            if([currentUserLIKedStr intValue] == 0)       {
    
                [likeButton setTitle:@"Like" forState:UIControlStateNormal];
            }
            else if([currentUserLIKedStr intValue] == 1)    {
            
                [likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
            }
         
       
        
        //// comments
        
        
        id iscmntsArray = [[[request responseString] JSONValue] objectForKey:@"comment"];
        
        if([iscmntsArray isKindOfClass:[NSArray class]])     {
            
            commentsarr = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in iscmntsArray)         {
                
                CommentsControl *comm = [[CommentsControl alloc] init];
                comm.commentid = [[dic objectForKey:@"comment_id"] integerValue];
                comm.commentliks = [[dic objectForKey:@"comment_likes"] integerValue];
                comm.commentuid = [[dic objectForKey:@"comment_uid"] integerValue];
                comm.comments = [dic objectForKey:@"comments"];
                comm.imageid = [[dic objectForKey:@"image_id"] integerValue];
                comm.createdon =[[dic objectForKey:@"created_on"] integerValue];
                comm.prfimg = [dic objectForKey:@"image"];
             
                comm.iscommentlike = [[dic objectForKey:@"current_user_comment_like"] intValue];
                
                [commentsarr addObject:comm];
            }
        }
        else if([iscmntsArray isKindOfClass:[NSDictionary class]])   {
            
            commentsarr = [[NSMutableArray alloc] init];
            [commentsarr addObject:iscmntsArray];
        }
        if ([commentsarr count]>0)    {
            
            //------------------------------11/02/14 --------------------------------------------
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger dynamicHeight=0;
               
                
            for (int i=0; i<[commentsarr count]; i++) {
                
                    CommentsControl *getsize = [commentsarr objectAtIndex:i];
                
                
                    UILabel *cmntslbl = [[UILabel alloc]initWithFrame:CGRectMake(50,15,200, 60)];
                    UIFont *font=[UIFont fontWithName:@"Helvetica"size:10.0];
                    
                    CGSize size=CGSizeMake(cmntslbl.frame.size.width, 100000);
                    size.height=[getsize.comments sizeWithFont:font constrainedToSize:size].height;
                   
                    if(size.height<23){
                        dynamicHeight=dynamicHeight+60;
                    }
                    else{
                        dynamicHeight=dynamicHeight+size.height+35;
                    }
                
                }
                
            photoCommentScrollView.contentSize= CGSizeMake(320, 360+dynamicHeight);
          
                
                
                
        NSArray* subviews = [[NSArray alloc] initWithArray: photoCommentScrollView.subviews];
                
            for (UIView* view in subviews)      {
                    
                    if (view.tag == 500) {
                        
                        [view removeFromSuperview];
                    }
                }
                
                for (int i=0; i<[commentsarr count]; i++)   {
                    
                    commentview=[[UIView alloc] init];
                    commentview.tag = 500;
                    
                    commentview.frame=CGRectMake(0, 355+60*i,320, 55);
                    
                    commentview.backgroundColor=[UIColor clearColor];
                    
                    CommentsControl *comctrl = [commentsarr objectAtIndex:i];
                    
                    AsyncImageView *imgview1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 30, 30, 30)];
                    
                    NSURL *imgurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ImagebaseUrl,comctrl.prfimg]];
                    [imgview1 loadImageFromURL:imgurl];
                    [commentview addSubview:imgview1];
                    
                    
                    
                    UILabel *cmntslbl = [[UILabel alloc]initWithFrame:CGRectMake(50,15,200, 60)];
                    
                    UIFont *font=[UIFont fontWithName:@"Helvetica"size:10.0];
                    CGSize size=CGSizeMake(cmntslbl.frame.size.width, 100000);
                    
                    size.height=[comctrl.comments sizeWithFont:font constrainedToSize:size].height+25;
                    
                    cmntslbl.frame=CGRectMake(50,15,200,size.height);
                    
                    
                    cmntslbl.backgroundColor = [UIColor clearColor];
                    cmntslbl.textColor = [UIColor whiteColor];
                    //------------------------------- 05/02/14 ---------------------------
                    
                    cmntslbl.numberOfLines=5;
                    cmntslbl.font=[UIFont fontWithName:@"Helvetica"size:10.0];
                    cmntslbl.text = comctrl.comments;
                    
                    [commentview addSubview:cmntslbl];
                    
                    greylikbtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    greylikbtn.frame = CGRectMake(265, 30, 40, 20);
                    greylikbtn.tag = i;
                    [greylikbtn addTarget:self action:@selector(individualCommentLike:) forControlEvents:UIControlEventTouchUpInside];
                    
                    /*UITapGestureRecognizer *pinchgreylikbtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(individualCommentLike:)];
                    pinchgreylikbtn.numberOfTapsRequired=1;
                    [greylikbtn addGestureRecognizer:pinchgreylikbtn] ; */
                    
                    [[greylikbtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:8]];
                    
                    greylikbtn.backgroundColor=[UIColor grayColor];
                    
                    NSInteger iscom = comctrl.iscommentlike;
                    
                    //nslog(@"current user liked or not .... %d",iscom);
                    
                    if (iscom == 0)         {
                        
                        [greylikbtn setTitle:@"Like" forState:UIControlStateNormal];
                        
                    }
                    if(iscom >0)            {
                        
                        [greylikbtn setTitle:@"Unlike" forState:UIControlStateNormal];
                        
                    }
                    
                    [commentview addSubview:greylikbtn];
                    
                    UILabel *commntliklbl = [[UILabel alloc] initWithFrame:CGRectMake(252, 30, 12, 14)];
                    commntliklbl.backgroundColor = [UIColor clearColor];
                    commntliklbl.textColor = [UIColor whiteColor];
                    commntliklbl.font=[UIFont fontWithName:@"Helvetica"size:10.0];
                    commntliklbl.text =[NSString stringWithFormat:@"%d",comctrl.commentliks];
                    [commentview addSubview:commntliklbl];
                    [photoCommentScrollView addSubview:commentview];
                }
                
                
                
            });
            
            
        }
        
        // simply to remove comment view if comment array is zero
        else       {
            
            photoCommentScrollView.contentSize= CGSizeMake(320, 350);
            NSArray* subviews = [[NSArray alloc] initWithArray: photoCommentScrollView.subviews];
            
            for (UIView* view in subviews)      {
                
                if (view.tag == 500) {
                    
                    [view removeFromSuperview];
                }
            }
        }
     
        
        
        
}
    
   // flag webservice response ....
    
    
    
    
    else if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"flag_added"])  {
      
        NSDictionary *responseDictionary=[[request responseString] JSONValue];
        NSString *statusString=[responseDictionary objectForKey:@"status"];
        NSString *messageString=[responseDictionary objectForKey:@"message"];
        
        if ([statusString isEqualToString:@"1"])  {
          
            UIAlertView *messageAlert=[[UIAlertView alloc] initWithTitle:@"Flag Alert" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [messageAlert show];
            
            
            isFlagButtonPresent=NO;
            [self setNoFlagButton];
        }
        else   {
           
            isFlagButtonPresent=YES;
            [self setFlagButton];
            
            UIAlertView *messageAlert=[[UIAlertView alloc] initWithTitle:@"Flag Alert" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [messageAlert show];
        }
    }
    
    
    
    else   if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"deleteImage"])  {
        
        NSDictionary *dict=[[request responseString] JSONValue];
        
        if ([[dict objectForKey:@"status"] isEqualToString:@"1"])   {
            
            NSInteger  imageIdval=[[dict objectForKey:@"image_id"] integerValue];
            int i=0;
            NSInteger removeIndexval=0;
            
            for (ImageSortingOrder *cls in IMGArray)
            {
                
                NSInteger splImageIdVal=cls.imageid;
                
                if (imageIdval ==splImageIdVal)
                {
                    
                    removeIndexval=i;
                }
                i++;
            }
            
            [IMGArray removeObjectAtIndex:removeIndexval];
            
            UIAlertView *deletedAlert=[[UIAlertView alloc] initWithTitle:@"Alert!!" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            deletedAlert.tag=666;
            [deletedAlert show];
        }
        
        else  if ([[dict objectForKey:@"status"] isEqualToString:@"0"])      {
            
            UIAlertView *deleteAlert=[[UIAlertView alloc] initWithTitle:@"Alert!!" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [deleteAlert show];
        }
        
    }
    
    
     else  if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"imagelikes"])         {
        
        NSDictionary *dic = [[request responseString] JSONValue];
         
      //   NSString *statusString=[dic objectForKey:@"status"];
         
         currentUserLIKedStr=[dic objectForKey:@"current_user_like_status"];
             
             
             if([currentUserLIKedStr intValue] == 0)       {
                 
                 [likeButton setTitle:@"Like" forState:UIControlStateNormal];
             }
             else if([currentUserLIKedStr intValue] == 1)    {
                 
                 [likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
             }
             
             int LikeCount=[[dic objectForKey:@"likes"] integerValue];
             imageLikeLbl.text = [NSString stringWithFormat:@"%d likes ",LikeCount];
             
    }
    
 
    
         
    
    
    else  if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"commentslike"])  {
        
       // NSDictionary *dic = [[request responseString] JSONValue];
        // statusMsg = [dic objectForKey:@"status"];
        
        
            int arrayIndex = [[[request userInfo] objectForKey:@"index"] integerValue];
            
            CommentsControl *commentscls = (CommentsControl*)[commentsarr objectAtIndex:arrayIndex];
            int commentCount= commentscls.commentliks + 1;
            
            commentscls.commentliks = commentCount;
            [commentsarr replaceObjectAtIndex:arrayIndex withObject:commentscls];
            
            
            
            [self performSelector:@selector(DetailService:) withObject:nil afterDelay:0.1f];
        
    }
    
    
}


-(void) didFailWithError:(ASIHTTPRequest*)request
{
  //  [SVProgressHUD dismiss];
    
    NSString *errorString=[(NSError*)[request error] localizedDescription];
    
    UIAlertView *ErrorAlert=[[UIAlertView alloc] initWithTitle:@"Error Occured" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [ErrorAlert show];
}

#pragma mark-date functionality

-(NSString*) Dateformate:(NSString*)str
{    
    NSDateFormatter *dfrt =[[NSDateFormatter alloc] init];
    [dfrt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   
    
    NSDate *presentdate = [dfrt dateFromString:str];
    [dfrt setDateFormat:@"MMMM"];
    NSString *fullMonth = [dfrt stringFromDate:presentdate];

    [dfrt setDateFormat:@"yyyy"];
    NSString *yearStr = [dfrt stringFromDate:presentdate];
    
    [dfrt setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dfrt setDateFormat:@"d"];
    int date_day = [[dfrt stringFromDate:presentdate] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    NSString *fullDateFormat = [NSString stringWithFormat:@"%@ %d%@ %@",fullMonth,date_day,suffix,yearStr];
         
    return fullDateFormat;
    
}

-(NSString*) DateConversion:(NSString*)str
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *strDate = [formatter dateFromString:str];
    [formatter setDateFormat:@"MMMM d yyyy"];
    
    NSString *finalString=nil;
    finalString=[formatter stringFromDate:strDate];
    
    return finalString;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == titletxt)
        [titletxt resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    //nslog(@"recieved memory warning ooooo");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
