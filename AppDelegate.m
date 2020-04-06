//
//  AppDelegate.m
//  MapShot
//
//  Created by Innoppl Technologies on 20/11/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <CFNetwork/CFNetwork.h>
#import "Reachability.h"
#import "UncaughtExceptionHandler.h"
#import "PMTLogger.h"

#import "MTLog.h"


#define FB_ACCESS_TOKEN       @"FBAccessTokenKey"
#define FB_EXPIRATION_DATE    @"FBExpirationDateKey"
#define FB_LOGINNAME          @"FBLoginName"


@implementation AppDelegate
@synthesize isImageLocate,isFromSearchView;
@synthesize faceBookAccount;

@synthesize  logStartTimer;
@synthesize fbGraph;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self openingScreen];
    
    [self.window makeKeyAndVisible];
    
    InstallUncaughtExceptionHandler();
    
    logStartTimer = [[NSMutableDictionary alloc] init];
    [logStartTimer setValue:[NSDate date] forKey:LS_START_SESSIONTIME];
    [logStartTimer setValue:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] forKey:LS_APP_LIVESESSIONTIME];
    
    static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    PMTLogger *logger = [[PMTLogger alloc] init];
	    [logger logAppInstallInfo:@""];
        [logger createLogFile:LS_XMPP_FilePath];
	});
    
       
    Screenshotdic = [[NSMutableDictionary alloc] init];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
   
    
    return YES;
}


-(void)openingScreen
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    
    if ([ArtMap_DELEGATE getUserDefault:ArtMap_UserId]!=nil)
    {
        self.tabBarCon = [storyboard instantiateViewControllerWithIdentifier:@"tabBarStoryBoardId"];
        self.window.rootViewController = self.tabBarCon;
        
          NSString *userActiveState=[self getUserDefault:ArtMapUserActive];
        
        if ([userActiveState isEqualToString:@"0"])
        {
          [self.tabBarCon setSelectedIndex:4];
        }
    }
    else
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
        SignInViewController *SignIn =[storyBoard  instantiateViewControllerWithIdentifier:@"naviID"];
        self.window.rootViewController = SignIn;
    }
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
   
    __block UIBackgroundTaskIdentifier bgTask = 0;
    
    
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if ([application backgroundTimeRemaining] > 1.0) {
          
            PMTLogger *logger = [[PMTLogger alloc] init];
            [logger logAppInstallInfo:@"close"];
            [PMTLogger logHistoryUpdateServer:[logStartTimer objectForKey:LS_START_SESSIONTIME]];
        }
    });
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [logStartTimer setValue:[NSDate date] forKey:LS_START_SESSIONTIME];
        [logStartTimer setValue:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] forKey:LS_APP_LIVESESSIONTIME];
        
        PMTLogger *logger = [[PMTLogger alloc] init];
        [logger logAppInstallInfo:@"open"];
        [logger createLogFile:LS_XMPP_FilePath];
        [PMTLogger cleanSession];
        
    });

    
    [self processInfoLog:testOk messageString:@""];
    [self processInfoLog:testOk messageString:[NSString stringWithFormat:@"test case"]];
    [self processInfoLog:testOk messageString:nil];
    
    
    application.applicationIconBadgeNumber = 0;
    NSString *userIdVal=[ArtMap_DELEGATE getUserDefault:ArtMap_UserId];
    if (userIdVal!=nil)
    {
    UIAlertView *errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    NSDictionary *tempDict=[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"{\"user_id\":\"%@\"}",userIdVal] forKey:@"data"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:ArtMap_Push_Reset]];
    [httpClient setAuthorizationHeaderWithUsername:ArtMapAuthenticationUsername password:ArtMapAuthenticationPassword];
    
    NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"POST" path:ArtMap_Push_Reset parameters:tempDict];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc]initWithRequest:urlRequest];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
            errAlertView.message = [responseObject objectForKey:@"message"];
            //[errAlertView show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //[ArtMap_DELEGATE stopSpinner];
         //  NSLog(@"response in options %@",[operation responseString]);
         NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSString *messageString=[json  objectForKey:@"message"];
          UIAlertView *errAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         errAlertView.message = messageString;
         [errAlertView show];
         
     }];
    [operation start];

    }
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
    {
        [self.window.rootViewController.view  setFrame:CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20)];
    }
}

+ (void)setStatusbar
{
    if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
    {
//        [self.window.rootViewController.view  setFrame:CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20)];
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE())
    {
        [self.window.rootViewController.view  setFrame:CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height-20)];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

# pragma mark - APNS Delegate

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken
{
    NSString *mytoken = [[_deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    mytoken = [mytoken stringByReplacingOccurrencesOfString:@" " withString:@""];
    

    [ArtMap_DELEGATE setUserDefault:ArtMapDeviceToken setObject:mytoken];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
      [application setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
    
}

+ (BOOL) hasConnectivity
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    if (reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}


-(NSString *)emptystr:(NSString *)txt
{
    //nslog(@"text value %@",txt);
    
    if ([txt isEqualToString:@"(null)"])
    {
        return @"";
    }
    if(txt)
    {
        return txt;
    }
    else
    {
        return @"";
    }
}

#pragma mark - FB/INSTA HANDLEURL
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  
    return nil;
      //  return [self.session handleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
    return nil;
      //  return [self.session handleOpenURL:url];
}


-(void) setTwitImg:(UIImage*)img    {
    
    twitterImg = [img copy];
}


-(NSDictionary*)convertToJSON:(id)data{
    NSError *err;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: &err];
    return JSON;
}


- (void)setUserDefault:(NSString*)key setObject:(NSString*)myString
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:myString forKey:key];
		[standardUserDefaults synchronize];
	}
}

-(id)getUserDefaults:(NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id Val = nil;
    Val = [userDefaults objectForKey:key];
    return Val;
}



- (NSString*) getUserDefault:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults)
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}
- (void)setUserDefault:(NSString*)key setImage:(UIImage *)myImage
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:myImage forKey:key];
		[standardUserDefaults synchronize];
	}
}
-(void) Setscreenshot:(UIImage*)arr forkey:(NSString*)key
{
    [Screenshotdic setObject:arr forKey:key];
}
-(UIImage*) Getscreenshot:(NSString*)key
{
    return [Screenshotdic objectForKey:key];
}



#pragma Log Manager

- (void) processInfoLog:(NSString*)name messageString:(NSString*)string{
    
  NSString *logFilePath = [LS_Log_Folder stringByAppendingPathComponent:name];
    
   // NSLog(@"logFilePath %@",logFilePath);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
        NSString *logString = [NSString stringWithFormat:@"\n\n------------------  %@ : %@ -------------------- \n\n",name , [self now]];
        
       // NSLog(@"log string (1) is %@",logString);
        
        [logString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [logStartTimer setValue:[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] forKey:name];
        
    }else if (string == nil) {
        
        NSString *logString = [NSString stringWithFormat:@"\n-------------------------------------------------------------------------------------------------\n"];
        
      //  NSLog(@"log string is (2) %@",logString);
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[NSString stringWithFormat:@"%@", logString] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
        
        NSString *data = [NSString stringWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:NULL];
    
        TSLog(@"%@",data);
        
        [logStartTimer removeObjectForKey:name];
        NSError *error;
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:logFilePath]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:logFilePath error:&error];
            if (!success) {
                
            }
        }
    }else{
        startInterval = [[logStartTimer objectForKey:name] doubleValue];
        stopInterval = [NSDate timeIntervalSinceReferenceDate];
        elapsedTime = stopInterval - startInterval;
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[NSString stringWithFormat:@"=====> elapsedTime : %.2f - %@ \n",elapsedTime , string] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

- (NSString*) now{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    return [formatter stringFromDate:[NSDate date]];
}



@end
