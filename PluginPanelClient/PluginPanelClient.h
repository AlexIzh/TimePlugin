//
//  PluginPanelClient.h
//  PluginPanel
//
//  Created by Александр Северьянов on 08.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
//#import "DVTKit.h"
extern NSString *const PluginPanelAddPluginNotification;
extern NSString *const PluginPanelRemovePluginNotification;
extern NSString *const PluginPanelDidLoadedWindowNotification;
extern NSString *const PluginPanelWindowNotificationKey;
@class DVTChoice;

FOUNDATION_EXPORT void PluginPanelAddPlugin(DVTChoice * choise, NSWindow *window);
FOUNDATION_EXPORT void PluginPanelRemovePlugin(DVTChoice * choise);