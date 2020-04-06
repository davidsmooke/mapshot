//
//  SettingsViewController.m
//  MapShot
//
//  Created by Innoppl Technologies on 21/11/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import "SettingsViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"

#import "TermsAndConditonsViewController.h"




@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
   
    NSDictionary *textAttributesDict = @{UITextAttributeTextColor : [UIColor whiteColor],
                                         UITextAttributeFont : [UIFont systemFontOfSize:13.0f]};
    
    [[UITabBarItem appearance] setTitleTextAttributes:textAttributesDict forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:textAttributesDict forState:UIControlStateNormal];
    
    
    errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
       // RHViewControllerDown();
    }
   
    [super viewDidAppear:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden=YES;
    NSString *PushValueStatus= [ArtMap_DELEGATE getUserDefault:ArtMapPushStatus];
    //on
    if ([PushValueStatus isEqualToString:@"1"]) {
        
        //nslog(@"already on so off it ");
        [PushOnOffButton setTitle:@"Turn off Push Notifications" forState:UIControlStateNormal];
        PushOnOffButton.backgroundColor=ColorWithOrange;
        PushOnOffButton.tag=101;
        
    }
    //off
    else if ([PushValueStatus isEqualToString:@"0"])    {
        
        //nslog(@"already off so on it ");
        [PushOnOffButton setTitle:@"Turn on Push Notifications" forState:UIControlStateNormal];
        PushOnOffButton.backgroundColor=ColorWithGray;
        PushOnOffButton.tag=111;
        
    }
    
    //// geo on or off////
    NSString *checkGeoOnorOff=[ArtMap_DELEGATE getUserDefault:@"GEOSWITCHonORoff"];
    if ([checkGeoOnorOff isEqualToString:@"SWITCH_ON"])     {
        
        //nslog(@"Geo On appear");
        GeoOnOffButton.tag=211;
        [GeoOnOffButton setTitle:@"Turn off Location Tracking" forState:UIControlStateNormal];
        GeoOnOffButton.backgroundColor=ColorWithOrange;
        
        
    }
    else if ([checkGeoOnorOff isEqualToString:@"SWITCH_OFF"])   {
        
        //nslog(@"Geo off appear");
        GeoOnOffButton.tag=201;
        [GeoOnOffButton setTitle:@"Turn on Location Tracking" forState:UIControlStateNormal];
        GeoOnOffButton.backgroundColor=ColorWithGray;
    }
    
    
    //// user active or not /////
    NSString *stateCheck=[ArtMap_DELEGATE getUserDefault:ArtMapUserActive];
   
    if ([stateCheck isEqualToString:@"0"])      {
        
        [deactiveButton setTitle:@"Activate My Account" forState:UIControlStateNormal];
        deactiveButton.backgroundColor=ColorWithGray;
       
        UIAlertView *UserAlertToMakeActive=[[UIAlertView alloc] initWithTitle:@"Active Alert" message:@"Activate to make use of this app" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [UserAlertToMakeActive show];
    }
    else if ([stateCheck isEqualToString:@"1"])     {
        deactiveButton.backgroundColor=ColorWithOrange;
        [deactiveButton setTitle:@"Deactivate My Account" forState:UIControlStateNormal];
    }
    
    [super viewWillAppear:YES];

}
-(IBAction)back:(id)sender{
    NSString *userActiveState=[ArtMap_DELEGATE getUserDefault:ArtMapUserActive];
    
    if ([userActiveState isEqualToString:@"0"]){
        
        UIAlertView *tempAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"In deactive state you can't use your app" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [tempAlert show];
    }
    else{
     [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)signOut:(id)sender{
    UIAlertView *LogoutAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Are you sure you want to sign out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    LogoutAlert.delegate=self;
    LogoutAlert.tag=103;
    [LogoutAlert show];

}

-(void)SignOutAction{
   
    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *userId=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
    
    NSString *devicetoken = [ArtMap_DELEGATE getUserDefault:ArtMapDeviceToken];
    
    NSDictionary *dict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"device_token\":\"%@\"}",userId,devicetoken] forKey:@"data"];
   
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:signOutService]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:signOutService parameters:dict];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlRequest];
    //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        // NSDictionary *JSON = [responseObject JSONValue];
        
        
        NSDictionary *JSON=[ArtMap_DELEGATE convertToJSON:responseObject];
      
        if ([operation.response statusCode] == 200)
        {
            NSInteger statusString=[[JSON objectForKey:@"status"] integerValue];
            NSString *messageString=[JSON objectForKey:@"message"];
            
            if (statusString==1)
            {
                
                [self removeTempDetails];
                
                [ArtMap_DELEGATE openingScreen];
                
            }
            else if (statusString==0)
            {
                UIAlertView *failureAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [failureAlert show];
                
                
            }
            
        }
        else
        {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [SVProgressHUD dismiss];        //        errAlertView.message = @"Try again";
        //        [errAlertView show];
       
    }];
    [operation start];
}

-(IBAction)changePassword:(id)sender
{
    view_changePassword.hidden=NO;
}

-(IBAction)changePasswordWebService:(id)sender {
    
    
    NSMutableString *errorString=[[NSMutableString alloc] init];
    
    
    if ([oldPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        
        [errorString appendString:@"Enter old password\r\n"];
    }
    if ([newPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
       
        [errorString appendString:@"Enter new password\r\n"];
    }
    if ([confirmPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
      
        [errorString appendString:@"Enter confirm password\r\n"];
    }
    
    if ([errorString isEqualToString:@""])
    {
        
        if ([oldPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>=8   )
            
        {
            if ([oldPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<17 )
            {
                [errorString appendString:@""];
            }
            else
            {
                [errorString appendString:@"Old password should be atleast 8-digits \r\n"];
            }
        }
        else
        {
            [errorString appendString:@"Old password should be atleast 8-digits \r\n"];
        }
        
        
        if ([newPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>=8   )
        {
            if ([newPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<17 )
            {
                [errorString appendString:@""];
            }
            else
            {
                [errorString appendString:@"New password should be atleast 8-digits \r\n"];
            }
        }
        else
        {
            [errorString appendString:@"New password should be atleast 8-digits \r\n"];
        }
        
        
        if ([confirmPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>=8   )
        {
            if ([confirmPasswordAlertTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<17 )
            {
                [errorString appendString:@""];
            }
            else
            {
                [errorString appendString:@"Confirm password should be same as New password \r\n"];
            }
        }
        else
        {
            [errorString appendString:@"Confirm password should be same as New password \r\n"];
        }
        
        
        
        if ([errorString isEqualToString:@""])
        {
            [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
            NSString *useridVal=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
            
            NSDictionary *dict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"oldpassword\":\"%@\",\"newpassword\":\"%@\",\"confirmpassword\":\"%@\"}",useridVal,oldPasswordAlertTextField.text,newPasswordAlertTextField.text,confirmPasswordAlertTextField.text] forKey:@"data"];
            
            AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ChangePasswordUrl]];
            [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
            
            NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ChangePasswordUrl parameters:dict];
            AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
            //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
            
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
               [SVProgressHUD dismiss];
             
                // NSDictionary *JSON = [responseObject JSONValue];
                
                
               // NSDictionary *JSON=[ArtMap_DELEGATE convertToJSON:responseObject];
              
                if ([operation.response statusCode] == 200)
                {
                    NSInteger statusString=[[responseObject objectForKey:@"status"] integerValue];
                    NSString *messageString=[responseObject objectForKey:@"message"];
                    
                    if (statusString==1)
                    {
                        oldPasswordAlertTextField.text=@"";
                        newPasswordAlertTextField.text=@"";
                        confirmPasswordAlertTextField.text=@"";
                        UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Password successfully changed" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        successAlert.tag=342;
                        [successAlert show];
                    }
                    else if (statusString==0)
                    {
                        UIAlertView *failureAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        [failureAlert show];
                        
                    }
                    
                }
                else
                {
                    UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    errAlertView1.message = [responseObject objectForKey:@"message"];
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
        else{
            UIAlertView *showErrAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:errorString delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            showErrAlert.tag=456;
            [showErrAlert show];
        }
        
        
    }
    else
    {
        
        UIAlertView *showErroAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:errorString delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        showErroAlert.tag=987;
        [showErroAlert show];
    }
    
    
    
    //[webServiceObj  changePasswordService:temp];
}
-(IBAction)cancel_changePassword:(id)sender
{
    [self hideKeyboard];
    view_changePassword.hidden=YES;
}
-(IBAction)pushnotification:(UIButton*)sender
{
    NSString *UserIdValk=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
    

    NSDictionary *pushDetailDict;
    
    if (sender.tag==111)    {
        
        //nslog(@"switch is on");
        pushDetailDict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"push_status\":\"1\"}",UserIdValk] forKey:@"data"];
        //nslog(@"push details dict %@",pushDetailDict);
        
    }
    else if (sender.tag==101)   {
        
        //nslog(@"switch is off");
        pushDetailDict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"push_status\":\"0\"}",UserIdValk] forKey:@"data"];
        //nslog(@"push details dict %@",pushDetailDict);
    }
    [self pushNotificationDeactivateService:pushDetailDict];

}

-(void) pushNotificationDeactivateService:(NSDictionary*) details
{
    
    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ArtMap_Deactive_pushMsg]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ArtMap_Deactive_pushMsg parameters:details];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        if ([operation.response statusCode] == 200)
        {
            NSInteger statusString=[[responseObject objectForKey:@"status"] integerValue];
            NSString *messageString=[responseObject objectForKey:@"message"];
            
            if (statusString==1)
            {
                
                NSString *pushmsg_status=[responseObject objectForKey:@"push_status"];
                if ([pushmsg_status isEqualToString:@"1"])  {
                    
                    [PushOnOffButton setTitle:@"Turn off Push Notifications" forState:UIControlStateNormal];
                  //[PushOnOffButton setBackgroundImage:[UIImage imageNamed:@"SettingsOrangeButton.png"] forState:UIControlStateNormal];
                    PushOnOffButton.backgroundColor=ColorWithOrange;
                    
                    PushOnOffButton.tag=101;
                    
                }
                else if ([pushmsg_status isEqualToString:@"0"]) {
                    
                    [PushOnOffButton setTitle:@"Turn on Push Notifications" forState:UIControlStateNormal];
                  //  [PushOnOffButton setBackgroundImage:[UIImage imageNamed:@"SettingsGreyButton.png"] forState:UIControlStateNormal];
                     PushOnOffButton.backgroundColor=ColorWithGray;
                    PushOnOffButton.tag=111;
                }
                
                UIAlertView *tempAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [tempAlert show];
                [ArtMap_DELEGATE setUserDefault:ArtMapPushStatus setObject:pushmsg_status];
            }
            else if (statusString==0)
            {
                UIAlertView *failureAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [failureAlert show];
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
         UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        NSString *messageString=[json  objectForKey:@"message"];
        errAlertView1.message = messageString;
        [errAlertView1 show];
      
    }];
    [operation start];

}

-(IBAction) GeobuttonFunction:(UIButton*)senderval
{
    if (senderval.tag==201) {
        
        //nslog(@"geo ON");
        [ArtMap_DELEGATE setUserDefault:@"GEOSWITCHonORoff" setObject:@"SWITCH_ON"];
        UIAlertView *geoAlert=[[UIAlertView alloc] initWithTitle:@"Location Tracking" message:@"Current location is used automatically" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        geoAlert.delegate=self;
        geoAlert.tag=325;
        [geoAlert show];
    }
    else if (senderval.tag==211)    {
        
        //nslog(@"geo OFF");
        [ArtMap_DELEGATE setUserDefault:@"GEOSWITCHonORoff" setObject:@"SWITCH_OFF"];
        UIAlertView *geoAlert=[[UIAlertView alloc] initWithTitle:@"Ask Permission" message:@"You want to access your current location?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        geoAlert.delegate=self;
        geoAlert.tag=345;
        [geoAlert show];
    }

}

-(IBAction)termsAndCondition:(UIButton*)sender{
    
   
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    TermsAndConditonsViewController *termsObject =[storyBoard  instantiateViewControllerWithIdentifier:@"termAndConditionId"];
    // FollowerViewController *follow = [[FollowerViewController alloc] initWithNibName:@"FollowerViewController" bundle:nil];
    [self.navigationController pushViewController:termsObject animated:YES];
}

-(IBAction)mailFunction:(UIButton*)sender{
    
  if ([MFMailComposeViewController canSendMail]) {
        
        
        MFMailComposeViewController *mailer  = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        
        
        [mailer setSubject:@"About MapShot"];
        [mailer  setToRecipients:[NSArray arrayWithObject:@"Support@MapShot.co"]];
        NSString *emailBody = @"";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        
        for (UIViewController *viewController in mailer.viewControllers) {
           
        }
        
        if (mailer)
        {
            [self presentViewController:mailer animated:YES completion:nil];
            
        }
        
    }
    else{
        
        UIAlertView *deviceAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"This device cannot send email not configured." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [deviceAlert show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
   

	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)deleteAccountPermanently
{
     [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *userIdVal=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
    NSDictionary *tempDict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\"}",userIdVal] forKey:@"data"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:DeleteUserAccount]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:DeleteUserAccount parameters:tempDict];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      [SVProgressHUD dismiss];
        
        if ([operation.response statusCode] == 200)
        {
            NSInteger statusString=[[responseObject objectForKey:@"status"] integerValue];
            NSString *messageString=[responseObject objectForKey:@"message"];
            
            if (statusString==1)
            {
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:ArtMap_UserId];
                [defaults removeObjectForKey:@"FBAccessToken"];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ArtMapActionType];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ArtMapFBType];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsPath = [paths objectAtIndex:0];
                NSString *filePath = [documentsPath stringByAppendingPathComponent:@"profileimage.png"];
                
                BOOL fileexists=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
                
                if (fileexists)
                {
                   
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
                }
                else
                {
                   
                }
                [self removeTempDetails];
                
                UIAlertView *deleteAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Account deleted successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                deleteAlert.tag=102;
                [deleteAlert show];
                
            }
            else if (statusString==0)
            {
                UIAlertView *failureAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [failureAlert show];
                
            }
            
        }
        else
        {
             UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            // [self resignKeyboard];
            errAlertView1.message = [responseObject objectForKey:@"message"];
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

-(IBAction)deActivate:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *userIdVal=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
    NSString *stateCheck=[ArtMap_DELEGATE getUserDefault:ArtMapUserActive];
    
    NSString *StringActive;
    
    if ([stateCheck isEqualToString:@"0"])      {
        
        StringActive=@"1";
    }
    else if ([stateCheck isEqualToString:@"1"])    {
        
        StringActive=@"0";
    }
    
    NSDictionary *tempDict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"active\":\"%@\"}",userIdVal,StringActive] forKey:@"data"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:DeactivateUserAccount]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:DeactivateUserAccount parameters:tempDict];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
       
        if ([operation.response statusCode] == 200)
        {
            NSInteger statusString=[[responseObject objectForKey:@"status"] integerValue];
            NSString *messageString=[responseObject objectForKey:@"message"];
            
            if (statusString==1)
            {
                NSString *ActiveStatusResponse=[responseObject objectForKey:@"active"];
                
                [ArtMap_DELEGATE setUserDefault:ArtMapUserActive setObject:ActiveStatusResponse];
                
                if ([ActiveStatusResponse isEqualToString:@"1"])
                {
                    [deactiveButton setTitle:@"Deactivate My Account" forState:UIControlStateNormal];
                    deactiveButton.backgroundColor=ColorWithOrange;
                    
                    UIAlertView *tempAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"User has been activated" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [tempAlert show];
                }
                else if ([ActiveStatusResponse isEqualToString:@"0"])
                {
                    [deactiveButton setTitle:@"Activate My Account" forState:UIControlStateNormal];
                     deactiveButton.backgroundColor=ColorWithGray;
                    UIAlertView *tempAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"User has been deactivated" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [tempAlert show];
                }
            }
            else if (statusString==0)
            {
                UIAlertView *failureAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:messageString delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [failureAlert show];
                
                
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
         UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        NSString *messageString=[json  objectForKey:@"message"];
        errAlertView1.message = messageString;
        [errAlertView1 show];
       
    }];
    [operation start];

}

-(void) removeTempDetails
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    ArtMap_DELEGATE.fbGraph.accessToken=nil;
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString *domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    
    
    
   
    
   // [ArtMap_DELEGATE setUserDefault:ArtMap_UserId setObject:Nil];
    [defaults removeObjectForKey:ArtMap_UserId];
    [defaults removeObjectForKey:@"FBAccessToken"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ArtMapActionType];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ArtMapFBType];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"profileimage.png"];
    
    BOOL fileexists=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileexists) {
        
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
    }
    else    {
        
        
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    if (alertView.tag==325 && buttonIndex==0)   {
        
        //nslog(@"Auto locate is On ");
        GeoOnOffButton.tag=211;
        [GeoOnOffButton setTitle:@"Turn off Location Tracking" forState:UIControlStateNormal]
        ;
       // [GeoOnOffButton setBackgroundImage:[UIImage imageNamed:@"SettingsOrangeButton"] forState:UIControlStateNormal];
        
         GeoOnOffButton.backgroundColor=ColorWithOrange;
        [locationController.locationManager startUpdatingLocation];
        [ArtMap_DELEGATE setUserDefault:ArtMap_GEOLOCATION setObject:@"YES"];
    }
    else if (alertView.tag==345 && buttonIndex==0)  {
        
        //nslog(@"yes clicked so autolocate on ");
        GeoOnOffButton.tag=211;
        [GeoOnOffButton setTitle:@"Turn off Location Tracking" forState:UIControlStateNormal];
       // [GeoOnOffButton setBackgroundImage:[UIImage imageNamed:@"SettingsOrangeButton"] forState:UIControlStateNormal];
        GeoOnOffButton.backgroundColor=ColorWithOrange;
        [locationController.locationManager startUpdatingLocation];
        
        [ArtMap_DELEGATE setUserDefault:ArtMap_GEOLOCATION setObject:@"YES"];
        [ArtMap_DELEGATE setUserDefault:@"GEOSWITCHonORoff" setObject:@"SWITCH_ON"];
    }
    else if (alertView.tag==345 && buttonIndex==1)  {
        
        //nslog(@"NO clicked So auto locate is off   ");
        GeoOnOffButton.tag=201;
        [GeoOnOffButton setTitle:@"Turn on Location Tracking" forState:UIControlStateNormal];
      //  [GeoOnOffButton setBackgroundImage:[UIImage imageNamed:@"SettingsGreyButton.png"] forState:UIControlStateNormal];
         GeoOnOffButton.backgroundColor=ColorWithGray;
        [locationController.locationManager stopUpdatingLocation];
        [ArtMap_DELEGATE setUserDefault:ArtMap_GEOLOCATION setObject:@"NO"];
    }
    
    else if (alertView.tag==342 && buttonIndex==0)
    {
        [self removeTempDetails];
        
    }
    else if (alertView.tag==101)
    {
        if(buttonIndex ==0)
        {
            [self deleteAccountPermanently];
        }
    }
    else if(alertView.tag==102)
    {
        [ArtMap_DELEGATE openingScreen];
    }
    else if (alertView.tag==103)
    {
        if(buttonIndex ==1)
        {
            [self SignOutAction];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==oldPasswordAlertTextField)
    {
        [oldPasswordAlertTextField resignFirstResponder];
        [newPasswordAlertTextField becomeFirstResponder];
    }
    if (textField==newPasswordAlertTextField) {
        [newPasswordAlertTextField resignFirstResponder];
        [confirmPasswordAlertTextField becomeFirstResponder];
        
    }
    if (textField==confirmPasswordAlertTextField)
    {
        [confirmPasswordAlertTextField resignFirstResponder];
    }
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}
-(void)hideKeyboard
{
    [oldPasswordAlertTextField resignFirstResponder];
    [newPasswordAlertTextField resignFirstResponder];
    [confirmPasswordAlertTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
