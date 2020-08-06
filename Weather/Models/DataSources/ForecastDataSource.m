//
//  ForecastDataSource.m
//  Weather
//
//  Created by Nicholas Cooke on 4/4/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "ForecastDataSource.h"

@interface ForecastDataSource ()



@property (nonatomic, assign) NSString *cellIdentifier;
@property (nonatomic, copy) CollectionCellConfigureBlock configureCellBlock;

@end


@implementation ForecastDataSource

- (id)init {
    return nil;
}

- (id)initWithItems:(NSMutableArray *)anItems cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(CollectionCellConfigureBlock)aConfigureCellBlock {
    self = [super init];
    if (self) {
        _items = [anItems mutableCopy];
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[(NSUInteger) indexPath.row];
}


#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    collectionView.backgroundView = [_items count] == 0 ? _emptyView : nil;
    collectionView.scrollEnabled = [_items count] >= 1;
    
    return [_items count];
}


@end
