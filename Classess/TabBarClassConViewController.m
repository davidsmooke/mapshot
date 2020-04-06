//
//  TabBarClassConViewController.m
//  WoundEZ
//
//  Created by sathish kumar on 10/4/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import "TabBarClassConViewController.h"

@interface TabBarClassConViewController ()

@end

@implementation TabBarClassConViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.tabBarItem.imageInsets = UIEdgeInsetsMake(50,20,-30,40);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   [self setSelectedIndex:1];
    self.delegate=self;
  
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbarSelection.png"]];
    
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
    {
     [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
     [self.tabBar setBarTintColor:[UIColor blackColor]];
    }

}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
        
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSString *userActiveState=[ArtMap_DELEGATE getUserDefault:ArtMapUserActive];
    
    if ([userActiveState isEqualToString:@"0"])
    {
        //  [item setSelectedIndex:4];
        
        UIAlertView *tempAlert=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"In deactive state you can't use your app" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [tempAlert show];
        return NO;
        
    }
    else
    {
        return YES;
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
