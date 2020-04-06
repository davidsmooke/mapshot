//
//  CommentsControl.h
//  ArtMap
//
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
