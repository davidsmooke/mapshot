//
//  sortMassImageUploadClass.h
//  ArtMap
//
//  Created by Innoppl Technologies on 22/07/13.
//  Copyright (c) 2013 sathish kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sortMassImageUploadClass : NSObject{
    
}

@property(nonatomic,strong) NSDictionary *sortedDetailsDictionary;
@property(nonatomic,strong) NSString *filePathString;
@property(nonatomic,strong) UIImage *sortedResizedImage;
@property (nonatomic,strong ) NSString *imageId;
@property (nonatomic,strong ) NSData *imageData;
@end
