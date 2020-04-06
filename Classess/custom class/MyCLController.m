//
//  MyCLController.m
//  NixonApp
//
//  Created by Innoppl Technologies on 13/10/10.
//  Copyright Innoppl 2010. All rights reserved.
//

#import "MyCLController.h"



@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;
// initialization of MYCLController which controls Gps;
-(id) init{
	self=[super init] ;
	if (self !=nil) {
		self.locationManager=[[CLLocationManager alloc] init];
		self.locationManager.delegate=self;
		
	}
	return self;
}
//when the location is determined 
-(void) locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    //nslog(@"new location %@ old location %@",newLocation,oldLocation);
	[self.delegate locationUpdate:newLocation];
   
}
// if error found while determining location
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	
	[self.delegate locationError:error];
}
- (void)locationUpdate:(CLLocation *)location {
    
}

- (void)locationError:(NSError *)error {
}




@end
