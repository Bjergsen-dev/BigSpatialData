//
//  PointAnnotationView.h
//  BigSpatialData
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import <MapKit/MapKit.h>



@interface PointAnnotationView : MKAnnotationView

- (id)initWithAnnotationColor:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier colorNum:(int)colorNum;


@end


