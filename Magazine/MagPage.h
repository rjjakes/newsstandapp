//
//  MagPage.h
//

#import <UIKit/UIKit.h>
#import "PDFScrollView.h"

@interface MagPage : UIView <UIGestureRecognizerDelegate>
{
    int page_index;
    int page_count;
    bool visible; 

}

@property (nonatomic) PDFScrollView *pageView;
@property (nonatomic) CGPDFPageRef PDFPage;

- (id)initWithFrame:(CGRect)frame andIndex:(int)index andPagecount:(int)pagecount;
- (void)becomeVisible;
- (void)becomeInvisible;

- (void)realignForOrientation:(bool)is_portrait;

@end
