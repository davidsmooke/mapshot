//
//  defaultTheme.h
//  referralHealth
//
//  Created by Innoppl Technologies on 14/08/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>


#define storyBoardName (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? @"Main_iPad" : @"Main_iPhone")

#define selfViewWidth   self.view.frame.size.width
#define selfViewHeight   self.view.frame.size.height

#define MAPDELEGA        ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// fonts related

#define txtColor              [UIColor whiteColor]
#define bdrColor      [UIColor colorWithRed:0.0351 green:0.328 blue:0.687 alpha:1.000]
#define ColorWithOrange   [UIColor colorWithRed:195.0/255.0 green:63.0/255.0 blue:7.0/255.0 alpha:1]
#define ColorWithGray   [UIColor colorWithRed:86.0/255.0 green:86.0/255.0 blue:86.0/255.0 alpha:1]
#define fontType               @"Helvetica"
#define fontTypeBold               @"Helvetica-Bold"

#define navigationBarTitleHome   @"MapShot"
#define navigationBarTitleMap @"MapShot"


#define RHViewControllerDown()     [self.view setFrame:CGRectMake(0, 20, selfViewWidth, selfViewHeight-20)];

#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)

