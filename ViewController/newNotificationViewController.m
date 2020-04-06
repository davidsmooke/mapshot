//
//  newNotificationViewController.m
//  ArtMap
//
//

#import "newNotificationViewController.h"
#import "MapViewController.h"
#import "JSON.h"
#import "FeedsCell.h"
#import "UIImageView+AFNetworking.h"
#import "ImageViewController.h"
#import "UserProfileViewController.h"
#import "FollowerViewController.h"

@interface newNotificationViewController ()
{
    UIImageView *  profilePhotoImageView;
    UILabel *tilteLbl;
    NSInteger tempsection;
}
- (void)loadTable;
@end

@implementation newNotificationViewController

NSArray *sortDescriptors;
NSMutableArray *listorderarr;
NSMutableArray *notifydetailarr;

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
     [self.view setBackgroundColor:[UIColor blackColor]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setUIDesign];
    });
    
    [super viewDidLoad];
}



-(void) setUIDesign  {
    
    UploadedImageFeedsTable.indicatorStyle=UIScrollViewIndicatorStyleWhite;
       
    UIImageView *titleimage=[[UIImageView alloc] init];
    [titleimage setImage:[UIImage imageNamed:@"homeTitleBackground.png"]];
    [self.view addSubview:titleimage];
    
    UILabel*  titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text=@"NewsFeed";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    [self.view addSubview:titleLabel];
    
    listorderarr = [[NSMutableArray alloc] init];
    
//    UploadedImageFeedsTable =[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 375) style:UITableViewStylePlain];
//    UploadedImageFeedsTable.backgroundColor=[UIColor blackColor];
    
//    UploadedImageFeedsTable.delegate=self;
//    UploadedImageFeedsTable.dataSource=self;
//    [self.view addSubview:UploadedImageFeedsTable];
    
    pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:UploadedImageFeedsTable withClient:self];
    
   // CGRect screensize=[[UIScreen mainScreen] bounds];
    
     titleLabel.frame=CGRectMake(80, 7, 150, 30);
     titleimage.frame=CGRectMake(0, 0,320,44);
//    if (screensize.size.height==568)   {
//        
//        UploadedImageFeedsTable.frame=CGRectMake(0, 44, 320, 465);
//       
//       
//    }
//    else if (screensize.size.height==480)   {
//        
//        UploadedImageFeedsTable.frame=CGRectMake(0, 44, 320, 480);
//        titleLabel.frame=CGRectMake(80, 7, 150, 30);
//        titleimage.frame=CGRectMake(0, 0,320,44);
//    }

    
}

-(void) viewWillAppear:(BOOL)animated{
    
  
    
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:YES];
    
    [self setNotiFicationVariableAndService];
   
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
}


-(void) setNotiFicationVariableAndService   {
    
    
    [listorderarr removeAllObjects];
    //[UploadedImageFeedsTable reloadData];
    
    startValue=0;
    reloads_ = 10;
    sectioncount=0;
    //UploadedImageFeedsTable.userInteractionEnabled=NO;
    
    
    [NSThread detachNewThreadSelector:@selector(getnotificationservice) toTarget:self withObject:nil];
    //[self performSelector:@selector(getnotificationservice) withObject:nil afterDelay:0.1];
    
}

-(void) getnotificationservice  {
    
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)  {
     
        // [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
         
//          callWebservice *get = [[callWebservice alloc] init];
//         get.delegate = self;
         
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        // [get GetNotificationService:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"Start_limit\":\"%d\"}",[ArtMap_DELEGATE emptystr:userid],startValue] forKey:@"data"]];
         
         NSDictionary *dict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"Start_limit\":\"%d\"}",[ArtMap_DELEGATE emptystr:userid],startValue] forKey:@"data"];
         
         AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ArtMApGetNotification]];
         [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
         
         NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ArtMApGetNotification parameters:dict];
         AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
         //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
         
         [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // [ArtMap_DELEGATE stopSpinner];
            
             // NSDictionary *JSON = [responseObject JSONValue];
             
             
             // NSDictionary *JSON=[ArtMap_DELEGATE convertToJSON:responseObject];
           
             if ([operation.response statusCode] == 200)
             {
                 NSInteger statusString=[[responseObject objectForKey:@"status"] integerValue];
                // NSString *messageString=[dic objectForKey:@"message"];
                 
                 if (statusString==1)
                 {
                     
                     notifydetailarr = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"list"]];
                     ////// //nslog(@"values in %@",notifydetailarr);
                     listorderarr = [[NSMutableArray alloc] init];
                     
                     for(NSDictionary *dictry in notifydetailarr)
                     {
                         ImageSortingOrder *order = [[ImageSortingOrder alloc] init];
                         
                         order.imageid = [[dictry objectForKey:@"image_id"] integerValue];
                         order.imagetitle = [dictry objectForKey:@"image_title"];
                         order.imagename=[dictry objectForKey:@"image_name"];
                         order.imagepath = [dictry objectForKey:@"upload_imagepath"];
                         
                         order.message = [dictry objectForKey:@"message"];
                         
                         order.UserProfilepath=[dictry objectForKey:@"profile_picturepath"];
                         order.userid=[[dictry objectForKey:@"user_id"] integerValue];
                         order.notificationid = [[dictry objectForKey:@"notification_id"] integerValue];
                         
                         
                         order.likes=[[dictry objectForKey:@"total_likes"] integerValue];
                         order.comments=[[dictry objectForKey:@"total_comments"] integerValue];
                         
                         
                         
                         order.currentUserImageLike=[[dictry objectForKey:@"current_user_status"]integerValue];
                         
                         [listorderarr addObject:order];
                     }
                     
                     
                     NSSortDescriptor *sortarr = [[NSSortDescriptor alloc] initWithKey:@"notificationid" ascending:NO];
                     sortDescriptors = [[NSArray alloc] initWithArray:[listorderarr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortarr]]];
                     
                     
                     
                     sectioncount=[listorderarr count];
                     
                     
                     [UploadedImageFeedsTable reloadData];
                     UploadedImageFeedsTable.userInteractionEnabled=YES;
                     [pullToRefreshManager_ tableViewReloadFinished];
                     
                   //  [SVProgressHUD dismiss];
                    //
                     
                 }
                 
                 else if (statusString==0)
                 {
                     sectioncount=[listorderarr count];
                     
                     startValue=startValue-10;
                     [UploadedImageFeedsTable reloadData];
                     UploadedImageFeedsTable.userInteractionEnabled=YES;
                     [pullToRefreshManager_ tableViewReloadFinished];
                     
                    // [SVProgressHUD dismiss];
                     
//                     UIAlertView *ErrorAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:[responseObject objectForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//                     [ErrorAlert show];
                     
                     
                 }
             }
             else
             {
                 // [self resignKeyboard];
                  UIAlertView *errAlertView1 = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 errAlertView1.message = [dict objectForKey:@"message"];
                 [errAlertView1 show];
                 
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // [ArtMap_DELEGATE stopSpinner];
             sectioncount=[listorderarr count];
             
             startValue=startValue-10;
             [UploadedImageFeedsTable reloadData];
             UploadedImageFeedsTable.userInteractionEnabled=YES;
             [pullToRefreshManager_ tableViewReloadFinished];
            // [SVProgressHUD dismiss];


            
         }];
         [operation start];

     }
     else{
      
   
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
    
     }
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    [pullToRefreshManager_ relocatePullToRefreshView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
    [pullToRefreshManager_ tableViewScrolled];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [pullToRefreshManager_ tableViewReleased];
}
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
   
   [self performSelector:@selector(loadTable) withObject:nil afterDelay:1.0f];
}



- (void)loadTable {
    
  
    startValue=startValue+10;
  
    [NSThread detachNewThreadSelector:@selector(getnotificationservice) toTarget:self withObject:nil];
    [self performSelector:@selector(getnotificationservice) withObject:nil afterDelay:0.2];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
    
    // Return the number of sections.
  
    
    if ([listorderarr count]==0)
    {
        return 1;
    }
    else
    {
    return sectioncount;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    
    // Return the number of rows in the section.
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if ([listorderarr count]==0)
    {
         return 0;
    }
    else
    {
        return 370;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    
    ImageSortingOrder *sortorder = (ImageSortingOrder*) [sortDescriptors objectAtIndex:section];
    
   
    
    NSString *profilePhotoUrl = [NSString stringWithFormat:@"%@/%@",ImagebaseUrl,sortorder.UserProfilepath];
  
//    dispatch_queue_t queue = dispatch_queue_create("Image Queue",NULL);
//    // dispatch_async(queue, ^(void) {
//    //130718 Lingam - Synchronous method getting image one by one orderly
//    dispatch_async(queue, ^{
//        
//      
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:profilePhotoUrl]];
//        UIImage *proimg = [UIImage imageWithData:imageData];
//        
//        //130718 Lingam - check if no image
//        if (!proimg)
//        {
//           
//            profilePhotoImageView.image=proimg;
//            [headerView addSubview:profilePhotoImageView];
//            return;
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                profilePhotoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 40, 40)];
//                profilePhotoImageView.backgroundColor=[UIColor clearColor];
//                profilePhotoImageView.image=proimg;
//                [headerView addSubview:profilePhotoImageView];
//            });
//        }
//    });

    NSURL *tempurl=[[NSURL alloc] initWithString:profilePhotoUrl];
    
    
    profilePhotoImageView=[[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 40, 40)];
    profilePhotoImageView.backgroundColor=[UIColor clearColor];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame=CGRectMake(0, 0, 40, 40);
    activityIndicator.center=profilePhotoImageView.center;
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
    [profilePhotoImageView addSubview:activityIndicator];
    
    
    if ([listorderarr count]!=0)
    {
        [headerView addSubview:profilePhotoImageView];
    }
    
    [profilePhotoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:tempurl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
         
         profilePhotoImageView.image = image;
        
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
         
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
     }];

   
    
    UIButton *customButton=[UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame=CGRectMake(7, 5, 40, 40);
    [customButton addTarget:self action:@selector(profileViewCall:) forControlEvents:UIControlEventTouchUpInside];
    customButton.tag=section;
     customButton.backgroundColor=[UIColor clearColor];
    [headerView addSubview:customButton];
    
    UIButton *customButtonTwo=[UIButton buttonWithType:UIButtonTypeCustom];
    customButtonTwo.frame=CGRectMake(65, 5, 70, 40);
    [customButtonTwo addTarget:self action:@selector(profileViewCall:) forControlEvents:UIControlEventTouchUpInside];
    customButtonTwo.tag=section;
    customButtonTwo.backgroundColor=[UIColor clearColor];
    [headerView addSubview:customButtonTwo];
    
    tilteLbl=[[UILabel alloc] initWithFrame:CGRectMake(71, 5, 230, 40)];
    tilteLbl.backgroundColor=[UIColor clearColor];
    tilteLbl.text=[NSString stringWithFormat:@"%@",sortorder.message];
    tilteLbl.textColor=[UIColor whiteColor];
    [tilteLbl setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [headerView addSubview:tilteLbl];
    
    
    if ([listorderarr count]==0)
    {
        tilteLbl.frame=CGRectMake(0, 5, 320, 40);
        tilteLbl.textAlignment=NSTextAlignmentCenter;
        customButton.hidden=YES;
        customButtonTwo.hidden=YES;
        tilteLbl.text=@"No activity found";
    }
    
    [headerView setBackgroundColor:[UIColor blackColor]];
   
    return headerView;
}
- (void)handleError:(NSError *)error
{
	UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Cannot load image"
                              message:[error localizedDescription]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    
	[alertView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"cell";
    FeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        //  cell = [[FeedsCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        cell = [[FeedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor=[UIColor blackColor];
  
   ImageSortingOrder *sortorder = (ImageSortingOrder*) [sortDescriptors objectAtIndex:indexPath.section];
    
    NSString *UserUplodedUrl = [NSString stringWithFormat:@"%@/uploads/large/%@",IMG_BASE_URL,sortorder.imagename];
    NSURL *tempurl=[[NSURL alloc] initWithString:UserUplodedUrl];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame=CGRectMake(0, 0, 40, 40);
    activityIndicator.center=cell.UploadedImageView.center;
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
   
       if ([listorderarr count]!=0)
    {
        [cell.UploadedImageView addSubview:activityIndicator];

    }

    [cell.UploadedImageView setImageWithURLRequest:[NSURLRequest requestWithURL:tempurl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
       
         cell.UploadedImageView.image = image;
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
     {
       
         [activityIndicator setHidden:YES];
         [activityIndicator stopAnimating];
     }];
    
    NSString *SenderVal=[NSString stringWithFormat:@"%d",indexPath.section];
    [ArtMap_DELEGATE setUserDefault:@"SenderValue" setObject:SenderVal];
    
    cell.UploadedImageView.userInteractionEnabled = YES;
  
   singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(singleTapFunction:)];
    singleTap.numberOfTapsRequired=1;
    cell.UploadedImageView.tag=indexPath.section;
    
    [cell.UploadedImageView addGestureRecognizer:singleTap] ;
    
    
    
    doubltTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFunction:)];
    doubltTap.numberOfTapsRequired=2;
   [cell.UploadedImageView addGestureRecognizer:doubltTap];
    
    [singleTap requireGestureRecognizerToFail:doubltTap];
    
    cell.noOfLikeLabel.text=[NSString stringWithFormat:@"%d likes",sortorder.likes];
    cell.noOfCommentLabel.text=[NSString stringWithFormat:@"%d comments",sortorder.comments];
  
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
	UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
	CGRect imageRect = CGRectMake(0.0f, 0.0f, size.width, size.height);
	[image drawInRect:imageRect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}


-(void)profileViewCall:(UIButton*) sender   {
    
 
  
    ImageSortingOrder *sortorder = (ImageSortingOrder*) [sortDescriptors objectAtIndex:sender.tag];
    NSString *notificationUserId=[NSString stringWithFormat:@"%d",sortorder.userid];
   
  
    
    
    NSString *userIdval=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
    
    [ArtMap_DELEGATE setUserDefault:ArtMapSecondaryuserid setObject:notificationUserId];
    
   if ([notificationUserId integerValue]==[userIdval integerValue])
    {
       ////// //nslog(@"call profile service ");
        
        
        for (UIViewController *uiview in self.navigationController.viewControllers)
        {
           ////// //nslog(@"uiviews in search is %@",uiview);
            if ([uiview isKindOfClass:[newNotificationViewController class]])
            {
               // AppDelegate *del=ArtMap_DELEGATE;
               // [del.tabbarObject setSelectedIndex:4];
               // [del.tabbarObject selectTab:4];
            }
            
            
        }
    }
    else
    {
         ////// //nslog(@"call Follower service ");
//        FollowerViewController *followerUserObj=[[FollowerViewController alloc] initWithNibName:@"FollowerViewController" bundle:nil];
//        [self.navigationController pushViewController:followerUserObj animated:YES];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
        FollowerViewController *follow =[storyBoard  instantiateViewControllerWithIdentifier:@"Followers"];
        //follow.hidesBottomBarWhenPushed=NO;
        [self.navigationController pushViewController:follow animated:YES];
    }
     
}

-(void) singleTapFunction:(UITapGestureRecognizer*) sender  {
   
   ////// //nslog(@"sigle tap %d",sender.view.tag);
    
    UIView *temp=sender.view;
    int sectionSelected=temp.tag;
   ////// //nslog(@"row value %d",row);
    
    NSMutableArray *filterArray = [[NSMutableArray alloc] init];
    
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
           ////// //nslog(@"sorting order in WRITE SUmTHING FUN %@",sortDescriptors);
            
            for (ImageSortingOrder *array in  sortDescriptors )
            {
               ////// //nslog(@"array value in for each  %@",array);
                
                float thefloat = array.distance;
                int roundedup = ceilf(thefloat);
                int value = roundedup/1609.34;
                if(value <= 1)
                {
                    ////nslog(@"maete %d",value);
                    [filterArray addObject:array];
                }
            }
        });
        
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    ImageViewController *imageobj =[storyBoard  instantiateViewControllerWithIdentifier:@"imageobj"];
        imageobj.hidesBottomBarWhenPushed=NO;
        imageobj.IMGArray = filterArray;
        
        ImageSortingOrder *imgobj=(ImageSortingOrder *)[sortDescriptors objectAtIndex:sectionSelected];
        
        NSString *smallUrlString=[NSString stringWithFormat:@"%@",imgobj.imagepath];
        NSData *SmallImageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:smallUrlString]];
        UIImage *smallImage=[[UIImage alloc] initWithData:SmallImageData];
        imageobj.imageview=smallImage;
        
       ////// //nslog(@"val in indiv dual view %@",imgobj.imagepath);
        NSURL *largeimageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/large/%@",IMG_BASE_URL,imgobj.imagename]];
        imageobj.uploadedImageUrl=largeimageUrl;
        imageobj.titlestr = imgobj.imagetitle;
    
        NSString *imageIdVal = [NSString stringWithFormat:@"%d",imgobj.imageid];
        [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:imageIdVal];
        [self.navigationController pushViewController:imageobj animated:YES];
}
-(void) doubleTapFunction:(UITapGestureRecognizer *)sender
{
     BOOL internet= [AppDelegate hasConnectivity];
    
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)  {
        
         UIView *temp=sender.view;
         sectionSelectedWhileDoubleTap=temp.tag;
         
         UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
         [im setImage:[UIImage imageNamed:@"globe.png"]];
         im.transform = CGAffineTransformScale(im.transform, 0.1, 0.1);
         
         CGRect screensize=[[UIScreen mainScreen] bounds];
         if (screensize.size.height==568)  {
             
             im.center = CGPointMake(160, 250);
         }
         else if (screensize.size.height==480)  {
             
             im.center = CGPointMake(160, 160);
         }
         
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
         
         ImageSortingOrder *imgobj=(ImageSortingOrder *)[sortDescriptors objectAtIndex:sectionSelectedWhileDoubleTap];
         NSString *imageId=[NSString stringWithFormat:@"%d",imgobj.imageid];
         NSInteger UserCurrentLikeOrNot=imgobj.currentUserImageLike;
         
         callWebservice *likes = [[callWebservice alloc] init];
         likes.delegate = self;
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         
         NSDictionary *dict;
         if (UserCurrentLikeOrNot==0)
         {
             ////// //nslog(@"LIKe");
             
             dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\",\"current_user_like_status\":\"1\"}",[ArtMap_DELEGATE emptystr:imageId],userid],@"data",@"1",@"islike", nil];
         }
         else if (UserCurrentLikeOrNot==1)
         {
             ////// //nslog(@"LIKe");
             dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"image_id\":\"%@\",\"user_id\":\"%@\",\"current_user_like_status\":\"0\"}",[ArtMap_DELEGATE emptystr:imageId],userid],@"data",@"0",@"islike", nil];
             
         }
         [likes performSelector:@selector(GreenLikes:) withObject:dict afterDelay:0.5];
     }
    
     else{
         
         UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
         [noInternetAlert show];
     }
}
-(void) didFinishLoading:(ASIHTTPRequest*)request
{
 
       
    NSDictionary *dic = [[request responseString] JSONValue];
 
    NSInteger status=[[dic objectForKey:@"status"] integerValue];
    
    if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"getnotification"]) {
        
        
        
    }
    else if ([[[request userInfo] objectForKey:@"action"] isEqualToString:@"imagelikes"])
    {
        //nslog(@"dic image likes  %@",dic);
        
        //[SVProgressHUD dismiss];
      
        if (status==2)  {
            
            
            
            ImageSortingOrder *order = (ImageSortingOrder*)[listorderarr objectAtIndex:sectionSelectedWhileDoubleTap];
            order.currentUserImageLike=[[dic objectForKey:@"current_user_like_status"] integerValue];
            order.likes=[[dic objectForKey:@"likes"] integerValue];
            
            FeedsCell *cell=(FeedsCell*)[UploadedImageFeedsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionSelectedWhileDoubleTap]];
            cell.noOfLikeLabel.text=[NSString stringWithFormat:@"%d likes",order.likes];
            
            //nslog(@"liked ");
        }
        else if (status==0)
        {
          
            
            ImageSortingOrder *order = (ImageSortingOrder*)[listorderarr objectAtIndex:sectionSelectedWhileDoubleTap];
            order.currentUserImageLike=[[dic objectForKey:@"current_user_like_status"] integerValue];
            order.likes=[[dic objectForKey:@"likes"] integerValue];
           
            FeedsCell *cell=(FeedsCell*)[UploadedImageFeedsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionSelectedWhileDoubleTap]];
             cell.noOfLikeLabel.text=[NSString stringWithFormat:@"%d likes",order.likes];
            //nslog(@"liked removed ");
          
        }
       }
}

-(void) didFailWithError:(ASIHTTPRequest*)request   {
    
   //  [SVProgressHUD dismiss];
   
    NSString *errorString=[NSString stringWithFormat:@"%@",[(NSError*)request.error localizedDescription]];
    
    UIAlertView *ErrorAlert=[[UIAlertView alloc] initWithTitle:@"Error Occured" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [ErrorAlert show];
}



- (void)didReceiveMemoryWarning
{
  
    [super didReceiveMemoryWarning];
}
@end
