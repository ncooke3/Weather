//
//  NSArray+Map.m
//  Weather
//
//  Created by Nicholas Cooke on 3/31/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

- (void)forEach:(void(^)(id item))block {
    for (id obj in self) {
        block(obj);
    }
}

- (NSArray *)map: (id (^)(id obj))block {
    NSMutableArray *new = [NSMutableArray array];
    for(id obj in self) {
        id newObj = block(obj);
        [new addObject: newObj ? newObj : [NSNull null]];
    }
    return new;
}

- (NSArray *)map: (id (^)(id obj))block toSize:(NSInteger)size {
    NSMutableArray *new = [NSMutableArray array];
    NSInteger count = 0;
    for(id obj in self) {
        if ([new count] == size) { break; }
        id newObj = block(obj);
        [new addObject: newObj ? newObj : [NSNull null]];
        count++;
    }
    return new;
}

- (NSArray *)compactMap:(id (^)(id obj))transform  {
    NSMutableArray *array = [NSMutableArray new];
    for (id element in self) {
        id transformedElement = transform(element);
        if (transformedElement) {
            [array addObject:transformedElement];
        }
    }
    return [array copy];
}
    
- (NSArray *)filter:(BOOL (^)(id obj))block {
    NSMutableArray *array = [NSMutableArray new];
    for (id element in self) {
        if (block(element)) {
            [array addObject:element];
        }
    }
    return [array copy];
}

@end
