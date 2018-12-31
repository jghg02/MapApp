//
//  GlovoAppRootViewController.m
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 24/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

#import "GlovoAppRootViewController.h"
#import "GlovoAppRootPresenter.h"

#import "GlovoApp-Swift.h"

#import <GoogleMaps/GoogleMaps.h>
@import GooglePlaces;
@import JCore_ui;

@interface GlovoAppRootViewController ()  <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;

@property (strong, nonatomic) GMSMarker *marker;

@property (weak, nonatomic) IBOutlet GlovoAppListView *listView;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet GlovoAppPanelInfoView *panelInfoView;

@property (strong, nonatomic) NSArray <Country *> *countries;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navButton;

@property (strong, nonatomic) GMSPlacesClient *placeClient;

@end

@implementation GlovoAppRootViewController

#pragma mark - Init

- (instancetype)initWithPresenter:(NSObject <GlovoAppPresenterProtocol> *)presenter
{
    if ([super init]) {
        self.presenter = presenter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.presenter initwithPlace:self.placemark panelView:self.panelInfoView];
    [self.presenter initWithMapView:self.mapView];
    
    [self fetchData];
    [self addNavButton];
    
    self.geocoder = [[CLGeocoder alloc] init];
    [self startLocationManager];
    [self.presenter configMaps:self.mapView delegate:self];
    
    self.placeClient = [GMSPlacesClient sharedClient];
}

# pragma mark - Fetch Data from Server

- (void) fetchData
{
    [self.presenter fetchCountries];
    [self.presenter fetchCities:self.listView];
}

#pragma mark - Config Location

- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 100.0; // Will notify the LocationManager every 100 meters
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.allowsBackgroundLocationUpdates = YES;

    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    if (self.currentLocation != nil)
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                                longitude:self.currentLocation.coordinate.longitude
                                                                     zoom:16];
        self.mapView.camera = camera;
    }
    
    [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            self.placemark = [placemarks lastObject];
            NSString *currentLocation = [NSString stringWithFormat:@"%@,%@", self.placemark.locality, self.placemark.country];
            NSLog(@"%@-- ",currentLocation.description);
            [self.presenter initwithPlace:self.placemark panelView:self.panelInfoView];
        }
    }];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"No Determine");
            [self.locationManager requestWhenInUseAuthorization];
            
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied location access request!!");
            [self.presenter showListView:self.listView constraint:self.topLayoutConstraint];
            [self.locationManager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.presenter hidePanelInfo:self.view constraint:self.bottomLayoutConstraint];
    [self.presenter hideListView:self.listView constraint:self.topLayoutConstraint];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [self.presenter updatePanelInfoWithMarker:marker];
    CGPoint point = [self.mapView.projection pointForCoordinate:marker.position];
    GMSCameraUpdate *camera = [GMSCameraUpdate setTarget:[self.mapView.projection coordinateForPoint:point] zoom:16];
    [self.mapView animateWithCameraUpdate:camera];
    
    return YES;
}


#pragma mark - Nav Button

- (void)addNavButton
{
    [self.navigationItem setLeftBarButtonItem:self.navButton];
}

- (IBAction)didTapNavButton:(id)sender
{
    [self.presenter showListView:self.listView constraint:self.topLayoutConstraint];
}

#pragma mark - Tap Actions

- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView
{
    //Update Camera.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                            longitude:self.currentLocation.coordinate.longitude
                                                                 zoom:16];
    self.mapView.camera = camera;

    
    return YES;
}

- (IBAction)tapInformationPanel:(id)sender
{
    [self.presenter showPanelInfo:self.view constraint:self.bottomLayoutConstraint];
}

@end
