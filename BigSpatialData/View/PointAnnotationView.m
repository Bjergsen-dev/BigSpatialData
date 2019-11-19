//
//  PointAnnotationView.m
//  BigSpatialData
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import "PointAnnotationView.h"

@implementation PointAnnotationView

- (id)initWithAnnotationColor:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier colorNum:(int)colorNum
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.enabled = YES;
        self.draggable = NO;
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"circle_%d",colorNum]];
    }
    
    return self;
}

@end
