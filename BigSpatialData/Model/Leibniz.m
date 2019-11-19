//
//  Leibniz.m
//  BigSpatialData
//
//  Created by Apple on 2019/10/30.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import "Leibniz.h"

@implementation Leibniz


-(id) initWithProperStr:(NSString *)ProperStr {
    
    self = [super init];
    if (self && ![ProperStr isEqualToString:@""]) {
        NSArray *array = [ProperStr componentsSeparatedByString:@","];
        
        if (array[0]) {
            _institute = array[0];
        }
        if (array[1]) {
            _city = array[1];
        }
        if (array[2]&&array[3]) {
            double lat = [array[2] doubleValue];
            double lon = [array[3] doubleValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
        if (array[4]) {
            _link = array[4];
        }
    }
    
    return self;
}
@end
