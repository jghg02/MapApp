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

@property (strong, nonatomic) NSArray <Country *> *countries;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *navButton;

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

    [self addNavButton];
    
    self.geocoder = [[CLGeocoder alloc] init];
    [self startLocationManager];
    [self.presenter configMaps:self.mapView delegate:self];
    
    [self fetchData];
}

# pragma mark - Fetch Data from Server

- (void) fetchData
{
    self.countries = [self.presenter fetchCountries];
    
    NSMutableArray <GMSMarker *> *data = [self.presenter getAllLocations];
    for (GMSMarker* current in data) {
        current.map = self.mapView;
    }
}

#pragma mark - Config Location

- (void)startLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil)
    {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                                longitude:currentLocation.coordinate.longitude
                                                                     zoom:16];
        self.mapView.camera = camera;
    }
    
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0)
        {
            self.placemark = [placemarks lastObject];
            NSString *currentLocation = [NSString stringWithFormat:@"%@,%@", self.placemark.locality, self.placemark.country];
            NSLog(@"%@",currentLocation.description);
            //[self.panelInformationView setDataWithTitle:self.placemark.locality description:self.placemark.country];
        }
    }];
    
    
    //Set pin in current location
    self.marker = [self.presenter getMarker:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    self.marker.map = self.mapView;

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
            [self fetchData];
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
    return YES;
}

- (IBAction)tapInformationPanel:(id)sender
{
    [self.presenter showPanelInfo:self.view constraint:self.bottomLayoutConstraint];
}

@end
