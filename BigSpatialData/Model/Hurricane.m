//
//  Hurricane.m
//  BigSpatialData
//
//  Created by Apple on 2019/10/30.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import "Hurricane.h"

@implementation Hurricane

-(id) initWithProperStr:(NSString *)ProperStr{
    
    self = [super init];
    if (self && ![ProperStr isEqualToString:@""]) {
        NSArray *array = [ProperStr componentsSeparatedByString:@","];
        //set the propers
        if (array[0]) {
            _date = array[0];
        }
        if (array[1]) {
            _time = array[1];
        }
        if (array[2]&&array[3]) {
            double lat = [array[2] doubleValue];
            double lon = [array[3] doubleValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
        if (array[4]) {
            _wind = array[4];
        }
        if (array[5]) {
            _presure = array[5];
        }
        if (array[6]) {
            _stormType = array[6];
        }
        if (array[7]) {
            _category = array[7];
        }
        if (array[8]) {
            _name = array[8];
        }
       
    }
    
    return self;
}

@end
