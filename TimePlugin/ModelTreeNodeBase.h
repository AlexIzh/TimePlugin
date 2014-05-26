//
//  ModelTreeNodeBase.h
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

// Model object to hold the structure of the tree
@interface ModelTreeNodeBase : NSObject <NSCoding, NSCopying>
{
	NSString *name;
	NSMutableArray *children;
	BOOL isGroup;
}

@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSArray *children;
@property(assign, nonatomic) BOOL isGroup;

- (id)init;
- (id)initWithName:(NSString*)name;
- (id)initGroupWithName:(NSString*)name;
- (id)copyWithZone:(NSZone*)zone;
- (NSArray*)keysForEncoding;
- (id)initWithCoder:(NSCoder*)coder;
- (void)encodeWithCoder:(NSCoder*)coder;
- (void)setNilValueForKey:(NSString *)key;
- (NSUInteger)countOfChildren;
- (void)insertObject:(id)object inChildrenAtIndex:(NSUInteger)index;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index;
- (void)removeObjectFromChildren:(id)object;
- (id)objectInChildrenAtIndex:(NSUInteger)index;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)index withObject:(id)object;
- (NSString*)description;

@end
