//
//  searchNewImageViewController.m
//  ArtMap
//
//

#import "searchNewImageViewController.h"
#import "MapViewController.h"
#import "JSON.h"
#import "ImageSortingOrder.h"
#import "ImageViewController.h"

@interface searchNewImageViewController ()
{
    AppDelegate *appdel;
}

@end

@implementation searchNewImageViewController
@synthesize srchtext;
@synthesize keyText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    deleg = MAPDELEGA;
    errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [sbar setBackgroundImage:[UIImage new]];
    [sbar setTranslucent:YES];
    searchListTable.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    searchListTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setUIdesign];
    });
    
     [super viewDidLoad];
}

-(void) setUIdesign
{
    keyText=@"default";
}


-(void) viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden=YES;
    
     appdel=ArtMap_DELEGATE;
    // [appdel.tabbarObject ShowNewTabBar];
     sbar.hidden=NO;
    
    [segmentedControl addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
     [self performSelector:@selector(SearchFunction) withObject:nil afterDelay:0.1];
    [super viewWillAppear:YES];
}
-(void) viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:YES];
}
-(void) viewWillDisappear:(BOOL)animated
{
    sbar.hidden=YES;
    [super viewWillDisappear:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [sbar resignFirstResponder];
    
    [self performSelector:@selector(showProgressBarafterDelay) withObject:nil afterDelay:0.3];
    
    [searchlistarr removeAllObjects];
    [searchListTable reloadData];
   
    [self performSelector:@selector(SearchFunction) withObject:nil afterDelay:0.4];
}

-(void) showProgressBarafterDelay
{
     [self setProgressBar];
}


-(void) setProgressBar
{
     [SVProgressHUD showWithStatus:@"Please Wait..." maskType:SVProgressHUDMaskTypeGradient];
}

-(void) hideProgressBar
{
    [SVProgressHUD dismiss];
}


-(void) pickOne:(id)sender
{
   
    [sbar resignFirstResponder];

    [self setProgressBar];
    
    [searchlistarr removeAllObjects];
    [searchListTable reloadData];
    
    
    UISegmentedControl *segmentedControl1 = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl1.selectedSegmentIndex;
  
    if (selectedSegment == 0) {
        keyText=@"default";
      
    }
    else if(selectedSegment==1)
    {
        keyText=@"title";
    }
    else if(selectedSegment==2)
    {
        keyText=@"location";

    }
    else
    {
        keyText=@"user";
    }
  [self performSelector:@selector(SearchFunction) withObject:nil afterDelay:0.1];
}

-(void) chanageSegmentByButton:(UIButton*) sender
{

    
//    [allButton setBackgroundImage:(sender.tag==11)?[UIImage imageNamed:@"SearchSelectedSegButton .png"]:Nil forState:UIControlStateNormal];
//    [TitleButton setBackgroundImage:(sender.tag==12)?[UIImage imageNamed:@"SearchSelectedSegButton .png"]:Nil forState:UIControlStateNormal];
//    [LocationButton setBackgroundImage:(sender.tag==13)?[UIImage imageNamed:@"SearchSelectedSegButton .png"]:Nil forState:UIControlStateNormal];
//    [userButton setBackgroundImage:(sender.tag==14)?[UIImage imageNamed:@"SearchSelectedSegButton .png"]:Nil forState:UIControlStateNormal];
    
    [sbar resignFirstResponder];
    
    switch (sender.tag)
    {
        case 11:
           
            [self setProgressBar];
            
            keyText=@"default";
            [self performSelector:@selector(SearchFunction) withObject:nil afterDelay:0.1];
            break;
        case 12:
           
              [self setProgressBar];
            
                       
            keyText=@"title";
            [self performSelector:@selector(SearchFunction) withObject:nil afterDelay:0.1];
            break;
        case 13:
           
            
             [self setProgressBar];
            
                        
            keyText=@"location";
            [self performSelector:@selector(SearchFunction) withObject:nil afterDelay:0.1];
            break;
        case 14:
            
           
             [self setProgressBar];
           
            
            keyText=@"user";
            
            [self performSelector:@selector(SearchFunction) withObject:nil afterDelay:0.1];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - SearchWebservice

-(void) SearchFunction
{
    searchListTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine; 
    BOOL internet= [AppDelegate hasConnectivity];
    BOOL internetIsConnected=1;
     
     if (internet ==internetIsConnected)
     {
        srchtext=sbar.text;
        callWebservice *search = [[callWebservice alloc] init];
        search.delegate = self;
        [search SearchImagebyTitle:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"title\":\"%@\",\"search_by\":\"%@\"}",[ArtMap_DELEGATE emptystr:srchtext],keyText] forKey:@"data"]];
     }
     else
     {
     
    [self hideProgressBar];
     
     UIAlertView *noInternetAlert=[[UIAlertView alloc] initWithTitle:@"No Internet." message:@"Internet connection is down." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [noInternetAlert show];
    
     }
}

-(void) didFinishLoading:(ASIHTTPRequest*)request
{
    if([[[request userInfo] objectForKey:@"action"] isEqualToString:@"searchimage"])    {
        
    NSDictionary *dic = [[request responseString] JSONValue];
   // NSString *message = [dic objectForKey:@"message"];
    searchResultArray=[[NSMutableArray alloc] init];
        
    if([[dic objectForKey:@"status"] intValue] == 1)    {
            
        [SVProgressHUD dismiss];
            
        if ([[dic objectForKey:@"type"] isEqualToString:@"default"]){
                        
        searchlistarr = [[NSMutableArray alloc] init];
        searchlistarrLOCATION = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"location"]];
            
                        
                    for (NSDictionary *dict in searchlistarrLOCATION)   {
                        
                        ImageSortingOrder *sortorder=[[ImageSortingOrder alloc] init];
                        sortorder.latitude=[[dict objectForKey:@"latitude"] floatValue];
                        sortorder.longitude=[[dict objectForKey:@"longitude"] floatValue];
                        sortorder.address=[dict objectForKey:@"address"];
                        sortorder.searchType=[dict objectForKey:@"type"];
                        
                        [searchlistarr addObject:dict];
                            
                        [searchResultArray addObject:sortorder];
                    }
             
                searchlistarrLOCATIONImages=[[NSMutableArray alloc] initWithArray:[dic objectForKey:@"location_images_info"]];
                
                for (NSDictionary *dict in searchlistarrLOCATIONImages)   {
                    
                    ImageSortingOrder *sortorder=[[ImageSortingOrder alloc] init];
                   
                    sortorder.address=[dict objectForKey:@"address"];
                    sortorder.createdon=[[dict objectForKey:@"create_date"] integerValue];
                    sortorder.imageid=[[dict objectForKey:@"image_id"] integerValue];
                    sortorder.imagename=[dict objectForKey:@"image_name"];
                    sortorder.imagepath=[dict objectForKey:@"image_path"];
                    sortorder.imagetitle=[dict objectForKey:@"image_title"];
                    
                    sortorder.searchType=[dict objectForKey:@"type"];
                    
                    sortorder.userid=[[dict objectForKey:@"user_id"] integerValue];
                    sortorder.username=[dict objectForKey:@"username"];
                    
                
                    
                    [searchlistarr addObject:dict];
                    [searchResultArray addObject:sortorder];
                }
                
                
                
                
                
            searchlistarrUSER = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"user"]];
                                 
                    for (NSDictionary *dict in searchlistarrUSER)   {
                            
                        ImageSortingOrder *sortorder=[[ImageSortingOrder alloc] init];
                        sortorder.userid=[[dict objectForKey:@"user_id"] integerValue];
                        sortorder.username=[dict objectForKey:@"username"];
                        sortorder.profilePath=[dic objectForKey:@"profile_path"];
                         sortorder.searchType=[dict objectForKey:@"type"];
                        
                         [searchlistarr addObject:dict];
                        [searchResultArray addObject:sortorder];
                            
                    }
                
                searchlistarrTITLE = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"titles"]];
           
                
                for (NSDictionary *dict in searchlistarrTITLE)   {
                    
                    ImageSortingOrder *sortorder=[[ImageSortingOrder alloc] init];
                    sortorder.createdon=[[dict objectForKey:@"create_date"] integerValue];
                    sortorder.imageid=[[dict objectForKey:@"image_id"] integerValue];
                    sortorder.imagename=[dict objectForKey:@"image_name"];
                    sortorder.imagepath=[dict objectForKey:@"image_path"];
                    sortorder.imagetitle=[dict objectForKey:@"image_title"];
                    sortorder.userid=[[dict objectForKey:@"user_id"] integerValue];
                    sortorder.username=[dict objectForKey:@"username"];
                    sortorder.latitude=[[dict objectForKey:@"latitude"] floatValue];
                   
                    sortorder.longitude=[[dict objectForKey:@"longitude"] floatValue];
                    sortorder.address=[dict objectForKey:@"address"];
                    sortorder.searchType=[dict objectForKey:@"type"];
                    
                    [searchlistarr addObject:dict];
                    [searchResultArray addObject:sortorder];
                }
            
            
            
            
                       
            }
            else if ([[dic objectForKey:@"type"] isEqualToString:@"title"]){
            
                
                    searchlistarr = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"info"]];
                
                
                        for (NSDictionary *dict in searchlistarr)   {
                    
                            ImageSortingOrder *sortorder=[[ImageSortingOrder alloc] init];
                            sortorder.createdon=[[dict objectForKey:@"create_date"] integerValue];
                    
                            sortorder.imageid=[[dict objectForKey:@"image_id"] integerValue];
                            sortorder.imagename=[dict objectForKey:@"image_name"];
                            sortorder.imagepath=[dict objectForKey:@"image_path"];
                            sortorder.imagetitle=[dict objectForKey:@"image_title"];
                            sortorder.userid=[[dict objectForKey:@"user_id"] integerValue];
                            sortorder.username=[dict objectForKey:@"username"];
                            sortorder.latitude=[[dict objectForKey:@"latitude"] floatValue];
                            sortorder.longitude=[[dict objectForKey:@"longitude"] floatValue];
                            sortorder.address=[dict objectForKey:@"address"];
                            sortorder.searchType=[dict objectForKey:@"type"];
                    
                            [searchResultArray addObject:sortorder];
                        }
            }
            else  if ([[dic objectForKey:@"type"] isEqualToString:@"location"]) {
            
                searchlistarr = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"info"]];
                
                
                          for (NSDictionary *dict in searchlistarr)   {
                    
                                ImageSortingOrder *sortorder=[[ImageSortingOrder alloc] init];
                 
                                sortorder.latitude=[[dict objectForKey:@"latitude"] floatValue];
                                sortorder.longitude=[[dict objectForKey:@"longitude"] floatValue];
                                sortorder.address=[dict objectForKey:@"address"];
                                sortorder.searchType=[dict objectForKey:@"type"];
                    
                                [searchResultArray addObject:sortorder];
                          }
            }
            else  if ([[dic objectForKey:@"type"] isEqualToString:@"user"]){
                
               
                searchlistarr = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"info"]];
              
                
                    for (NSDictionary *dict in searchlistarr)   {
                        
                        ImageSortingOrder *sortorder=[[ImageSortingOrder alloc] init];
                        sortorder.userid=[[dict objectForKey:@"user_id"] integerValue];
                        sortorder.username=[dict objectForKey:@"username"];
                    sortorder.profilePath=[dic objectForKey:@"profile_path"];
                    sortorder.searchType=[dict objectForKey:@"type"];

                        [searchResultArray addObject:sortorder];
                    }
            }
        }
        else if([[dic objectForKey:@"status"] intValue] == 2)   {
            
            [SVProgressHUD dismiss];
            
            return;
        }
        else if([[dic objectForKey:@"status"] intValue] == 0)   {
            
            [SVProgressHUD dismiss];
            return;
        }
        
               
        
    [searchListTable reloadData];

}
    
}
-(void) didFailWithError:(ASIHTTPRequest*)request
{
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [searchlistarr count];
   

  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell != nil)
        cell = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor blackColor];
    
   if ([keyText isEqualToString:@"default"])
   {
       
        NSString *typeCheck=[[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"type"];
       
        if ([typeCheck isEqualToString:@"location"])    {
           
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 30)];
            lbl.text = @"Location";
            lbl.textColor=[UIColor whiteColor];
            lbl.backgroundColor=[UIColor blackColor];
            lbl.font=[UIFont fontWithName:@"Helvetica" size:20];
            [cell.contentView addSubview:lbl];
            
            
            
            UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 30)];
            lbl2.text = [[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"address"];
            lbl2.textColor=[UIColor whiteColor];
            lbl2.backgroundColor=[UIColor blackColor];
            lbl2.font=[UIFont fontWithName:@"Helvetica" size:20];
            [cell.contentView addSubview:lbl2];
        }
     
        else if ([typeCheck isEqualToString:@"user"])       {
           
            AsyncImageView *imageview = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ImagebaseUrl,[[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"profile_path"]]];
            [imageview loadImageFromURL:url];
            [cell.contentView addSubview:imageview];
            
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
            lbl.text = [[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"username"];
            lbl.textColor=[UIColor whiteColor];
            lbl.backgroundColor=[UIColor blackColor];
            lbl.font=[UIFont fontWithName:@"Helvetica" size:17];
            [cell.contentView addSubview:lbl];
            
        }
       
        else if ([typeCheck isEqualToString:@"title"] ||  [typeCheck isEqualToString:@"location_images"])      {
        
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 180, 30)];
            lbl.text = [[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"image_title"];
            lbl.textColor=[UIColor whiteColor];
            lbl.backgroundColor=[UIColor blackColor];
            lbl.font=[UIFont fontWithName:@"Helvetica" size:17];
            [cell.contentView addSubview:lbl];
            
            AsyncImageView *imageview = [[AsyncImageView alloc] initWithFrame:CGRectMake(250, 5, 50, 50)];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ImagebaseUrl,[[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"image_path"]]];
            [imageview loadImageFromURL:url];
            [cell.contentView addSubview:imageview];

        }

    }
    else  if ([keyText isEqualToString:@"title"])  {
        
        
         AsyncImageView *imageview = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
         NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ImagebaseUrl,[[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"image_path"]]];
         [imageview loadImageFromURL:url];
         [cell.contentView addSubview:imageview];
        
         UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
         lbl.text = [[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"image_title"];
         lbl.textColor=[UIColor whiteColor];
         lbl.backgroundColor=[UIColor blackColor];
         lbl.font=[UIFont fontWithName:@"Helvetica" size:17];
         [cell.contentView addSubview:lbl];
         
    }
    else if ([keyText isEqualToString:@"location"])
    {
        
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 30)];
        lbl.text = @"Location";
        lbl.textColor=[UIColor whiteColor];
          lbl.backgroundColor=[UIColor blackColor];
        lbl.font=[UIFont fontWithName:@"Helvetica" size:20];
        [cell.contentView addSubview:lbl];
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 30)];
        lbl2.text = [[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"address"];
        lbl2.textColor=[UIColor whiteColor];
        lbl2.backgroundColor=[UIColor blackColor];
        lbl2.font=[UIFont fontWithName:@"Helvetica" size:20];
        [cell.contentView addSubview:lbl2];
    }
    else if ([keyText isEqualToString:@"user"])     {
        
        
        AsyncImageView *imageview = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",ImagebaseUrl,[[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"profile_path"]]];
        [imageview loadImageFromURL:url];
        [cell.contentView addSubview:imageview];
        
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
        lbl.text = [[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"username"];
        lbl.textColor=[UIColor whiteColor];
        lbl.backgroundColor=[UIColor blackColor];
        lbl.font=[UIFont fontWithName:@"Helvetica" size:17];
        [cell.contentView addSubview:lbl];
        
        
    }
    cell.textLabel.backgroundColor=[UIColor blackColor];
    cell.textLabel.textColor=[UIColor whiteColor];

    cell.selectionStyle=UITableViewCellAccessoryNone;
   return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *typeCheck=[[searchlistarr objectAtIndex:indexPath.row] objectForKey:@"type"];
    
    if ([typeCheck isEqualToString:@"title"] || [typeCheck isEqualToString:@"location_images"])
    
    {
       
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
        ImageViewController *imageobj =[storyBoard  instantiateViewControllerWithIdentifier:@"imageobj"];
       
        imageobj.IMGArray = searchResultArray;
        
        ImageSortingOrder *sortOrder=(ImageSortingOrder*) [searchResultArray objectAtIndex:indexPath.row];
        
      
        
        NSURL *largeimageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@/uploads/large/%@",IMG_BASE_URL,sortOrder.imagename]];
        imageobj.uploadedImageUrl=largeimageUrl;
        imageobj.titlestr =[NSString stringWithFormat:@"%@",sortOrder.imagetitle] ;
        NSString *detstr = [NSString stringWithFormat:@"%d",sortOrder.imageid];
        [ArtMap_DELEGATE setUserDefault:ArtMap_detail setObject:detstr];
        
        [self.navigationController pushViewController:imageobj animated:YES];
        
        
       
    }
    else if ([typeCheck isEqualToString:@"location"])
    {
    NSMutableDictionary *latlonaddArray=[[NSMutableDictionary alloc] init];
        
        ImageSortingOrder *sortOrder=(ImageSortingOrder*) [searchResultArray objectAtIndex:indexPath.row];
        
        
        [latlonaddArray setValue:[NSString stringWithFormat:@"%f",sortOrder.latitude] forKey:@"latitudeFromSearch"];
        [latlonaddArray setValue:[NSString stringWithFormat:@"%f",sortOrder.longitude] forKey:@"longitudeFromSearch"];
        [latlonaddArray setValue:sortOrder.address forKey:@"addressFromSearch"];
        
        NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
        [Defaults setObject:latlonaddArray forKey:@"dictIsAvail"];
        [Defaults synchronize];
        
        appdel.isFromSearchView=YES;
        [self.tabBarController setSelectedIndex:1];
    }
    else if ([typeCheck isEqualToString:@"user"])
    {
       
        
        ImageSortingOrder *sortOrder=(ImageSortingOrder*) [searchResultArray objectAtIndex:indexPath.row];
       
        NSString *searchReasultUserId=[NSString stringWithFormat:@"%d",sortOrder.userid];
        
        NSString *userIdval=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
        
        [ArtMap_DELEGATE setUserDefault:ArtMapSecondaryuserid setObject:searchReasultUserId];
        
        if ([searchReasultUserId integerValue]==[userIdval integerValue])
        {
            
            
            for (UIViewController *uiview in self.navigationController.viewControllers)
            {
               
                if ([uiview isKindOfClass:[MapViewController class]])
                {
                 
                     [self.tabBarController setSelectedIndex:4];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                if ([uiview isKindOfClass:[searchNewImageViewController class]])
                {
                     [self.tabBarController setSelectedIndex:4];
                  
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
        else
        {
            
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
            FollowerViewController *followerUserObj =[storyBoard  instantiateViewControllerWithIdentifier:@"Followers"];
          
            [self.navigationController pushViewController:followerUserObj animated:YES];
        }
   
        
    }
    

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  //  if(textField == searchfield)
    //    [searchfield resignFirstResponder];
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}
-(void)hideKeyboard
{
    [sbar resignFirstResponder];

}

-(void) viewDidDisappear:(BOOL)animated
{
    sbar.hidden=YES;
    [super viewDidDisappear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}
@end

