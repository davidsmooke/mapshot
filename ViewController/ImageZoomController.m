//
//  ImageZoomController.m
//  MapShot
//
//  Created by Innoppl technologies on 10/01/14.
//  Copyright (c) 2014 Innoppl Technologies. All rights reserved.
//

#import "ImageZoomController.h"

@interface ImageZoomController ()

@end

@implementation ImageZoomController
@synthesize imageZoom,getimageName,getImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageZoom;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollV withView:(UIView *)view atScale:(float)scale
//{
//    [imageScrollView setContentSize:CGSizeMake(scale*320, scale*50)];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageName.text=getimageName;
    imageScrollView.scrollEnabled = YES;
    imageScrollView.minimumZoomScale=1.0;
    imageScrollView.maximumZoomScale=4.0;
    [imageScrollView setContentSize:CGSizeMake(320, 378)];
    imageScrollView.delegate=self;
     imageScrollView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    
//    UIImage *imagesName=[UIImage imageNamed:@"globe.png"];
    imageZoom.image=getImage;
    imageZoom.contentMode=UIViewContentModeScaleAspectFit;
    [imageScrollView addSubview:imageZoom];
	// Do any additional setup after loading the view.
}
-(IBAction)backoption:(id)sender
{
    
    // self.navigationController.navigationBarHidden=NO;
    appdel=ArtMap_DELEGATE;
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
