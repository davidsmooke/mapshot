
//
//  MapViewController.m
//  ArtMap
//
//  Created by sathish kumar on 10/1/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import "MapViewController.h"




@interface MapViewController ()
@end


@implementation MapViewController
@synthesize UserLocation;
@synthesize mapView;
@synthesize locationManager;
@synthesize requestQueue;
@synthesize isImageLocateMap;


BOOL isSearch;
BOOL didchange = NO;
//BOOL multiUploadFirst=YES;

BOOL regionWillChangeAnimatedCalled;
BOOL regionChangedBecauseAnnotationSelected;

MKMapRect previousRect;

int ttr;

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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setUIdesign];
    });    
   
   [super viewDidLoad];
   
}


-(void) setUIdesign
{
    
      errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    appdel = ArtMap_DELEGATE;
    [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];    

    
    imageArr = [[NSMutableArray alloc] initWithCapacity:40];
    imgUrl=[[NSMutableArray alloc] initWithCapacity:10];

    
    locationController=[[MyCLController alloc] init];
    locationController.delegate=self;
    [locationController.locationManager startUpdatingLocation];
   
    
    [ArtMap_DELEGATE setUserDefault:@"GEOSWITCHonORoff" setObject:@"SWITCH_ON"];
    [ArtMap_DELEGATE setUserDefault:ArtMap_GEOLOCATION setObject:@"YES"];
        
    UIAlertView *multiImageAlert=[[UIAlertView alloc] initWithTitle:@"Build Your Map" message:@"Share your favorite pictures" delegate:self cancelButtonTitle:@"Now" otherButtonTitles:@"Later", nil];
    multiImageAlert.tag=888;
    [multiImageAlert show];
    
    
    share=[[ShareCustomClass alloc] init];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
        // RHViewControllerDown();
        // [ArtMap_DELEGATE applicationDidBecomeActive:[UIApplication sharedApplication]];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden=YES;
    // [self.view addSubview:mapView];
    appdel=ArtMap_DELEGATE;
    //[appdel.tabbarObject ShowNewTabBar];
    
    
    BOOL internet= [AppDelegate hasConnectivity];
   
    BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected) {
        
      //  [self performSelector:@selector(callwebServicePushstatus) withObject:nil afterDelay:1.5];
        
        [self callwebServicePushstatus];
    }
    
    [self updatebadgecount];
    
    if (appdel.isImageLocate==YES)  {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setmapRegionFromImageView];
            
        });
        
    }
    else if(appdel.isFromSearchView==YES)   {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setMapRegionFromSearch];
            
        });
    }
    else {
        
        [self setMapRegionBasedOnGeo];
    }

    [super viewWillAppear:YES];
    
}

-(void) viewWillDisappear:(BOOL)animated    {
    
   // [mapView removeFromSuperview];
   // mapView = nil;
   
    [super viewWillDisappear:YES];
}



-(void) setMapRegionFromSearch  {
   
    defaults=[NSUserDefaults standardUserDefaults];
   
    if ([defaults dictionaryForKey:@"dictIsAvail"] != nil){
        
        NSDictionary *xdict=[defaults dictionaryForKey:@"dictIsAvail"];
        double latiValz=[[xdict objectForKey:@"latitudeFromSearch"] doubleValue];
        double longValz=[[xdict objectForKey:@"longitudeFromSearch"] doubleValue];
        
        UserLocation=CLLocationCoordinate2DMake(latiValz, longValz);
        region = MKCoordinateRegionMakeWithDistance(UserLocation, 900093.4400f, 900093.4400f);
        [mapView setRegion:region animated:YES];
        [mapView setZoomEnabled:YES];
        
        [defaults removeObjectForKey:@"dictIsAvail"];
    }
    appdel.isFromSearchView=NO;
}

-(void) setmapRegionFromImageView   {
  
    double latiValz=[[ArtMap_DELEGATE getUserDefault:@"Image_latitude"] doubleValue];
    double longValz=[[ArtMap_DELEGATE getUserDefault:@"Image_longitude"] doubleValue];
    
    UserLocation=CLLocationCoordinate2DMake(latiValz, longValz);
    region = MKCoordinateRegionMakeWithDistance(UserLocation, 16093.4400f, 16093.4400f);
    [mapView setRegion:region animated:YES];
    
    appdel.isImageLocate=NO;
}
-(void) setMapRegionBasedOnGeo      {
    
 
    
    if ([[ArtMap_DELEGATE getUserDefault:ArtMap_GEOLOCATION] isEqualToString:@"YES"])   {
        
       //NSLog(@"GEO enabled so location updating");
    }
    else if ([[ArtMap_DELEGATE getUserDefault:ArtMap_GEOLOCATION] isEqualToString:@"NO"])   {
        
        //nslog(@"GEO disabled so use USA map ");
        
        userLatitude=@"0.0000";
        userLongitude=@"0.0000";
        [locationController.locationManager stopUpdatingLocation];
        
        NSString *latitudeVa=@"39.809734";
        NSString *longitudeVa=@"-98.55562";
        double latiValz=[latitudeVa doubleValue];
        double longValz=[longitudeVa doubleValue];
        
        UserLocation=CLLocationCoordinate2DMake(latiValz, longValz);
        region = MKCoordinateRegionMakeWithDistance(UserLocation, 16093.4400f, 16093.4400f);
        [mapView setRegion:region animated:YES];
    }
}

-(void) callwebServicePushstatus    {
    
    NSString *userIdvalueX=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
//    callWebservice *web=[[callWebservice alloc] init];
//    web.delegate=self;
    NSDictionary *tempDict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\"}",userIdvalueX] forKey:@"data"];
    //[web Check_PushNotification_status:details];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:Artmap_check_push_status]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:Artmap_check_push_status parameters:tempDict];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       [SVProgressHUD dismiss];
        if ([operation.response statusCode] == 200)
        {

                NSString *statusVal=[responseObject objectForKey:@"status"];
                NSString *PushStatus=[responseObject objectForKey:@"push_status"];
                if ([statusVal isEqualToString:@"1"])
                {
                    [ArtMap_DELEGATE setUserDefault:ArtMapPushStatus setObject:PushStatus];
                }
        }
        else
        {
              UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            errAlertView1.message = [responseObject objectForKey:@"message"];
            [errAlertView1 show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD dismiss];
         NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
         UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        if(data!=nil)
        {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            NSString *messageString=[json  objectForKey:@"message"];
            errAlertView1.message = messageString;
            [errAlertView1 show];
        }
        else
        {
            errAlertView1.message = @"Internet connection is down.";
            [errAlertView1 show];
            
        }
        
    }];
    [operation start];

}

-(IBAction)shareMethod:(id)sender
{
    [ArtMap_DELEGATE Setscreenshot:[self captureView:mapView] forkey:ArtMapScreenShot];
    [ArtMap_DELEGATE  setUserDefault:@"screenShotName" setObject:@"Image Title"];
    [ArtMap_DELEGATE  setUserDefault:@"Share_Location" setObject:@"map"];
    
    
    [self presentViewController:[share ShareTapped] animated:YES completion:^{
        [share ShareTapped].view.superview.bounds = CGRectMake(0, 0, 250, 250);}];
}

- (UIImage *)captureView:(UIView *)view {
    
    CGRect screenRect = self.view.bounds;
   UIGraphicsBeginImageContextWithOptions(screenRect.size, 1, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [self.view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void) updatebadgecount    {
    
    memcount.text = [NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber]];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
        
       ///  first time multi  image upload
        if (alertView.tag==888 && buttonIndex==0){
        
            MultiImageUploadViewController *mulObj=[[MultiImageUploadViewController alloc] init];
            [self.navigationController pushViewController:mulObj animated:YES];
        }
        else if (alertView.tag==888 && buttonIndex==1)  {
            
        //nslog(@"you have clicked cancel ");
        }
}

#pragma mark - LocationController

- (void)locationUpdate:(CLLocation *)location {
    
    CLLocationCoordinate2D loc = location.coordinate;
    UserLocation = location.coordinate;
    
    region = MKCoordinateRegionMakeWithDistance(loc, 10000.0f, 10000.0f);
    [mapView setRegion:region];
    
    didchange=YES;
    [[locationController locationManager] stopUpdatingLocation];
}
- (void)locationError:(NSError *)error  {
    
    //nslog(@"location error %@",error);
}

#pragma MARK - MapView Annotation

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation  {
    
  
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
     
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    INAnnotation *pointCheck=(INAnnotation*)annotation;
    
    MKAnnotationView *annotationView =[mapview dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        if(annotationView==nil) {
       
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        }
        annotationView.tag = pointCheck.tag;
        annotationView.canShowCallout = YES;
     
        if(pointCheck.tag  != 1000)     {
            
            if(pointCheck.tag > 0)   {
                
                if ([imageArr count]>0)  {
                    
                 annotationView.image = [[imageArr objectAtIndex:pointCheck.tag] objectForKey:@"imageData"];
                }
                else{
                    //nslog(@"image array empty ...");
                }
            }
        }
        else{
            if(isUpload) {
                annotationView.image = [UIImage imageNamed:@"Pin.png"];
            }
        }
    
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(writeSomething:) forControlEvents:UIControlEventTouchUpInside];
         rightButton.tag =  pointCheck.tag;
         [rightButton setTitle:annotation.title forState:UIControlStateNormal];
         annotationView.rightCalloutAccessoryView = rightButton;
         annotationView.canShowCallout = YES;
         annotationView.draggable = YES;
         return annotationView;
}

#pragma mark -Go to individual image view 

-(void) writeSomething:(UIButton*)sender
{
    
    NSMutableArray *filterArray = [[NSMutableArray alloc] init];

    [AFHTTPClient cancelPreviousPerformRequestsWithTarget:self];
    [AFHTTPRequestOperation cancelPreviousPerformRequestsWithTarget:self];
       
    for (ImageSortingOrder *array in  SortArray )
    {
        float thefloat = array.distance;
        int roundedup = ceilf(thefloat);
        int value = roundedup/1609.34;
        if(value <= 1)
        {
            
            [filterArray addObject:array];
        }
    }

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    ImageViewController *imageobj =[storyBoard  instantiateViewControllerWithIdentifier:@"imageobj"];
        imageobj.IMGArray = filterArray;
    
    
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

#pragma mark - MApView Delegate

- (void)mapView:(MKMapView *)mapView1 didAddAnnotationViews:(NSArray *)views
{
    if(views.count<2)return;
   
    previousRect=[mapView1 visibleMapRect];
    [self performSelectorOnMainThread:@selector(imageProcess:) withObject:mapView1 waitUntilDone:YES];
}



-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
  
   
    regionWillChangeAnimatedCalled = YES;
    regionChangedBecauseAnnotationSelected = NO;
}

-(void)mapView:(MKMapView *)mapView1 regionDidChangeAnimated:(BOOL)animated
{
    
     if (!regionChangedBecauseAnnotationSelected) //note "!" in front
    {
        [self cancelRequest];
        
        MKMapRect r = [mapView1 visibleMapRect];
        region= MKCoordinateRegionForMapRect(r);
        
        MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(r), MKMapRectGetMidY(r));
        MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(r), MKMapRectGetMidY(r));
     
       // //nslog(@" east map %,west map value %f",eastMapPoint,westMapPoint);
        
        
        BOOL internet= [AppDelegate hasConnectivity];
       
        BOOL internetIsConnected=1;
        
        if (internet ==internetIsConnected) {
        
        
        [self ToptenimageService:[NSNumber numberWithFloat:(MKMetersBetweenMapPoints(eastMapPoint, westMapPoint)*0.000621371/2)]];
        }
        
        
        
        
    }
   
    //reset flags...
    regionWillChangeAnimatedCalled = NO;
    regionChangedBecauseAnnotationSelected = NO;
    
 }

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
     regionChangedBecauseAnnotationSelected = regionWillChangeAnimatedCalled;
     [self cancelRequest];
    
    if(view.tag != 1000)
    {
        
        if([imageArr count]> 0)
        {
            view.image = [[imageArr objectAtIndex:view.tag] objectForKey:@"highlightedimage"];
        }
    }
}
- (void)mapView:(MKMapView *)mapView1 didDeselectAnnotationView:(MKAnnotationView *)view
{
    
    
    if(view.tag != 1000)
    {
        
        
        if([imageArr count]> 0)
        {
            view.image = [[imageArr objectAtIndex:view.tag] objectForKey:@"imageData"];

            [self performSelectorOnMainThread:@selector(imageProcess:) withObject:mapView1 waitUntilDone:YES];
        }
    }
}

#pragma mark -top ten webservice 

-(void) ToptenimageService:(NSNumber*)dist  {
    
    NSString *lat = [NSString stringWithFormat:@"%f",region.center.latitude];
     NSString *lon  =[NSString stringWithFormat:@"%f",region.center.longitude];
    
    [self GetTopTenImages:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"lat\":\"%@\",\"lng\":\"%@\",\"distance\":\"%f\" }",[ArtMap_DELEGATE emptystr:lat],[ArtMap_DELEGATE emptystr:lon],[dist floatValue]] forKey:@"data"]];
}

-(void) GetTopTenImages:(NSDictionary*)topten
{
    previousRect=mapView.visibleMapRect;
  
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[topten objectForKey:@"data"], @"data",nil];
    //nslog(@"check dict in GetTopTenImages  %@",params);
   
    NSURL *url = [NSURL URLWithString:ArtMapTopimages];
    AFHTTPClient *httpClient =  [AFHTTPClient clientWithBaseURL:url];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];

    [httpClient postPath:@"." parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //nslog(@"response STRING %@",[responseStr JSONValue ]);
   
        
        NSArray *arr = [[responseStr JSONValue] objectForKey:@"info"];
        
        //nslog(@"array in response in tep ten sevice %@",arr);
        
        comparearr = [NSMutableArray arrayWithCapacity:arr.count];
        
        for(NSDictionary *dic in arr)
        {
           
            
            int Totalsize = [[dic objectForKey:@"comments"] intValue] * 10 + [[dic objectForKey:@"likes"] intValue] * 2 + 90;
            
            ImageSortingOrder *sort = [[ImageSortingOrder alloc] init];
            sort.address = [dic objectForKey:@"address"];
            sort.comments = [[dic objectForKey:@"comments"] integerValue];
            sort.createdon = [[dic objectForKey:@"created_on"] integerValue];
            sort.imageid = [[dic objectForKey:@"image_id"] integerValue];
            sort.imagename = [dic objectForKey:@"image_name"];
         
            sort.imagepath = [dic objectForKey:@"image_path"];
             ///sep 17
         //   sort.imagesize = [[dic objectForKey:@"image_size"] integerValue];
            
            sort.imagetitle = [dic objectForKey:@"image_title"];
            sort.imagetype = [dic objectForKey:@"image_type"];
            sort.latitude = [[dic objectForKey:@"latitude"] integerValue];
            sort.longitude = [[dic objectForKey:@"longitude"] integerValue];
            sort.likes = [[dic objectForKey:@"likes"] integerValue];
            
                   
            if(sort.distance)
            {
                sort.distance = [[dic objectForKey:@"distance"] floatValue];
            }
            sort.userid = [[dic objectForKey:@"user_id"] integerValue];
           
            sort.totalsize = Totalsize;
            
            
            [comparearr addObject:sort];
        }
      
        NSSortDescriptor *sortdest = [[NSSortDescriptor alloc] initWithKey:@"totalsize" ascending:YES];
      
        SortArray = [[NSArray alloc] initWithArray:[comparearr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortdest]]];
        
//        [progressView setCaption:@""];
//        [progressView setActivity:NO];
//        [progressView update];
//        [progressView hideAfter:0.5];
        
        [self downloadImg:[responseStr JSONValue]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [progressView setCaption:@""];
//        [progressView setActivity:NO];
//        [progressView update];
//        [progressView hideAfter:0.5];
        
        //nslog(@"%d [HTTPClient Error]: %@", ttr,error.localizedDescription);
    }];
    
   
}

#pragma mark -response from web service




#pragma mark -image download functionalty

-(void) downloadImg:(NSDictionary*)responseDict
{
    
[ASINetworkQueue cancelPreviousPerformRequestsWithTarget:self];

    
    
    imagedictionary = [[NSDictionary alloc] initWithDictionary:responseDict];
   
    [requestQueue cancelAllOperations];
    requestQueue = [ASINetworkQueue queue];
    [[self requestQueue] setDelegate:self];
    [requestQueue setRequestDidFinishSelector:@selector(Finished:)];
    [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
    [requestQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    [imgUrl removeAllObjects];
    [SVProgressHUD dismiss];
    
    NSArray *arrayLoc = [imagedictionary objectForKey:@"info"];
    
   for (NSDictionary *dictVal in arrayLoc) {
        
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",IMG_BASE_URL,[dictVal objectForKey:@"image_path"]];
    NSString* escapedUrlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    // //nslog(@"img url for testing %@",escapedUrlString);
        [imgUrl addObject:escapedUrlString];
       
       ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
       [request setTimeOutSeconds:160];
      [request setUserInfo:[NSDictionary dictionaryWithObject:dictVal forKey:@"data"]];
       // [request setDidFinishSelector:@selector(Finished:)];
        [[self requestQueue] addOperation:request];
        
    }
    [[self requestQueue] go];
}
- (void)Finished:(ASIHTTPRequest *)request
{
   
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[[request userInfo] objectForKey:@"data"] copyItems:YES];
 
    @autoreleasepool {
    
    UIImage *orgImg = [[UIImage alloc] initWithData:[request responseData]];
    CGFloat TotalSize= [[NSString stringWithFormat:@"%@",[dict objectForKey:@"total"]] floatValue];

        if(TotalSize==0) TotalSize=130.0f;
   
    UIImage *resizeImg = [UIImage imageWithImage:orgImg  scaledToWidth:TotalSize alpha:0.4f];
    UIImage *resizeImg2 = [UIImage imageWithImage:orgImg  scaledToWidth:TotalSize alpha:1.0f];
    
    [dict setValue:resizeImg forKey:@"imageData"];
    [dict setValue:resizeImg2 forKey:@"highlightedimage"];
        
    [dict setValue:orgImg forKey:@"OriginalImage"];
   
        if (imageArr.count>=40)   {
            
             [imageArr removeObjectAtIndex:0];
             [imageArr addObject:dict];
        }
        else{
            
            [imageArr addObject:dict];
        }
       
        /* if ([[self requestQueue] requestsCount] == 0)
       {
        CLLocationCoordinate2D curentLoc;
        region = MKCoordinateRegionMakeWithDistance(curentLoc,  16093.4400f,  16093.4400f);
     
      }*/
        
    }
    
   

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //nslog(@"fal %@",[(NSError*)[request error] localizedDescription]);
   
    if ([[self requestQueue] requestsCount] == 0)
    {
       
    }
   
}
#pragma Image Download on NetworkQueue 

- (void)queueFinished:(ASINetworkQueue *)queue
{
       if ([[self requestQueue] requestsCount] == 0) {
    }
    
    if ([imageArr count]>0) {
        
        NSMutableDictionary *duplicatesRemovedArray=[[NSMutableDictionary alloc]init];
        for (NSDictionary *dic in imageArr)  {
            
            [duplicatesRemovedArray setValue:dic forKey:[NSString stringWithFormat:@"%@",[dic objectForKey:@"image_id"]]];
        }
        [imageArr removeAllObjects];
        
        for (NSString *key in [duplicatesRemovedArray allKeys])  {
          
            [imageArr addObject:[duplicatesRemovedArray objectForKey:key]];
        }
      
        
        [imageArr sortUsingComparator:^NSComparisonResult(id a,id b){
            NSDictionary *dict1=(NSDictionary*)a;
            NSDictionary *dict2=(NSDictionary*)b;
            
            
            if([(UIImage*)[dict1 valueForKey:@"imageData"] size].width>[(UIImage*)[dict2 valueForKey:@"imageData"] size].width) return NSOrderedAscending;
            else if([(UIImage*)[dict1 valueForKey:@"imageData"] size].width<[(UIImage*)[dict2 valueForKey:@"imageData"] size].width) return NSOrderedDescending;
            
            return NSOrderedSame;
            
        }];
        
        [self removeAnnotation];
        [self addAnnotationToMapView];
    }
    else  {
      //  //nslog(@"image array count zero");
    }
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // [searchfield resignFirstResponder];
}



#pragma Custom Label 
-(UILabel*) customLabel:(NSString*)str initFrame:(CGRect)frame totallines:(int)lines
{
	UILabel *customLabel = [[UILabel alloc] initWithFrame:frame];
    customLabel.adjustsFontSizeToFitWidth = YES;
    customLabel.text = str;
    customLabel.numberOfLines = lines;
    customLabel.backgroundColor=[UIColor clearColor];
    customLabel.font=[UIFont fontWithName:@"Helvetica"size:12.0];
    customLabel.textColor=[UIColor whiteColor];
    
	return customLabel;
}

#pragma Custom TextField

-(UITextField*) customTextfield:(NSString*)fieldType textName:(NSString*)str initFrame:(CGRect)frame
{
    UITextField *customField = [[UITextField alloc] initWithFrame:frame];
	customField.delegate = self;
	customField.adjustsFontSizeToFitWidth = NO;
	customField.borderStyle = UITextBorderStyleRoundedRect;
	customField.clearButtonMode = UITextFieldViewModeWhileEditing;
	customField.clearsOnBeginEditing = NO;
	customField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	customField.autocorrectionType = UITextAutocorrectionTypeNo;
	customField.enablesReturnKeyAutomatically = YES;
	customField.returnKeyType = UIReturnKeyDefault;
	customField.placeholder = NSLocalizedString(str, nil);
	customField.keyboardType = UIKeyboardTypeDefault;
    customField.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    customField.textColor = [UIColor blackColor];
    customField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    customField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
	return customField;
}

#pragma TextField Delegate


- (void)didReceiveMemoryWarning 
{
    //nslog(@"did receive memory warning ooooo");
    [self resetAll];
    [super didReceiveMemoryWarning];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0f);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    for(int i=0;i<views.count;i++)  {
      
    MKAnnotationView *ann1=(MKAnnotationView*)[views objectAtIndex:i];
    [annotations removeObject:ann1];
        
      for(MKAnnotationView *ann2 in annotations)  {
            
            CGRect rect;
            
            if(CGRectIntersectsRect(ann1.frame, ann2.frame))
            {
                
              rect=CGRectIntersection(ann1.frame, ann2.frame);
              CGRect remainder, slice,remainder1,slice1;
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
    //NSLog(@"annotation val %@ clipper height %f width %f",ann,clipper.origin.x,clipper.origin.y);
    if(CGRectIsEmpty(clipper))
    {
        return;
    }
    
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:clipper];
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
    UIGraphicsEndImageContext();
    //CGContextRelease(context);
   
}

-(void)resetAll
{
   // requestQueue=nil;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [imageArr removeAllObjects];
    SortArray=nil;
    imagedictionary=nil;
    [imgUrl removeAllObjects];
   
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


@end
