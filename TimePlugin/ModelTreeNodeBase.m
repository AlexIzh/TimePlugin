//
//  ModelTreeNodeBase.m
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

#import "ModelTreeNodeBase.h"


@implementation ModelTreeNodeBase

@synthesize name;
@synthesize isGroup;
@synthesize children;


- (id)init {
	if (self = [super init]) {
		self.isGroup = NO;
	}
	return self;
}

- (id)initWithName:(NSString*)n {
	self = [self init];
	self.name = n;
	return self;
	
}

- (id)initGroupWithName:(NSString*)n {
	self = [self init];
	self.name = n;
	self.isGroup = YES;
	return self;
	
}


-(NSString*)description
{
	return name;
}

#pragma mark -
#pragma mark Property overrides

- (void)setIsGroup:(BOOL)g {
	isGroup = g;
	if (isGroup)
		children = [NSMutableArray array];
	else
	{
#if  !__has_feature(objc_arc)
		[children release];
#endif
		children = nil;
	}
}

#pragma mark -
#pragma mark NSCopying protocol
- (id)copyWithZone:(NSZone*)zone {
	ModelTreeNodeBase *copy = [[ModelTreeNodeBase allocWithZone:zone] init];
	if (copy) {
		copy.name = self.name;
		copy.isGroup = self.isGroup;
		if (self.isGroup)
			copy.children = self.children;
		
	}
	return copy;
}

#pragma mark -
#pragma mark NSCoding protocol

- (NSArray*)keysForEncoding {
	return [NSArray arrayWithObjects:@"name", @"isGroup", @"children", nil];
}

- (id)initWithCoder:(NSCoder*)coder {
	if ([self init])
	{
		for (NSString *key in [self keysForEncoding])
		{
			// Tolerate missing values
			if ([coder containsValueForKey:key])
				[self setValue:[coder decodeObjectForKey:key] forKey:key];
		}
	}
	return self;
}
- (void)encodeWithCoder:(NSCoder*)coder {
	for (NSString *key in [self keysForEncoding])
		[coder encodeObject:[self valueForKey:key] forKey:key];
}

- (void)setNilValueForKey:(NSString *)key {
	// overridden to deal with primitives
	if ([key isEqualToString:@"isGroup"])
		self.isGroup = NO;
	else 
		[super setNilValueForKey:key];
	
}

#pragma mark -
#pragma mark KVC helper methods
// For why these methods are needed, see
// http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/KeyValueCoding/Concepts/AccessorConventions.html#//apple_ref/doc/uid/20002174-SW4
- (NSUInteger)countOfChildren {
	if (!children)
		return 0;
	else
		return [children count];
}

- (void)insertObject:(id)object inChildrenAtIndex:(NSUInteger)index {
	if (isGroup)
	{
		[children insertObject:object atIndex:index];
	}
}

- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index {
	if (isGroup)
		[children removeObjectAtIndex:index];
	
}

- (void)removeObjectFromChildren:(id)object {
	if (isGroup)
		[children removeObject:object];
	
}

- (id)objectInChildrenAtIndex:(NSUInteger)index {
	if(!isGroup)
		return nil;
	else 
		return [children objectAtIndex:index];
	
}

- (void)replaceObjectInChildrenAtIndex:(NSUInteger)index withObject:(id)object {
	if (isGroup) {
		[children replaceObjectAtIndex:index withObject:object];
	}
	
}

- (void)dealloc {
#if  !__has_feature(objc_arc)
    [name release];
    [children release];
    [super dealloc];
#endif
}


@end
