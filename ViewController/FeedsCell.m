//
//  FeedsCell.m
//  ArtMap
//
//  Created by Innoppl Technologies on 18/04/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import "FeedsCell.h"


@implementation FeedsCell

@synthesize UploadedImageView;
@synthesize imageLikeBtn;
@synthesize noOfCommentLabel;
@synthesize noOfLikeLabel;
@synthesize likeTextShowLable;
@synthesize commentTextShowLable,currentuserLikeLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor blackColor]];
        
        UploadedImageView=[[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 300,300)];
        UploadedImageView.backgroundColor=[UIColor clearColor];
        UploadedImageView.contentMode=UIViewContentModeScaleAspectFit;
        UploadedImageView.userInteractionEnabled=YES;
        [self.contentView addSubview:UploadedImageView];
        
       noOfLikeLabel=[[UILabel alloc] initWithFrame:CGRectMake(60,302 , 50, 55)];
        noOfLikeLabel.backgroundColor=[UIColor clearColor];
        noOfLikeLabel.textColor=[UIColor whiteColor];
        noOfLikeLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        noOfLikeLabel.layer.shadowColor=[UIColor blackColor].CGColor;
        [self.contentView addSubview:noOfLikeLabel];
        [self.contentView bringSubviewToFront:noOfLikeLabel];
        
        
        noOfCommentLabel=[[UILabel alloc] initWithFrame:CGRectMake(180,302 , 80, 55)];
        noOfCommentLabel.backgroundColor=[UIColor clearColor];
        noOfCommentLabel.textColor=[UIColor whiteColor];
        noOfCommentLabel.font=[UIFont fontWithName:@"Helvetica" size:13];
        noOfCommentLabel.layer.shadowColor=[UIColor blackColor].CGColor;
        [self.contentView addSubview:noOfCommentLabel];
        [self.contentView bringSubviewToFront:noOfCommentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
