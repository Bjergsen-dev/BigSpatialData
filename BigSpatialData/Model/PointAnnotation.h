//
//  PointAnnotation.h
//  BigSpatialData
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointAnnotationView.h"
#import "Hurricane.h"
#import "Leibniz.h"

NS_ASSUME_NONNULL_BEGIN

@interface PointAnnotation : NSObject<MKAnnotation>

@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, readonly) NSString * idstr;
@property(nonatomic, readonly) NSString * mag;
@property(nonatomic, readonly) NSString * place;
@property(nonatomic, readonly) NSString * time;
@property(nonatomic, readonly) NSString * updated;
@property(nonatomic, readonly) NSString * tz;
@property(nonatomic, readonly) NSString * url;
@property(nonatomic, readonly) NSString * detail;
@property(nonatomic, readonly) NSString * felt;
@property(nonatomic, readonly) NSString * cdi;
@property(nonatomic, readonly) NSString * mmi;
@property(nonatomic, readonly) NSString * alert;
@property(nonatomic, readonly) NSString * status;
@property(nonatomic, readonly) NSString * tsunami;
@property(nonatomic, readonly) NSString * sig;
@property(nonatomic, readonly) NSString * type;
@property(nonatomic, readonly) NSString * tiktle;

@property(nonatomic, strong) Hurricane * hurricane;
@property(nonatomic, strong) Leibniz * leibniz;

//colorNum used for color chioce
@property(nonatomic,assign) int colorNum;
@property(nonatomic, weak) PointAnnotationView* annotationView;

-(id) initWithFeatureDic:(NSDictionary *)featureDic colorNum:(int) colorNum;

-(id) initWithHurricane:(Hurricane *)hurricane colorNum:(int) colorNum;

-(id) initWithLebniz:(Leibniz *)leibniz colorNum:(int) colorNum;

@end

NS_ASSUME_NONNULL_END
