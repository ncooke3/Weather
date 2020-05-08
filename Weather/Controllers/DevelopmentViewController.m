//
//  DevelopmentViewController.m
//  Weather
//
//  Created by Nicholas Cooke on 4/11/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "DevelopmentViewController.h"

// Controllers
#import "SearchResultsController.h"

// Categories
#import "UIView+Pinto.h"
#import "NSLayoutAnchor+Pinto.h"

// Frameworks
#import <MapKit/MapKit.h>

@interface DevelopmentViewController () <MKLocalSearchCompleterDelegate, UISearchBarDelegate>

@property (nonatomic) MKLocalSearchCompleter *completer;
@property (nonatomic) UISearchController *searchController;

@end

@implementation DevelopmentViewController

- (MKLocalSearchCompleter *)completer {
    if (!_completer) {
        _completer = [MKLocalSearchCompleter new];
        _completer.delegate = self;
    }
    return _completer;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        SearchResultsController *searchResultsController = [[SearchResultsController alloc] initWithStyle:UITableViewStylePlain];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
        _searchController.searchResultsUpdater = searchResultsController;
        _searchController.obscuresBackgroundDuringPresentation = NO;
    }
    return _searchController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *searchBarContainerView = [UIView new];
    [self.view addSubview:searchBarContainerView];
    searchBarContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [searchBarContainerView.leadingAnchor pinTo:self.view.leadingAnchor];
    [[searchBarContainerView.heightAnchor constraintEqualToConstant:50] setActive:YES];
    [searchBarContainerView.topAnchor pinTo:self.view.topAnchor withPadding:100];
    [searchBarContainerView.centerXAnchor pinTo:self.view.centerXAnchor];
    
    [self.searchController.searchBar sizeToFit];
    UISearchBar *searchbar = self.searchController.searchBar;
    searchbar.placeholder = @"Add a location";
    [searchBarContainerView addSubview:searchbar];
    //[self.view addSubview:searchbar];
    
    self.definesPresentationContext = YES;
    
    UIView *box = [UIView new];
    box.frame = CGRectMake(0, 0, 100, 100);
    box.center = self.view.center;
    box.backgroundColor = UIColor.systemPinkColor;
    [self.view addSubview:box];

    
}

- (void)completerDidUpdateResults:(MKLocalSearchCompleter *)completer {
    
    // results  = filtering logic below
    NSMutableArray<MKLocalSearchCompletion *> *filteredResults = [[NSMutableArray alloc] init];
    for (MKLocalSearchCompletion *result in completer.results) {
        if (![result.title containsString:@","]) {
            continue;
        }
        
        if ([result.title rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location != NSNotFound) {
            continue;
        }

        if ([result.subtitle rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet].location != NSNotFound) {
            continue;
        }
        
        NSLog(@"%@", [result description]);
        [filteredResults addObject:result];
    }
    
    // after we get the results
    
    // do we need to refresh the table? maybe in the future you can use the diffing the get some nice animations here
    
    // update tableview with the results being the datasource
    // use the highlighting range in each cell's text of the title.
    
}

//  method to perform search with chosen city: [[MKLocalSearchRequest alloc] initWithCompletion:filteredResults[0]]

// tableview delegateDidSelect -> create a forecast object. geocode the place and then fetch and store the data, add to
//      the main collectionview

- (void)completer:(MKLocalSearchCompleter *)completer didFailWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    return YES;
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.completer.queryFragment = searchText;
}

// called when text ends editing
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    return;
}



@end
