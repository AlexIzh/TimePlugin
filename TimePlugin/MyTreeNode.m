//
//  ModelTreeNode.m
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

#import "MyTreeNode.h"


@implementation MyTreeNode

@synthesize hashValue;

- (id)init
{
	if (self = [super init])
	{
		// Generate a hash for this instance and copies of it
		// This is a bit hacky and you might not want to do this, it makes the
		// instance unique and easy to store as a hash value for comparison / indexing
		hashValue = [[[NSProcessInfo processInfo] globallyUniqueString] hash];

	}
	return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
        self.name = [dictionary objectForKey:@"name"];
        self.time = [[dictionary objectForKey:@"time"] doubleValue];
        [self setIsGroup:[[dictionary objectForKey:@"group"] boolValue]];
        if ([self isGroup]) {
            NSArray *array = [dictionary objectForKey:@"children"];
            for (NSDictionary *dic in array) {
                MyTreeNode *node = [[MyTreeNode alloc] initWithDictionary:dic];
                node.parent = self;
                [self->children addObject:node];
            }
        }
    }
    return self;
}

- (NSDictionary *)dictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.name forKey:@"name"];
    [dictionary setObject:[NSNumber numberWithDouble:self.time] forKey:@"time"];
    [dictionary setObject:[NSNumber numberWithBool:[self isGroup]] forKey:@"group"];
    if ([self isGroup]) {
        NSMutableArray *array = [NSMutableArray array];
        for (MyTreeNode *node in children) {
            [array addObject:[node dictionary]];
        }
        [dictionary setObject:array forKey:@"children"];
    }
    return dictionary;
}

- (NSString *)stringValue {
    NSString * str = [NSString stringWithFormat:@"%@%@, %@", self.name, [self isGroup]?@"[G]":@"", [self timeString]];
    return str;
}

- (NSString *)timeString {
    div_t h = div([self time], 3600);
    int hours = h.quot;
    div_t m = div(h.rem, 60);
    int minutes = m.quot;
    int seconds = m.rem;
    return  [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

- (NSTimeInterval)time {
    if ([self isGroup]) {
        NSTimeInterval aTime = .0f;
        for (MyTreeNode *node in children) {
            aTime += node.time;
        }
        return aTime;
    } else {
        return _time;
    }
}

#pragma mark -
#pragma mark NSCopying protocol
- (id)copyWithZone:(NSZone*)zone {
	MyTreeNode *copy = [[MyTreeNode allocWithZone:zone] init];
	if (copy)
	{
		copy.name = self.name;
		copy.isGroup = self.isGroup;
		if (self.isGroup)
			copy.children = self.children;
		
		copy.time = self.time;
		copy.hashValue = self.hashValue;
		
	}
	return copy;
}

#pragma mark -
#pragma mark NSCoding protocol

- (NSArray*)keysForEncoding
{
	NSArray* baseKeys = [super keysForEncoding];
	NSArray* myKeys = [NSArray arrayWithObjects: @"time", nil];
	return [baseKeys arrayByAddingObjectsFromArray:myKeys];
}
- (void)setNilValueForKey:(NSString *)key
{
	// overridden to deal with primitives
	if ([key isEqualToString:@"timer"])
		self.time = 0;
	else 
		[super setNilValueForKey:key];
	
}

-(NSUInteger) hash {
	return hashValue;
}

-(BOOL) isEqual:(id)object {
	// isEqual must agree with hash, and neither can be based on mutable state
	if ([object class] == [self class]) {
		MyTreeNode* oth = object;
		return hashValue == oth.hashValue;
	}
	return NO;
}

- (void)dealloc {
#if  !__has_feature(objc_arc)
    [someText release];
    [super dealloc];
#endif
}

@end
