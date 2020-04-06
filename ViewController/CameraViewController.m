//
//  CameraViewController.m
//  MapShot
//
//  Created by Innoppl Technologies on 20/11/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import "CameraViewController.h"
#import "MultiImageUploadViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

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
    
    viewAlertRound.layer.cornerRadius = 10;
    viewAlertRound.layer.masksToBounds = YES;
    
    deleg = MAPDELEGA;
    errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setUIdesign];
    });

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) setUIdesign
{
    
    cropController = [[PECropViewController alloc] init];
        
    
  //  progressView = [[ATMHud alloc] initWithDelegate:self];
//	[[ArtMap_DELEGATE window] addSubview:progressView.view];
    
    locationController=[[MyCLController alloc] init];
    locationController.delegate=self;
    
    picker=[[UIImagePickerController alloc]init];
    
    
    appDel=ArtMap_DELEGATE;
   
}

-(void)viewWillAppear:(BOOL)animated
{
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden=YES;

     [[locationController locationManager] startUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
       // RHViewControllerDown();
       // [ArtMap_DELEGATE applicationDidBecomeActive:[UIApplication sharedApplication]];
    }
}

- (void)locationUpdate:(CLLocation *)location {
    
    CLLocationCoordinate2D loc = location.coordinate;
    
  
    
    UserLocation = location.coordinate;
    userLatitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    userLongitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    [[locationController locationManager] stopUpdatingLocation];
    
    geoCoder=[[MKReverseGeocoder alloc] initWithCoordinate:loc];
    geoCoder.delegate=self;
    [geoCoder start];
    
}
- (void)locationError:(NSError *)error {
    
}

#pragma ReverseGeocoder

- (void)reverseGeocoder: (MKReverseGeocoder *)geocoder didFailWithError: (NSError *)error{
 
    
}
- (void)reverseGeocoder: (MKReverseGeocoder *)geocoder didFindPlacemark: (MKPlacemark *)placemark{
    
  
    
    currentadds = [placemark locality];
    
    if([placemark locality]==NULL) currentadds=[placemark title];
    
    UserLocation.latitude = placemark.coordinate.latitude;
    userLatitude =[NSString stringWithFormat:@"%f",UserLocation.latitude];
    UserLocation.longitude = placemark.coordinate.longitude;
    userLongitude =[NSString stringWithFormat:@"%f",UserLocation.longitude];
}
-(IBAction)buttonAction:(UIButton*)sender
{
    if ([sender tag]==111)
    {
        if ([[ArtMap_DELEGATE getUserDefault:ArtMap_GEOLOCATION] isEqualToString:@"YES"])
        {
            //nslog(@"GEO enabled ");
            [self chooseImageFromGallery];
            
        }
        else if ([[ArtMap_DELEGATE getUserDefault:ArtMap_GEOLOCATION] isEqualToString:@"NO"])
        {
            UIAlertView *geoAlert=[[UIAlertView alloc] initWithTitle:@"GeolOcation is Off" message:@"You can't upload photo since your geolocation is off" delegate:self cancelButtonTitle:@"Go to Settings" otherButtonTitles:@"Upload Cancel", nil];
            geoAlert.tag=234;
            [geoAlert show];
        }
    }
    else if ([sender tag]==222)
    {
        if ([[ArtMap_DELEGATE getUserDefault:ArtMap_GEOLOCATION] isEqualToString:@"YES"])
        {
            //nslog(@"GEO enabled ");
            [self chooseImageFromCamera];
            
        }
        else if ([[ArtMap_DELEGATE getUserDefault:ArtMap_GEOLOCATION] isEqualToString:@"NO"])
        {
            UIAlertView *geoAlert=[[UIAlertView alloc] initWithTitle:@"GeolOcation is Off" message:@"You can't upload photo since your geolocation is off" delegate:self cancelButtonTitle:@"Go to Settings" otherButtonTitles:@"Upload Cancel", nil];
            geoAlert.tag=234;
            [geoAlert show];
        }
        
        
    }
    else if([sender tag]==333)
    {
        [self imageFromMassUpload];
    }
}
//- (void) navigationController:(UINavigationController *) navigationController   willShowViewController:(UIViewController *) viewController animated:(BOOL)animated
//{
//    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//        [self setNeedsStatusBarAppearanceUpdate];
//        viewController.contentSizeForViewInPopover = navigationController.topViewController.view.frame.size;
//    }
//}

-(void) chooseImageFromGallery
{
    picker.allowsEditing=NO;
    [picker setDelegate:self];
    
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
//    picker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
//        [self.navigationController presentViewController:picker animated:YES completion:^{
//            
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//                [[UIApplication sharedApplication] setStatusBarHidden:YES
//                                                        withAnimation:UIStatusBarAnimationNone];
//        }];
//    }
//    else {
//        [self.navigationController presentViewController:picker animated:YES completion:nil];
//       // [self presentModalViewController:picker animated:YES];
//    }
   // [self presentModalViewController:picker animated:YES];
    
}
-(void) chooseImageFromCamera
{
    
    picker.allowsEditing=NO;
    [picker setDelegate:self];
    
   // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else    {
        
        UIAlertView *cameraAlert=[[UIAlertView alloc] initWithTitle:@"camera not found " message:@"please test with device" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [cameraAlert show];
    }
    
}
-(void) imageFromMassUpload
{
    MultiImageUploadViewController *MulObj=[[MultiImageUploadViewController alloc] init];
    [self.navigationController pushViewController:MulObj animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
 
   // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [ArtMap_DELEGATE setUserDefault:@"PresentModalYes" setObject:@"YES"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    IMG = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //[self performSelector:@selector(callCropFunctionality) withObject:nil afterDelay:0.5];
    [self callCropFunctionality];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [ArtMap_DELEGATE setUserDefault:@"PresentModalYes" setObject:@"YES"];
     [self dismissViewControllerAnimated:YES completion:nil];
}



-(void) callCropFunctionality
{
    [self performSelectorOnMainThread:@selector(openEditor) withObject:nil waitUntilDone:YES];
}
- (void)openEditor
{
    
    
  //  cropController.delegate = self;
  //  cropController.image = IMG;
    
   UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    PECropViewController *crop =[storyBoard  instantiateViewControllerWithIdentifier:@"crop"];
    crop.image = IMG;
    crop.delegate=self;
       [self.navigationController pushViewController:crop animated:YES];
   // [self.navigationController presentViewController:crop animated:YES completion:nil];
    //[self presentViewController:picker animated:YES completion:nil];
   // UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cropController];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
//    }
   // [self.navigationController pushViewController:cropController animated:YES];
   // [self.navigationController presentViewController:cropController animated:YES completion:NULL];
   // [self presentViewController:crop animated:YES completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller.navigationController popToRootViewControllerAnimated:YES];
   // [controller dismissViewControllerAnimated:YES completion:NULL];
    [ArtMap_DELEGATE setUserDefault:@"PresentModalYes" setObject:@"YES"];
    
    [self resizeAndWritepathForImage:croppedImage];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [ArtMap_DELEGATE setUserDefault:@"PresentModalYes" setObject:@"YES"];
   // [controller dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void) resizeAndWritepathForImage :(UIImage*) otherImage
{
    [self.navigationController popToRootViewControllerAnimated:YES];

    //[self dismissModalViewControllerAnimated:YES];
   // resizeimg = [otherImage squareImageWithImage:otherImage scaledToSize:CGSizeMake(640,600)];
    //lingam
    resizeimg=[self resizeImage:otherImage];
    
    imagedataresize=UIImagePNGRepresentation(resizeimg);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    [imagedataresize writeToFile:filePath atomically:YES];
    [self Asktitle];
    
    
}

-(void) Asktitle    {
    
    titletxt.text=@"";
    [titletxt becomeFirstResponder];
    alertImage.image = resizeimg;
    view_alert.hidden=NO;
}

-(IBAction)mapPic:(id)sender
{
    [titletxt resignFirstResponder];
    view_alert.hidden=YES;
    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
    
    [self performSelector:@selector(imageUploadcall) withObject:nil afterDelay:0.1];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    /// alert for geo alert for upload
    
    if (alertView.tag==234 && buttonIndex==0)   {
        
        //nslog(@"settings ...");
        
        
      
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
        SettingsViewController *optionObj =[storyBoard  instantiateViewControllerWithIdentifier:@"settings"];
        [self.navigationController pushViewController:optionObj animated:YES];
    }
  
    if (alertView.tag==345 && buttonIndex==1){
        //nslog(@"yes original ");
        [self resizeAndWritepathForImage:IMG];
    }
    
}

-(void) imageUploadcall {
    
    if (titletxt.text.length>0)     {
        
        if (titletxt.text.length>140)  {
            
            limitedString=  [titletxt.text substringWithRange:NSMakeRange(0, 140)];
        }
        else  {
            
            limitedString=titletxt.text;
        }
       [self checkNetworkbeforeUpload];
        
        
    }
    else        {
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"Title is missing" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        [alt show];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [titletxt resignFirstResponder];
    return YES;
}

-(void) checkNetworkbeforeUpload
{
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected)  {
        
        [self singleImageUpload];
    }
    else{
        
        [SVProgressHUD dismiss];
        
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
    }
}

-(void) singleImageUpload
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
    
    NSDictionary *temp=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"lat\":\"%@\",\"lng\":\"%@\",\"image_title\":\"%@\",\"address\":\"%@\"}",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId],userLatitude,userLongitude ,[ArtMap_DELEGATE emptystr:limitedString],[ArtMap_DELEGATE emptystr:currentadds]]forKey:@"data"];
    
  
    
    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:ArtMapSigleimage]];
    [client setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:ArtMapSigleimage parameters:temp constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
       
        NSData *taxidata=[[NSData alloc]initWithContentsOfFile:filePath];
        [formData appendPartWithFileData:taxidata name:@"img" fileName:@"img.png" mimeType:@"image/png"];
    }];
    
    //[request setTimeoutInterval:10];
    
   // AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
        float percentageString = round(((float)totalBytesWritten/(float)totalBytesExpectedToWrite)*100);
        
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Saving...%i%%",(int)percentageString-1] maskType:SVProgressHUDMaskTypeGradient];
        
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [SVProgressHUD dismiss];
       
       
         NSDictionary *dict=[deleg convertToJSON:responseObject];
       
         
         NSString *statusString=[dict objectForKey:@"status"];
         
         if ([statusString isEqualToString:@"1"])
         {
             UIAlertView *Successalert=[[UIAlertView alloc] initWithTitle:@"MapShot" message:@"Picture mapped successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [Successalert show];
         }
         else
         {
             UIAlertView *Failurealert=[[UIAlertView alloc] initWithTitle:@"MapShot" message:@"Picture is not mapped" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
             [Failurealert show];
             
         }
         
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
           UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [SVProgressHUD dismiss];
          NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
         if(data!=nil)
         {
             id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSString *messageString=[json  objectForKey:@"message"];
             if(messageString==nil || [messageString isEqualToString:@""] || messageString==NULL)
             {
                 messageString=@"Please try uploading at some other time.";
             }
          
             errAlertView1.message = messageString;
             [errAlertView1 show];
         }
         else
         {
             errAlertView1.message = @"Internet connection is down.";
             [errAlertView1 show];

         }
         
     }];
    

    [client enqueueHTTPRequestOperation:operation];
}

#define radians(degrees) (degrees * M_PI/180)
-(UIImage*)resizeImage:(UIImage*)image
{
    int imagesize=3;
    
    CGSize size = CGSizeMake(image.size.width / (CGFloat)imagesize, image.size.height/(CGFloat)imagesize);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // If this is commented out, image is returned as it is.
    CGContextTranslateCTM( context, 0.5f * size.width, 0.5f * size.height ) ;
    CGContextRotateCTM( context, radians( 0 ) ) ;
    
   
    [ image drawInRect:(CGRect){ { -size.width * 0.5f, -size.height * 0.5f }, size } ] ;
    
    // [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}
-(void)hideKeyboard
{
    [titletxt resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
