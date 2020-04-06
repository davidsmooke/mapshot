//
//  FollowListViewController.m
//  ArtMap
//
//

#import "FollowListViewController.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "UserProfileViewController.h"
#import "FollowerViewController.h"


@interface FollowListViewController ()

@end

@implementation FollowListViewController
@synthesize followno;
@synthesize userOrFolloUser;

NSString *sameUserID;

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
    progressView = [[ATMHud alloc] initWithDelegate:self];
	[[ArtMap_DELEGATE window] addSubview:progressView.view];
    
    self.navigationController.navigationBar.tintColor=[UIColor clearColor];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imageView.image=[UIImage imageNamed:@"homeTitleBackground.png"];
    self.navigationItem.titleView=imageView;
    
    listTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 37, 320, 480) style:UITableViewStylePlain];
    listTableView.scrollEnabled=YES;
    listTableView.delegate=self;
    listTableView.dataSource=self;
    listTableView.backgroundColor=[UIColor blackColor];
    listTableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:listTableView];
    
    UIImageView *titleimage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,320,37)];
    [titleimage setImage:[UIImage imageNamed:@"homeTitleBackground.png"]];
    [self.view addSubview:titleimage];
    
    
    UILabel *titleLabel=[[UILabel alloc] init];
    titleLabel.frame=CGRectMake(110, 2,100, 30);
    titleLabel.backgroundColor=[UIColor clearColor];
    
    if (followno ==101) {
         titleLabel.text=@"Followers";
    }
    if (followno==102)
    {
         titleLabel.text=@"Following";
    }
    
   
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    UIButton *custombackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    custombackButton.frame=CGRectMake(10, 3, 70, 30);
    [custombackButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [custombackButton setBackgroundColor:[UIColor clearColor]];
    [custombackButton addTarget:self action:@selector(CancelFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:custombackButton];
    
    
    [self fetchList];
    
    [super viewDidLoad];
    
    
    //*-------Custom Progress View---------
    
    
	// Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
     appDel=ArtMap_DELEGATE;
    if(appDel.isFromSearchView==YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
    self.navigationController.navigationBarHidden=YES;
   
    [super viewWillAppear:YES];
}


-(void) fetchList
{
    [self performSelector:@selector(Getfollow) withObject:nil afterDelay:0.5];
    
}

#pragma mark- follow webservice

-(void) Getfollow
{
     BOOL internet= [AppDelegate hasConnectivity];
  
     BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)
     {
         [progressView setFixedSize:CGSizeMake(150, 150)];
         [progressView setCaption:@"Loading Please wait..."];
         [progressView setActivity:YES];
         [progressView setBlockTouches:NO];
         [progressView show];

         
         
         callWebservice *get = [[callWebservice alloc] init];
         get.delegate  = self;
         
         NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
         
         if ([userOrFolloUser isEqualToString:@"fromUserProfile"])   {
             
             ////nslog(@"from current  profile ");
             if(followno == 101)     {
                 
                 // //nslog(@"followers service called ");
                 [get GetfollowService:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"prfl_view_id\":\"\",\"followerfollow\":\"follower\"}",userid] forKey:@"data"]];
             }
             if (followno==102)      {
                 
                 ////nslog(@"following  service called ");
                 [get GetfollowService:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"prfl_view_id\":\"\",\"followerfollow\":\"follow\"}",userid] forKey:@"data"]];
             }
         }
         
         if ([userOrFolloUser isEqualToString:@"followUserprofile"])     {
             
             //  //nslog(@"from follower profile ");
             NSString *secuserid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMapSecondaryuserid]];
             
             if(followno == 101)     {
                 
                 //  //nslog(@"followers service called ");
                 [get GetfollowService:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"prfl_view_id\":\"%@\",\"followerfollow\":\"follower\"}",userid,secuserid] forKey:@"data"]];
             }
             if (followno==102)      {
                 
                 ////nslog(@"following  service called ");
                 [get GetfollowService:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"prfl_view_id\":\"%@\",\"followerfollow\":\"follow\"}",userid,secuserid] forKey:@"data"]];
             }
         }

         
         
     }
     else{
     
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
          [noInternetAlert show];
    
     
     }

         
}

-(void)CancelFunction   {
    
    arr = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

-(void) FollowAction:(id) sender    {
    
    
    BOOL internet= [AppDelegate hasConnectivity];
      BOOL internetIsConnected=1;
    
    if (internet ==internetIsConnected)
    {
    
        //*-------Custom Progress View---------*/
        [progressView setFixedSize:CGSizeMake(150, 150)];
        [progressView setCaption:@"Please wait..."];
        [progressView setActivity:YES];
        [progressView setBlockTouches:NO];
        [progressView show];
        ////nslog(@"sender %d",[sender tag]);
        
        int isFollow = [[[arr objectAtIndex:[sender tag]] objectForKey:@"follow_status"] intValue];
        ////nslog(@"while click isfollow button %d",isFollow);
        
        if(isFollow == 0)   {
            
            // //nslog(@"READY TO FOLLOW");
            callWebservice *follow = [[callWebservice alloc] init];
            follow.delegate = self;
            NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
            NSString *followerUserid = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:[sender tag]] objectForKey:@"id"]];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"follow_id\":\"%@\",\"status\":\"1\"}",userid,followerUserid],@"data",@"1",@"isfollow", nil];
            [follow performSelector:@selector(FollowService:) withObject:dict afterDelay:0.5];
        }
        else if(isFollow == 1)  {
            
            // //nslog(@"READY TO unFOLLOW");
            callWebservice *follow = [[callWebservice alloc] init];
            follow.delegate = self;
            NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
            NSString *followerUserid = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:[sender tag]] objectForKey:@"id"]];
            //nslog(@"SEC  Remove%@",followerUserid);
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"{\"user_id\":\"%@\",\"follow_id\":\"%@\",\"status\":\"0\"}",userid,followerUserid],@"data",@"0",@"isfollow" ,nil];
            [follow performSelector:@selector(FollowService:) withObject:dict afterDelay:0.5];
        }

        
    }
    else{
        
        UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noInternetAlert show];
    }
}

#pragma mark- resonse from backend

-(void) didFinishLoading:(ASIHTTPRequest*)request   {
    
    //  //nslog(@"Get follow service %@",[[request responseString] JSONValue]);
    NSDictionary *resdict = [[request responseString] JSONValue];
    
    if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"getfollow"])
    {
        
        if([resdict objectForKey:@"followers"])
        {
            //nslog(@"response dict  followers %@",[resdict objectForKey:@"followers"]);
            
            if ([[resdict   objectForKey:@"followers"] isKindOfClass:[NSArray class]])
            {
                //nslog(@"array class");
                arr = [[NSMutableArray alloc] initWithArray: [resdict   objectForKey:@"followers"] ];
                
            }
            else
            {
                //nslog(@"string  class");
                
                [arr removeAllObjects];
                
            }
        }
        
        
        
        if([resdict objectForKey:@"following"])
        {
            //nslog(@"response dict  following %@",[resdict objectForKey:@"following"]);
            
            if ([[resdict   objectForKey:@"following"] isKindOfClass:[NSArray class]])
            {
                //nslog(@"array class");
                arr = [[NSMutableArray alloc] initWithArray: [resdict   objectForKey:@"following"] ];
                
            }
            else
            {
                //nslog(@"string  class");
                [arr removeAllObjects];
                
            }
        }
        
        [progressView setCaption:@"Success.."];
        [progressView setActivity:NO];
        [progressView update];
        [progressView hideAfter:0.5];
        
        [listTableView reloadData];
        
    }
    
    
    
    if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"follow"])
    {
        //nslog(@"follow service while button tomfollow or unfollow RESPONSE  %@",[[request responseString] JSONValue]);
        
        [progressView setCaption:@"Success.."];
        [progressView setActivity:NO];
        [progressView update];
        [progressView hideAfter:0.5];
        
        [self performSelector:@selector(Getfollow) withObject:nil afterDelay:0.1];
        
        [listTableView reloadData];
    }
}
-(void) didFailWithError:(ASIHTTPRequest*)request
{
    //nslog(@"error occured in %@",request.error);
    [progressView setCaption:@"Success.."];
    [progressView setActivity:NO];
    [progressView update];
    [progressView hideAfter:0.5];

    
}
#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor blackColor];
    
    // Configure the cell...
    
    if (followno==101)
    {
        sameUserID = [[arr objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        
        if([sameUserID isEqualToString:userid])
        {
            cell.textLabel.text = @"Me";
        }
        if(![sameUserID isEqualToString:userid])
        {
            cell.textLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"username"];
        }
    }
    
    
    if (followno==102)
    {
        cell.textLabel.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"username"];
        
        sameUserID= [[arr objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        
        if([sameUserID isEqualToString:userid])    {
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 50, 30)];
            lbl.text = @"Me";
            [cell.contentView addSubview:lbl];
            
            
        }
        if(![sameUserID isEqualToString:userid])
        {
            
            UIButton *followbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            followbtn.frame = CGRectMake(220, 7, 80, 26);
            followbtn.backgroundColor=[UIColor grayColor];
            [[followbtn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            [followbtn addTarget:self action:@selector(FollowAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:followbtn];
            
            int isFollow = [[[arr objectAtIndex:indexPath.row] objectForKey:@"follow_status"] intValue];
            
            if (isFollow == ART_FOLLOWSTATUS_FOLLOW)    {
                
                [followbtn setTitle:@"UnFollow" forState:UIControlStateNormal];
                
                [followbtn setTag:indexPath.row];
            }
            else if(isFollow == ART_FOLLOWSTATUS_UNFOLLOW)  {
                
                [followbtn setTitle:@"Follow" forState:UIControlStateNormal];
                [followbtn setTag:indexPath.row];
            }
        }
        
    }
    
   
   cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:18];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arr count] >0)
    {
        
        //nslog(@"array in did select %@",[[arr objectAtIndex:indexPath.row] objectForKey:@"id"]);
        
        NSString *userid = [NSString stringWithFormat:@"%@",[ArtMap_DELEGATE getUserDefault:ArtMap_UserId]];
        NSString *secondaryUserId=[[arr objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        //nslog(@"curent user %@ second user %@ ",userid,secondaryUserId);
        
        [ArtMap_DELEGATE setUserDefault:ArtMapSecondaryuserid setObject:secondaryUserId];
        
        if([userid isEqualToString:secondaryUserId])   {
            
            for(UIViewController *uiview in self.navigationController.viewControllers)
            {
                //nslog(@"view controllers are %@",uiview);
                
                if ([uiview isKindOfClass:[UserProfileViewController class]])
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
//                else if ([uiview isKindOfClass:[HomeViewController class]])
//                {
//                    
//                   // [appDel.tabbarObject selectTab:4];
//                    
//                }
                
            }
        }
        else {
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
            FollowerViewController *followerUserObj =[storyBoard  instantiateViewControllerWithIdentifier:@"Followers"];
           // FollowerViewController *follow = [[FollowerViewController alloc] initWithNibName:@"FollowerViewController" bundle:nil];
            appDel=ArtMap_DELEGATE;
            followerUserObj.hidesBottomBarWhenPushed=NO;
            [self.navigationController pushViewController:followerUserObj animated:YES];
        }
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
