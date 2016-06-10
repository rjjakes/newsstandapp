//
//  AppDelegate.m
//

#import "AppDelegate.h"


/*
TODO: 
*/

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController;

@synthesize storeVC, magVC;

@synthesize pub, apnObject, tmpdeviceToken;

@synthesize inApp;

//------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [UIWindow new];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    // init the publisher class
    pub = [[Publisher alloc] init];
    
    // init the store VC
    storeVC = [[StoreViewController alloc] initWithNibName:nil bundle:nil];
    
    // init the navcontroller
    navController=[[UINavigationController alloc]initWithRootViewController:storeVC];
    navController.navigationBar.hidden = YES;
    
    if ([navController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {    // stop the swipe behaviour on iOS7
        navController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.window.rootViewController = navController;
    
    // push notification setup
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeNewsstandContentAvailability];    
    
    // remove any existing sash and badge
    
    // don't throttle push notifications
    if (DEBUGMODE == YES)
    {
        NSLog(@"**** DEBUG MODE ****");
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NKDontThrottleNewsstandContentNotifications"];
    }

    // init the in app puchase controller
    inApp = [[InAppPurchaseManager alloc] init];

    // init apn sending object
    apnObject = [[apn alloc] init];
    
    
    // check for background running (received push notification?
    NSDictionary *payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    
    if (payload) {
    
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
        
        NSLog(@"FOUND PAYLOAD");

        
        // and just download the cover (do a refresh of the issueslist)
        [appDelegate.pub getIssuesListFromServer];
        
        /*
        NKIssue *issue4 = [[NKLibrary sharedLibrary] issueWithName:@"Magazine-4"];
        if(issue4) {
            NSURL *downloadURL = [NSURL URLWithString:@"http://www.viggiosoft.com/media/data/blog/newsstand/magazine-4.pdf"];
            NSURLRequest *req = [NSURLRequest requestWithURL:downloadURL];
            NKAssetDownload *assetDownload = [issue4 addAssetWithRequest:req];

            [assetDownload downloadWithDelegate:store];
        }
         */
    }
    else
    {
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    
    [self.window makeKeyAndVisible];
    self.window.frame = [UIScreen mainScreen].bounds;    

    return YES;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// push notification token
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    tmpdeviceToken = deviceToken;
    
    [apnObject setToken:deviceToken];
    
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    
        NSLog(@"Received remote notification");
        
        // get new issues list from server (and auto update store VC)
        [appDelegate.pub getIssuesListFromServer];
        
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(CGSize)screenSizeOrientationIndependent {
     CGSize screenSize = [UIScreen mainScreen].bounds.size;
     return CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
}


-(float) getScreenWidth
{
    if (IS_OS_8_OR_LATER)
    {
        CGSize sSize = [self screenSizeOrientationIndependent];        
        return sSize.width;
    }
    else
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        return screenWidth;
    }


}

-(float) getScreenHeight
{
    if (IS_OS_8_OR_LATER)
    {
        CGSize sSize = [self screenSizeOrientationIndependent];        
        return sSize.height;
    }
    else
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        return screenHeight;
    }

}

//------------------------------------------------------------------------------------------
-(bool) isiPhone
{
    // is not iPad
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    
    return NO;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// simple check for internet connection
- (bool)connected
{
    //    Reachability *reachability = [Reachability reachabilityWithHostname:ENDPOINT_DOMAIN];
    //    reachability.reachableOnWWAN = YES;
    //    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    //    NSLog(@"%@", networkStatus);
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == NotReachable)
    {
        return false;
    }
    /*    else if (status == ReachableViaWiFi)
     {
     //WiFi
     return true;
     }
     else if (status == ReachableViaWWAN)
     {
     //3G
     return true;
     }
     */
    
    return true;
    //    return !(networkStatus == NotReachable);
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
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

//------------------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
}

//------------------------------------------------------------------------------------------
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"DANGER!");
}

//------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ((appDelegate.storeVC) && (appDelegate.pub))
    {
        NSLog(@"enterting FOREGROUND - going for a refresh");
        
        [appDelegate.pub getIssuesListFromServer];
    }

    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

//------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
//    if ((tmpdeviceToken) && (apnObject))
//    {
//        NSLog(@"init from suspended");
        
//        [apnObject setToken:tmpdeviceToken];
//    }
    
}

//------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

//------------------------------------------------------------------------------------------

@end
