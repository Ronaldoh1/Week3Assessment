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

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //need to set the delegate.
    
}

//delegate method - we have the data now we need to extract it and add it to Bike Station objects for later use.

-(void)gotBikeStations:(NSArray *)bikeStationsArray{


}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    // TODO:
    return cell;
}

@end
