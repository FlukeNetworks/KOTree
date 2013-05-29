//
//  KOSelectingTableViewCell.m
//  Kodiak
//
//  Created by Adam Horacek on 18.04.12.
//  Copyright (c) 2012 Adam Horacek, Kuba Brecka
//
//  Website: http://www.becomekodiak.com/
//  github: http://github.com/adamhoracek/KOTree
//	Twitter: http://twitter.com/becomekodiak
//  Mail: adam@becomekodiak.com, kuba@becomekodiak.com
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "KOTreeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define KOCOLOR_FILES_TITLE [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define KOCOLOR_FILES_TITLE_SHADOW [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9] /*#000000*/
#define KOCOLOR_FILES_COUNTER [UIColor colorWithRed:0 green:0 blue:0 alpha:0.80] /*#000000*/
#define KOCOLOR_FILES_COUNTER_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] /*#ffffff*/
#define KOFONT_FILES_TITLE [UIFont fontWithName:@"HelveticaNeue" size:24.0f]
#define KOFONT_FILES_COUNTER [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]

@implementation KOTreeTableViewCell

@synthesize backgroundImageView;
@synthesize iconButton;
@synthesize titleTextField;
@synthesize countLabel;
@synthesize delegate;
@synthesize treeItem;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
		backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_row"]];
		[backgroundImageView setContentMode:UIViewContentModeTopRight];
		
		[self setBackgroundView:backgroundImageView];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[iconButton setFrame:CGRectMake(0, 0, 44, 44)];
		[iconButton setAdjustsImageWhenHighlighted:NO];
		[iconButton addTarget:self action:@selector(iconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[iconButton setImage:[UIImage imageNamed:@"filter_check"] forState:UIControlStateNormal];
		[iconButton setImage:[UIImage imageNamed:@"filter_check_active"] forState:UIControlStateSelected];
		[iconButton setImage:[UIImage imageNamed:@"filter_check_active"] forState:UIControlStateHighlighted];
		
		[self.contentView addSubview:iconButton];
		
		titleTextField = [[UITextField alloc] init];
        [titleTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[titleTextField setFont:KOFONT_FILES_TITLE];
		[titleTextField setTextColor:KOCOLOR_FILES_TITLE];
		[titleTextField.layer setShadowColor:KOCOLOR_FILES_TITLE_SHADOW.CGColor];
		[titleTextField.layer setShadowOffset:CGSizeMake(0, -1)];
		[titleTextField.layer setShadowOpacity:1.0f];
		[titleTextField.layer setShadowRadius:0.0f];
		
		[titleTextField setUserInteractionEnabled:NO];
		[titleTextField setBackgroundColor:[UIColor clearColor]];
		[titleTextField setFrame:CGRectMake(44, 4, self.frame.size.width - 148, 36)];
		[self.contentView addSubview:titleTextField];
		
		[self.layer setMasksToBounds:YES];
		
		countLabel = [[UILabel alloc] initWithFrame:CGRectMake(666, 28, 48, 28)];
		[countLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
		[countLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"filter_counter_bg"]]];
		[countLabel setTextAlignment:UITextAlignmentCenter];
		[countLabel setLineBreakMode:UILineBreakModeMiddleTruncation];
		[countLabel setFont:KOFONT_FILES_COUNTER];
		[countLabel setTextColor:KOCOLOR_FILES_COUNTER];
		[countLabel setShadowColor:KOCOLOR_FILES_COUNTER_SHADOW];
		[countLabel setShadowOffset:CGSizeMake(0, 1)];
		
		[self setAccessoryView:countLabel];
		[self.accessoryView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
        [self.accessoryView setFrame:CGRectMake(self.accessoryView.frame.origin.x - 20.0, self.accessoryView.frame.origin.y, self.accessoryView.frame.size.width, self.accessoryView.frame.size.height)];
		
    }
    return self;
}

//Shift the accessory view left because of overlaid view
- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView* defaultAccessoryView = nil;
    
    for (UIView* subview in self.subviews) {
        if (subview != self.textLabel &&
            subview != self.detailTextLabel &&
            subview != self.backgroundView &&
            subview != self.contentView &&
            subview != self.selectedBackgroundView &&
            subview != self.imageView &&
            subview.frame.origin.x > 0 // Assumption: the checkmark will always have an x position over 0.
            ) {
            defaultAccessoryView = subview;
            break;
        }
    }
    CGRect r = defaultAccessoryView.frame;
    r.origin.x -= 40.0;
    defaultAccessoryView.frame = r;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

- (void)setLevel:(NSInteger)level {
	CGRect rect;
	
	rect = iconButton.frame;
	rect.origin.x = 32 * level;
	iconButton.frame = rect;
	
	rect = titleTextField.frame;
	rect.origin.x = 44 + 32 * level;
    rect.size.width = (self.frame.size.width - 128) - 32 * level;
	titleTextField.frame = rect;
}

- (void)iconButtonAction:(id)sender {
	NSLog(@"iconButtonAction:");
	
	if (delegate && [delegate respondsToSelector:@selector(treeTableViewCell:didTapIconWithTreeItem:)]) {
		[delegate treeTableViewCell:(KOTreeTableViewCell *)self didTapIconWithTreeItem:(KOTreeItem *)treeItem];
	}
}

@end
