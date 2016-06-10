//
//  MagViewController.h
//

#import <UIKit/UIKit.h>
#import "MagPage.h"
#import "PageSelectView.h"
#import "NavigationSelectView.h"
#import "UpdateCover.h"
#import "InstructionsView.h"

@interface MagViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    int issueindex;     // index of issue
    int pagecount;      // number of pages in this issue
    
    bool pageselect_visible;
    bool init_complete;
    
}

@property (nonatomic) bool is_portrait;

@property (nonatomic, strong) NSString *magpath;
@property (nonatomic, strong) NSMutableDictionary *issueMeta;

@property (nonatomic) CGPDFDocumentRef PDFDocument;
@property (nonatomic, strong) UIScrollView *allScroll;

@property (nonatomic, strong) UIView *blackOverlay;
@property (nonatomic, strong) PageSelectView *pageSelect;       // popup page selector
@property (nonatomic, strong) NavigationSelectView *navigationSelect; // popup pesudo navigation bar
//@property (nonatomic, strong) InstructionsView *insView;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

- (void) setIndex:(int)theindex;        // set issue index
- (void) setPage:(int)index hideStatus:(bool)hideStatus;            // change page within issue index
- (void) forceWillRotate:(UIInterfaceOrientation)toInterfaceOrientation;
- (void) willDisappear;

@end
