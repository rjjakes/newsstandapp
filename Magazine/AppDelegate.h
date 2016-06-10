//
//  AppDelegate.h
//

#import <UIKit/UIKit.h>
#import <NewsstandKit/NewsstandKit.h>
#import "UINavigationController+Retro.h"
#import "StoreViewController.h"
#import "Publisher.h"
#import "MagViewController.h"
#import "Reachability.h"
#import "apn.h"
#import "InAppPurchaseManager.h"

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define DEBUGMODE   NO

#define ISSUES_PLIST_URL    @"http://./_nsdelivery/issues.plist"

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) Publisher *pub;

@property (strong, nonatomic) StoreViewController *storeVC;
@property (strong, nonatomic) MagViewController *magVC;

@property (nonatomic, retain) apn *apnObject;
@property (nonatomic, strong) NSData *tmpdeviceToken;

@property (nonatomic, retain) InAppPurchaseManager* inApp;

-(float) getScreenWidth;
-(float) getScreenHeight;
-(bool) isiPhone;
- (NSString *) saveFilePath:(NSString *)fileName;
- (bool)connected;
-(CGSize)screenSizeOrientationIndependent;


@end
