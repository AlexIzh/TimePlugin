//
//  CustomCellController.h
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

#import <Cocoa/Cocoa.h>


@class MyTreeNode;

@interface CustomCellController : NSObject 
{
	NSView* detailView;
	NSView* groupView;	
	
	NSTextField* detailTitle;
	NSTextField* groupTitle;
		
	NSColor* textColour;	
	
	MyTreeNode* node;
	
}

@property (nonatomic, retain) IBOutlet NSView* detailView;
@property (nonatomic, retain) IBOutlet NSView* groupView;
@property (nonatomic, retain) IBOutlet NSTextField* detailTitle;
@property (nonatomic, retain) IBOutlet NSTextField* groupTitle;
@property (nonatomic, retain) IBOutlet NSButton *playButton;
@property (nonatomic, retain) IBOutlet NSTextField  *timeLabel;

@property (nonatomic, retain) MyTreeNode* node;
@property (nonatomic, retain) NSColor* textColour;

-(id)initWithNode:(MyTreeNode*)n;
-(void)showViews:(NSView*)parent frame:(NSRect)cellFrame highlight:(BOOL)highlight;
-(void)hideViews;

- (void)buttonAction:(NSButton *)btn;
- (void)timerAction:(NSTimer *)timer;

@end
