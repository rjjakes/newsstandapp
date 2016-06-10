//
//  StoreViewController.h
//

#import <UIKit/UIKit.h>
#import "IssueTableCell.h"
#import "downloadset.h"

@interface StoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, NSURLConnectionDownloadDelegate, NSURLConnectionDelegate>
{
}

@property (nonatomic, retain) UIImageView *bgIV;
@property (nonatomic, retain) UITableView *issuesTableView;
@property (nonatomic, retain) UILabel *niLabel;
@property (nonatomic, retain) UIButton *niButtonReload;
@property (nonatomic, retain) UILabel *loadLabel;
@property (nonatomic) bool is_portrait;


- (void) refreshTableData;
- (void) reAlignEverything:(UIInterfaceOrientation)orientation;
- (void) startDownload:(int)index;


@end
