//
//  Publisher.h
//

#import <Foundation/Foundation.h>
#import "UpdateCover.h"

@interface Publisher : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableData *responseData;  // nsurlconnection response
@property (nonatomic, retain) NSMutableArray *issuesList;

-(void) getIssuesListFromServer;
-(NSString *) nameOfIssueAtIndex:(int)index;
-(NSURL *) contentURLForIssueWithName:(NSString *)name;

@end
