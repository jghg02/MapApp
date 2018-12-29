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

@property (strong, nonatomic) NSArray <City *> *cities;
@property (strong, nonatomic) NSArray <Country *> *countries;
@property (strong, nonatomic) NSMutableDictionary *allData;
@property (strong, nonatomic) City *cityInfo;
@property (strong, nonatomic) GlovoAppPanelInfoView *panelView;

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
                         constraint.constant = -170;
                         [view layoutIfNeeded];
                     }];
}


#pragma mark - List View

- (void)showListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.60
                     animations:^{
                         constraint.constant = 100;
                         [view layoutIfNeeded];
                     }];
}

- (void)hideListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.30
                     animations:^{
                         constraint.constant = -300;
                         [view layoutIfNeeded];
                     }];
}

- (void)populateList:(NSMutableDictionary *)data view:(GlovoAppListView *)view listCountries:(NSArray <Country *> *)listCountries
{
    [view reloadDatainListWithData:data listCountries:listCountries];
}

#pragma mark - Update panel info

- (void)updatePanelinfo:(GlovoAppPanelInfoView *)view
{
    self.panelView = view;
    
    if (self.cityInfo) {
        [view populateViewWithData:self.cityInfo];
    }
}

#pragma mark - Looking My Current Location

- (void)lookingCity:(NSString *)cityName
{
    for (City *current in self.cities) {
        if ([[current.name lowercaseString] isEqualToString:[cityName lowercaseString]]) {
            [self fetchCityDetails:current.code];
        }
    }
}

#pragma mark - WebServices

- (void)fetchCountries
{
    __weak __typeof(self)weakSelf = self;
    [GlovoAppServices fetchCountriesWithCompletion:^(NSArray * _Nullable data) {
        weakSelf.countries = data;
    }];
}

- (void)fetchCities:(GlovoAppListView *)view
{
    __weak __typeof(self)weakSelf = self;
    [GlovoAppServices fetchCitiesWithCompletion:^(NSArray<City *> * _Nullable data) {
        weakSelf.cities = data;
        weakSelf.allData = [self processData:weakSelf.countries cities:weakSelf.cities];
        [self populateList:weakSelf.allData view:view listCountries:weakSelf.countries];
    }];
}

- (void)fetchCityDetails:(NSString *)city_code
{
    __weak __typeof(self)weakSelf = self;
    [GlovoAppServices fetchCityDetailsWithCity_code:city_code completion:^(City * _Nullable data) {
        weakSelf.cityInfo = data;
        [weakSelf updatePanelinfo:weakSelf.panelView];
    }];
}

- (NSMutableDictionary *)processData:(NSArray <Country *> *)countries cities:(NSArray <City *> *)cities
{
    NSMutableDictionary *allData = NSMutableDictionary.new;
    for (City *currentCity in cities) {
        if (![allData objectForKey:currentCity.country_code]) {
            [allData setObject:[NSMutableArray new] forKey:currentCity.country_code];
        }
        
        [[allData objectForKey:currentCity.country_code] addObject:currentCity];
    }
    
    return allData;
}

@end
