    //
//  SignInViewController.m
//  MapShot
//
//  Created by Innoppl Technologies on 20/11/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import "SignInViewController.h"
#import <Twitter/Twitter.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "AFNetworking.h"



@interface SignInViewController ()

@end

@implementation SignInViewController

@synthesize fbResponse;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    
    view_title.layer.masksToBounds = NO;
   // view_title.layer.cornerRadius = 8; // if you like rounded corners
    view_title.layer.shadowOffset = CGSizeMake(0, 5);
    //view_title.layer.shadowRadius = 5;
    view_title.layer.shadowOpacity = 0.5;

    view_Facebook.layer.masksToBounds = NO;
    view_Facebook.layer.shadowOffset = CGSizeMake(0, 0);
    view_Facebook.layer.shadowRadius = 1;
    view_Facebook.layer.shadowOpacity = 0.7;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // Start at the Top Left Corner
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    
    // Move to the Top Right Corner
    [path addLineToPoint:CGPointMake(CGRectGetWidth(view_Facebook.frame), 0.0)];
    
    // Move to the Bottom Right Corner
    [path addLineToPoint:CGPointMake(CGRectGetWidth(view_Facebook.frame), CGRectGetHeight(view_Facebook.frame))];
    
    // This is the extra point in the middle :) Its the secret sauce.
    [path addLineToPoint:CGPointMake(CGRectGetWidth(view_Facebook.frame), CGRectGetHeight(view_Facebook.frame))];
    
    // Move to the Bottom Left Corner
    [path addLineToPoint:CGPointMake(0.0, CGRectGetHeight(view_Facebook.frame))];
    
    // Move to the Close the Path
    [path closePath];
    
   view_Facebook.layer.shadowPath = path.CGPath;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated{
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
       // RHViewControllerDown();
        //   self.edgesForExtendedLayout = UIRectEdgeNone;
        [ArtMap_DELEGATE applicationDidBecomeActive:[UIApplication sharedApplication]];
    }
 
}

- (void)customalertOK:(CustomAlertViewController*)viewController
               button:(UIButton*)sender  textFieldValue:(NSString*)valueString{
   
    DDSetUserDefault(valueString, @"newUserName");
  /*  UIAlertView *termsAndConditionAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"you have read and agree to the Terms and Conditions." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    termsAndConditionAlert.tag=5000;
    [termsAndConditionAlert show]; */
    
    [self.navigationController popViewControllerAnimated:NO];
    [self LoginwithNewUser:DDGetUserDefaultForKey(@"newUserName")];
}


- (void)customalertCancel:(CustomAlertViewController*)viewController
                   button:(UIButton*)sender
{
   
     [self.navigationController popViewControllerAnimated:NO];
}

-(void) createCustomAlert{
   
    
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
  CustomAlertViewController *customAlertView = [storyboard instantiateViewControllerWithIdentifier:@"alertID"];
    customAlertView.delegate=self;
  //  customAlertView.modalPresentationStyle = UIModalPresentationFullScreen;
   [self.navigationController pushViewController:customAlertView animated:NO];
}


-(IBAction)faceBook:(id)sender{
  
  NSString *client_id = facebookAppID;
	
    AppDelegate *appDelObj=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //alloc and initalize our FbGraph instance
	appDelObj.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
	
	//begin the authentication process.....
	[appDelObj .fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback) andExtendedPermissions:extendedPermission];
   
}





- (void)fbGraphCallback {
	
    AppDelegate *appDelObj=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
	if ( (appDelObj. fbGraph.accessToken == nil) || ([appDelObj.fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[appDelObj.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:)andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} else {
		//pop a message letting them know most of the info will be dumped in the log
		
       //--------------------- User Profile --------------------------------------
        
        
    FbGraphResponse *fb_graph_response = [appDelObj.fbGraph doGraphGet:@"me" withGetVars:nil];
        
    NSDictionary *FBInfo = [[fb_graph_response.htmlResponse JSONValue] copy];
        
   
        
    NSString *userId = [FBInfo objectForKey:@"id"];
    NSString *email = [FBInfo objectForKey:@"email"];
    NSString *first_name = [FBInfo objectForKey:@"first_name"];
    NSString *last_name = [FBInfo objectForKey:@"last_name"];
    NSString *username = @"";
         
    [ArtMap_DELEGATE setUserDefault:@"Share_DialogueName" setObject:first_name];
    NSString *devicetokn = [ArtMap_DELEGATE getUserDefault:ArtMapDeviceToken];
    [ArtMap_DELEGATE setUserDefault:ArtMap_FBid setObject:userId];
         
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"loginType\":\"%d\",\"id\":\"%@\",\"isAgree\":\"0\",\"username\":\"%@\",\"first_name\":\"%@\",\"last_name\":\"%@\",\"email\":\"%@\",\"password\":\"\",\"device_token\":\"%@\"}",AMLOGINTYPE_FACEBOOK,[ArtMap_DELEGATE emptystr:userId],[ArtMap_DELEGATE emptystr:username],[ArtMap_DELEGATE emptystr:first_name],[ArtMap_DELEGATE emptystr:last_name],[ArtMap_DELEGATE emptystr:email],[ArtMap_DELEGATE emptystr:devicetokn]] forKey:@"data"];
        

    callWebservice *webObject=[[callWebservice alloc] init];
    webObject.delegate=self;
    [webObject postValueFromFaceBookApi:dict];
        
    callWebservice *call=[[callWebservice alloc] init];
    call.delegate=self;
    [call saveFBImg:userId];
        
  
    }
	
}


-(IBAction)signIn:(id)sender
{
    [txt_username resignFirstResponder];
    [txt_password resignFirstResponder];
    BOOL internet= [AppDelegate hasConnectivity];
       BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected)
    {
        
        NSMutableString *errorStr = [[NSMutableString alloc] init];
        
        if([[txt_username.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)   {
            
            [errorStr appendFormat:@"Please enter user name. \n"];
        }
        if ([[txt_password.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)       {
            
            [errorStr appendFormat:@"Please enter password. \n"];
        }
        if(![errorStr isEqualToString:@"" ])        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else    {
           
            [self performSelector:@selector(login) withObject:nil afterDelay:0.2];
        }
        
    }
    else{
        
        
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
    }

  
}
-(void) login{
    
    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *devicetoken = [ArtMap_DELEGATE getUserDefault:ArtMapDeviceToken];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\",\"device_token\":\"%@\"}",[ArtMap_DELEGATE emptystr:txt_username.text],[ArtMap_DELEGATE emptystr:txt_password.text],devicetoken] forKey:@"data"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ArtMapLogin]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ArtMapLogin parameters:dict];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         [SVProgressHUD dismiss];
        
        NSDictionary *JSON=[ArtMap_DELEGATE convertToJSON:responseObject];
        if ([operation.response statusCode] == 200)
        {
            [self LoginAction:JSON value:1];
            
        }else{
            UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            errAlertView1.message = [JSON objectForKey:@"msg"];
            [errAlertView1 show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        errAlertView1.message = @"Invalid Username and Password";
        [errAlertView1 show];
      
    }];
    [operation start];

}


-(IBAction)SignUp:(id)sender
{

      [self performSegueWithIdentifier:@"signUp" sender:self];
}

-(IBAction)twitter:(id)sender{
    
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected){
       
        if ([TWTweetComposeViewController canSendTweet]){
           
            // ArtMap_DELEGATE=(ArtMap_DELEGATE*)[UIApplication sharedApplication].delegate;
            ArtMap_DELEGATE.myAccountStore=[[ACAccountStore alloc] init];
            ArtMap_DELEGATE.twitterAccount=nil;
            
            // Request access to the Twitter accounts
            //   ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [ArtMap_DELEGATE.myAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [ArtMap_DELEGATE.myAccountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)    {
                
                if (granted){
                    
                    NSArray *accounts = [ArtMap_DELEGATE.myAccountStore accountsWithAccountType:accountType];
                    // Check if the users has setup at least one Twitter account
                    
                    if (accounts.count > 0){
                        
                        ArtMap_DELEGATE.twitterAccount = [accounts objectAtIndex:0];
                       
                        NSString *userName=[(ACAccount*)[ accounts objectAtIndex:0] accountDescription];
                        
                        
                        // Creating a request to get the info about a user on Twitter
                        SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:userName forKey:@"screen_name"]];
                        twitterInfoRequest.account=ArtMap_DELEGATE.twitterAccount;
                        [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)       {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                // Check if we reached the reate limit
                                if ([urlResponse statusCode] == 429) {
                                    
                                  
                                    return;
                                }
                                // Check if there was an error
                                if (error) {
                                    
                                    //nslog(@"Error: %@", error.localizedDescription);
                                    return;
                                }
                                // Check if there is some response data
                                if (responseData)   {
                                    
                                    NSError *error = nil;
                                    NSArray *TWData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                                    
                                  // Filter the preferred data
                                    NSString *screen_name = [(NSDictionary *)TWData objectForKey:@"screen_name"];
                                 //   NSString *name = [(NSDictionary *)TWData objectForKey:@"name"];
                                    NSString *twitter_Id = [(NSDictionary *)TWData objectForKey:@"id"];
                                  //  NSString *email_Id =@"";
                                    
                                    
                                    
                NSString *devicetoken = [ArtMap_DELEGATE getUserDefault:ArtMapDeviceToken];
               
        NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"loginType\":\"%d\",\"id\":\"%@\",\"isAgree\":\"0\",\"username\":\"%@\",\"first_name\":\"\",\"last_name\":\"\",\"email\":\"\",\"password\":\"\",\"device_token\":\"%@\"}",AMLOGINTYPE_TWITTER,twitter_Id,[ArtMap_DELEGATE emptystr:screen_name],[ArtMap_DELEGATE emptystr:devicetoken]] forKey:@"data"];
                                    
                                    
           
         
                                
            [self TwitterService:dict];
            NSString *profileImageStringURL = [(NSDictionary *)TWData objectForKey:@"profile_image_url_https"];
            [self getProfileImageForURLString:profileImageStringURL];
                                
                                }
                            });
                        }];
                    }
    else{
        
    noAccessGrantedAlert=[[UIAlertView alloc] initWithTitle:@"No Accounts in settings" message:@"Check twitter account in settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [self performSelectorOnMainThread:@selector(showAlert) withObject:Nil waitUntilDone:NO];
    }
                }
                else {
                   
    noAccessGrantedAlert=[[UIAlertView alloc] initWithTitle:@"Mapshot access is disabled" message:@"Check twitter account in settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                
    [self performSelectorOnMainThread:@selector(showAlert) withObject:Nil waitUntilDone:YES];
                
                }
            }];
        }
        else {
            
    noAccessGrantedAlert = [[UIAlertView alloc] initWithTitle:@"Twitter Alert" message:@"Please login with your twitter account in settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [self performSelectorOnMainThread:@selector(showAlert) withObject:Nil waitUntilDone:NO];
        }
        
    }
    else{
      
       noAccessGrantedAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    }

}

-(void)showAlert
{
    [noAccessGrantedAlert show];
}

-(void) TwitterService:(NSDictionary*)dict{
    
    callWebservice *webObject=[[callWebservice alloc] init];
    webObject.delegate=self;
    [webObject postValueFromTwitterBookApi:dict];
    
}

- (void) getProfileImageForURLString:(NSString *)urlString {
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [ArtMap_DELEGATE setTwitImg:image];
        
        NSData *imgdata = UIImagePNGRepresentation(image);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"profileimage.png"];
        
        
        
        [imgdata writeToFile:filePath atomically:YES];
        
    });
}


-(void)LoginAction:(NSDictionary*)dict value:(int)value
{
    NSString *MessageString = @"";
  
    NSString *statusString=[dict objectForKey:@"status"];
    
   
    
    MessageString = [dict objectForKey:@"message"];
 //   if([[dict objectForKey:@"action"] integerValue] ==webSERVICE_LOGIN)     {
        
    if(value ==1){
        
        if ([statusString integerValue] == 0)       {
            
            UIAlertView *loginFailAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [loginFailAlert show];
        }
        else if ([statusString integerValue] == 1)      {
            
            [ArtMap_DELEGATE setUserDefault:ArtMap_UserId setObject:[dict objectForKey:@"user_id"]];
            [ArtMap_DELEGATE setUserDefault:ArtMapUserActive setObject:[dict objectForKey:@"active_status"]];
            [ArtMap_DELEGATE setUserDefault:@"Share_DialogueName" setObject:[dict objectForKey:@"user_name"]];
            
            [ArtMap_DELEGATE openingScreen];
            
        }
    }
    
    else  if([[dict objectForKey:@"action"] integerValue] == webSERVICE_SIGNUP)
        
    {
        
       
        
        
        if ([statusString integerValue] == 13)  {
            //username reserved by admin
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserName Reserved" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        
        else if ([statusString integerValue] == 0)   {
            // not authorised user fb,twitter,instagram
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Authorised" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        
        else if ([statusString integerValue] == 1)   {
            
            // success for normal ,twitter,fb ,instagram
            
            [self LoginAction:dict value:1];
            
        }
        
        
    }
    
    if ([[dict objectForKey:@"action"] isEqualToString:@"forgetPassWord"])
    {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Alert" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    }
}





-(void)setUserDefaults:(NSString*)key setObject:(id)myObject{
  
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:myObject forKey:key];
    [userDefaults synchronize];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	return YES;
}

-(IBAction)forgotPasswordAction:(id)sender
{
    txt_forgotUsername.text=@"";
    txt_forgotEmail.text=@"";
    view_forgotPassword.hidden=NO;
}
-(IBAction)forgotClose:(id)sender
{
    [self hideKeyboard];
    view_forgotPassword.hidden=YES;
}
-(IBAction)forgotSend:(id)sender
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:txt_forgotEmail.text];
    
    NSMutableString *errorString=[[NSMutableString alloc] init];
    
    
    if ([txt_forgotUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0)
    {
       
        [errorString appendString:@"Enter user name\r\n"];
        
    }
    if ([txt_forgotEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        
      
        [errorString appendString:@"Enter email address\r\n"];
        
        
    }
    else
    {
        if (!myStringCheck)
        {
            
            [errorString appendString:@"Please enter a valid email address"];
        }
    }
    
    if ([errorString isEqualToString:@""])
    {
        [self forgetPasswordWebService];
    }
    else
    {
        UIAlertView *errorAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:errorString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [errorAlert show];
        
    }

}
-(void) forgetPasswordWebService
{
    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    [txt_forgotUsername resignFirstResponder];
    [txt_forgotEmail resignFirstResponder];
    
    NSDictionary *tempDictionary=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"email\":\"%@\",\"username\":\"%@\"}",txt_forgotEmail.text,txt_forgotUsername.text] forKey:@"data"];
   // [webserviceObject forgetPasswordService:tempDictionary];
    
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:forgetPassWordUrl]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:forgetPassWordUrl parameters:tempDictionary];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSString *statusString=[json objectForKey:@"status"];
       // NSString *messageString=[json  objectForKey:@"message"];
        UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        if ([statusString integerValue] == 1)
        {
            errAlertView1.message = [json objectForKey:@"message"];
            [errAlertView1 show];
            
            txt_forgotEmail.text=@"";
            txt_forgotUsername.text=@"";
            
            
        }else{
            // [self resignKeyboard];
            errAlertView1.message = [json objectForKey:@"message"];
            [errAlertView1 show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
        
        NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        NSString *messageString=[json  objectForKey:@"message"];
        errAlertView1.message = messageString;
        [errAlertView1 show];
        
        
    }];
    [operation start];
   
    
}

-(void) didFinishLoading:(ASIFormDataRequest*)res{
  
   
    
    NSString *MessageString = @"";
    NSDictionary *dicc = [[res responseString] JSONValue];
   
    
    NSString *statusString=[dicc objectForKey:@"status"];
    MessageString = [dicc objectForKey:@"message"];
    NSString *loginType =[dicc objectForKey:@"loginType"];
    
    
    if([[[res userInfo] objectForKey:@"action"] integerValue] ==webSERVICE_LOGIN)
    {        
        [progressView setCaption:MessageString];
        [progressView setActivity:NO];
        [progressView update];
        
        if ([MessageString isEqualToString:@""])
        {
            [progressView hideAfter:0.0];
        }
        else
        {
            [progressView hideAfter:0.3];
           
        }
        
        txt_username.text = @"";
        txt_password.text = @"";
        
        if ([statusString integerValue] == 0)       {
            
            UIAlertView *loginFailAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [loginFailAlert show];
        }
        else if ([statusString integerValue] == 1)      {
            
            [ArtMap_DELEGATE setUserDefault:ArtMap_UserId setObject:[dicc objectForKey:@"user_id"]];
            [ArtMap_DELEGATE setUserDefault:ArtMapUserActive setObject:[dicc objectForKey:@"active_status"]];
            [ArtMap_DELEGATE setUserDefault:@"Share_DialogueName" setObject:[dicc objectForKey:@"user_name"]];
            
            NSString *userActiveState=[dicc objectForKey:@"active_status"];
            
            if ([userActiveState isEqualToString:@"1"])     {
                
                
                //AppDelegate *appdel=ArtMap_DELEGATE;
//                [appdel.window addSubview:appdel.tabbarObject.view];
//                //  [appdel.tabbarObject.btn2 setSelected:true];
//                [appdel.tabbarObject selectTab:1];
            }
            else if ([userActiveState isEqualToString:@"0"])
            {
                
               // AppDelegate *appdel=ArtMap_DELEGATE;
//                [appdel.window addSubview:appdel.tabbarObject.view];
//                [appdel.tabbarObject selectTab:4];
                
                
            }
        }
    }
    
    else  if([[[res userInfo] objectForKey:@"action"] integerValue] == webSERVICE_SIGNUP){
        
        
       if ([loginType isEqualToString:@"1"] || [loginType isEqualToString:@"2"]){
            NSLog(@"faceBook Or Twitter");
            
           if ([statusString integerValue]==2){
                
            signUpDict = [[NSDictionary alloc] initWithDictionary:[dicc objectForKey:@"input"]];
             [self createCustomAlert];
               
            }
            else if ([statusString integerValue]==1 || [statusString integerValue]==3){
                // id already exists in database so user is allowed to login
                
                [ArtMap_DELEGATE setUserDefault:ArtMap_UserId setObject:[dicc objectForKey:@"user_id"]];
                [ArtMap_DELEGATE setUserDefault:ArtMapUserActive setObject:[dicc objectForKey:@"active_status"]];
                [ArtMap_DELEGATE openingScreen];
                
            }
           
            else   if ([statusString integerValue] == 4)       {
                
                // user name already exist so new name for fb,twitter ,instagram
              
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New User Alert" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                alert.tag = 101;
                [alert show];
            }
            
          
           else   if ([statusString integerValue] == 0)   {
                // not authorised user fb,twitter,instagram
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Authorised" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            else   if ([statusString integerValue] == 5){
                
               signUpDict = [[NSDictionary alloc] initWithDictionary:[dicc objectForKey:@"input"]];
            
                UIAlertView *pleaseEnter=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter another user name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                pleaseEnter.tag=101;
                [pleaseEnter show];
                
               
            }
            
            
            else if ([statusString integerValue] == 6)  {
                //username reserved by admin
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserName Reserved" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
           

        }
        
        
    }
    

}

-(void) didFailWithError:(ASIHTTPRequest*)request{
   
    
    [progressView setCaption:[(NSError*)request.error localizedDescription]];
    [progressView setActivity:NO];
    [progressView update];
    [progressView hideAfter:0.1];
    
   
}






- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
   
    if (alertView.tag==180){
        
        BOOL internet= [AppDelegate hasConnectivity];
        BOOL internetIsConnected=1;
        
        if (internet ==internetIsConnected){
       
        }
        else{
            UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [noInternetAlert show];
        }
        
    }
    if (alertView.tag==101){
      [self createCustomAlert];
    }
    /* else  if (alertView.tag==5000){
     
         [self.navigationController popViewControllerAnimated:NO];
         [self LoginwithNewUser:DDGetUserDefaultForKey(@"newUserName")];
    } */
}

-(void) LoginwithNewUser :(NSString*) userName
{
    NSString *devicetkn  = [ArtMap_DELEGATE getUserDefault:ArtMapDeviceToken];
    
    NSString *strData = [NSString stringWithFormat:@"{\"loginType\":\"%d\",\"id\":\"%@\",\"isAgree\":\"1\",\"username\":\"%@\",\"first_name\":\"%@\",\"last_name\":\"%@\",\"email\":\"%@\",\"password\":\"\",\"device_token\":\"%@\"}",
                        
                         [[signUpDict objectForKey:@"loginType"] integerValue],
                         [ArtMap_DELEGATE emptystr:[signUpDict objectForKey:@"id"]],
                         [ArtMap_DELEGATE emptystr:userName],
                         [ArtMap_DELEGATE emptystr:[signUpDict objectForKey:@"first_name"]],
                         [ArtMap_DELEGATE emptystr:[signUpDict objectForKey:@"last_name"]],
                         [ArtMap_DELEGATE emptystr:[signUpDict objectForKey:@"email"]],
                         [ArtMap_DELEGATE emptystr:[ArtMap_DELEGATE emptystr:devicetkn]]];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:strData forKey:@"data"];
    
    NSLog(@"resubmitt dict %@",dict);
    
    
    
    callWebservice *callService = [[callWebservice alloc] init];
    callService.delegate = self;
    [callService signUpWebServices:dict];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}
-(void)hideKeyboard
{
    [txt_username resignFirstResponder];
    [txt_password resignFirstResponder];
    [txt_forgotUsername resignFirstResponder];
    [txt_forgotEmail resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
