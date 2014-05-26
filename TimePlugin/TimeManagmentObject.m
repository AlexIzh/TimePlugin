//
//  TimeManagmentObject.m
//  TimePlugin
//
//  Created by Alex Severyanov on 02.09.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import "TimeManagmentObject.h"
#import "LogClient.h"

@interface TimeClass : NSObject
@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;
@end

@implementation TimeClass

- (void)dealloc {
    _action = nil;
#if  !__has_feature(objc_arc)
    [_target release];
    [super dealloc];
#endif
}

@end

@interface TimeManagmentObject() {
    NSMutableArray     *_items;
    NSTimer                         *_timer;
}

@end

@implementation TimeManagmentObject

+ (TimeManagmentObject *)defaultObject {
    static dispatch_once_t  onceToken;
    static TimeManagmentObject * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[TimeManagmentObject alloc] init];
    });
    return sSharedInstance;
}

- (id)init {
    if (self = [super init]) {
        PluginLog(@"%s", __PRETTY_FUNCTION__);
        _items = [NSMutableArray new];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)selector {
//    TimeClass *class = [[TimeClass new] autorelease];
    TimeClass *class = [TimeClass new];
#if  !__has_feature(objc_arc)
    [class autorelease];
#endif
    class.target = target;
    class.action = selector;
    [_items addObject:class];
    if (!_performing) {
        _performing = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
    }
}

- (void)removeTarget:(id)target {
    TimeClass *class = nil;
    for (TimeClass *cl in _items) {
        if (cl.target == target) {
            class = cl;
            break;
        }
    }
    [_items removeObject:class];
    if (!_items.count) {
        _performing = NO;
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)removeAllTargets {
    [_items removeAllObjects];
    _performing = NO;
    [_timer invalidate];
    _timer = nil;
}

- (void)dealloc {
    [_items removeAllObjects];
#if  !__has_feature(objc_arc)
    [_items release];
    [super dealloc];
#endif
}

- (void)fireTimer:(NSTimer *)timer {
    for (TimeClass *class in _items) {
        SEL selector = class.action;
        if ([class.target respondsToSelector:selector]) {
            [class.target performSelector:selector withObject:timer];
        }
    }
}

@end
