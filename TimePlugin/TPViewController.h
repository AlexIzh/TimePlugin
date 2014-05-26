//
//  TPViewController.h
//  TimePlugin
//
//  Created by Александр Северьянов on 08.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TPViewController : NSViewController {
    IBOutlet NSOutlineView *outlineView;
}

@property (nonatomic, assign) NSWindow *mainWindow;

- (IBAction)addNote:(id)sender;
- (IBAction)removeNote:(id)sender;

- (IBAction)import:(id)sender;
- (IBAction)stopAll:(id)sender;
@end
