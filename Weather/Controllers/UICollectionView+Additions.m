//
//  UICollectionView+Additions.m
//  Weather
//
//  Created by Nicholas Cooke on 5/30/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "UICollectionView+Additions.h"

#import "NSArray+Map.h"

@implementation UICollectionView (Additions)

- (void)unhighlightVisibleCells {
    [self.visibleCells forEach:^(UICollectionViewCell *cell) {
        cell.highlighted = NO;
    }];
}

@end
