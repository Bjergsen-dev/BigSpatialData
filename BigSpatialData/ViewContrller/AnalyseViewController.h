//
//  AnalyseViewController.h
//  BigSpatialData
//
//  Created by Apple on 2019/11/16.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointAnnotation.h"


#define RED 0
#define GREEN 1
#define BLUE 2
#define BLACK 3

NS_ASSUME_NONNULL_BEGIN

@interface AnalyseViewController : UIViewController<MKMapViewDelegate>
@property (nonatomic, strong) NSArray *irmaData;
@property (nonatomic, strong) NSArray *harveyData;
@property (nonatomic, strong) NSArray *openData;
@property (nonatomic, strong) NSArray *lebnizData;
@end

NS_ASSUME_NONNULL_END
