//
//  InstructionsView.m
//
//

#import "InstructionsView.h"

@implementation InstructionsView

@synthesize imgView;

//---------------------------------------------------------------------------------------------------------------------------------------------------
-(void) closeThis
{
    [UIView animateWithDuration:0.5
                    delay:0.0
                    options: UIViewAnimationCurveEaseOut
                    animations:^{
                        
                        self.frame = CGRectMake(0, self.frame.size.height*2, self.frame.size.width, self.frame.size.height);
                        self.alpha = 0.0;
                        
                    } 
                    completion:^(BOOL finished){
                        // remove it
                        [self removeFromSuperview];
                        
                        // save the cookie
                        NSArray *path =
                            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString* stringPath = [[path lastObject] stringByAppendingPathComponent:@"read_instructions.plist"];
                        
                        NSString *doneString = @"READ";
                        [doneString writeToFile:stringPath atomically:YES encoding:NSUTF8StringEncoding error:nil];                        
                        
                        
                    }];
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        
        // white wrapper
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, frame.size.width,frame.size.height-8)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        // and create the image
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-240)/2, 0, 240, 390)];        
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0))
        {
            imgView.image = [UIImage imageNamed:@"instructions@2x.png"];        
        }
        else
        {
            imgView.image = [UIImage imageNamed:@"instructions.png"];        
        }
        
        [whiteView addSubview:imgView];
        
        // gesture recog for close
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeThis)];
        tap.numberOfTapsRequired = 1;
        [whiteView addGestureRecognizer:tap];
        
        
        
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

//---------------------------------------------------------------------------------------------------------------------------------------------------

@end
