//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *bikeAnnotation;
@property NSString *allSteps;
@property NSString *someString;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allSteps = [NSString new];

    [self displayBikeStation:self.bikeStation];

    //show user's current location.
   self.mapView.showsUserLocation = true;
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    if ([annotation isEqual:self.bikeAnnotation]) {
        pinAnnotation.image = [UIImage imageNamed:@"mobilemakers"];
    }else if([annotation isEqual:mapView.userLocation]){

        return nil;
    }
    pinAnnotation.image = [UIImage imageNamed:@"bikeImage"];

    pinAnnotation.canShowCallout = true;
    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pinAnnotation;


}

//helper method to display alerts.
-(void)displayDirections:(BikeStation*)bikestation
{
   NSString *someString =  [self getDirectionsToBikeStation:self.currentLocation.coordinate withDestination:self.bikeAnnotation.coordinate];



    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Directions" message:[NSString stringWithFormat:@"%@",someString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];


}


//-helper method to diplay get bikeStations
-(void)displayBikeStation:(BikeStation *)bikeStation{
    CLLocationCoordinate2D bikeCoordinate = CLLocationCoordinate2DMake(bikeStation.latitude, bikeStation.longitude);
    self.bikeAnnotation = [MKPointAnnotation new];
    self.bikeAnnotation.title = bikeStation.bikeStationName;
   // NSString *address = bikeStation.bikeStationAddress;

    self.bikeAnnotation.subtitle = [NSString stringWithFormat:@"%ld", (long)bikeStation.bikeCount];
    self.bikeAnnotation.coordinate = bikeCoordinate;

    self.bikeStation.thebikeAnnotation = self.bikeAnnotation;

    [self.mapView addAnnotation:self.bikeAnnotation];

    double lat = self.bikeStation.latitude;
    double lon = self.bikeStation.longitude;

   [self zoomToRegion:&lat:&lon];

    self.someString =  [self getDirectionsToBikeStation:self.currentLocation.coordinate withDestination:self.bikeAnnotation.coordinate];


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
//helper method to get directions.

-(NSString  *) getDirectionsToBikeStation:(CLLocationCoordinate2D ) source  withDestination:(CLLocationCoordinate2D) destination{
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];

    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placemarkDest];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItemSrc];
    [request setDestination:mapItemDest];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    request.requestsAlternateRoutes = NO;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error){
        MKRoute *route = response.routes.lastObject;



        for (int i = 0; i < route.steps.count; i++)
        {
            MKRouteStep *step = [route.steps objectAtIndex:i];
            NSString *newStepString = step.instructions;
            self.allSteps = [self.allSteps stringByAppendingString:newStepString];
            self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
        }
        
        
    }];
    return self.allSteps;
}

#pragma mark MapKit-Delegate


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocationCoordinate2D center = view.annotation.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    [mapView setRegion:MKCoordinateRegionMake(center, span) animated:true];

    //when the user taps the button - display the directions.
     [self displayDirections:self.bikeStation];
}

@end
