//
//  MapViewController.m
//  Weather
//
//  Created by Nicholas Cooke on 4/24/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import "MapViewController.h"

// Frameworks
#import <MapKit/MapKit.h>

// Controller
#import "SearchResultsController.h"

// Categories
#import "UIView+Pinto.h"
#import "NSLayoutAnchor+Pinto.h"

@interface MapViewController () <MKMapViewDelegate, SearchResultsDelegate>


@property (nonatomic) MKMapView *mapView;
@property (nonatomic) NSDictionary<NSString *, id> *selectedLocationInfo;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *selectButton;
@property (nonatomic) UIView *unknownLocationView;

@end

@implementation MapViewController

- (UISearchController *)searchController {
    if (!_searchController) {
        SearchResultsController *searchResultsController = [[SearchResultsController alloc] initWithStyle:UITableViewStylePlain];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
        searchResultsController.delegate = self;
        _searchController.searchResultsUpdater = searchResultsController;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        _searchController.searchBar.placeholder = @"Search for a city";
        _searchController.definesPresentationContext = YES;
        _searchController.searchBar.barTintColor = [UIColor systemBackgroundColor];
        _searchController.searchBar.backgroundColor = [UIColor systemBackgroundColor];
        _searchController.searchBar.tintColor = [UIColor secondaryLabelColor];
    }
    return _searchController;
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [MKMapView new];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor secondaryLabelColor],NSForegroundColorAttributeName,
                                    [UIFont systemFontOfSize:16 weight:UIFontWeightMedium],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.navigationItem.title = @"Tap a location on the map or search for one.";
    self.navigationItem.searchController = self.searchController;
    
    [self.view addSubview:self.mapView];
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [[_mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[_mapView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[_mapView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[_mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    
    UITapGestureRecognizer *tapGestureRecognizer = [UITapGestureRecognizer new];
    [tapGestureRecognizer addTarget:self action:@selector(handleTapOnMap:)];
    [self.mapView addGestureRecognizer:tapGestureRecognizer];
    
    _selectButton = [self configuredSelectionButton];
    [self.mapView addSubview:_selectButton];
    _selectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[_selectButton.centerXAnchor constraintEqualToAnchor:self.mapView.centerXAnchor] setActive:YES];
    [[_selectButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-50] setActive:YES];

    _cancelButton = [self configuredCancelButton];
    [self.mapView addSubview:_cancelButton];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[_cancelButton.centerXAnchor constraintEqualToAnchor:self.mapView.centerXAnchor] setActive:YES];
    [[_cancelButton.widthAnchor constraintEqualToAnchor:self.selectButton.widthAnchor] setActive:YES];
    [[_cancelButton.heightAnchor constraintEqualToAnchor:self.selectButton.heightAnchor] setActive:YES];
    [[_cancelButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0] setActive:YES];
    
    
    
    _unknownLocationView = [UIView new];
    _unknownLocationView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_unknownLocationView addSubview:effectView];
    } else {
        _unknownLocationView.backgroundColor = [UIColor systemBackgroundColor];
    }
    
    [self.mapView addSubview:_unknownLocationView];
    [_unknownLocationView.topAnchor pinTo:self.mapView.safeAreaLayoutGuide.topAnchor withPadding:15];
    [_unknownLocationView.leadingAnchor pinTo:self.mapView.leadingAnchor withPadding:75];
    [_unknownLocationView.trailingAnchor pinTo:self.mapView.trailingAnchor withPadding:-75];
    [[_unknownLocationView.heightAnchor constraintEqualToConstant:50] setActive:YES];
    
    UILabel *unknownLocationLabel = [UILabel new];
    unknownLocationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    unknownLocationLabel.text = @"Unknown Location";
    unknownLocationLabel.textColor = [UIColor labelColor];
    unknownLocationLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    unknownLocationLabel.textAlignment = NSTextAlignmentCenter;
    
    [_unknownLocationView addSubview:unknownLocationLabel];
    [unknownLocationLabel.topAnchor pinTo:_unknownLocationView.topAnchor withPadding:10];
    [unknownLocationLabel.bottomAnchor pinTo:_unknownLocationView.bottomAnchor withPadding:-10];
    [unknownLocationLabel.leadingAnchor pinTo:_unknownLocationView.leadingAnchor withPadding:20];
    [unknownLocationLabel.trailingAnchor pinTo:_unknownLocationView.trailingAnchor withPadding:-20];
    
    _unknownLocationView.alpha = 0;
    
}

- (void)animateUnknownLocationView {
    
    UIViewPropertyAnimator *fadeInAnimation = [[UIViewPropertyAnimator alloc] initWithDuration:0.8 curve:UIViewAnimationCurveEaseInOut animations:^{
        self.unknownLocationView.alpha = 1;
    }];
    
    [fadeInAnimation addCompletion:^(UIViewAnimatingPosition finalPosition) {
        // Fade out animation
        [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.unknownLocationView.alpha = 0;
        } completion:nil];
    }];
    
    [fadeInAnimation startAnimation];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _cancelButton.layer.cornerRadius = CGRectGetHeight(_cancelButton.bounds) / 2;
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.userInteractionEnabled = NO;
        effectView.frame = _cancelButton.bounds;
        [_cancelButton insertSubview:effectView atIndex:0];
        _cancelButton.backgroundColor = UIColor.clearColor;
    } else {
        _cancelButton.backgroundColor = [UIColor systemBackgroundColor];
    }
    
    _unknownLocationView.layer.cornerRadius = CGRectGetHeight(_unknownLocationView.bounds) / 2;
    _unknownLocationView.layer.masksToBounds = YES;
    
}

- (UIButton *)configuredSelectionButton {
    UIButton *button = [UIButton new];
    [button setTitle:@"Select Location" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor tertiaryLabelColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateHighlighted];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
    [button sizeToFit];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.userInteractionEnabled = NO;
        effectView.frame = button.bounds;
        [button insertSubview:effectView atIndex:0];
        button.backgroundColor = UIColor.clearColor;
    } else {
        button.backgroundColor = [UIColor systemBackgroundColor];
    }
    
    button.layer.cornerRadius = button.bounds.size.height / 2;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(handleButton) forControlEvents:UIControlEventTouchUpInside];
    button.enabled = NO;
    
    return button;
}

- (UIButton *)configuredCancelButton {
    UIButton *button = [UIButton new];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateHighlighted];
    
    button.layer.cornerRadius = button.bounds.size.height / 2;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(handleCancelButton) forControlEvents:UIControlEventTouchUpInside];
    
    button.layer.cornerRadius = CGRectGetWidth(button.bounds) / 2;
    
    return button;
}

- (void)handleButton {
    [self searchResultSelected:self.selectedLocationInfo];
}

- (void)handleCancelButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTapOnMap:(UITapGestureRecognizer *)recognizer {
    self.selectedLocationInfo = nil;
    
    CGPoint point = [recognizer locationInView:self.mapView];
    
    // Check if user tapped already exisiting annotation and if so, remove it
    MKPointAnnotation *currentlyDisplayedAnnotation = (MKPointAnnotation *)self.mapView.annotations.firstObject;
    MKAnnotationView *annotationView = [self.mapView viewForAnnotation:currentlyDisplayedAnnotation];
    if (annotationView) {
        if (CGRectContainsPoint(annotationView.frame, point)) {
            [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:0.13 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                annotationView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                annotationView.alpha = 0;
            } completion:^(UIViewAnimatingPosition finalPosition) {
                [self.mapView removeAnnotations:self.mapView.annotations];
            }];
            self.selectButton.enabled = NO;
            return;
        }
    }
    
    [self.mapView removeAnnotations:_mapView.annotations];
    
    // Don't place an annotation within frame of selectButton
    if (CGRectContainsPoint(_selectButton.frame, point)) {
        return;
    }
    
    // Tapped point is valid for reverse geocoding
    CLLocationCoordinate2D tappedCoordinates = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    [annotation setCoordinate:tappedCoordinates];
    [self.mapView addAnnotation:annotation];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:tappedCoordinates.latitude longitude:tappedCoordinates.longitude];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Oops.." message:@"Something went wrong. Please wait a few moments and try your selection again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { }];
            [alertViewController addAction:alertAction];
            [self presentViewController:alertViewController animated:YES completion:nil];
        }
       
        if (placemarks.firstObject != nil) {
            CLPlacemark *placemark = [placemarks firstObject];
            NSString *placeName = placemark.locality != nil ? placemark.locality : placemark.subLocality;
            placeName = [placeName componentsSeparatedByString:@","][0];
            
            if (placeName) {
                self.selectedLocationInfo = @{ @"placeName": placeName, @"location": placemark.location };

                // Enable selectButton since a location has been selected 
                self.selectButton.enabled = YES;

            } else {
                [self.mapView removeAnnotation:annotation];
                [self animateUnknownLocationView];
            }
            
        }
        
    }];
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKMarkerAnnotationView *annotationView = [MKMarkerAnnotationView new];
    annotationView.annotation = annotation;
    annotationView.markerTintColor = UIColor.systemIndigoColor;
    annotationView.animatesWhenAdded = YES;
    annotationView.enabled = NO;
    return annotationView;
}

#pragma mark - SearchResultsDelegate

- (void)searchResultSelected:(NSDictionary *)searchResult {
//    NSLog(@"Adding Place: %@ with location: %@", [searchResult objectForKey:@"placeName"], [searchResult objectForKey:@"location"]);
    
    if (searchResult && searchResult[@"placeName"] && searchResult[@"location"]) {
        [_delegate addForecastWithInfo:searchResult];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
}

@end
