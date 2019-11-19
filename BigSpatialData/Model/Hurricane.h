//
//  Hurricane.h
//  BigSpatialData
//
//  Created by Apple on 2019/10/30.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hurricane : NSObject

@property(nonatomic, readonly) NSString * date;
@property(nonatomic, readonly) NSString * time;
@property(nonatomic, readonly) NSString * wind;
@property(nonatomic, readonly) NSString * presure;
@property(nonatomic, readonly) NSString * stormType;
@property(nonatomic, readonly) NSString * category;
@property(nonatomic, readonly) NSString * name;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithProperStr:(NSString *)ProperStr ;
@end

NS_ASSUME_NONNULL_END
