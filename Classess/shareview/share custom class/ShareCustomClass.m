//
//  ShareCustomClass.m
//  ArtMap
//
//  Created by Innoppl Technologies on 07/06/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import "ShareCustomClass.h"
@implementation ShareCustomClass

-(UIActivityViewController*) ShareTapped{
    
    
    DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
   
    
    NSArray *applicationActivities = @[instagramActivity];
    APActivityProvider *ActivityProvider = [[APActivityProvider alloc] init];
   
    UIImage *img = [ArtMap_DELEGATE Getscreenshot:ArtMapScreenShot];
  
   
    NSArray *Items = @[ActivityProvider,img];
    
    UIActivityViewController *ActivityView = [[UIActivityViewController alloc] initWithActivityItems:Items applicationActivities:applicationActivities];
   
    [ActivityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact,UIActivityTypePrint,
     UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeCopyToPasteboard]];
    
    return ActivityView;
}

@end
