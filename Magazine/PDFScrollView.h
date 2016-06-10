//
//  PDFScrollView.h
//  Magazine
//
//  Created by ray jakes on 18/04/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
 
 
@interface PDFScrollView : UIScrollView <UIScrollViewDelegate> 
 
- (void)setPDFPage:(CGPDFPageRef)PDFPage;
 
@end