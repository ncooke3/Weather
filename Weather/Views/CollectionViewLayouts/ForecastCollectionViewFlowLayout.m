//
//  ForecastCollectionViewFlowLayout.m
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "ForecastCollectionViewFlowLayout.h"

@implementation ForecastCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        self.minimumInteritemSpacing = 0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
   return YES;
}

@end
