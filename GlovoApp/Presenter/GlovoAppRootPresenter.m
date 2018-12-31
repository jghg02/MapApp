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
@property (strong, nonatomic) GlovoAppListView *listView;
@property (strong, nonatomic) CLPlacemark *currentPlace;
@property (strong, nonatomic) NSMutableArray <GooglePlace *> *allGooglePlaces;
@property (strong, nonatomic) NSMutableArray <GMSMarker *> *markers;
@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation GlovoAppRootPresenter

#pragma mark - Init

- (void)initwithPlace:(CLPlacemark *)placeMark panelView:(GlovoAppPanelInfoView *)view
{
    self.currentPlace = placeMark;
    self.panelView = view;
}

- (void)initWithMapView:(GMSMapView *)mapView
{
    self.mapView = mapView;
}

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

- (void)setAllMarkers:(GooglePlace *)place
{
    GMSMarker *marker = [self getMarker:place.lat longitude:place.lng];
    marker.map = self.mapView;
    
}

#pragma mark - Load JSON

- (NSURL *)getURLToJSON
{
    return [[GlovoAppBundle bundle] URLForResource:@"style" withExtension:@"json"];
}

#pragma mark - Panel Info

- (void)showPanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.60
                     animations:^{
                         constraint.constant = 120;
                         [view layoutIfNeeded];
                     }];
}

- (void)hidePanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint
{
    [UIView animateWithDuration:.30
                     animations:^{
                         constraint.constant = -165;
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
    self.listView = view;
    view.delegate = self;
    [view reloadDatainListWithData:data listCountries:listCountries];
}

#pragma mark - Update panel info

- (void)updatePanelinfo:(GlovoAppPanelInfoView *)view data:(City *)data
{
    [view populateViewWithData:data];
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

- (void)lookingCountry:(NSString *)contryName
{
    for (Country *current in self.countries) {
        if ([[current.name lowercaseString] isEqualToString:[contryName lowercaseString]]) {
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
        [weakSelf updatePanelInfo:weakSelf.panelView country:self.currentPlace.administrativeArea city:self.currentPlace.ISOcountryCode];
        [self getAllInfoFromGoogle];
    }];
}

- (void)fetchCityDetails:(NSString *)city_code
{
    __weak __typeof(self)weakSelf = self;
    [GlovoAppServices fetchCityDetailsWithCity_code:city_code completion:^(City * _Nullable data) {
        weakSelf.cityInfo = data;
        [weakSelf updatePanelinfo:weakSelf.panelView data:weakSelf.cityInfo];
    }];
}

- (void)fetchGoogleAPI:(NSString *)cityName countryName:(NSString *)countryName
{
    __weak __typeof(self)weakSelf = self;
    [GlovoAppServices googleMapsAPIWithCityName:cityName countryName:countryName completion:^(GooglePlace * _Nullable data) {
        [weakSelf.allGooglePlaces addObject:data];
        [weakSelf setAllMarkers:data];
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

- (void)updatePanelInfo:(GlovoAppPanelInfoView *)view country:(NSString *)countryName city:(NSString *)city
{
    NSArray <City *> *allCities = self.allData[city];
    
    for (City *current in allCities) {
        if ([[countryName lowercaseString] isEqualToString:[current.name lowercaseString]]) {
            [self fetchCityDetails:current.code];
        }
    }
}

- (void)updatePanelInfoWithMarker:(GMSMarker *)marker
{
    for (GooglePlace *currentGP in self.allGooglePlaces) {
        if (currentGP.lat == marker.position.latitude && currentGP.lng == marker.position.longitude){
            NSLog(@"This is a country %@",currentGP.longName);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@",currentGP.longName];
            City *city = [self.cities filteredArrayUsingPredicate:predicate].firstObject;
            if (city == nil) {
                predicate = [NSPredicate predicateWithFormat:@"name==%@",[self hasConvertion:currentGP.longName]];
                city = [self.cities filteredArrayUsingPredicate:predicate].firstObject;
            }
            
            [self fetchCityDetails:city.code];
        }
    }
    
}


- (void)getAllInfoFromGoogle
{
    self.allGooglePlaces = NSMutableArray.new;
    self.markers = NSMutableArray.new;
    
    for (City *currentCity in self.cities) {
        for (Country *currentCountry in self.countries) {
            if ([currentCity.country_code isEqualToString:currentCountry.code]) {
                [self fetchGoogleAPI:currentCity.name countryName:currentCountry.name];
            }
        }
    }
}

- (NSString *)hasConvertion:(NSString *)cityName
{
    NSDictionary<NSString *, NSString *> *conversionTable = @{
                                                              @"Turin":@"Torino",
                                                              @"Rome":@"Roma",
                                                              @"Sur":@"Madrid Sur",
                                                              @"Milan":@"Milano",
                                                              @"13":@"Milano Nord",
                                                              @"Lisbon":@"Lisboa"
                                                              };
    
    return conversionTable[cityName];
}

- (void)didTapRowWithCity:(City * _Nonnull)city
{
    [self fetchCityDetails:city.code];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"longName==%@",city.name];
    GooglePlace *place = [self.allGooglePlaces filteredArrayUsingPredicate:predicate].firstObject;

    //Update Camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.lat
                                                            longitude:place.lng
                                                                 zoom:16];
    self.mapView.camera = camera;
    
    
}

@end
