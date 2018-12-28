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

- (void)configMaps:(GMSMapView *)mapView delegate:(id<GMSMapViewDelegate>)delegate;
- (CLLocationManager *)locationManager:(id <CLLocationManagerDelegate>)delegate;
- (GMSMarker *)getMarker:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (NSMutableArray <GMSMarker *> *)getAllLocations;
- (void)showPanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint;
- (void)hidePanelInfo:(UIView *)view constraint:(NSLayoutConstraint *)constraint;
- (void)updatePanelinfo:(UIView *)view;

- (void)hideListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint;
- (void)showListView:(UIView *)view constraint:(NSLayoutConstraint *)constraint;

- (NSArray <Country *> *)fetchCountries;

@end
