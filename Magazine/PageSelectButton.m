//
//  PageSelectButton.m
//

#import "AppDelegate.h"
#import "PageSelectButton.h"

@implementation PageSelectButton

@synthesize issue_path;
@synthesize thumbIV;
@synthesize indicator;
@synthesize imageURL;

//---------------------------------------------------------------------------------------------------------------------------------------------------
// downloads and processes the image sync
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                    UIImage *image = [[UIImage alloc] initWithData:data];
                                    completionBlock(YES,image);
                                } else{
                                    completionBlock(NO,nil);
                                }
                           }];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)becomeVisible
{
    // already visible
    if (visible == YES)
    {   return; }
    
    // set to visible now
    visible = YES;
    
    // show the activity indicator
    [self addSubview:indicator];
    [indicator startAnimating]; 

    // download the image asynchronously
    [self downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {

            // remove the activity indicator 
            [indicator removeFromSuperview];

            // change the image in the cell
            thumbIV.image = image;
        }
    }];        

}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)becomeInvisible
{
    // already invisible
    if (visible == NO)
    {   return; }

    // set to invisible
    visible = NO;
    
    // destroy the image
    thumbIV.image = nil;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tapForIndex
{
    [appDelegate.magVC setPage:page_index hideStatus:YES];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithPath:(NSString *)path andIndex:(int)index
{
    self = [super initWithFrame:CGRectMake((index-1)*122, 4, 122, 162)];
    if (self) {

        // save the path
        issue_path = [NSString stringWithString:path];
        page_index = index;
        
        // some vars
        visible = NO;
        
        // init the display
        self.backgroundColor = [UIColor blackColor];

        // add ther GR
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapForIndex)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];    
        
        
        // the image view
        NSString *imageFname;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        {
            // Retina display
            imageFname = [NSString stringWithFormat:@"%@/retina_thumbs/issue%d.jpg", issue_path, index];
        }
        else
        {
            // non-Retina display
            imageFname = [NSString stringWithFormat:@"%@/thumbs/issue%d.jpg", issue_path, index];
        }        
        
        // define the url (from the path)
        imageURL = [NSURL fileURLWithPath:imageFname];
        
        // init the image view
        thumbIV =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 122, 162)];        
        [self addSubview:thumbIV];
        
        // add the activity indicator
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleLeftMargin;
        indicator.center = CGPointMake(122.0/2, 162.0/2);
      
        
        
    }
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
