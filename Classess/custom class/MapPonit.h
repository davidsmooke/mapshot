//
//  MapPonit.h
//  ArtMap
//
//  Created by sathish kumar on 10/1/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapPonit : NSObject  <MKAnnotation>
{
    NSString *title;
    NSString *subTitle;
    NSString *pointtag;
    
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy)  NSString *title;
@property (nonatomic,copy)  NSString *subTitle;
@property  (nonatomic,copy) NSString *pointtag;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st setTag:(NSString *) tag;


@end
