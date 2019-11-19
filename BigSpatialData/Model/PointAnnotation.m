//
//  PointAnnotation.m
//  BigSpatialData
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import "PointAnnotation.h"

@implementation PointAnnotation

-(id) initWithFeatureDic:(NSDictionary *)featureDic colorNum:(int) colorNum{
    
    self = [super init];
    NSDictionary * geometry = [[NSDictionary alloc] init];
    NSMutableArray * coordinates = [[NSMutableArray alloc] init];
    NSDictionary * properties = [[NSDictionary alloc] init];
    NSString * idstr = [[NSString alloc] init];
    if (featureDic) {
        geometry = [featureDic objectForKey:@"geometry"];
        coordinates = [geometry objectForKey:@"coordinates"];
        properties = [featureDic objectForKey:@"properties"];
        idstr = [featureDic objectForKey:@"id"];
        
    }
    
    if (self) {
        if (coordinates) {
            double lon = [[coordinates objectAtIndex:0] doubleValue];
            double lat = [[coordinates objectAtIndex:1] doubleValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
            _idstr = idstr;
            _colorNum = colorNum;
        }
        
        if (properties) {
            _mag = [properties objectForKey:@"mag"];
            _place = [properties objectForKey:@"place"];
            _time = [properties objectForKey:@"time"];
            _updated = [properties objectForKey:@"updated"];
            _tz = [properties objectForKey:@"tz"];
            _url = [properties objectForKey:@"url"];
            _detail = [properties objectForKey:@"detail"];
            _felt = [properties objectForKey:@"felt"];
            _cdi = [properties objectForKey:@"cdi"];
            _mmi = [properties objectForKey:@"mmi"];
            _alert = [properties objectForKey:@"alert"];
            _status = [properties objectForKey:@"status"];
            _tsunami = [properties objectForKey:@"tsunami"];
            _sig = [properties objectForKey:@"sig"];
            _type = [properties objectForKey:@"type"];
            _tiktle = [properties objectForKey:@"tile"];


        }
        
    }
    
    return self;
}

-(id)initWithHurricane:(Hurricane *)hurricane colorNum:(int)colorNum{
    self = [super init];
    
    if (self) {
        if (hurricane) {
            _hurricane = [[Hurricane alloc] init];
            _hurricane = hurricane;
        }
        _coordinate = _hurricane.coordinate;
        _colorNum = colorNum;
    }
    
    return self;
    
}


-(id) initWithLebniz:(Leibniz *)leibniz colorNum:(int) colorNum{
    self = [super init];
    
    if (self) {
        if (leibniz) {
            _leibniz = [[Leibniz alloc] init];
            _leibniz = leibniz;
        }
        _coordinate = leibniz.coordinate;
        _colorNum = colorNum;
    }
    
    return self;
    
}

@end
