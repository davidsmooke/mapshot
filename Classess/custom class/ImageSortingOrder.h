//
//  ImageSortingOrder.h
//  ArtMap
//
//  Created by sathish kumar on 11/28/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSortingOrder : NSObject
{
    
}
@property (nonatomic,retain) NSString  *address;
@property (nonatomic) NSUInteger       comments;
@property (nonatomic) NSUInteger       createdon;
@property (nonatomic) NSUInteger       imageid;
@property (nonatomic,retain) NSString  *imagepath;
@property (nonatomic,retain) NSString  *searchType;
@property (nonatomic,retain) NSString  *profilePath;
@property (nonatomic,retain) NSString  *UserProfilepath;
@property (nonatomic,retain) NSString  *imagename;
@property (nonatomic) NSUInteger       imagesize;
@property (nonatomic,retain) NSString  *imagetitle;
@property (nonatomic,retain) NSString  *imagetype;
@property (nonatomic) float            latitude;
@property (nonatomic) float            longitude;
@property (nonatomic) NSUInteger       userid;
@property (nonatomic) NSUInteger       likes;
@property (nonatomic) NSUInteger       totalsize;
@property (nonatomic) float            distance;

@property (nonatomic) NSUInteger       notificationid;
@property (nonatomic) NSUInteger       sentid;
@property (nonatomic,retain) NSString  *message;
@property (nonatomic,retain) NSString  *username;
@property (nonatomic) NSUInteger       status;
@property (nonatomic) NSUInteger       type;
@property (nonatomic,retain) NSString  *upload;
@property (nonatomic)  NSUInteger  currentUserImageLike;
@end
