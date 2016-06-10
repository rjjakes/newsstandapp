//
//  PageSelectView.h
//

#import <UIKit/UIKit.h>
#import "PageSelectButton.h"

@interface PageSelectView : UIView <UIScrollViewDelegate>
{
    int page_count;
}

@property (nonatomic, strong) NSString *issue_path;
@property (nonatomic, strong) UIScrollView *allScroll;

- (id)initWithFrame:(CGRect)frame pageCount:(int)pageCount path:(NSString *)path;

@end
