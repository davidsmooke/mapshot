//
//  APActivityProvider.m
//  ArtMap
//
//  Created by Innoppl Technologies on 05/06/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import "APActivityProvider.h"

@implementation APActivityProvider

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    NSString *imageTitle=[ArtMap_DELEGATE getUserDefault:@"screenShotName"];
    NSString *TwitterName=[ArtMap_DELEGATE getUserDefault:@"Share_DialogueName"];
    NSString *locationName=[ArtMap_DELEGATE getUserDefault:@"Share_Location"];
    
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
    {
        
        NSString *urlStr=@"https://www.facebook.com/MapShotApp";
        NSString *twitterString;
        if ([locationName isEqualToString:@"profile"])
        {
            twitterString=[NSString stringWithFormat:@"%@'s #MapShot %@",TwitterName,urlStr];
        }
        else if([locationName isEqualToString:@"map"])
        {
            twitterString=[NSString stringWithFormat:@"New App to See the World, #MapShot! %@",urlStr];
        }
        else
        {
            twitterString=[NSString stringWithFormat:@"'%@' by %@ in %@ #MapShot %@",imageTitle,TwitterName,@"",urlStr];
        }
        
        return twitterString;
    }
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
    {
        NSString *urlStr=@"https://www.facebook.com/MapShotApp";
        NSString *faceBookString;
        
        if ([locationName isEqualToString:@"profile"])
        {
            faceBookString=[NSString stringWithFormat:@"%@'s #MapShot %@",TwitterName,urlStr];
        }
        else if([locationName isEqualToString:@"map"])
        {
            faceBookString=[NSString stringWithFormat:@"New App to See the World, #MapShot! %@",urlStr];
        }
        else
        {
            faceBookString=[NSString stringWithFormat:@"'%@' by %@ in %@ #MapShot %@",imageTitle,TwitterName,@"",urlStr];
        }
        return faceBookString;
    }
    if ( [activityType isEqualToString:UIActivityTypeMail] )
    {
        
        NSString *urlStr=@"https://www.facebook.com/MapShotApp";
        NSString *faceBookString;
        if ([locationName isEqualToString:@"profile"])
        {
            faceBookString=[NSString stringWithFormat:@"%@'s #MapShot %@",TwitterName,urlStr];
        }
        else if([locationName isEqualToString:@"map"])
        {
            faceBookString=[NSString stringWithFormat:@"New App to See the World, #MapShot! %@",urlStr];
        }
        else
        {
            faceBookString=[NSString stringWithFormat:@"'%@' by %@ in %@ #MapShot %@",imageTitle,TwitterName,@"",urlStr];
        }
        return faceBookString;

    }
    
    if ( [activityType isEqualToString:@"UIActivityTypePostToInstagram"] )
    {
        
        NSString *urlStr=@"https://www.facebook.com/MapShotApp";
        NSString *instagramString=[NSString stringWithFormat:@"'%@' by %@ in %@ #MapShot %@",imageTitle,TwitterName,locationName,urlStr];
       return instagramString;
    }
        
    return nil;
}
- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }

@end
