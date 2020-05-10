//
//  SearchResultsController.m
//  Weather
//
//  Created by Nicholas Cooke on 4/22/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "SearchResultsController.h"

// Controllers
#import "MapViewController.h"

// Frameworks
#import <MapKit/MapKit.h>

// Utils
#import "NSArray+Map.h"

@interface SearchResultsController () <MKLocalSearchCompleterDelegate>

@property (nonatomic) UITableViewDiffableDataSource *dataSource;
@property (nonatomic) MKLocalSearchCompleter *completer;
@property (nonatomic) NSArray<NSAttributedString *> *locations;

@property (nonatomic) NSInteger searchTextLength;

@end

@implementation SearchResultsController

- (NSArray<NSAttributedString *> *)locations {
    if (!_locations) {
        _locations = [NSArray new];
    }
    return _locations;
}

- (MKLocalSearchCompleter *)completer {
    if (!_completer) {
        _completer = [MKLocalSearchCompleter new];
        _completer.delegate = self;
    }
    return _completer;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    [self configureBackgroundBlurView];
    [self configureDataSource];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)configureDataSource {
    _dataSource = [[UITableViewDiffableDataSource alloc] initWithTableView:self.tableView cellProvider:^UITableViewCell * (UITableView * tableView, NSIndexPath * indexPath, NSAttributedString *location) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
        cell.textLabel.textColor = UIColor.secondaryLabelColor;
        [cell.textLabel setAttributedText:location];
        
        cell.backgroundColor = UIColor.clearColor;
        return cell;
    }];
    
    _dataSource.defaultRowAnimation = UITableViewRowAnimationFade;
    
    // load our initial data
    NSDiffableDataSourceSnapshot *snapshot = [self snapshotForCurrentState];
    [_dataSource applySnapshot:snapshot animatingDifferences:NO];
}

- (NSDiffableDataSourceSnapshot *)snapshotForCurrentState {
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[@"Section"]];
    [snapshot appendItemsWithIdentifiers:self.locations];
    return snapshot;
}

- (void)updateUI {
    NSDiffableDataSourceSnapshot *snapshot = [self snapshotForCurrentState];
    [_dataSource applySnapshot:snapshot animatingDifferences:YES];
}

- (void)configureBackgroundBlurView {
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.tableView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.tableView.backgroundView = blurEffectView;
        
    } else {
        self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *locationName = [(NSAttributedString *)[_dataSource itemIdentifierForIndexPath:indexPath] string];
    weakify(self);
    [self placemarkSearchWithQuery:locationName completion:^(NSDictionary *dictionary) {
        strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.delegate searchResultSelected:dictionary];
    }];
    
    // Add a blur view on top of previous screen to make view dismissal look smoother
    MapViewController *presentingController = (MapViewController *)[self presentingViewController];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = presentingController.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [presentingController.view addSubview:blurEffectView];
    
}

# pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    if (searchText == nil) return;
    
    self.completer.queryFragment = searchText;
    _searchTextLength = [searchText length];
    
}

# pragma mark - MKLocalSearchCompleterDelegate

- (void)completerDidUpdateResults:(MKLocalSearchCompleter *)completer {
    
    NSArray *filteredResults = [completer.results compactMap:^NSAttributedString* _Nullable (MKLocalSearchCompletion *result) {
        
        if (![result.title containsString:@","]) return nil;
        
        NSRange resultTitleRangeOfNumbers = [result.title rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet];
        if (resultTitleRangeOfNumbers.location != NSNotFound) return nil;
       
        NSRange resultSubtitleRangeOfNumbers = [result.subtitle rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet];
        if (resultSubtitleRangeOfNumbers.location != NSNotFound) return nil;

        
        return [self highlightedStringForLocation:result.title andRange:NSMakeRange(0, self.searchTextLength)];
        
    }];
    
    _locations = [filteredResults copy];
    [self updateUI];
    
}

- (void)placemarkSearchWithQuery:(NSString *)query completion:(void(^)(NSDictionary * dictionary))completion {
    
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] initWithNaturalLanguageQuery:query];
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Oops.." message:[error description] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
            [alertViewController addAction:alertAction];
            [self presentViewController:alertViewController animated:YES completion:nil];
        }
        
        MKMapItem *mapItem = [response.mapItems firstObject];
        
        if (!mapItem) {
            NSLog(@"Search resulted in no mapItems");
            return;
        }

        NSString *formattedQuery = [query componentsSeparatedByString:@","][0];
        MKPlacemark *placemark = mapItem.placemark;
        completion(@{ @"placeName": formattedQuery, @"location": placemark.location });
        
    }];
}

- (NSAttributedString *)highlightedStringForLocation:(NSString *)location andRange:(NSRange)range {
    NSMutableAttributedString *attributedLocation = [[NSMutableAttributedString alloc] initWithString:location];
    [attributedLocation addAttribute:NSForegroundColorAttributeName value:UIColor.labelColor range:range];
    return [attributedLocation copy];
}

@end
