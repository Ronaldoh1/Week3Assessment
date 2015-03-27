//
//  BikeStation.h
//  CodeChallenge3
//
//  Created by Ronald Hernandez on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BikeStation : NSObject
//store the following properties for a bike station. 
@property NSString *bikeStationAddress;
@property NSInteger bikeCount;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
