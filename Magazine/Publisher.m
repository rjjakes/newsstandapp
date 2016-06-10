//
//  Publisher.m
//

#import "Publisher.h"
#import "AppDelegate.h"


@implementation Publisher

@synthesize responseData;
@synthesize issuesList;

/*
(id)init

here we would attempt to load a previously saved issues list msmutablearray

*/

//------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];

    if (self) {

        issuesList = [[NSMutableArray alloc] init];
        
        // Initialize self.
        NSLog(@"Initializing the publisher class");
        
        // add the reachability network change code
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];        
        
    }
    return self;
}

//------------------------------------------------------------------------------------------
//Called by Reachability whenever status changes.    
- (void) reachabilityChanged: (NSNotification* )note    
{    
//    Reachability* curReach = [note object];        
    //TODO: Your specific handling.
      
    if ([appDelegate connected])
    {
        [appDelegate.apnObject sendToken];  // send the apn token
        [self getIssuesListFromServer];  // get issues list
    
        NSLog(@"HAS BECOME CONNECTED!!");
    }
}

//------------------------------------------------------------------------------------------
-(NSString *)nameOfIssueAtIndex:(int)index
{
    return [[issuesList objectAtIndex:index] objectForKey:@"Name"];
}

//------------------------------------------------------------------------------------------
-(NSURL *)contentURLForIssueWithName:(NSString *)name
{
    for (int i=0; i<[issuesList count]; i++)
    {
        if ([name isEqualToString:[[issuesList objectAtIndex:i] objectForKey:@"Name"]])
        {
            NSString *content_field;

            // iPhone
            if ([appDelegate isiPhone])
            {   content_field = @"Content iPhone";NSLog(@"Downloading for iPhone");    }
            // iPad
            else
            {   content_field = @"Content iPad";NSLog(@"Downloading for iPad");    }
            
        
            NSURL *url = [NSURL URLWithString:[[[issuesList objectAtIndex:i] objectForKey:content_field] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"%@", url);
            
            return url;
            
        }
    }
    
    return nil;
}


//------------------------------------------------------------------------------------------
-(void) getIssuesListFromServer
{
    NSString *list_url = ISSUES_PLIST_URL; 
                
    NSLog(@"Attempting to load issues list from server: %@", list_url);
    
    if ([appDelegate.pub.issuesList count] == 0)
    {
        [appDelegate.storeVC.niLabel removeFromSuperview];
        [appDelegate.storeVC.niButtonReload removeFromSuperview];
        [appDelegate.storeVC.view addSubview:appDelegate.storeVC.loadLabel];
    }
    
                
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:list_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

//------------------------------------------------------------------------------------------
// update the NKLibrary with our new list of issues
-(void) addIssuesInNewsstand
{
    // shared NKLibrary instance
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    // we iterate through our issues and add only the one not in the NK library yet
    [issuesList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *name = [(NSDictionary *)obj objectForKey:@"Name"];
        NKIssue *nkIssue = [nkLib issueWithName:name];
        if(!nkIssue) {
            nkIssue = [nkLib addIssueWithName:name date:[(NSDictionary *)obj objectForKey:@"Date"]];
        }
    }];
    
  
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
-(void) saveIssuesListRaw:(NSData *)rawData
{
//    SBJsonWriter *parser = [[SBJsonWriter alloc] init];
//    NSString *conv_string = [parser stringWithObject:issuesList];

    NSLog(@"caching RAW issues list data");
    
    // and save it
    [rawData writeToFile:[self saveFilePath:@"issues_list_cache.plist"] atomically:YES];

}

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
    
    NSLog(@"attempting to load the cached issues list");
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self saveFilePath:@"issues_list_cache.plist"]])
    {
        NSLog(@"issues list cache exists. loading as NSData");
        NSData *rawData = [NSData dataWithContentsOfFile:[self saveFilePath:@"issues_list_cache.plist"]];        
        
        issuesList = [NSPropertyListSerialization propertyListFromData:rawData mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:nil];
        
        // update the NKLibrary with our list of issues
        [self addIssuesInNewsstand];

        // refresh the table data
        if ( [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive && appDelegate.storeVC)
        {

            [appDelegate.storeVC refreshTableData];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
        else
        if ( [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
        {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];

            NSString *appCoverURL;
        
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
                appCoverURL = [NSString stringWithString:[[issuesList objectAtIndex:0] objectForKey:@"AppCoverRetina"]];
            else
                appCoverURL = [NSString stringWithString:[[issuesList objectAtIndex:0] objectForKey:@"AppCover"]];
        
            UpdateCover *c = [[UpdateCover alloc] init];
            [c updateCover:appCoverURL];
        }
        
        
    }
    
    
    // there are no issues available
    if ([appDelegate.pub.issuesList count] == 0)
    {
        [appDelegate.storeVC.loadLabel removeFromSuperview];
        [appDelegate.storeVC.view addSubview:appDelegate.storeVC.niLabel];
        [appDelegate.storeVC.view addSubview:appDelegate.storeVC.niButtonReload];
    }
    

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
                                                   
    // reinit the issue list
    issuesList = [[NSMutableArray alloc] init];

    // copy the http response data to our array
    issuesList = [NSPropertyListSerialization propertyListFromData:responseData mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:nil];
    
    // we would save the array locally here
    NSLog(@"Loaded issues list from server (CONNECTION): %@", issuesList);
    
    if (issuesList == nil)
    {
        [self connection:connection didFailWithError:nil];  
        return;
    }
    
    // save a copy of the issues list
    [self saveIssuesListRaw:responseData];
    
    // update the NKLibrary with our list of issues
    [self addIssuesInNewsstand];

    // refresh the table data
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive && appDelegate.storeVC)
    {

        [appDelegate.storeVC refreshTableData];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        
    }
    else
    if ( [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];

        NSString *appCoverURL;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
            appCoverURL = [NSString stringWithString:[[issuesList objectAtIndex:0] objectForKey:@"AppCoverRetina"]];
        else
            appCoverURL = [NSString stringWithString:[[issuesList objectAtIndex:0] objectForKey:@"AppCover"]];
        
        UpdateCover *c = [[UpdateCover alloc] init];
        [c updateCover:appCoverURL];
        
    }

}

//------------------------------------------------------------------------------------------


@end
