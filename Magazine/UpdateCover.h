//
//  UpdateCover.h
//

#import <Foundation/Foundation.h>

@interface UpdateCover : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableData *responseData;  // nsurlconnection response

-(void) updateCover:(NSString *)appcoverurl;

@end
