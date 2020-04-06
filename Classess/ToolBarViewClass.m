//
//  ToolBarViewClass.m
//  Vestify
//
//  Created by Innoppl Technologies on 09/07/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import "ToolBarViewClass.h"

@implementation ToolBarViewClass
@synthesize delegate;
@synthesize customTitleString;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self)
    {
		UIImageView *titleImageView = [[UIImageView alloc]init];

		[titleImageView setImage:[UIImage imageNamed:@"homeTitleBackground.png"]];
		[self addSubview:titleImageView];

		CGRect screenSize = [[UIScreen mainScreen]bounds];
		if (screenSize.size.height == 480)
        {
			titleImageView.frame = CGRectMake(0, 0, 320, 44);
		}
		else if (screenSize.size.height == 568) {
			titleImageView.frame = CGRectMake(0, 0, 320, 44);
		}

		titleLabel = [[UILabel alloc]init];
		titleLabel.frame = CGRectMake(60, 4, 200, 32);
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont fontWithName:fontTypeBold size:18.0];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.textColor = txtColor;
		[self addSubview:titleLabel];
       
		backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(8, 6, 60, 30);
		backButton.backgroundColor = [UIColor clearColor];
		backButton.tag = 600;
        [backButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(buttontappedback:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:backButton];


		logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
		logoutButton.frame = CGRectMake(260, 6, 50, 30);
		logoutButton.tag = 700;
        [logoutButton setTitle:@"Done" forState:UIControlStateNormal];
		[[logoutButton titleLabel] setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:6]];
		[logoutButton addTarget:self action:@selector(buttontappedTop:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:logoutButton];
	}
	return self;
}



- (void)buttontappedback:(UIButton *)sender {
	[[self delegate] backButtonAction:sender];
}

- (void)buttontappedTop:(UIButton *)sender {
	[[self delegate] logoutBtnAction:sender];
}

- (void)setTilteForTopRight:(NSString *)tiltleStringValue {
	
}

- (void)setTilte:(NSString *)tiltleStringValue {
	titleLabel.text = tiltleStringValue;
}
- (void)setImageAsTitle:(NSString *)imageName {
    [titleLabel setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:imageName]]];
}

- (void)setRightImage:(NSString *)imageName {
	[logoutButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)removeDraftButton:(BOOL)removeBoolen {
	if (removeBoolen == YES) {
		[logoutButton removeFromSuperview];
	}
}
- (void)removeBackButton:(BOOL)removeBoolen {
	if (removeBoolen == YES) {
		[backButton removeFromSuperview];
	}
}

- (void)setFrameForLabel:(CGRect)newframe {
	titleLabel.frame = newframe;
}

@end
