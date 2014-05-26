//
//  TimePlugin.m
//  TimePlugin
//
//  Created by Александр Северьянов on 08.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import "TimePlugin.h"
#import "DVTKit.h"
#import "PluginPanelClient.h"
#import "TPViewController.h"
#import "TimeManagmentObject.h"

@implementation TimePlugin


+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panelDidLoadNote:) name:PluginPanelDidLoadedWindowNotification object:nil];
    }
    return self;
}

- (void)panelDidLoadNote:(NSNotification *)note {
    static NSImage *image = nil;
    if (!image) {
        image  = [[NSImage alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForImageResource:@"plugin_icon"]];
#if  !__has_feature(objc_arc)
        [image autorelease];
#endif
    }
    TPViewController *c = [[TPViewController alloc] initWithNibName:@"TPView" bundle:[NSBundle bundleForClass:self.class]];
#if  !__has_feature(objc_arc)
    [c autorelease];
#endif
    c.mainWindow = [note.userInfo objectForKey:PluginPanelWindowNotificationKey];
    DVTChoice *choice = [[NSClassFromString(@"DVTChoice") alloc] initWithTitle:@"Time" toolTip:@"Time management plugin" image:image representedObject:c];
#if  !__has_feature(objc_arc)
    [choice autorelease];
#endif
    PluginPanelAddPlugin(choice, [[note userInfo] objectForKey:PluginPanelWindowNotificationKey]);
}

- (void)dealloc
{
//    [[TimeManagmentObject defaultObject] removeAllTargets];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if  !__has_feature(objc_arc)
       [super dealloc];
#endif
}

@end
