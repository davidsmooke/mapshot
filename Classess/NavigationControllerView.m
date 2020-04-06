//
//  NavigationControllerView.m
//  referralHealth
//
//  Created by sathish kumar on 10/23/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import "NavigationControllerView.h"

@interface NavigationControllerView ()

@end

@implementation NavigationControllerView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
    {
       [ArtMap_DELEGATE applicationDidBecomeActive:[UIApplication sharedApplication]];
    }
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
