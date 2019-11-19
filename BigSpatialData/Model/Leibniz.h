//
//  Leibniz.h
//  BigSpatialData
//
//  Created by Apple on 2019/10/30.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Leibniz : NSObject
@property(nonatomic, readonly) NSString * institute;
@property(nonatomic, readonly) NSString * city;
@property(nonatomic, readonly) NSString * link;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithProperStr:(NSString *)ProperStr ;
@end

NS_ASSUME_NONNULL_END
