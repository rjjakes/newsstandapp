//
//  IssueTableCell.h
//

#import <UIKit/UIKit.h>
#import "UpdateCover.h"

#define TOPPADDING    50

@interface IssueTableCell : UITableViewCell <NSURLConnectionDelegate>
{
    int item_index;
    float height;
}

@property (nonatomic, strong) UIProgressView *downloadProgress;
@property (nonatomic, strong) UIImageView *coverIV;
@property (nonatomic, strong) NSString *coverLocalFilename;
@property (nonatomic, retain) NSMutableData *responseData;  // nsurlconnection response
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *buttonSubscribe;

@property (nonatomic, strong) UpdateCover *uC;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *greyCoverBG;


@property (nonatomic, strong) NSString *appCoverURL;


- (void) setWithData:(NSMutableDictionary *)issueData index:(int)index;
- (void) updateProgress:(float)val;

@end
