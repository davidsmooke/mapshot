//
//  ImageZoomController.h
//  MapShot
//
//  Created by Innoppl technologies on 10/01/14.
//  Copyright (c) 2014 Innoppl Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageZoomController : UIViewController <UIScrollViewDelegate>
{
    UIImage *getImage;
     AppDelegate *appdel;
   IBOutlet UIImageView *imageZoom;
    UIButton *backoption;
   IBOutlet UIScrollView *imageScrollView;
    IBOutlet UILabel *imageName;
    NSString *getimageName;
    
    
}
@property(nonatomic,retain)UIImage *getImage;
@property(nonatomic,retain) UIImageView *imageZoom;
@property(nonatomic,retain)NSString *getimageName;
-(IBAction)backoption:(id)sender;
@end
