//
//  GlovoAppRootPresenter.m
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 26/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

#import "GlovoAppRootPresenter.h"

#import "GlovoAppBundle.h"

#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GlovoAppRootPresenter ()

@end

@implementation GlovoAppRootPresenter

#pragma mark - Google Maps Config

- (void)configMaps:(GMSMapView *)mapView delegate:(id<GMSMapViewDelegate>)delegate
{
    mapView.delegate = delegate;
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    mapView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
    mapView.settings.compassButton = YES;
    mapView.mapType = kGMSTypeNormal;
    
    NSError *error;
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:[self getURLToJSON] error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    
    mapView.mapStyle = style;

}

#pragma mark -  Config Location Manager

- (CLLocationManager *)locationManager:(id <CLLocationManagerDelegate>)delegate
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = delegate;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingHeading];
    [locationManager requestWhenInUseAuthorization];
    
    return locationManager;
}

#pragma mark - Marker

- (GMSMarker *)getMarker:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    GMSMarker *marker = [GMSMarker new];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    
    return marker;
}

#pragma mark - Load JSON

- (NSURL *)getURLToJSON
{
    return [[GlovoAppBundle bundle] URLForResource:@"style" withExtension:@"json"];
}

#pragma mark - Fetch API Information

- (NSMutableArray <GMSMarker *> *)getAllLocations
{
    NSMutableArray <GMSMarker *> *markers = NSMutableArray.new;
    
    [markers addObject:[self getMarker:43.6570403 longitude:-79.3832]];
    [markers addObject:[self getMarker:10.4685529 longitude:-66.9604057]];
    
    return markers;
}

#pragma mark - Panel Info

- (void)showPanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.60
                     animations:^{
                         constraint.constant = 70;
                         [view layoutIfNeeded];
                     }];
}

- (void)hidePanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.30
                     animations:^{
                         constraint.constant = -270;
                         [view layoutIfNeeded];
                     }];
}


#pragma mark - List View

- (void)showListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.60
                     animations:^{
                         constraint.constant = 30;
                         [view layoutIfNeeded];
                     }];
}

- (void)hideListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.30
                     animations:^{
                         constraint.constant = -270;
                         [view layoutIfNeeded];
                     }];
}

#pragma mark - Update panel info

- (void)updatePanelinfo:(UIView *)view
{
    
    
}

#pragma mark - WebServices

- (NSArray<Country *> *)fetchCountries {
    [GlovoAppServices fetchCountriesWithCompletion:^(NSArray * _Nullable data) {
        NSLog(@"HERE");
        NSLog(@"%@",data);
    }];
    
    [GlovoAppServices fetchCitiesWithCompletion:^(NSArray<City *> * _Nullable data) {
        NSLog(@"%@",data);
    }];
    
    return nil;
}


@end
