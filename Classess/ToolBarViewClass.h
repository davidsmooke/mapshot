//
//  ToolBarViewClass.h
//  Vestify
//
//  Created by Innoppl Technologies on 09/07/13.
//  Copyright (c) 2013 Innoppl Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToolBarViewClass;

@protocol  customToolBarDelegate

- (void)backButtonAction:(UIButton *)sender;
- (void)logoutBtnAction:(UIButton *)sender;


@end

@interface ToolBarViewClass : UIView

{
	UIButton *backButton;
	UIButton *logoutButton;
	UILabel *titleLabel;
	id <customToolBarDelegate> delegate;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) NSString *customTitleString;

- (void)buttontappedback:(UIButton *)sender;
- (void)setTilte:(NSString *)tiltleStringValue;
- (void)removeDraftButton:(BOOL)removeBoolen;
- (void)removeBackButton:(BOOL)removeBoolen;
- (void)setFrameForLabel:(CGRect)newframe;
- (void)setTilteForTopRight:(NSString *)tiltleStringValue;
- (void)setRightImage:(NSString *)imageName;
- (void)setImageAsTitle:(NSString *)imageName;

@end
