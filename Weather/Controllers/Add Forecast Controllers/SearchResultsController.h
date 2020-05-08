//
//  SearchResultsController.h
//  Weather
//
//  Created by Nicholas Cooke on 4/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchResultsDelegate <NSObject>

- (void)searchResultSelected:(id)searchResult;

@end

@interface SearchResultsController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, weak) id<SearchResultsDelegate> delegate;

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;

@end

NS_ASSUME_NONNULL_END
