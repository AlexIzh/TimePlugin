//
//  CustomCellController.m
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

#import "CustomCellController.h"
#import "MyTreeNode.h"
#import "TimeManagmentObject.h"

@implementation CustomCellController

@synthesize detailView;
@synthesize groupView;
@synthesize node;
@synthesize detailTitle;
@synthesize groupTitle;
@synthesize textColour;


-(id)initWithNode:(MyTreeNode*)n {
	if ((self = [super init])) {
		node = n;
        if (![NSBundle loadNibNamed: @"CustomCells" owner: self])    {
            self = nil;
        }
        _timeLabel.stringValue = [node timeString];
    }
    return self;
}

-(void)showViews:(NSView*)parent frame:(NSRect)cellFrame highlight:(BOOL)highlight {
	NSView* nestedView;
	if ([node isGroup]) {
		nestedView = groupView;
	} else {
		nestedView = detailView;
    }
    [nestedView setFrame: cellFrame];
    if ([nestedView superview] != parent)
		[parent addSubview: nestedView];
}

-(void)hideViews {
	[detailView removeFromSuperview];
	[groupView removeFromSuperview];
}

- (void)setPlayButton:(NSButton *)playButton {
    if (_playButton != playButton) {
        _playButton.target = nil;
        _playButton.action = nil;
#if  !__has_feature(objc_arc)
        [_playButton autorelease];
        _playButton = [playButton retain];
#else 
        _playButton = playButton;
#endif
        _playButton.target = self;
        _playButton.action = @selector(buttonAction:);
    }
}

- (void)buttonAction:(NSButton *)btn {
    if (btn.state == NSOnState) {
        [[TimeManagmentObject defaultObject] addTarget:self action:@selector(timerAction:)];
    } else {
        [[TimeManagmentObject defaultObject] removeTarget:self];
    }
}

- (void)timerAction:(NSTimer *)timer {
    node.time += timer.timeInterval;
    _timeLabel.stringValue = [node timeString];
}

- (void)dealloc {
    PluginLog(@"%s", __PRETTY_FUNCTION__);
#if  !__has_feature(objc_arc)
    [_timeLabel release];
    [_playButton release];
    [detailTitle release];
    [detailView release];
    [groupTitle release];
    [groupView release];
    [textColour release];
    [node release];
    [super dealloc];
#endif
}


@end
