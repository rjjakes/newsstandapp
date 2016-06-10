//
//  MagViewController.m
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "MagViewController.h"

@implementation MagViewController

@synthesize magpath;
@synthesize issueMeta;  // meta data form inside the zip
@synthesize pageSelect, navigationSelect, blackOverlay;
//@synthesize insView;
@synthesize PDFDocument;
@synthesize indicator;
@synthesize allScroll;
@synthesize is_portrait;

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        blackOverlay = [[UIView alloc] init];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];

        allScroll = [[UIScrollView alloc] init];

    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//---------------------------------------------------------------------------------------------------------------------------------------------------
// user tapped the scroll view (toggling the status/page bars)
- (void)tapForStatus
{
    int bottom_padding;
    
    
    if (pageselect_visible == NO)
    {
        NSLog(@"** tapped for status : WILL SHOW");
        // set initial position as hidden
        if (is_portrait)
        {
        
            if ([appDelegate getScreenWidth] >= 600)
            {   bottom_padding = 210;   }      // iPad
            else
            {   bottom_padding = 170;   }       // iPhone
            
            pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenHeight]-bottom_padding+250, pageSelect.frame.size.width, pageSelect.frame.size.height);
            navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0-80, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
        }
        // iPad landscape
        else
        {
            pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenWidth]-200+250, pageSelect.frame.size.width, pageSelect.frame.size.height);
            navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0-80, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
            
            NSLog(@"Is %f, %f, %f, %f", pageSelect.frame.origin.x, pageSelect.frame.origin.y, pageSelect.frame.size.width, pageSelect.frame.size.height);
            
        }

        // init the overlay
        blackOverlay.frame = self.view.frame;
        blackOverlay.backgroundColor = [UIColor blackColor];
        blackOverlay.alpha = 0.0;
        blackOverlay.hidden = NO;
        [self.view addSubview:blackOverlay];
        
        // bring status bars to the front   
        [self.view bringSubviewToFront:pageSelect];
        [self.view bringSubviewToFront:navigationSelect];
        
        // gesture recog for status
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForStatus)];
        tap.numberOfTapsRequired = 1;
        [blackOverlay addGestureRecognizer:tap];
        
        
        // status bar initial visibility
        pageSelect.alpha = 1.0;
        navigationSelect.alpha = 1.0;
        
        [UIView animateWithDuration:0.35 animations:^(void) {

            // animate the overlay alpha
            blackOverlay.alpha = 0.5;

            // animate the statusbar frames
            int bottom_padding;
            if (is_portrait)
            {
            
                if ([appDelegate getScreenWidth] >= 600)
                {   bottom_padding = 210;   }      // iPad
                else
                {   bottom_padding = 170;   }       // iPhone
        
                pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenHeight]-bottom_padding, pageSelect.frame.size.width, pageSelect.frame.size.height);
                navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
            }
            // iPad landscape
            else
            {
                pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenWidth]-200, pageSelect.frame.size.width, pageSelect.frame.size.height);
                navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
            }
        
        }];        

        // set the visibility
        pageselect_visible = YES;
    }
    else
    if (pageselect_visible == YES)
    {
        NSLog(@"** tapped for status : WILL HIDE");

        // set initial position as visible
        if (is_portrait)
        {
            if ([appDelegate getScreenWidth] >= 600)
            {   bottom_padding = 210;   }      // iPad
            else
            {   bottom_padding = 170;   }       // iPhone
        
            pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenHeight]-bottom_padding, pageSelect.frame.size.width, pageSelect.frame.size.height);
            navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
        }
        // iPad landscape
        else
        {
            pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenWidth]-200, pageSelect.frame.size.width, pageSelect.frame.size.height);
            navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
        }

        pageSelect.alpha = 1.0;
        navigationSelect.alpha = 1.0;

        [UIView animateWithDuration:0.35 animations:^(void) {

            // animate the overlay alpha
            blackOverlay.alpha = 0.0;

            // animate the statusbar frames
            int bottom_padding;
            if (is_portrait)
            {
            
                if ([appDelegate getScreenWidth] >= 600)
                {   bottom_padding = 210;   }      // iPad
                else
                {   bottom_padding = 170;   }       // iPhone
        
                pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenHeight]-bottom_padding+250, pageSelect.frame.size.width, pageSelect.frame.size.height);
                navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0-80, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
            }
            // iPad landscape
            else
            {
                pageSelect.frame = CGRectMake(pageSelect.frame.origin.x, [appDelegate getScreenWidth]-200+250, pageSelect.frame.size.width, pageSelect.frame.size.height);
                navigationSelect.frame = CGRectMake(navigationSelect.frame.origin.x, 0-80, navigationSelect.frame.size.width, navigationSelect.frame.size.height);
            }

        }];        

        // animate the visibility
        pageselect_visible = NO;
    }
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void) setPage:(int)index hideStatus:(bool)hideStatus
{

    if (is_portrait == YES)
    {
        [allScroll setContentOffset:CGPointMake([appDelegate getScreenWidth]*(index-1), 0) animated:NO];
    }
    else
    {
        // force "index" to be even
        if (index & 1)
        {   index = index-1;    }
        
        [allScroll setContentOffset:CGPointMake(([appDelegate getScreenHeight]/2)*(index), 0) animated:NO];
    }

    // hide the navigation.pageselect popups
    if (hideStatus == YES)
    {
        pageselect_visible = YES;
        [self tapForStatus];    
    }

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)initPopups
{
    if (pageSelect)
        [pageSelect removeFromSuperview];
    
    if (navigationSelect)
        [navigationSelect removeFromSuperview];
    
    // iPad/iPhone portrait
    if (is_portrait)
    {
        int bottom_padding;
        
        if ([appDelegate getScreenWidth] >= 600)
        {   bottom_padding = 210;   }      // iPad
        else
        {   bottom_padding = 170;   }       // iPhone
        
        pageSelect = [[PageSelectView alloc] initWithFrame:CGRectMake(0, [appDelegate getScreenHeight]-bottom_padding, [appDelegate getScreenWidth], 170) pageCount:pagecount path:magpath];
        navigationSelect = [[NavigationSelectView alloc] initWithFrame:CGRectMake(0, 0, [appDelegate getScreenWidth], 70) meta:issueMeta];
    }
    // iPad landscape
    else
    {
        pageSelect = [[PageSelectView alloc] initWithFrame:CGRectMake(0, [appDelegate getScreenWidth]-200, [appDelegate getScreenHeight], 170) pageCount:pagecount path:magpath];
        navigationSelect = [[NavigationSelectView alloc] initWithFrame:CGRectMake(0, 0, [appDelegate getScreenHeight], 70) meta:issueMeta];
    }
  
    
  
    // initial page select visibility
    pageselect_visible = NO;
    pageSelect.alpha = 0.0;
    [self.view addSubview:pageSelect];
    
    // initial navigation select visibility
    navigationSelect.alpha = 0.0;
    [self.view addSubview:navigationSelect];
    
    // hide the blackoverlay (if visible)
    if (blackOverlay)
    {   blackOverlay.alpha = 0.0;; }
    
    

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void) setIndex:(int)theindex
{
    // save the path!
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NKIssue *nkIssue = [nkLib issueWithName:[appDelegate.pub nameOfIssueAtIndex:theindex]];
    self.magpath = [NSString stringWithString:nkIssue.contentURL.path];

    // save the index
    issueindex = theindex;

    // load the issue meta from plist file (originally form the zip)
    NSString *metaFilename = [NSString stringWithFormat:@"%@/issue.plist", magpath];
    issueMeta = [[NSMutableDictionary alloc] init];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:metaFilename];
    issueMeta = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListMutableContainers format:nil errorDescription:nil];

    // setup some data
    pagecount = [[issueMeta objectForKey:@"Pagecount"] intValue];
    
    // init the scrollview
    if (is_portrait)
    {
        allScroll.frame = CGRectMake(0, 0, [appDelegate getScreenWidth], [appDelegate getScreenHeight]);
        [allScroll setContentSize:CGSizeMake(pagecount*[appDelegate getScreenWidth], [appDelegate getScreenHeight])];
    }
    else
    {
        allScroll.frame = CGRectMake(0, 0, [appDelegate getScreenHeight], [appDelegate getScreenWidth]);
        [allScroll setContentSize:CGSizeMake((pagecount+2)*([appDelegate getScreenHeight]/2), [appDelegate getScreenWidth])];
    }
    
    allScroll.delegate = self;
    [allScroll setScrollEnabled:YES];
    allScroll.pagingEnabled = YES;
    [self.view addSubview:allScroll];
    
    // --- popups
    [self initPopups];
    
    
    // init the status overlay
    blackOverlay.frame = self.view.frame;
    [self.view addSubview:blackOverlay];
    blackOverlay.hidden = YES;
    
    
    // show the loading activity indicator
    indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:indicator];
    indicator.center = self.view.center;
    [indicator startAnimating];
    
    // and run the timer for loading
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(initPages)
                                   userInfo:nil
                                    repeats:NO];    
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // init the self
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [appDelegate getScreenWidth], [appDelegate getScreenHeight])];
    self.view.backgroundColor = [UIColor clearColor];

    // gesture recog for status
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForStatus)];
    tap2.numberOfTapsRequired = 1;
    [allScroll addGestureRecognizer:tap2];
           
   
    init_complete = NO;
    
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void) realignPortrait
{
    is_portrait = YES;
//    [self setPage:thispage];
    
}

-(void) realignLandscape
{
    is_portrait = FALSE;
//    [self setPage:thispage];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)prefersStatusBarHidden {return YES;}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    // update the orientation
    if ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        is_portrait = YES;
    }
    else
    {   is_portrait = NO;   }

    // hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)willDisappear
{
    // trash the document
//    CGPDFPageRelease
//    CGPDFPageRetain(PDFPage);
//    CGPDFPageRelease(_PDFPage);

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated {

    // kill all visible pages
    if (allScroll)
    {
        for(UIView* view in allScroll.subviews)
        {
            if([view isKindOfClass:[MagPage class]])
            {
                if (view)
                {
                    // invisible
                    [(MagPage *)view becomeInvisible];
                    
                    NSLog(@"FINAL TRASH:");
                }
            }
            
        }
    }    
    
    init_complete = NO;
    
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void)scrollEnableTimer
{
    allScroll.userInteractionEnabled = YES;

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)checkPageVisibility:(UIScrollView *)scrollView
{
    if (init_complete == NO)
    {   return; }

    // hide
    for(UIView* view in scrollView.subviews) {
    if([view isKindOfClass:[MagPage class]]) {
    
            if (view)
            {

                // get bounds of scrollview
                double left = allScroll.contentOffset.x-100;
                double right = allScroll.contentOffset.x + allScroll.frame.size.width+100; 

                // check for visibility
                if (((view.frame.origin.x+view.frame.size.width) > left) && (view.frame.origin.x <= right))
                {
                }
                else
                {
                    allScroll.userInteractionEnabled = NO;
            
                    // invisible
                    [(MagPage *)view becomeInvisible];
                }
            }
        
        }
    }    

    // show
    for(UIView* view in scrollView.subviews) {
    if([view isKindOfClass:[MagPage class]]) {

            if (view)
            {
                // get bounds of scrollview
                double left = allScroll.contentOffset.x-100;
                double right = allScroll.contentOffset.x + allScroll.frame.size.width+100; 

                // check for visibility
                if (((view.frame.origin.x+view.frame.size.width) > left) && (view.frame.origin.x <= right))
                {
                    allScroll.userInteractionEnabled = NO;
                    [(MagPage *)view becomeVisible];
                }
                else
                {
                }
            }
        
        
        }
    }    

    // reenable the scrollView
    if (allScroll.userInteractionEnabled == NO)
    {
        // this is here to give the flaws in PDFScrollView a chance to catch up and not cause EXC_BAD_ACCESS
        [NSTimer scheduledTimerWithTimeInterval:0.2
            target:self
            selector:@selector(scrollEnableTimer)
            userInfo:nil
            repeats:NO];    
    }

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
/*
- (void)initInstructions
{
    if (insView)
    {   [insView removeFromSuperview];  }
    
    // has the user ever cleared the instruction before?
    NSArray *path =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* stringPath = [[path lastObject] stringByAppendingPathComponent:@"read_instructions.plist"];
                        
    NSString *returnData = [[NSString alloc] initWithContentsOfFile:stringPath encoding:NSUTF8StringEncoding error:nil];
    
    if (returnData != nil)
    {   
        NSLog(@"user already read the instructions");
        return; 
    }
    

    // init the instructions
    insView = [[InstructionsView alloc] initWithFrame:CGRectMake(0, (allScroll.frame.size.height-398)/2, allScroll.frame.size.width, 398)];
    [self.view addSubview:insView];

}
*/

//---------------------------------------------------------------------------------------------------------------------------------------------------
// from the timer
- (void)initPages
{
    init_complete = NO;

    if ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        is_portrait = YES;
    }
    else
    {   is_portrait = NO;   }

    // load up the pdf and save in memory
    NSString *url;
    
    if ([appDelegate isiPhone])
    {
        // 72DPI version for iPhones
        url = [NSString stringWithFormat:@"%@/issue-72.pdf", self.magpath];
        NSLog(@"72DPI version for iPhones");
    }
    else
    {
        // 144DPI version for iPads
        url = [NSString stringWithFormat:@"%@/issue-144.pdf", self.magpath];
        NSLog(@"144DPI version for iPads");
    }
    
    // trash existing pdf (prevents memory leaking)
    if (PDFDocument)
    {
        NSLog(@"releasing old document");
        CGPDFDocumentRelease(PDFDocument);
    }
    
    
    // laod the pdf
    NSURL *pdfURL = [NSURL fileURLWithPath:url];
    PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
    
    // create the pages
    for (int i=1; i<=pagecount; i++)
    {
        MagPage *magPage = [[MagPage alloc] initWithFrame:CGRectMake((i-1)*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) andIndex:i andPagecount:pagecount];
        [allScroll addSubview:magPage];
        [magPage realignForOrientation:is_portrait];
    }
    
    // check visibility
    [self checkPageVisibility:allScroll];

    // trash the indicator
    if (indicator)
        [indicator removeFromSuperview];

    // complete the init, so pages are allowed to load
    init_complete = YES;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    

    // set the first page
    [self forceWillRotate:self.interfaceOrientation];
    [self setPage:1 hideStatus:NO];
    
    // init the instruction
//    [self initInstructions];
    
    

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// scrollview moved
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (init_complete == YES)
    {
        [self checkPageVisibility:scrollView];
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    

}


//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void) forceWillRotate:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        [self realignPortrait];
    }
    else
    {
        [self realignLandscape];
    }


    // reframe the scrollview
    float screen_width;
    
    if (is_portrait)
    {
        allScroll.frame = CGRectMake(0, 0, [appDelegate getScreenWidth], [appDelegate getScreenHeight]);
        [allScroll setContentSize:CGSizeMake(pagecount*[appDelegate getScreenWidth], [appDelegate getScreenHeight])];    
        screen_width = [appDelegate getScreenWidth];
    }
    else
    {
        allScroll.frame = CGRectMake(0, 0, [appDelegate getScreenHeight], [appDelegate getScreenWidth]);
        [allScroll setContentSize:CGSizeMake((pagecount+2)*([appDelegate getScreenHeight]/2), [appDelegate getScreenWidth])];    
        screen_width = ([appDelegate getScreenHeight]);
    }
    
    // put the scrollview on the last closest page boundary
    [allScroll setContentOffset:CGPointMake(allScroll.contentOffset.x - fmod(allScroll.contentOffset.x, screen_width), allScroll.contentOffset.y)];
    
    

    // realign all the magpage views
    for(UIView* view in allScroll.subviews) {
    if([view isKindOfClass:[MagPage class]]) {

            [(MagPage *)view realignForOrientation:is_portrait];
            [(MagPage *)view becomeInvisible];
        
        }
    }    
    
    [self checkPageVisibility:allScroll];
    
    // realign the loading indicator
    indicator.center = self.view.center;
    
    // reinit the popups
    [self initPopups];
    
    // reinit the instruction
//    [self initInstructions];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self forceWillRotate:toInterfaceOrientation];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([appDelegate isiPhone])
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else
    {
        return YES; 
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------

@end
