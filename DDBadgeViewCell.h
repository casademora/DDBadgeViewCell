//
//  DDBadgeViewCell.h
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

#import <UIKit/UIKit.h>

@protocol DDBadgeViewDelegate <NSObject>

- (BOOL) isEditing;
- (BOOL) isHighlighted;
- (BOOL) isSelected;

- (NSString *) summary;
- (NSString *) detail;
- (NSString *) badgeText;
- (UIColor *) badgeColor;
- (UIColor *) badgeHighlightedColor;

@end

@interface DDBadgeView : UIView 

- (id) initWithTableCell:(UITableViewCell<DDBadgeViewDelegate> *)cell;
                          
@end

@interface DDBadgeViewCell : UITableViewCell 

@property (nonatomic, copy) NSString *      summary;
@property (nonatomic, copy) NSString *      detail;
@property (nonatomic, copy) NSString *		badgeText;
@property (nonatomic, retain) UIColor *		badgeColor;
@property (nonatomic, retain) UIColor *		badgeHighlightedColor;

@end
