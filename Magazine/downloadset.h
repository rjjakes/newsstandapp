//
//  downloadset.h
//
//

#import <Foundation/Foundation.h>

@interface downloadset : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableData *responseData;  // nsurlconnection response

- (void)setDownload:(NSString *)issueString;

@end
