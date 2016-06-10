//
//  downloadset.m
//
//

#import "downloadset.h"

@implementation downloadset

@synthesize responseData;

//------------------------------------------------------------------------------------------
-(id)init
{
    self = [super init];
    
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setDownload:(NSString *)issueString
{
    // get some important data
    NSString *deviceString = [UIDevice currentDevice].model;
    NSString *iosVersionString = [NSString stringWithFormat:@"%f", [[[UIDevice currentDevice] systemVersion] floatValue]];

    // do the stats
    NSString *downloadset_url = [NSString stringWithFormat:@"http://./_nsdelivery/downloadset.php?issue=%@&device=%@&ios=%@", issueString, deviceString, iosVersionString];
    
    NSLog(@"%@", downloadset_url);

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadset_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // try and send the token again
    // setup the the one shot timer for 20 seconds time to call [self sendToken]
/*    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(sendToken)
                                   userInfo:nil
                                    repeats:NO];
*/                                    
    
}

// connection suceeded and we got some json data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    
    NSLog(@"DOWNLOAD FLAG received by server");
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------


@end
