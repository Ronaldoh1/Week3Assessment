//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self displayBikeStation:self.bikeStation];
   
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pinAnnotation.image = [UIImage imageNamed:@"bikeImage"];

    pinAnnotation.canShowCallout = true;
    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pinAnnotation;


}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocationCoordinate2D center = view.annotation.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    [mapView setRegion:MKCoordinateRegionMake(center, span) animated:true];
}

-(void)displayBikeStation:(BikeStation *)bikeStation{
    CLLocationCoordinate2D bikeCoordinate = CLLocationCoordinate2DMake(bikeStation.latitude, bikeStation.longitude);
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.title = bikeStation.bikeStationName;
   // NSString *address = bikeStation.bikeStationAddress;

    annotation.subtitle = [NSString stringWithFormat:@"%ld", (long)bikeStation.bikeCount];
    annotation.coordinate = bikeCoordinate;

    [self.mapView addAnnotation:annotation];

    double lat = self.bikeStation.latitude;
    double lon = self.bikeStation.longitude;

   [self zoomToRegion:&lat:&lon];


}
//--Zoom into region--//
-(void)zoomToRegion:(double *)lat :(double *)lon{

    MKCoordinateRegion region;
    region.center.latitude = *lat;
    region.center.longitude = *lon;
    region.span.latitudeDelta = .05;
    region.span.longitudeDelta = .05;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:TRUE];
    
}

@end
