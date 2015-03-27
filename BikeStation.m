//
//  BikeStation.m
//  CodeChallenge3
//
//  Created by Ronald Hernandez on 3/27/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "BikeStation.h"

@implementation BikeStation

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self.bikeStationAddress = dictionary[@"stAddress1"];
    self.bikeCount = [dictionary[@"availableBikes"] integerValue];


    return self;
}

@end
