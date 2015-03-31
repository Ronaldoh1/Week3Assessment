//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "BikeStation.h"
#import "BikeStationsDownloader.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface StationsListViewController () <UITableViewDelegate, UITableViewDataSource, BikeStationDownloaderDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *bikeStationsObjectsArray;
@property BikeStationsDownloader *downloader;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property NSMutableArray* filteredTableData;
@property BOOL isFiltered;
@property BOOL isAscending;
@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downloader = [BikeStationsDownloader new];
    //need to set the delegate.
    self.downloader.ParentVC = self;
    //call the method to begin download data.
    [self.downloader pullBikeStationDataFromDivvyAPI];


    //initialize mutable array to store Bike Station Objects.
    self.bikeStationsObjectsArray = [NSMutableArray new];

    self.locationManager = [CLLocationManager new];

    //set the delegate for the current view controller.
    self.locationManager.delegate = self;

    //call helper method to update user's current location.
    [self UpdateUserCurrentLocation];

}
//--Helper method to update the current location--//
-(void)UpdateUserCurrentLocation{
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

}

//delegate method - we have the data now we need to extract it and add it to Bike Station objects for later use.
#pragma mark - UISearchbarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(self.searchBar.text.length == 0)
    {
        self.isFiltered = NO;
    }
    else
    {
        self.isFiltered = YES;

        self.filteredTableData = [NSMutableArray new];

        for (BikeStation *bikestation in self.bikeStationsObjectsArray)
        {

            NSRange nameRange = [bikestation.bikeStationName rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];

            if(nameRange.location != NSNotFound )
            {
                [self.filteredTableData  addObject:bikestation];
            }
        }

    }
    
    [self.tableView reloadData];
}


-(void)gotBikeStations:(NSArray *)bikeStationsArray{


    for (NSDictionary *someDictionary in bikeStationsArray){

        BikeStation *bikeStation = [[BikeStation alloc]initWithDictionary:someDictionary];

        //bikeStation.distanceFromCurrentLocation = [self.currentLocation distanceFromLocation:bikeStation.thebikeAnnotation.coordinate];

        
        [self.bikeStationsObjectsArray addObject:bikeStation];


    }


    //reload the table view data after array has been filled with data.
    [self.tableView reloadData];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    MapViewController *mapVC = [segue destinationViewController];
    mapVC.bikeStation = [self.bikeStationsObjectsArray objectAtIndex: self.tableView.indexPathForSelectedRow.row];
    mapVC.currentLocation = self.currentLocation;

}
#pragma Mark CLLocationManager-Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    self.currentLocation = locations.firstObject;
    NSLog(@"%@",self.currentLocation);
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:


    if(self.isFiltered)
        return self.filteredTableData.count;
    else
        return self.bikeStationsObjectsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    BikeStation *bikeStation = [BikeStation new];
    if (self.isFiltered == true) {
        bikeStation = [self.filteredTableData objectAtIndex:indexPath.row];
    }else {
        bikeStation = [self.bikeStationsObjectsArray objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = bikeStation.bikeStationAddress;

  NSInteger bikeStationCount = bikeStation.bikeCount;
    NSString *somebikeStation = [NSString stringWithFormat:@"%ld",(long)bikeStationCount];

   cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Bikes Available", somebikeStation];

    return cell;
}

@end
