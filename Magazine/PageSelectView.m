//
//  PageSelectView.m
//

#import "PageSelectView.h"

@implementation PageSelectView

@synthesize issue_path;
@synthesize allScroll;

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)checkButtonVisibility:(UIScrollView *)scrollView
{
    for(UIView* view in scrollView.subviews) {
    if([view isKindOfClass:[PageSelectButton class]]) {

            // get bounds of scrollview
            double left = allScroll.contentOffset.x-100;
            double right = allScroll.contentOffset.x + allScroll.frame.size.width + 100; 

            // check for visibility
            if (((view.frame.origin.x+view.frame.size.width) > left) && (view.frame.origin.x <= right))
            {
               [(PageSelectButton *)view becomeVisible];
            }
            else
            {
                // invisible
               [(PageSelectButton *)view becomeInvisible];
            }
        
        
        }
    }    

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame pageCount:(int)pageCount path:(NSString *)path
{
    self = [super initWithFrame:frame];
    if (self) {
    
        // save data
        page_count = pageCount;
        issue_path = [NSString stringWithString:path];

        // display
        self.backgroundColor = [UIColor blackColor];
        
        allScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 170)];
        allScroll.delegate = self;
        [allScroll setScrollEnabled:YES];    
        allScroll.pagingEnabled = NO;
        [allScroll setContentSize:CGSizeMake(page_count*122, 170)];    
        [self addSubview:allScroll];
        
        // load up some pages
        for (int i=1; i<=page_count; i++)
        {
            // create the button
            PageSelectButton *button = [[PageSelectButton alloc] initWithPath:path andIndex:i];
            [allScroll addSubview:button];
            
        }

        // initial visibility of buttons
        [self checkButtonVisibility:allScroll];
        
        
        
    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// scrollview moved
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self checkButtonVisibility:scrollView];
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

@end
