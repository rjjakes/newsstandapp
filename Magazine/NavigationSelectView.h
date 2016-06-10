//
//  NavigationSelectView.h
//

#import <UIKit/UIKit.h>

@interface NavigationSelectView : UIView

@property (nonatomic, strong) NSMutableDictionary *issueMeta;

- (id)initWithFrame:(CGRect)frame meta:(NSMutableDictionary *)meta;

@end
