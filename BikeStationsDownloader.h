//
//  BikeStationsDownloader.h
//  CodeChallenge3
//
//  Created by Ronald Hernandez on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BikeStationDownloaderDelegate <NSObject>

-(void)gotBikeStations:(NSArray *)bikeStationsArray;

@end

@interface BikeStationsDownloader : NSObject

@property id<BikeStationDownloaderDelegate>ParentVC;

-(void)pullBikeStationDataFromDivvyAPI;

@end
