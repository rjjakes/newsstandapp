//
//  UpdateCover.m
//

#import "UpdateCover.h"

@implementation UpdateCover

@synthesize responseData;

//------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    NSLog(@"%@", error);

    // try and send the token again
        // setup the the one shot timer for 20 seconds time to call [self sendToken]
/*        
        [NSTimer scheduledTimerWithTimeInterval:10.0
            target:self
            selector:@selector(sendToken)
            userInfo:nil
            repeats:NO];        
*/            
    
}

// connection suceeded and we got some json data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    
    // remove the loading animation
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    // convert response to NSDictionary
//    NSLog(@"Succeeded! Received %d bytes of data",[responseData
//                                                   length]);
                                                   
    // setup the UIImage
    UIImage *cover = [UIImage imageWithData:responseData];
    
    // and set the app cover image based on this new UIImage
    NSLog(@"Updating the newsstand icon image %f, %f", cover.size.width, cover.size.height);
    [[UIApplication sharedApplication] setNewsstandIconImage:cover];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
}

//------------------------------------------------------------------------------------------
-(void) updateCover:(NSString *)appcoverurl
{

    NSLog(@"Updating app cover: %@", appcoverurl);


    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appcoverurl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;



}

//------------------------------------------------------------------------------------------

@end
