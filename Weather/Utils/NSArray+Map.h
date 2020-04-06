//
//  NSArray+Map.h
//  Weather
//
//  Created by Nicholas Cooke on 3/31/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Map)

- (NSArray *)map: (id (^)(id obj))block;
- (NSArray *)map: (id (^)(id obj))block toSize:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
