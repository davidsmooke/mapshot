//
//  MyCLController.h
//  NixonApp
//
//  Created by Innoppl Technologies on 13/10/10.
//  Copyright Innoppl 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MyCLController : NSObject <CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
	id delegate;
}
@property (nonatomic,retain)CLLocationManager *locationManager;
@property(retain)id delegate;

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
    fromLocation:(CLLocation *)oldLocation;

-(void) locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

-(void)locationUpdate:(CLLocation *)location;
-(void)locationError:(NSError *)error;
@end
