//
//  PageSelectButton.h
//

#import <UIKit/UIKit.h>

@interface PageSelectButton : UIView
{
    int page_index;
    bool visible;
}

@property (nonatomic, strong) NSString *issue_path;
@property (nonatomic, strong) NSURL *imageURL;

@property (nonatomic, strong) UIImageView *thumbIV;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;


- (id)initWithPath:(NSString *)path andIndex:(int)index;
- (void)becomeInvisible;
- (void)becomeVisible;


@end
