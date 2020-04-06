//
//  WebEngine.h
//  Demo
//
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@protocol WebEngineDelegate <NSObject>

- (void) didFinsh:(NSDictionary*)response;
- (void) didFinshWithError:(NSDictionary *)error;

@end

@interface WebEngine : NSObject
{
    id<WebEngineDelegate>delegate;
    
}

@property (nonatomic) id<WebEngineDelegate>delegate;
@property (nonatomic, strong) NSDictionary *userInfo;


- (void) MSLoginApp:(NSDictionary*)data;
- (void) MSSignUpApp:(NSDictionary*)data;

@end
