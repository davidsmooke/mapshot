//
//  AddCommentViewController.m
//  ArtMap
//
//

#import "AddCommentViewController.h"
#import "JSON.h"
#import "SVProgressHUD.h"

@interface AddCommentViewController ()

@end

@implementation AddCommentViewController

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
    errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    textview = [[UITextView alloc] initWithFrame:self.view.frame];
    textview.backgroundColor = [UIColor whiteColor];
    textview.textColor = [UIColor blackColor];
    textview.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
   
    [self.view addSubview:textview];
    [textview setDelegate:self];
    [textview becomeFirstResponder];
    
    UIBarButtonItem *CancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(emptyAction:)];
    CancelBtn.tag = 100;
    self.navigationItem.leftBarButtonItem = CancelBtn;
    
    UIBarButtonItem *DoneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Comment" style:UIBarButtonItemStyleDone target:self action:@selector(action:)];
    DoneBtn.tag = 200;
    self.navigationItem.rightBarButtonItem = DoneBtn;
    

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    if (textView.text.length >= 160)
    {
        return NO;
    }
    return YES;
}

-(void) emptyAction:(UIBarButtonItem*)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)action:(UIBarButtonItem*)btn {
    
    [self dismissViewControllerAnimated:YES completion:nil];
     BOOL internet= [AppDelegate hasConnectivity];
     BOOL internetIsConnected=1;
     
    
    if (internet ==internetIsConnected)  {
     
    [SVProgressHUD showWithStatus:DefaultHudText maskType:SVProgressHUDMaskTypeGradient];
        
    NSString *imageIdVal = [ArtMap_DELEGATE getUserDefault:ArtMap_detail];
    NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         
        callWebservice *add = [[callWebservice alloc] init];
        add.delegate = self;
      
        
  
        
    NSString * encodedText;
      encodedText = [self urlEncoding:textview.text];
        [add AddComments:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\",\"comments\":\"%@\"}",[ArtMap_DELEGATE emptystr:imageIdVal],[ArtMap_DELEGATE emptystr:userid],[ArtMap_DELEGATE emptystr:encodedText]] forKey:@"data"]];
        
   }
    else{
     
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
      [noInternetAlert show];
   
     }

}

- (NSString *)urlEncoding:(NSString *)valueString {
    
    if (!valueString) {
        valueString = @"";
    }
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)valueString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	return encodedString;
}





-(void) didFinishLoading:(ASIHTTPRequest*)request  {
   
    [SVProgressHUD dismiss];
   
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"addcomments" object:nil];
}
-(void) didFailWithError:(ASIHTTPRequest*)request
{
     [SVProgressHUD dismiss];
    
    UIAlertView *errorAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:[NSString stringWithFormat:@"%@",request.error.localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
   
    [errorAlert show];
    
   
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
