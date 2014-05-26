//
//  CustomCell.m
//  CustomOutlineView
//
//  Created by Steven Streeting on 07/08/2010.
//  Copyright 2010 Torus Knot Software Ltd. 
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following condition:
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CustomCell.h"
#import "CustomCellController.h"
#import "MyTreeNode.h"


@implementation CustomCell

-(id)init {
	if (self = [super initTextCell:@""]){
	}
	return self;
}

-(void)setController:(CustomCellController*)ctrl {
	controller = ctrl;
}

- (CustomCellController *)controller {
    return controller;
}

#pragma mark -
#pragma mark Drawing

- (NSRect)titleRectForBounds:(NSRect)cellRect inView:(NSView*)controlView
{	
	//	Returns the proper bound for the cell's title while being edited
	NSRect textFrame;
	if (controller.node.isGroup)
	{
		textFrame = [controller.groupTitle frame];
	}
	else
	{
		textFrame = [controller.detailTitle frame];
	}
	
	cellRect.origin.x += textFrame.origin.x;
	cellRect.size.height = textFrame.size.height;
	
	return cellRect;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView*)controlView editor:(NSText*)textObj delegate:(id)anObject event:(NSEvent*)theEvent
{
	isEditing = YES;
	NSRect textFrame = [self titleRectForBounds:aRect inView:controlView];
	[super editWithFrame:textFrame inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView*)controlView editor:(NSText*)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
	isEditing = YES;
	NSRect textFrame = [self titleRectForBounds:aRect inView:controlView];
	[super selectWithFrame:textFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView
{
	// Override this to allow editing of the name by clicking anywhere in the box
	return NSCellHitContentArea | NSCellHitEditableTextArea;
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView; {
	[controller showViews:controlView frame:cellFrame highlight:[self isHighlighted] && !isEditing];
}

-(void)endEditing:(NSText *)textObj
{
	isEditing = NO;
	[super endEditing:textObj];
}

- (void)dealloc {
    PluginLog(@"%s", __PRETTY_FUNCTION__);
#if  !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end
