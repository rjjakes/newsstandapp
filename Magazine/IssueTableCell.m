//
//  IssueTableCell.m
//

#import "IssueTableCell.h"
#import "AppDelegate.h"


@implementation IssueTableCell

@synthesize downloadProgress;
@synthesize coverIV, coverLocalFilename;
@synthesize responseData;  // nsurlconnection response
@synthesize appCoverURL;
@synthesize button, buttonSubscribe;

@synthesize uC, titleLabel, descLabel, greyCoverBG;

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // Initialization code

        uC = [[UpdateCover alloc] init];

        titleLabel = [[UILabel alloc] init];

        descLabel = [[UILabel alloc] init];

        button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button addTarget:self action:@selector(selectMethod) forControlEvents:UIControlEventTouchUpInside];
        
        buttonSubscribe = [UIButton buttonWithType:UIButtonTypeSystem];
        [buttonSubscribe addTarget:self action:@selector(subscribeMethod) forControlEvents:UIControlEventTouchUpInside];
        
        downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        coverIV = [[UIImageView alloc] init];
        
        greyCoverBG = [[UIView alloc] init];
        
        
    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateProgress:(float)val
{
    downloadProgress.hidden = NO;
    [downloadProgress setProgress:val animated:YES];
    
    [button setTitle:@"DOWNLOADING" forState:UIControlStateNormal];
    button.enabled = NO;
    
    buttonSubscribe.hidden = YES;   // hide subscribe while we download
    

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    NSLog(@"%@", error);

    // try and send the token again
        // setup the the one shot timer for 20 seconds time to call [self sendToken]
/*        
        [NSTimer scheduledTimerWithTimeInterval:10.0
            target:self
            selector:@selector(sendToken)
            userInfo:nil
            repeats:NO];        
*/            
    
}

// connection suceeded and we got some json data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    
    // remove the loading animation
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    // convert response to NSDictionary
//    NSLog(@"Succeeded! Received %d bytes of data",[responseData
//                                                   length]);
                                                   
    // save responseData as the image
    NSError* error;
    [responseData writeToFile:[appDelegate saveFilePath:coverLocalFilename] options:NSDataWritingAtomic error:&error];
        
//    NSLog(@"saving ASSET error: %@", [error localizedDescription]);
    
                      
    if ([[NSFileManager defaultManager] fileExistsAtPath:[appDelegate saveFilePath:coverLocalFilename]])
    {
        // cover image exists, so get it
        UIImage* cover = [UIImage imageWithContentsOfFile:[appDelegate saveFilePath:coverLocalFilename]];
        
        // set the app cover
        if (item_index == 0)    // only if this is the latest issue 
        {
            
            [uC updateCover:appCoverURL];
            
            
        }
        
        // set the cover in the table
        coverIV.image = cover;
    }
                                                                                
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)subscribeMethod
{

    NSLog(@"subscribe method");
    NSLog(@"subscription active: %d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"isProUpgradePurchased"] intValue]);

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isProUpgradePurchased"] intValue] == 0)
    {
        [appDelegate.inApp loadStore];
    }
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)selectMethod
{
    NSLog(@"Selected %d", item_index);
    
    // what do we need to do?
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NKIssue *nkIssue = [nkLib issueWithName:[appDelegate.pub nameOfIssueAtIndex:item_index]];
    
    // start downloading
    if (nkIssue.status == NKIssueContentStatusNone)
    {
        if ([appDelegate connected])
        {
            // tell the user to hold it
            button.enabled = NO;

            [button setTitle:@"PLEASE WAIT" forState:UIControlStateNormal];

            [appDelegate.storeVC startDownload:item_index];
        
        }
        else
        {
            // not connected
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warning" message: @"Cannot continue. There is no internet connection." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
        // do nothing
        if (nkIssue.status == NKIssueContentStatusDownloading)
        {
            NSLog(@"Issue: do nothing (already downloading)");
        }
        else
            // read the issue
            if (nkIssue.status == NKIssueContentStatusAvailable)
            {
                // is this the top (latest) issue?
                if (item_index == 0)
                {
                    // remove any existing sash and badge
//                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                }
                
                // init the magvc
                appDelegate.magVC = [[MagViewController alloc] initWithNibName:nil bundle:nil];
                
                
                // init the magazine view controller
                [appDelegate.magVC setIndex:item_index];
                
                // and push it onto the view controller
                // push the  nav controller
                if (IS_OS_7_OR_LATER)
                {   
                    [appDelegate.navController pushViewControllerRetro:appDelegate.magVC];      
                }
                else
                {   [appDelegate.navController pushViewController:appDelegate.magVC animated:YES];  }
                
                
            }
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void) setWithData:(NSMutableDictionary *)issueData index:(int)index
{
    // save the item index
    item_index = index;

    // get the NKLibrary issue object
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NKIssue *nkIssue = [nkLib issueWithName:[issueData objectForKey:@"Name"]];
    
    // Theinhardt-Bd
    // Theinhardt-UltLt

    // setup
    CGSize titlesize;
    CGSize descsize;
    
    // title string
//    UIFont *copyFont = [UIFont fontWithName:@"Helvetica" size:18.0f];
    UIFont *copyFont = [UIFont fontWithName:@"Theinhardt-Bd" size:16];
    
    CGSize constraint = CGSizeMake(488, 20000.0f);
    titlesize = [[issueData objectForKey:@"Title"] sizeWithFont:copyFont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    
    if ((appDelegate.storeVC.is_portrait) && ([appDelegate isiPhone]))  // iPhone
    {
        titleLabel.frame = CGRectMake(34, 20, 250, titlesize.height);
    }
    else
    if (appDelegate.storeVC.is_portrait)    // iPad portrait
    {
        titleLabel.frame = CGRectMake(275, TOPPADDING+0, 250, titlesize.height);
    }
    else    // iPad landscape
    {
        titleLabel.frame = CGRectMake(275, TOPPADDING+0, 250, titlesize.height);
    }
    
    
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setContentMode:UIViewContentModeScaleAspectFit];
    [titleLabel setText:[issueData objectForKey:@"Title"]];
    [titleLabel setFont:copyFont];
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    
    [self addSubview:titleLabel];
    
    // issue description
    
    if ((appDelegate.storeVC.is_portrait) && ([appDelegate isiPhone]))  // iPhone
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-UltLt" size:14];    
        constraint = CGSizeMake(250, 20000.0f);
        descsize = [[issueData objectForKey:@"iPhoneDesc"] sizeWithFont:copyFont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

        descLabel.frame = CGRectMake(34, 275, 250, descsize.height);
        [descLabel setText:[issueData objectForKey:@"iPhoneDesc"]];
    }
    else
    if (appDelegate.storeVC.is_portrait)    // iPad portrait
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-UltLt" size:15];
        constraint = CGSizeMake(250, 20000.0f);
        descsize = [[issueData objectForKey:@"iPadDesc"] sizeWithFont:copyFont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

        descLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titlesize.height+15, 250, descsize.height);
        [descLabel setText:[issueData objectForKey:@"iPadDesc"]];
    }
    else    // iPad landscape
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-UltLt" size:15];
        constraint = CGSizeMake(400, 20000.0f);
        descsize = [[issueData objectForKey:@"iPadDesc"] sizeWithFont:copyFont constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        descLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titlesize.height+15, 400, descsize.height);
        [descLabel setText:[issueData objectForKey:@"iPadDesc"]];
    }
    
    
    descLabel.backgroundColor = [UIColor clearColor];
    [descLabel setContentMode:UIViewContentModeScaleAspectFit];
    [descLabel setFont:copyFont];
    [descLabel setNumberOfLines:0];
    [descLabel setLineBreakMode:UILineBreakModeWordWrap];
    
    [self addSubview:descLabel];
    
    NSLog(@"%@", issueData);
    

    // status stringbutton
    NSString *issueStatusString;
    
   
    if (nkIssue.status == NKIssueContentStatusNone)
    {
        if ([appDelegate isiPhone])
        {
            issueStatusString = [NSString stringWithFormat:@"TAP TO DOWNLOAD (%@)", [issueData objectForKey:@"iPhoneSize"]];
        }
        else
        {
            issueStatusString = [NSString stringWithFormat:@"TAP TO DOWNLOAD (%@)", [issueData objectForKey:@"iPadSize"]];
        }
    
        downloadProgress.alpha=0.0;
        button.enabled = YES;
        buttonSubscribe.hidden = NO;
        
    }
    else
    if (nkIssue.status == NKIssueContentStatusDownloading)
    {

        downloadProgress.alpha=1.0;
        button.enabled = NO;
        buttonSubscribe.hidden = YES;
        
    }
    else
    if (nkIssue.status == NKIssueContentStatusAvailable)
    {
        issueStatusString = @"TAP TO READ";
        downloadProgress.alpha=0.0;
        button.enabled = YES;
        buttonSubscribe.hidden = NO;
        
    }
    
    [button setTitle:issueStatusString forState:UIControlStateNormal];
    button.frame = CGRectMake(descLabel.frame.origin.x, descLabel.frame.origin.y+descsize.height+15, 230.0, 30.0);
    [self addSubview:button];
    
    
    // ---- subscribe button
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isProUpgradePurchased"] intValue] == 0)
    {
        issueStatusString = @"TAP TO SUBSCRIBE (FREE)";
        buttonSubscribe.enabled = YES;

        [buttonSubscribe setTitle:issueStatusString forState:UIControlStateNormal];
        buttonSubscribe.frame = CGRectMake(descLabel.frame.origin.x, descLabel.frame.origin.y+descsize.height+15+40, 230.0, 30.0);
        [self addSubview:buttonSubscribe];
    }
    else
    {
        buttonSubscribe.hidden = YES;
    }
    
    
    
    // progress bar
    downloadProgress.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+45, 250, 20);
    downloadProgress.alpha = 1.0;
    downloadProgress.hidden = YES;
    [self addSubview:downloadProgress];

    [downloadProgress setProgress:0.0f animated:NO];
    
    // cover image view
    
    // ---- iPhone
    if ([appDelegate isiPhone])
    {
        coverIV.frame = CGRectMake(15, 15, 130, 173);
    }
    // ---- iPad
    else
    {
        coverIV.frame = CGRectMake(20, 20, 213, 282);
    }
    
    // grey cover bg
    if ((appDelegate.storeVC.is_portrait) && ([appDelegate isiPhone]))  // iPhone
    {
        greyCoverBG.frame = CGRectMake(82, 50, coverIV.frame.size.width+30, coverIV.frame.size.height+30);
    }
    else
    if (appDelegate.storeVC.is_portrait)    // iPad portrait
    {
        greyCoverBG.frame = CGRectMake(0, TOPPADDING, coverIV.frame.size.width+40, coverIV.frame.size.height+40);
    }
    else    // iPad landscape
    {
        greyCoverBG.frame = CGRectMake(0, TOPPADDING, coverIV.frame.size.width+40, coverIV.frame.size.height+40);
    }
    
    greyCoverBG.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.05f];
    
    
    [self addSubview:greyCoverBG];
    [greyCoverBG addSubview:coverIV];
    
    // get cover filename
    coverLocalFilename = [NSString stringWithFormat:@"%@.png", [issueData objectForKey:@"Name"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[appDelegate saveFilePath:coverLocalFilename]])
    {
        NSLog(@"Cover image: %@ EXISTS - using this cache", coverLocalFilename);
    
        // cover image exists, so just add it
        coverIV.image = [UIImage imageWithContentsOfFile:[appDelegate saveFilePath:coverLocalFilename]];
    }
    else
    {
        // cover image doesn't exist
        NSString *coverSourceURL;
        
        // get the correct source URL
        // ---- iPhone
        if ([appDelegate isiPhone])
        {
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
                coverSourceURL = [NSString stringWithString:[issueData objectForKey:@"CoveriPhoneRetina"]];
            else
                coverSourceURL = [NSString stringWithString:[issueData objectForKey:@"CoveriPhone"]];
        
        }
        else
        // ---- iPad
        {
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
                coverSourceURL = [NSString stringWithString:[issueData objectForKey:@"CoveriPadRetina"]];
            else
                coverSourceURL = [NSString stringWithString:[issueData objectForKey:@"CoveriPad"]];
        }
        
        // save the app cover url (just in case)
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0))
        appCoverURL = [NSString stringWithString:[issueData objectForKey:@"AppCoverRetina"]];
            else
        appCoverURL = [NSString stringWithString:[issueData objectForKey:@"AppCover"]];
        
        // setup the async load of the cover
        NSLog(@"Attempting to retrieve cover file: %@", coverSourceURL);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:coverSourceURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
        (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];  
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    }
    
    
    NSLog(@"%@", coverLocalFilename);
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------



@end
