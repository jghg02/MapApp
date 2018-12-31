//
//  GlovoAppPresenterProtocol.h
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 26/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "GlovoApp-Swift.h"

@protocol GlovoAppPresenterProtocol

- (void)initwithPlace:(CLPlacemark *)placeMark panelView:(GlovoAppPanelInfoView *)view;

- (void)configMaps:(GMSMapView *)mapView delegate:(id<GMSMapViewDelegate>)delegate;
- (CLLocationManager *)locationManager:(id <CLLocationManagerDelegate>)delegate;
- (GMSMarker *)getMarker:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (NSMutableArray <GMSMarker *> *)getAllLocations;

- (void)showPanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint;
- (void)hidePanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint;
- (void)updatePanelinfo:(GlovoAppPanelInfoView *)view data:(City *)data;

- (void)hideListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint;
- (void)showListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint;

- (void)fetchCountries;
- (void)fetchCities:(GlovoAppListView *)view;
- (void)fetchCityDetails:(NSString *)city_code;
- (void)fetchGoogleAPI:(NSString *)cityName countryName:(NSString *)countryName;

- (void)updatePanelInfo:(GlovoAppPanelInfoView *)view country:(NSString *)countryName city:(NSString *)city;

@end
