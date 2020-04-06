//
//  SignUpViewController.m
//  MapShot
//
//  Created by Innoppl Technologies on 20/11/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import "SignUpViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "TermsAndConditonsViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
     errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated {
    if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
        // RHViewControllerDown();
        //   self.edgesForExtendedLayout = UIRectEdgeNone;
       [ArtMap_DELEGATE applicationDidBecomeActive:[UIApplication sharedApplication]];
    }
    
}

-(IBAction)checkMarkButtonAction:(UIButton*)sender{
    
       if (sender.tag==2000)
       {
        [checkMarkButton setImage:[UIImage imageNamed:@"checkSelected.png"] forState:UIControlStateNormal];
        checkMarkButton.tag=3000;
        
    }
    else if (sender.tag==3000){
      
        [checkMarkButton setImage:[UIImage imageNamed:@"checkUnselected.png"] forState:UIControlStateNormal];
        checkMarkButton.tag=2000;
    }
}


-(IBAction)termsAndCondition:(UIButton*)sender{
   
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    TermsAndConditonsViewController *termsObject =[storyBoard  instantiateViewControllerWithIdentifier:@"termAndConditionId"];
    [self.navigationController pushViewController:termsObject animated:YES];
}

-(IBAction)Cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)signUp:(id)sender
{
    BOOL internet= [AppDelegate hasConnectivity];
      BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected) {
        
      
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        BOOL myStringCheck = [regExpred evaluateWithObject:txt_email.text];
        
        NSMutableString *errorStr = [[NSMutableString alloc] init];
        
        if ([[txt_username.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)
        {
            [errorStr appendFormat:@"Please enter user name. \n"];
        }
        if ([[txt_firstname.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)
        {
            [errorStr appendFormat:@"Please enter first name. \n"];
        }
        if ([[txt_lastname.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)
        {
            [errorStr appendFormat:@"Please enter last name. \n"];
        }
        
        if([[txt_email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)
        {
            [errorStr appendFormat:@"Please enter email address. \n"];
            
        }else if ([[txt_email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]  length]>0 ) {
            
            if(!myStringCheck){
                [errorStr appendFormat:@"Please enter a valid email address.\n"];
            }
        }
        if ([[txt_password.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0)       {
            
            [errorStr appendFormat:@"Please enter password. \n"];
        }
        else if ([[txt_password.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] < 8)
        {
            [errorStr appendFormat:@"Password should be a minimum of 8 characters. \n"];
        }
        
        if(![errorStr isEqualToString:@"" ])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:errorStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (checkMarkButton.tag==3000){
                
               /* UIAlertView *termsAndConditionAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"You have read and agreed to the Terms And Conditions." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                termsAndConditionAlert.tag=5000;
                [termsAndConditionAlert show]; */
                [self performSelector:@selector(registration) withObject:nil afterDelay:0.5];
                
                
            }else{
                
                UIAlertView *termsAndConditionAlert=[[UIAlertView alloc] initWithTitle:@"Agree" message:@"Please Agree to Terms And Conditions" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                termsAndConditionAlert.tag=700;
                [termsAndConditionAlert show];
            }
            
        }
        
    }
    else
    {
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
    }

}

-(void) registration  {
    
     UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
   [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    NSString *devicetkn  = [ArtMap_DELEGATE getUserDefault:ArtMapDeviceToken];
    NSString *username=txt_username.text;
    
    [ArtMap_DELEGATE setUserDefault:@"Share_DialogueName" setObject:username];
    NSDictionary *dict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"loginType\":\"%d\",\"id\":\"\",\"username\":\"%@\",\"first_name\":\"%@\",\"last_name\":\"%@\",\"email\":\"%@\",\"password\":\"%@\",\"device_token\":\"%@\"}",AMLOGINTYPE_LOCAL,[ArtMap_DELEGATE emptystr:txt_username.text],[ArtMap_DELEGATE emptystr:txt_firstname.text],[ArtMap_DELEGATE emptystr:txt_lastname.text],[ArtMap_DELEGATE emptystr:txt_email.text],[ArtMap_DELEGATE emptystr:txt_password.text],[ArtMap_DELEGATE emptystr:devicetkn]] forKey:@"data"];
    
    
  
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ArtMapRegister]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ArtMapRegister parameters:dict];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        [SVProgressHUD dismiss];
        if ([operation.response statusCode] == 200){
           
           
            
            [checkMarkButton setImage:[UIImage imageNamed:@"checkUnselected.png"] forState:UIControlStateNormal];
            checkMarkButton.tag=2000;
            
            
           /* errAlertView1.message = @"Registration success";
            errAlertView1.tag=888;
            [errAlertView1 show]; */
            
           //  [self.navigationController popViewControllerAnimated:YES];
            
            [self login];
            
             [self reset];
        }
        else if ([operation.response statusCode] == 202) {
            
            errAlertView1.message = [responseObject objectForKey:@"message"];
            [errAlertView1 show];
        }
    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD dismiss];
     
       
        errAlertView1.message = [NSString stringWithFormat:@"%@",error.localizedDescription];
        [errAlertView1 show];
        }];
    
    [operation start];

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
            NSString *MessageString = @"";
            
            NSString *statusString=[JSON objectForKey:@"status"];
            
            
            MessageString = [JSON objectForKey:@"message"];
            //   if([[dict objectForKey:@"action"] integerValue] ==webSERVICE_LOGIN)     {
            
      
                if ([statusString integerValue] == 0)
                {
                    
                    UIAlertView *loginFailAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:MessageString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [loginFailAlert show];
                }
                else if ([statusString integerValue] == 1)
                {
                    
                    [ArtMap_DELEGATE setUserDefault:ArtMap_UserId setObject:[JSON objectForKey:@"user_id"]];
                    [ArtMap_DELEGATE setUserDefault:ArtMapUserActive setObject:[JSON objectForKey:@"active_status"]];
                    [ArtMap_DELEGATE setUserDefault:@"Share_DialogueName" setObject:[JSON objectForKey:@"user_name"]];
                    
                    [ArtMap_DELEGATE openingScreen];
                    
                }

            
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


-(void)reset
{
    txt_username.text=@"";
    txt_firstname.text=@"";
    txt_lastname.text=@"";
    txt_email.text=@"";
    txt_password.text=@"";
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
	return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}
-(void)hideKeyboard
{
    [txt_username resignFirstResponder];
    [txt_password resignFirstResponder];
    [txt_firstname resignFirstResponder];
    [txt_lastname resignFirstResponder];
    [txt_email resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
   /* if (alertView.tag==888)
    {
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    if (alertView.tag==5000){
        [self performSelector:@selector(registration) withObject:nil afterDelay:0.5];
    } */
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
