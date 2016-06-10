//
//  TiledPDFView.h
//  Magazine
//
//  Created by ray jakes on 18/04/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
 
@interface TiledPDFView : UIView
 
- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;
 
@end