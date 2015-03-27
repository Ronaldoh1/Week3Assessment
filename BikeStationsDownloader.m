//
//  BikeStationsDownloader.m
//  CodeChallenge3
//
//  Created by Ronald Hernandez on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "BikeStationsDownloader.h"

@implementation BikeStationsDownloader


//implement the method to download data divvy api.
-(void)pullBikeStationDataFromDivvyAPI{

    //Step1. Create the URL.
    NSURL *url = [NSURL URLWithString:@"http://www.bayareabikeshare.com/stations/json"];
    //Step2. Create the resquest.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //Step3. Create the connection.
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        [self downloadcomplete:data];

    }];

}

//Create a helper method to notify PVC that download is complete.
-(void)downloadcomplete:(NSData *)data{
    //store all the data in dictionary.
    NSDictionary *bikeStationsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    NSArray *results = [bikeStationsDictionary objectForKey:@"stationBeanList"];

    //notify the parent VC that we have found the data and that it is an array of dictionaries.
    [self.ParentVC gotBikeStations:results];
}

@end
