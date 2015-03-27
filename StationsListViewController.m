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
@interface StationsListViewController () <UITableViewDelegate, UITableViewDataSource, BikeStationDownloaderDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *bikeStationsObjectsArray;
@property BikeStationsDownloader *downloader;
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
    
}

//delegate method - we have the data now we need to extract it and add it to Bike Station objects for later use.

-(void)gotBikeStations:(NSArray *)bikeStationsArray{

    for (NSDictionary *someDictionary in bikeStationsArray){

        BikeStation *bikeStation = [[BikeStation alloc]initWithDictionary:someDictionary];
        [self.bikeStationsObjectsArray addObject:bikeStation];

    }
    //reload the table view data after array has been filled with data.
    [self.tableView reloadData];

}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
    return self.bikeStationsObjectsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.textLabel.text = [self.bikeStationsObjectsArray[indexPath.row]bikeStationAddress];

    NSInteger bikeStationCount = [self.bikeStationsObjectsArray[indexPath.row]bikeCount];
    NSString *somebikeStation = [NSString stringWithFormat:@"%ld",(long)bikeStationCount];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Bikes Available", somebikeStation];

    return cell;
}

@end
