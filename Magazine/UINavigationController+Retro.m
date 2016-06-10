//
//  UINavigationController+Retro.m
//
//

#import "AppDelegate.h"
#import "UINavigationController+Retro.h"

@implementation UINavigationController (Retro)

- (void)pushViewControllerRetro:(UIViewController *)viewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    
    //DETERMINE ORIENTATION
    if (IS_OS_8_OR_LATER)       // iOS8 is now device orentation independant
    {
        transition.subtype = kCATransitionFromRight;
    }
    else
    {
        if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait ){
            transition.subtype = kCATransitionFromRight;
        }
        else
        if( [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown ){
            transition.subtype = kCATransitionFromLeft;
        }
        else
        if( [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ){
            transition.subtype = kCATransitionFromBottom;
        }
        else
        if( [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight ){
            transition.subtype = kCATransitionFromTop;
        }
    }
    
    
    
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerRetro {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    
    //DETERMINE ORIENTATION
    if (IS_OS_8_OR_LATER)       // iOS8 is now device orentation independant
    {
        transition.subtype = kCATransitionFromLeft;
    }
    else
    {
        if( [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait ){
            transition.subtype = kCATransitionFromLeft;
        }
        else
        if( [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown ){
            transition.subtype = kCATransitionFromRight;
        }
        else
        if( [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ){
            transition.subtype = kCATransitionFromTop;
        }
        else
        if( [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight ){
            transition.subtype = kCATransitionFromBottom;
        }
    }

    [self.view.layer addAnimation:transition forKey:nil];
    
    [self popViewControllerAnimated:NO];
}

@end
