//
//  NSArray+Map.m
//  Weather
//
//  Created by Nicholas Cooke on 3/31/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

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


@end
