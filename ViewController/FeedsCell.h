//
//  FeedsCell.h
//  ArtMap
//
//  Created by Innoppl Technologies on 18/04/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> 

@interface FeedsCell : UITableViewCell
{
    UIButton *imageLikeBtn;
    UILabel *currentuserLikeLbl;
    UIImageView  *UploadedImageView;
   
    UILabel *noOfLikeLabel;
    UILabel *noOfCommentLabel;
    UILabel *likeTextShowLable;
    UILabel *commentTextShowLable;
}
@property (nonatomic,retain)  UIImageView  *UploadedImageView;
@property (nonatomic,retain)  UIButton     *imageLikeBtn;

@property (nonatomic,retain)  UILabel *noOfLikeLabel;
@property (nonatomic,retain)  UILabel *currentuserLikeLbl;
@property (nonatomic,retain)  UILabel *noOfCommentLabel;
@property (nonatomic,retain)  UILabel *commentTextShowLable;
@property (nonatomic,retain)  UILabel *likeTextShowLable;

@end
