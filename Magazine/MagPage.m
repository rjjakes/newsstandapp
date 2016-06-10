//
//  MagPage.m
//

#import "AppDelegate.h"
#import "MagPage.h"

@implementation MagPage

@synthesize pageView;
@synthesize PDFPage;

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)realignForOrientation:(bool)is_portrait;
{
    if (is_portrait)
    {
        self.frame = CGRectMake((page_index-1)*[appDelegate getScreenWidth], 0, [appDelegate getScreenWidth], [appDelegate getScreenHeight]);
    }
    else
    {
        if (page_index == 1)
        {
            self.frame = CGRectMake([appDelegate getScreenHeight]/4, 0, [appDelegate getScreenHeight]/2, [appDelegate getScreenWidth]);
        }
        else
        if (page_index == page_count)
        {
            self.frame = CGRectMake(page_index*([appDelegate getScreenHeight]/2)+[appDelegate getScreenHeight]/4, 0, [appDelegate getScreenHeight]/2, [appDelegate getScreenWidth]);
        }
        else
        {
            self.frame = CGRectMake(page_index*([appDelegate getScreenHeight]/2), 0, [appDelegate getScreenHeight]/2, [appDelegate getScreenWidth]);
        }
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame andIndex:(int)index andPagecount:(int)pagecount;
{
    self = [super initWithFrame:frame];
    if (self) {

        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        // initial visibility
        visible = NO;
        
        // save index
        page_index = index;
        
        // and count
        page_count = pagecount;
        

    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadPDFintoScrollView:(int)index
{
    if (index < 1)
     {   return; }

    // start background thread
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
        // init the pageview
        pageView = [[PDFScrollView alloc] init];

        // get the PDF page ref
        PDFPage = CGPDFDocumentGetPage(appDelegate.magVC.PDFDocument, index);
    
        // start the forground callback
////        dispatch_async(dispatch_get_main_queue(), ^(void) {
 
            // now create the new object
            pageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
  

            // carry on
            pageView.minimumZoomScale = 1.0;
        
            if ([appDelegate isiPhone])
            {   pageView.maximumZoomScale = 2.0;    }   // iPhones can zoom in more than iPads
            else
            {   pageView.maximumZoomScale = 2.0;    }
            
            pageView.bouncesZoom = NO;
            pageView.bounces = YES;
    
    
            [pageView setScrollEnabled:YES];
            [pageView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
            pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            pageView.decelerationRate = UIScrollViewDecelerationRateFast;
            pageView.delegate = pageView;
            
            [self addSubview:pageView];
    
            if (pageView)
            {
                [pageView setPDFPage:PDFPage];
            }
        
 
////        });
////    });

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)becomeVisible
{
    // already visible, do nothing
    if (visible)
    {   return; }
    
    // and set new visibility
    visible = YES;

    // wasn't visible do create
    NSLog(@"ADDING %d", page_index);
    [self loadPDFintoScrollView:page_index];
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)becomeInvisible
{
    // wasn't visible, so return
    if (visible == NO)
    {   return; }

    // set new visibility
    visible = NO;

    // kill the PDF page
    NSLog(@"removing %d", page_index);
    
  
//@autoreleasepool {      
    // kill the pageview
    if (pageView)
    {
        NSLog(@"trashing %d", page_index);
        
//        @autoreleasepool{     
        
    
        [pageView removeFromSuperview];
//        pageView = nil;       // can't do this as pageView does stuff async and created bad access messages :/
        
//        }
    }
    
    
    
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
