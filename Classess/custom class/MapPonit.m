//
//  MapPonit.m
//  ArtMap
//
//  Created by sathish kumar on 10/1/12.
//  Copyright (c) 2012 sathish kumar. All rights reserved.
//

#import "MapPonit.h"


@implementation MapPonit

@synthesize  title,subTitle;
@synthesize  pointtag;
@synthesize  coordinate;


-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st
                  setTag:(NSString *) tag

{
    
    coordinate = c;
    title      = t;
    subTitle   = st;
    pointtag   = tag;
    
    return self;
}

@end
