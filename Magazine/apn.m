//
//  apn.m
//

#import "AppDelegate.h"
#import "apn.h"

@implementation apn

@synthesize apnToken, timer, responseData;

//------------------------------------------------------------------------------------------
-(id)init
{
    self = [super init];
    
    return self;
}

//------------------------------------------------------------------------------------------
// get the file path for saving (helper function)
- (NSString *) saveFilePath:(NSString *)fileName
{
	NSArray *path =
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [[path lastObject] stringByAppendingPathComponent:fileName];
    
}

//------------------------------------------------------------------------------------------
// saves a complete cache NSDictionary to plist file
- (bool) saveArrayToFile:(NSArray *)dict filename:(NSString *)fname
{
    
    // first convert back to JSON
    //    NSString *tmpString = [dict JSONRepresentation];
    SBJsonWriter *parser = [[SBJsonWriter alloc] init];
    NSString *conv_string = [parser stringWithObject:dict];
    
    // and save it
    return [conv_string writeToFile:[self saveFilePath:fname] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

//------------------------------------------------------------------------------------------
- (NSMutableArray *) getArrayFromFile:(NSString *)plistFilename
{
    
    // load the string in from the .plist file
    NSString *returnData = [[NSString alloc] initWithContentsOfFile:[self saveFilePath:plistFilename] encoding:NSUTF8StringEncoding error:nil];
    
    if (returnData == nil)
    {   return nil; }
    
    // convert from NSString (JSON encoded) to NSMutableDictionary
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    id conv_object = [parser objectWithString:returnData];
    
    return conv_object;
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// generates a unique key that represents this install of this app (replacement for UDID which is depreciated and failes app store approval)
-(NSString *)getUUID:(bool)force_new
{
    
    // try and load the json containing an existing uuid
    NSMutableArray *tmp = [self getArrayFromFile:@"uuid.plist"];
    
    if (!tmp || force_new)
    {
        // create the uuid
        CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
        CFRelease(newUniqueId);
        
        
        // save it to the file
        tmp = [[NSMutableArray alloc] init];
        [tmp addObject:uuidString];
        
        [self saveArrayToFile:tmp filename:@"uuid.plist"];
        
        // update apn token
        [appDelegate.apnObject sendToken];    // new token, so re-send to drupal
        
        
    }
    
    // at this point, a uuid MUST exist in tmp, so just extract it
    return [tmp objectAtIndex:0];
}

//------------------------------------------------------------------------------------------
// send the UUID and apnToken back to Drupal - uses a timer to handle offline functionality
-(void) sendToken
{
    
    // kill any existing timers
    timer = nil;
    
    //
    if ([appDelegate connected])
    {
        // send the token
        NSLog(@"Sending apn token.");
        
        NSString *debug_flag;
        
        //        #ifdef  DEBUG
        //            debug_flag = @"YES";
        //        #else
        debug_flag = @"NO";
        //        #endif
        
        NSString *list_url = [NSString stringWithFormat:@"http://./_nsdelivery/apnset.php?token=%@&udid=%@", apnToken, [self getUUID:false]];
        
        NSLog(@"%@", list_url);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:list_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
        (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
    }
    else
    {
        NSLog(@"offline waiting....");
        
        // setup the the one shot timer for 20 seconds time to call [self sendToken]
//        timer = [NSTimer scheduledTimerWithTimeInterval:10.0
//                                         target:self
//                                       selector:@selector(sendToken)
//                                       userInfo:nil
//                                        repeats:NO];
    }
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
    
    // remove the loading animation
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSLog(@"APN token was received by server");
    
    return; // dont actually need to do anything else
    
    /*
     // convert response to NSDictionary
     NSLog(@"Succeeded! Received %d bytes of data",[responseData
     length]);
     NSString *statusString = [[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding];
     
     NSData* jsonData = [statusString dataUsingEncoding:NSUTF8StringEncoding];
     NSError *error = nil;
     NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
     
     NSLog(@"SENT TOKEN: %@", results);
     */
    
}

//------------------------------------------------------------------------------------------
-(void) setToken:(NSData*)deviceToken
{
    
    // get the apn token
    apnToken = [deviceToken description];
	apnToken = [apnToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	apnToken = [apnToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // show info
    [self sendToken];
    
}

//------------------------------------------------------------------------------------------


@end
