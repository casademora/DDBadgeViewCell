//
//  DDBadgeViewCell.m
//  DDBadgeViewCell
//
//  Created by digdog on 1/23/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. http://digdog.tumblr.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//   
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//   
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "DDBadgeViewCell.h"

#pragma mark -
#pragma mark DDBadgeView declaration



@interface DDBadgeView ()

@property (nonatomic, assign) id<DDBadgeViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<DDBadgeViewDelegate>)newCell;

@end

#pragma mark -
#pragma mark DDBadgeView implementation

@implementation DDBadgeView 

@synthesize delegate = _delegate;


#pragma mark -
#pragma mark init

- (id)initWithFrame:(CGRect)frame delegate:(id<DDBadgeViewDelegate>)delegate {
	
	if ((self = [super initWithFrame:frame])) {
		_delegate = delegate;
		
		self.backgroundColor = [UIColor clearColor];
		self.layer.masksToBounds = YES;
	}
	return self;
}

- (id) initWithTableCell:(UITableViewCell<DDBadgeViewDelegate> *)cell;
{
    self = [self initWithFrame:cell.contentView.bounds delegate:cell];
    if (self)
    {
         self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         self.contentMode = UIViewContentModeRedraw;
         self.contentStretch = CGRectMake(1., 0., 0., 0.);
         [cell.contentView addSubview:self];
    }
    return self;
}

#pragma mark -
#pragma mark redraw

- (void)drawRect:(CGRect)rect {	

    if ([[self.delegate badgeText] length] == 0) return;
	CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *currentSummaryColor = [UIColor blackColor];
    UIColor *currentDetailColor = [UIColor grayColor];
    UIColor *currentBadgeColor = self.delegate.badgeColor;
    if (!currentBadgeColor) {
        currentBadgeColor = [UIColor colorWithRed:0.53 green:0.6 blue:0.738 alpha:1.];
    }
    
	if (self.delegate.isHighlighted || self.delegate.isSelected) {
        currentSummaryColor = [UIColor whiteColor];
        currentDetailColor = [UIColor whiteColor];
		currentBadgeColor = self.delegate.badgeHighlightedColor;
		if (!currentBadgeColor) {
			currentBadgeColor = [UIColor whiteColor];
		}
	} 
	
	if (self.delegate.isEditing) {
		[currentSummaryColor set];
		[self.delegate.summary drawAtPoint:CGPointMake(10, 10) forWidth:rect.size.width withFont:[UIFont boldSystemFontOfSize:18.] lineBreakMode:UILineBreakModeTailTruncation];
		
		[currentDetailColor set];
		[self.delegate.detail drawAtPoint:CGPointMake(10, 32) forWidth:rect.size.width withFont:[UIFont systemFontOfSize:14.] lineBreakMode:UILineBreakModeTailTruncation];		
	} else {
		CGSize badgeTextSize = [self.delegate.badgeText sizeWithFont:[UIFont boldSystemFontOfSize:13.]];
		CGRect badgeViewFrame = CGRectIntegral(CGRectMake(rect.size.width - badgeTextSize.width - 24, (rect.size.height - badgeTextSize.height - 4) / 2, badgeTextSize.width + 14, badgeTextSize.height + 4));
		
		CGContextSaveGState(context);	
		CGContextSetFillColorWithColor(context, currentBadgeColor.CGColor);
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.width - badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI / 2, M_PI * 3 / 2, YES);
		CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI * 3 / 2, M_PI / 2, YES);
		CGContextAddPath(context, path);
		CGContextDrawPath(context, kCGPathFill);
		CFRelease(path);
		CGContextRestoreGState(context);
		
		CGContextSaveGState(context);	
		CGContextSetBlendMode(context, kCGBlendModeClear);
		[self.delegate.badgeText drawInRect:CGRectInset(badgeViewFrame, 7, 2) withFont:[UIFont boldSystemFontOfSize:13.]];
		CGContextRestoreGState(context);
		
		[currentSummaryColor set];
		[self.delegate.summary drawAtPoint:CGPointMake(10, 10) forWidth:(rect.size.width - badgeViewFrame.size.width - 24) withFont:[UIFont boldSystemFontOfSize:18.] lineBreakMode:UILineBreakModeTailTruncation];
		
		[currentDetailColor set];
		[self.delegate.detail drawAtPoint:CGPointMake(10, 32) forWidth:(rect.size.width - badgeViewFrame.size.width - 24) withFont:[UIFont systemFontOfSize:14.] lineBreakMode:UILineBreakModeTailTruncation];		
	}
}

@end

#pragma mark -
#pragma mark DDBadgeViewCell private

@interface DDBadgeViewCell () <DDBadgeViewDelegate>
@property (nonatomic, retain) DDBadgeView *	badgeView;
@end

#pragma mark -
#pragma mark DDBadgeViewCell implementation

@implementation DDBadgeViewCell

@synthesize summary = summary_;
@synthesize detail = detail_;
@synthesize badgeView = badgeView_;
@synthesize badgeText = badgeText_;
@synthesize badgeColor = badgeColor_;
@synthesize badgeHighlightedColor = badgeHighlightedColor_;

#pragma mark -
#pragma mark init & dealloc

- (void)dealloc {
	
	[badgeView_ release], badgeView_ = nil;
	
    [summary_ release], summary_ = nil;
    [detail_ release], detail_ = nil;
	[badgeText_ release], badgeText_ = nil;
	[badgeColor_ release], badgeColor_ = nil;
	[badgeHighlightedColor_ release], badgeHighlightedColor_ = nil;
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        badgeView_ = [[DDBadgeView alloc] initWithTableCell:self];
    }
    return self;
}

#pragma mark -
#pragma mark accessors

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
		
	[self.badgeView setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

	[super setHighlighted:highlighted animated:animated];
		
	[self.badgeView setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];

	[self.badgeView setNeedsDisplay];
}

@end
