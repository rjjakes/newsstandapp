//
//  apn.h
//

#import <Foundation/Foundation.h>
#import "SBJSon.h"

@interface apn : NSObject <NSURLConnectionDelegate>


@property (nonatomic, retain) NSString *apnToken;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSMutableData *responseData;  // nsurlconnection response


-(void) setToken:(NSData*)deviceToken;      // save and call sendToken
-(void) sendToken;                           // send to drupal

@end
