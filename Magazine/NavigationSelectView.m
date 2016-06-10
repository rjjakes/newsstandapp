//
//  NavigationSelectView.m
//

#import "NavigationSelectView.h"
#import "AppDelegate.h"

@implementation NavigationSelectView

@synthesize issueMeta;

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)homeButtonAction
{
    // realign all the storeVC buttons
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [appDelegate.storeVC reAlignEverything:orientation];

    // TRASH THE PDFDOCUMENT
    [appDelegate.magVC willDisappear];

    // and pop the magazine view controller
    if (IS_OS_7_OR_LATER)
    {   [appDelegate.navController popViewControllerRetro];      }
    else
    {   [appDelegate.navController popViewControllerAnimated:YES];  }
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)facebookButtonAction
{
    NSURL *url = [[ NSURL alloc ] initWithString: [issueMeta objectForKey:@"Facebook"]];
    
    BOOL res = [[UIApplication sharedApplication] canOpenURL:url];

    if (res)
    {   [[UIApplication sharedApplication] openURL:url];    }   
    else
    {
        NSURL *url = [[ NSURL alloc ] initWithString: [issueMeta objectForKey:@"Facebook Web"]];
        [[UIApplication sharedApplication] openURL:url];
    }
        
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)twitterButtonAction
{
    NSURL *url = [[ NSURL alloc ] initWithString: [issueMeta objectForKey:@"Twitter"]];

    BOOL res = [[UIApplication sharedApplication] canOpenURL:url];

    if (res)
    {   [[UIApplication sharedApplication] openURL:url];    }   
    else
    {
        NSURL *url = [[ NSURL alloc ] initWithString: [issueMeta objectForKey:@"Twitter Web"]];
        [[UIApplication sharedApplication] openURL:url];
    }

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)instagramButtonAction
{
    NSURL *url = [[ NSURL alloc ] initWithString: [issueMeta objectForKey:@"Instagram"]];

    BOOL res = [[UIApplication sharedApplication] canOpenURL:url];

    if (res)
    {   [[UIApplication sharedApplication] openURL:url];    }   
    else
    {
        NSURL *url = [[ NSURL alloc ] initWithString: [issueMeta objectForKey:@"Instagram Web"]];
        [[UIApplication sharedApplication] openURL:url];
    }

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame meta:(NSMutableDictionary *)meta
{
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        issueMeta = [meta mutableCopy];
        
        // white wrapper
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height-4)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        // back button
        UIButton *homeUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeUIButton addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [homeUIButton setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_back" ofType:@"png"]] forState:UIControlStateNormal];
        homeUIButton.frame = CGRectMake(12, 4, 58, 58);
        [whiteView addSubview:homeUIButton];
        
        // facebook button
        UIButton *facebookUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [facebookUIButton addTarget:self action:@selector(facebookButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [facebookUIButton setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_facebook" ofType:@"png"]] forState:UIControlStateNormal];
        facebookUIButton.frame = CGRectMake(frame.size.width-76, 4, 58, 58);

//        NSURL *url = [[ NSURL alloc ] initWithString: [meta objectForKey:@"Facebook"]];
//        BOOL res = [[UIApplication sharedApplication] canOpenURL:url];
//        if (!res)
//            facebookUIButton.enabled = NO;

        [whiteView addSubview:facebookUIButton];
        
        // twitter button
        UIButton *twitterUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [twitterUIButton addTarget:self action:@selector(twitterButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [twitterUIButton setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_twitter" ofType:@"png"]] forState:UIControlStateNormal];
        twitterUIButton.frame = CGRectMake(frame.size.width-152, 4, 58, 58);

//        url = [[ NSURL alloc ] initWithString: [meta objectForKey:@"Twitter"]];
//        res = [[UIApplication sharedApplication] canOpenURL:url];
//        if (!res)
//            twitterUIButton.enabled = NO;
            
        [whiteView addSubview:twitterUIButton];

       
        // instagram button
        UIButton *instagramUIButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [instagramUIButton addTarget:self action:@selector(instagramButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [instagramUIButton setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_instagram" ofType:@"png"]] forState:UIControlStateNormal];
        instagramUIButton.frame = CGRectMake(frame.size.width-228, 4, 58, 58);

//        url = [[ NSURL alloc ] initWithString: [meta objectForKey:@"Instagram"]];
//        res = [[UIApplication sharedApplication] canOpenURL:url];
//        if (!res)
//            instagramUIButton.enabled = NO;
            
        [whiteView addSubview:instagramUIButton];
        
        
    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//---------------------------------------------------------------------------------------------------------------------------------------------------

@end
