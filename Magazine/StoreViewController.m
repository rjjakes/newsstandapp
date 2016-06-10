//
//  StoreViewController.m
//

#import "StoreViewController.h"
#import "AppDelegate.h"
#import "ZipArchive/ZipArchive.h"

@implementation StoreViewController

@synthesize bgIV;
@synthesize issuesTableView;
@synthesize niLabel, niButtonReload;
@synthesize loadLabel;
@synthesize is_portrait;

//------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
        
    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable])
    {
        // internet suddenly became reachable
        [appDelegate.apnObject setToken:appDelegate.tmpdeviceToken];
        
        
    }
    else
    {
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// update the issues list table with new data
- (void) refreshTableData
{
    // if the issues tableview exists
    if (self.issuesTableView)
    {
        // should we show or hide the "no issues" label?
        if ([appDelegate.pub.issuesList count] != 0)
        {
            if (niLabel)
            {   [niLabel removeFromSuperview];  }

            if (niButtonReload)
            {   [niButtonReload removeFromSuperview];  }

            if (loadLabel)
            {   [loadLabel removeFromSuperview];  }
        }
    
        // refresh the table
        [self.issuesTableView reloadData];
    }
    else
    {   NSLog(@"table view was not initialised");   }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void) startDownload:(int)index
{
    // let's retrieve the NKIssue
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NKIssue *nkIssue = [nkLib issueWithName:[appDelegate.pub nameOfIssueAtIndex:index]];
    // let's get the publisher's server URL (stored in the issues plist)
    NSURL *downloadURL = [appDelegate.pub contentURLForIssueWithName:nkIssue.name];
    
    if(!downloadURL) return;
    // let's create a request and the NKAssetDownload object
    NSURLRequest *req = [NSURLRequest requestWithURL:downloadURL];
    NKAssetDownload *assetDownload = [nkIssue addAssetWithRequest:req];
    [assetDownload setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:index],@"Index",
                                nil]];
    // let's start download
    [assetDownload downloadWithDelegate:self];
    
    // and tell the server this is being downloaded (stats)
    downloadset* ds = [[downloadset alloc] init];
    [ds setDownload:[appDelegate.pub nameOfIssueAtIndex:index]];
    
    
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void)updateProgressOfConnection:(NSURLConnection *)connection withTotalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{

    // get pointer to the cell
    NKAssetDownload *dnl = connection.newsstandAssetDownload;
    IssueTableCell *cell = (IssueTableCell *)[issuesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[dnl.userInfo objectForKey:@"Index"] intValue] inSection:0]];

    // update the progress
    [cell updateProgress:1.f*totalBytesWritten/expectedTotalBytes];

//    NSLog(@"%, %d", totalBytesWritten, expectedTotalBytes);

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    NSLog(@"Resume downloading %f",1.f*totalBytesWritten/expectedTotalBytes);
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];    
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {

    // get various pointers
    NKAssetDownload *dnl = connection.newsstandAssetDownload;
    NKIssue *nkIssue = dnl.issue;
    NSString *contentPath = [nkIssue.contentURL path];
//    NSError *moveError=nil;
    
    // init the unzip class
    ZipArchive *za = [[ZipArchive alloc] init];
    
    // perform the unzip
    if ([za UnzipOpenFile: [destinationURL path]])
    {
        BOOL ret = [za UnzipFileTo: contentPath overWrite: YES];
        
        if (NO == ret){ NSLog(@"Unzip FAILED"); } [za UnzipCloseFile];
    }    
    
    za = nil;

//    if([[NSFileManager defaultManager] moveItemAtPath:[destinationURL path] toPath:contentPath error:&moveError]==NO) {
//        NSLog(@"Error copying file from %@ to %@",destinationURL,contentPath);
//    }

    [self refreshTableData];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
//    NSLog(@"%d", (int)[appDelegate.pub.issuesList count]);

    return [appDelegate.pub.issuesList count];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    // deselect the cell
    [issuesTableView deselectRowAtIndexPath:indexPath animated:NO];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((appDelegate.storeVC.is_portrait) && ([appDelegate isiPhone]))  // iPhone
    {
        return 425;
    }
    else
    if (appDelegate.storeVC.is_portrait)    // iPad portrait
    {
        return 420;
    }
    else    // iPad landscape
    {
        return 420;
    }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"IssueCell%d", (int)indexPath.row];

    IssueTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[IssueTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setWithData:[appDelegate.pub.issuesList objectAtIndex:(int)indexPath.row] index:(int)indexPath.row];
    
    
    return cell;
}

//------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

//------------------------------------------------------------------------------------------
- (void)realignElements
{
    float statusbar_padding = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        statusbar_padding = 20.0;
    }
    
    // ---- iPhone
    if ((is_portrait) && ([appDelegate isiPhone]))
    {
        // self.view
        self.view.frame = CGRectMake(0, statusbar_padding, [appDelegate getScreenWidth], [appDelegate getScreenHeight]-statusbar_padding);
        
        NSLog(@"Screen height: %f", [appDelegate getScreenHeight]);
    
        // background
        bgIV.frame = CGRectMake(0, statusbar_padding, 320, 460);

        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        bgIV.image = [UIImage imageNamed:@"iPhonePortrait@2x.png"];
            else
        bgIV.image = [UIImage imageNamed:@"iPhonePortrait.png"];

        // tableleview
        NSLog(@"PADDING: %f", statusbar_padding);
        
        issuesTableView.frame = CGRectMake(0, statusbar_padding, 320, [appDelegate getScreenHeight]-20);

        // ni labels
        niLabel.frame = CGRectMake(80, 100, niLabel.frame.size.width, niLabel.frame.size.width);
        niButtonReload.frame = CGRectMake(80, 230, niButtonReload.frame.size.width, niButtonReload.frame.size.height);
        loadLabel.frame = CGRectMake(80, 110, loadLabel.frame.size.width, loadLabel.frame.size.width);
    }
    else
    // ---- iPad portrait
    if (is_portrait)
    {
        // self.view
        self.view.frame = CGRectMake(0, statusbar_padding, 768, 1024-statusbar_padding);
    
        // background
        bgIV.frame = CGRectMake(0, statusbar_padding, 768, 1004);

        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        bgIV.image = [UIImage imageNamed:@"iPadPortrait@2x.png"];
            else
        bgIV.image = [UIImage imageNamed:@"iPadPortrait.png"];

        // tableleview
        issuesTableView.frame = CGRectMake(200, 0, 553+15, 1004);

        // ni labels
        niLabel.frame = CGRectMake(250, 230, niLabel.frame.size.width, niLabel.frame.size.width);
        niButtonReload.frame = CGRectMake(250, 440, niButtonReload.frame.size.width, niButtonReload.frame.size.height);
        loadLabel.frame = CGRectMake(250, 200, loadLabel.frame.size.width, loadLabel.frame.size.width);
    }
    // ---- iPad landscape
    else
    {
        // self.view
        self.view.frame = CGRectMake(0, statusbar_padding, 1024, 768-statusbar_padding);
    
        // background
        bgIV.frame = CGRectMake(0, statusbar_padding, 1024, 748);

        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        bgIV.image = [UIImage imageNamed:@"iPadLandscape@2x.png"];
            else
        bgIV.image = [UIImage imageNamed:@"iPadLandscape.png"];
        
        // tableleview
        issuesTableView.frame = CGRectMake(230, 0, 1024-230, 768-20);

        // ni labels
        niLabel.frame = CGRectMake(380, 160, niLabel.frame.size.width, niLabel.frame.size.width);
        niButtonReload.frame = CGRectMake(380, 370, niButtonReload.frame.size.width, niButtonReload.frame.size.height);
        loadLabel.frame = CGRectMake(380, 170, loadLabel.frame.size.width, loadLabel.frame.size.width);

    }

    // rebuild the tableview cells
    [self refreshTableData];
    
}

//------------------------------------------------------------------------------------------
- (void)niButtonReloadAction
{
    [appDelegate.pub getIssuesListFromServer];
}

//------------------------------------------------------------------------------------------
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    // init the self
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // setup uiimageview background
    bgIV =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];        
    [self.view addSubview:bgIV];
    
    // orientation
    if ((self.interfaceOrientation == UIInterfaceOrientationPortrait) || (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        is_portrait = YES;
    }
    else
    {   is_portrait = NO;   }
    

    // init the tableview showing the list of issues available
    issuesTableView = [[UITableView alloc] initWithFrame:CGRectMake(200, 0, 550, [appDelegate getScreenHeight]) style:UITableViewStylePlain];
    issuesTableView.backgroundColor = [UIColor clearColor];
    issuesTableView.dataSource = self;
    issuesTableView.delegate = self;
    issuesTableView.tag = 1;
        
    issuesTableView.separatorColor = [UIColor clearColor];


    [self.view addSubview:issuesTableView];
    
    // the "no issues" label
    UIFont *copyFont;
    niLabel = [[UILabel alloc] init];
    
    if ([appDelegate isiPhone])
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-Bd" size:16];
        niLabel.frame = CGRectMake(100, 100, 200, 100);
    }
    else
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-Bd" size:22];
        niLabel.frame = CGRectMake(100, 100, 350, 100);
    }
    
    niLabel.backgroundColor = [UIColor clearColor];
    niLabel.textColor = [UIColor lightGrayColor];
    [niLabel setContentMode:UIViewContentModeScaleAspectFit];
    [niLabel setTextAlignment:UITextAlignmentCenter];    
    [niLabel setText:@"NO ISSUES AVAILABLE (are you connected to the internet?)"];
    [niLabel setFont:copyFont];
    [niLabel setNumberOfLines:0];
    [niLabel setLineBreakMode:UILineBreakModeWordWrap];    
    [self.view addSubview:niLabel];
    
    // reload issues button
    niButtonReload = [UIButton buttonWithType:UIButtonTypeSystem];
    [niButtonReload addTarget:self action:@selector(niButtonReloadAction) forControlEvents:UIControlEventTouchUpInside];
    [niButtonReload setTitle:@"TAP TO RELOAD" forState:UIControlStateNormal];

    if ([appDelegate isiPhone])
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-Bd" size:16];
        niButtonReload.frame = CGRectMake(100, 100, 200, 30);
    }
    else
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-Bd" size:22];
        niButtonReload.frame = CGRectMake(100, 100, 350, 30);
    }

    [self.view addSubview:niButtonReload];
    
    
    // the "loading issues.. please wait..." label
    loadLabel = [[UILabel alloc] init];
    
    if ([appDelegate isiPhone])
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-Bd" size:16];
        loadLabel.frame = CGRectMake(100, 100, 200, 100);
    }
    else
    {
        copyFont = [UIFont fontWithName:@"Theinhardt-Bd" size:22];
        loadLabel.frame = CGRectMake(100, 100, 350, 100);
    }
    
    loadLabel.backgroundColor = [UIColor clearColor];
    loadLabel.textColor = [UIColor lightGrayColor];
    [loadLabel setContentMode:UIViewContentModeScaleAspectFit];
    [loadLabel setTextAlignment:UITextAlignmentCenter];    
    [loadLabel setText:@"LOADING ISSUES LIST... PLEASE WAIT..."];
    [loadLabel setFont:copyFont];
    [loadLabel setNumberOfLines:0];
    [loadLabel setLineBreakMode:UILineBreakModeWordWrap];
    
    
    // and align all the elements based on the orientation and device
    [self realignElements];
    
    
}


//------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    [super viewDidLoad];
}

//------------------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"going for a refresh");
    // immediately attempt to get the new list of issues
    [appDelegate.pub getIssuesListFromServer];

    // hide the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void) realignPortrait
{
    is_portrait = YES;
    [self realignElements];
    
}

-(void) realignLandscape
{
    is_portrait = FALSE;
    [self realignElements];
}

//------------------------------------------------------------------------------------------
- (void)reAlignEverything:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        [self realignPortrait];
    }
    else
    {
        [self realignLandscape];
    }

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)prefersStatusBarHidden {return NO;}

//------------------------------------------------------------------------------------------
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    [self reAlignEverything:toInterfaceOrientation];
}

//------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    // Return YES for supported orientations
    if (screenWidth < 600)
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else
    {
        return YES; 
    }
}

//------------------------------------------------------------------------------------------

@end
