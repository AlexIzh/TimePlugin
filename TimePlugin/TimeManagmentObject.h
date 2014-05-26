//
//  TimeManagmentObject.h
//  TimePlugin
//
//  Created by Alex Severyanov on 02.09.13.
//  Copyright (c) 2013 Александр Северьянов. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *	Object for use one timer in the app.
 */
@interface TimeManagmentObject : NSObject

@property (nonatomic, readonly, getter = isPerforming) BOOL performing;
/**
 *	Return instance object.
 *
 *	@return	Instance object.
 */
+ (TimeManagmentObject*)defaultObject;
/**
 *	Add target for use timer. TimeManagmentObject will call selector for target every second.
 *
 *	@param	target	Target
 *	@param	selector	Selector
 */
- (void)addTarget:(id)target action:(SEL)selector;
/**
 *	Remove observer for timer.
 *
 *	@param	target	Object
 */
- (void)removeTarget:(id)target;
/**
 *	Remoe all objects from observer list.
 */
- (void)removeAllTargets;

@end
