//
//  PluginPanelClient.m
//  PluginPanel
//
//  Created by Александр Северьянов on 08.08.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import "PluginPanelClient.h"

NSString *const PluginPanelAddPluginNotification = @"PluginPanelAddPluginNotification";
NSString *const PluginPanelRemovePluginNotification = @"PluginPanelRemovePluginNotification";
NSString *const PluginPanelDidLoadedWindowNotification= @"PluginPanelDidLoadedWindowNotification";

NSString *const PluginPanelWindowNotificationKey= @"window";

void PluginPanelAddPlugin(DVTChoice * choise, NSWindow *window) {
    [[NSNotificationCenter defaultCenter] postNotificationName:PluginPanelAddPluginNotification object:choise userInfo:[NSDictionary dictionaryWithObject:window forKey:PluginPanelWindowNotificationKey]];
}
void PluginPanelRemovePlugin(DVTChoice * choise) {
    [[NSNotificationCenter defaultCenter] postNotificationName:PluginPanelRemovePluginNotification object:choise];
}