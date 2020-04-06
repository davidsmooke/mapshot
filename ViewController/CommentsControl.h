//
//  CommentsControl.h
//  ArtMap
//
//  Created by sathish kumar on 11/16/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsControl : NSObject
{
    
}
@property(nonatomic) NSInteger  commentid;
@property(nonatomic) NSInteger  commentliks;
@property(nonatomic) NSInteger  commentuid;
@property(nonatomic) NSInteger  createdon;
@property(nonatomic) NSInteger  imageid;
@property(nonatomic) NSUInteger iscommentlike;

@property(nonatomic,retain) NSString *comments;
@property(nonatomic,retain) NSString *prfimg;

@end
