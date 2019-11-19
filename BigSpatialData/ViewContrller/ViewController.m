//
//  ViewController.m
//  BigSpatialData
//
//  Created by Apple on 2019/10/29.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import "ViewController.h"
#import "PointAnnotation.h"
#import "CallOutViewViewController.h"
#import "ZQAlterField.h"

#define RED 0
#define GREEN 1
#define BLUE 2
#define BLACK 3

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIView *dataSetView;
@property (weak, nonatomic) IBOutlet UIImageView *harveyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *irmaImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;


@property (nonatomic, strong) CallOutViewViewController *callOutVC;
@property (nonatomic, assign) CLLocationCoordinate2D annCoor;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture1;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture2;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //test the csv reader
    //[self readCSVData:@"hurricane-harvey-points"];
    
    

    
    //init the _anncoor to (0,0)
    _annCoor.latitude = 0.0;
    _annCoor.longitude = 0.0;
    
    //set the callVC init
    
    _callOutVC = [[CallOutViewViewController alloc] initWithNibName:@"CallOutViewViewController" bundle:[NSBundle mainBundle]];
    [_callOutVC.view setFrame:CGRectMake(0, 0, _callOutVC.view.frame.size.width, _callOutVC.view.frame.size.height)];
    [_callOutVC.view setCenter:self.view.center];
    _callOutVC.view.alpha = 0.0;
    [_mapView addSubview:_callOutVC.view];
    
//add the tap to mapview for hiding the calloutVC
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearVC:)];
    [_mapView addGestureRecognizer:_tapGesture];
    
//add the tap to dataSetImageview for animation
    _tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(harveyCliked:)];
    [_harveyImageView addGestureRecognizer:_tapGesture1];
    [_harveyImageView setUserInteractionEnabled:YES];
    //add the tap to dataSetImageview for animation
    _tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(irmaCliked:)];
    [_irmaImageView addGestureRecognizer:_tapGesture2];
    [_irmaImageView setUserInteractionEnabled:YES];
    //add the tap to dataSetImageview for animation
    _tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCliked:)];
    [_addImageView addGestureRecognizer:_tapGesture3];
    [_addImageView setUserInteractionEnabled:YES];
    
    //set the maptype to standard in the begin
    [_mapView setMapType: MKMapTypeStandard];
    _mapView.delegate = self;
    NSLog(@"123");
    
    
    

    
    //add data from scv files to mapview
//    NSArray* properArray = [self readCSVData:@"hurricane-harvey-points"];
//    for (int i = 1; i<properArray.count; i++) {
//        NSString * proper = properArray[i];
//        Hurricane * hurricane = [[Hurricane alloc] initWithProperStr:proper];
//        PointAnnotation * ann = [[PointAnnotation alloc] initWithHurricane:hurricane colorNum:RED];
//        [_mapView addAnnotation:ann];
//    }
//
//
//    //add Lebniz csv to mapview
//    NSArray* properArray1 = [self readCSVData:@"leibniz-locations"];
//    for (int i = 1; i<properArray1.count; i++) {
//        NSString * proper = properArray1[i];
//        Leibniz * leibniz = [[Leibniz alloc] initWithProperStr:proper];
//        PointAnnotation * ann = [[PointAnnotation alloc] initWithLebniz:leibniz colorNum:GREEN];
//        [_mapView addAnnotation:ann];
//    }
//
//    NSArray* properArray2 = [self readCSVData:@"hurricane-irma-points"];
//    for (int i = 1; i<properArray2.count; i++) {
//
//
//        NSString * proper = properArray2[i];
//        Hurricane * hurricane = [[Hurricane alloc] initWithProperStr:proper];
//        PointAnnotation * ann = [[PointAnnotation alloc] initWithHurricane:hurricane colorNum:BLACK];
//        [_mapView addAnnotation:ann];
//    }
    
    //add data from url to mapview
    //[self addDataSetFromUrl];

}

#pragma mark Inside Methods


//get the data array
-(NSArray *)getData:(int) colorNum{
    
    NSArray* annos = [NSArray arrayWithArray:_mapView.annotations];
    //judge if there is alrady anns with that color
    NSMutableArray * dyArray = [[NSMutableArray alloc] init ];
    
    for (int i = 0; i < annos.count; i++) {
        id<MKAnnotation> ann = [annos objectAtIndex:i];
        
        if ([ann isKindOfClass:[PointAnnotation class]] && [(PointAnnotation *) ann colorNum] == colorNum) { //Add it to check if the annotation is the aircraft's and prevent it from removing
            [dyArray addObject:ann];
        }
        
    }
    
    return [NSArray arrayWithArray:dyArray];
}

//add data from scv files to mapview
-(void) addCsvToMap:(NSString *) csvUrl color:(int)colorNUm{
    
    NSArray* annos = [NSArray arrayWithArray:_mapView.annotations];
    //judge if there is alrady anns with that color
    
    int ret = 0;
    for (int i = 0; i < annos.count; i++) {
        id<MKAnnotation> ann = [annos objectAtIndex:i];
        
        if ([ann isKindOfClass:[PointAnnotation class]] && [(PointAnnotation *) ann colorNum] == colorNUm) { //Add it to check if the annotation is the aircraft's and prevent it from removing
            [_mapView removeAnnotation:ann];
            ret = 1;
        }
        
    }
    if (ret == 1) {
        return;
    }
    
    NSArray* properArray = [self readCSVData:csvUrl];
    for (int i = 1; i<properArray.count; i++) {
        NSString * proper = properArray[i];
        //排除最后一行
        if (![proper isEqualToString:@""]) {
            Hurricane * hurricane = [[Hurricane alloc] initWithProperStr:proper];
            PointAnnotation * ann = [[PointAnnotation alloc] initWithHurricane:hurricane colorNum:colorNUm];
            [_mapView addAnnotation:ann];
        }
        
    }
    
}


//ZQalterview
-(void) alterUrlView{
    ZQAlterField *alertView = [ZQAlterField alertView];
    
alertView.placeholder = @"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
    
alertView.title = @"加载在线数据源";
    
[alertView ensureClickBlock:^(NSString *inputString) {
    
    //judge if input or not
    NSString * subStr;
    if([inputString isEqualToString:@""]){
        inputString = alertView.placeholder;
    }
    subStr = [inputString substringToIndex:4];
    
    //judge the type of data source
    if ([subStr isEqualToString:@"http"]) {
        //web json
        [self addDataSetFromUrl:inputString color:BLUE];
    }else{
        // local file
        [self addCsvToMap:inputString color:GREEN];
    }
    
        
}];
    
[alertView show];
    

    
}

//some action for datasetImageview selected
-(void) zoomAnnimation: (UIImageView *)view{
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:1.5];
    animation.duration=1.0;
    animation.autoreverses=NO;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    
    CABasicAnimation *animation1=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue=[NSNumber numberWithFloat:1.5];
    animation1.toValue=[NSNumber numberWithFloat:1.0];
    animation1.duration=1.0;
    animation1.autoreverses=NO;
    animation1.repeatCount=0;
    animation1.removedOnCompletion=NO;
    animation1.fillMode=kCAFillModeForwards;
    if (view.tag == 0) {
        [view.layer addAnimation:animation forKey:@"zoom"];
        [view setTag:1];
    }else{
        
        [view.layer addAnimation:animation1 forKey:@"ring"];
        [view setTag:0];
    }
    
}

//load the data from url
-(void)addDataSetFromUrl:(NSString *) url color: (int) color{
    
    //ios http request for dataset in JSON
    //add the anns to mapview with the JSON dataset
//    NSString *url =@"https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *zoneUrl = [NSURL URLWithString:url];
        //这就是网络请求
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data) {
                //这就是数据了
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if (dic) {
                    NSLog(@"DIC:%@",dic);
                    
                    //something in dic
                    //get the features
                    NSMutableArray * features = [dic objectForKey:@"features"];
                    for (int i = 0; i < features.count; i++) {
                        NSDictionary * featureDic = [features objectAtIndex:i];
                        if (featureDic) {
                            PointAnnotation * ann = [[PointAnnotation alloc] initWithFeatureDic:featureDic colorNum:color];
                            [self.mapView addAnnotation:ann];
                        }
                        
                    }
                    
                }
                
                
                
            }
            
        });
        
    });

}

//mmethod for csv files read
-(NSArray *)readCSVData:(NSString*) nameStr{
NSString *path = [[NSBundle mainBundle] pathForResource:nameStr ofType:@"csv"];
NSError *error = nil;
NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//取出每一行的数据
NSArray *_allLinedStrings = [fileContents componentsSeparatedByString:@"\r\n"];
NSLog(@"%@",_allLinedStrings);
    return _allLinedStrings;
    
}
//————————————————
//版权声明：本文为CSDN博主「jinrui_w」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
//原文链接：https://blog.csdn.net/jinrui_w/article/details/60966338

//key - value from LeibNiz Ann
-(NSMutableArray *) keyValueFromLeAnn:(PointAnnotation *) Ann{
    NSMutableArray * keyValueArray = [[NSMutableArray alloc] init];
    
    if (Ann.leibniz) {
        NSString * institute = [NSString stringWithFormat:@"Institute:%@",Ann.leibniz.institute];
        NSString * city = [NSString stringWithFormat:@"City:%@",Ann.leibniz.city];
        NSString * link = [NSString stringWithFormat:@"Link:%@",Ann.leibniz.link];
        
        [keyValueArray addObject:institute];
        [keyValueArray addObject:city];
        [keyValueArray addObject:link];
        
    }
    
    return keyValueArray;
    
}

//key - value from Hurricane Ann
-(NSMutableArray *) keyValueFromHuAnn:(PointAnnotation *) Ann{
    
    NSMutableArray * keyValueArray = [[NSMutableArray alloc] init];
    
    if (Ann.hurricane) {
        NSString * date = [NSString stringWithFormat:@"Date:%@",Ann.hurricane.date];
        NSString * time = [NSString stringWithFormat:@"Time:%@",Ann.hurricane.time];
        NSString * wind = [NSString stringWithFormat:@"Wind:%@",Ann.hurricane.wind];
        NSString * presure = [NSString stringWithFormat:@"Presure:%@",Ann.hurricane.presure];
        NSString * stormType = [NSString stringWithFormat:@"StormType:%@",Ann.hurricane.stormType];
        NSString * category = [NSString stringWithFormat:@"Category:%@",Ann.hurricane.category];
        NSString * name = [NSString stringWithFormat:@"Name:%@",Ann.hurricane.name];
        
        [keyValueArray addObject:date];
        [keyValueArray addObject:time];
        [keyValueArray addObject:wind];
        [keyValueArray addObject:presure];
        [keyValueArray addObject:stormType];
        [keyValueArray addObject:category];
        [keyValueArray addObject:name];
    }
    
    return keyValueArray;
}

//key - value from Ann
-(NSMutableArray *) keyValueFromAnn:(PointAnnotation *) Ann{
    
    //here so many keys because of they have been loaded in PointAnnotation
    //suggeustion:replace the key details with Array the same in values
    
    NSMutableArray * keyValueArray = [[NSMutableArray alloc] init];
    
    NSString * idstr = [NSString stringWithFormat:@"ID:%@",Ann.idstr];
    NSString * mag = [NSString stringWithFormat:@"msg:%@",Ann.mag];
    NSString * place = [NSString stringWithFormat:@"place:%@",Ann.place];
    NSString * time = [NSString stringWithFormat:@"time:%@",Ann.time];
    NSString * updated = [NSString stringWithFormat:@"updated:%@",Ann.updated];
    NSString * tz = [NSString stringWithFormat:@"tz:%@",Ann.tz];
    NSString * url = [NSString stringWithFormat:@"url:%@",Ann.url];
    NSString * detail = [NSString stringWithFormat:@"detail:%@",Ann.detail];
    NSString * felt = [NSString stringWithFormat:@"felt:%@",Ann.felt];
    NSString * cdi = [NSString stringWithFormat:@"cdi:%@",Ann.cdi];
    NSString * mmi = [NSString stringWithFormat:@"mmi:%@",Ann.mmi];
    NSString * alert = [NSString stringWithFormat:@"alert:%@",Ann.alert];
    NSString * status = [NSString stringWithFormat:@"status:%@",Ann.status];
    NSString * tsunami = [NSString stringWithFormat:@"tsunami:%@",Ann.tsunami];
    NSString * sig = [NSString stringWithFormat:@"sig:%@",Ann.sig];
    NSString * type = [NSString stringWithFormat:@"type:%@",Ann.type];
    NSString * tiktle = [NSString stringWithFormat:@"tiktle:%@",Ann.tiktle];
    NSString * lat = [NSString stringWithFormat:@"lat:%f",Ann.coordinate.latitude];
    NSString * lon = [NSString stringWithFormat:@"lon:%f",Ann.coordinate.longitude];
    
    
    //add the strs to Array
    [keyValueArray addObject:idstr];
    [keyValueArray addObject:lat];
    [keyValueArray addObject:lon];
    [keyValueArray addObject:mag];
    [keyValueArray addObject:place];
    [keyValueArray addObject:time];
    [keyValueArray addObject:updated];
    [keyValueArray addObject:tz];
    [keyValueArray addObject:url];
    [keyValueArray addObject:detail];
    [keyValueArray addObject:felt];
    [keyValueArray addObject:cdi];
    [keyValueArray addObject:mmi];
    [keyValueArray addObject:alert];
    [keyValueArray addObject:status];
    [keyValueArray addObject:tsunami];
    [keyValueArray addObject:sig];
    [keyValueArray addObject:type];
    [keyValueArray addObject:tiktle];
    
    return keyValueArray;
}

//生产tile
-(MKTileOverlay *) mapTileOverlay{
    
    
    
    MKTileOverlay * tile = [[MKTileOverlay alloc] initWithURLTemplate:@"http://mt1.google.cn/vt/lyrs=s&hl=zh-CN&gl=cn&x={x}&y={y}&z={z}"];
    
    tile.minimumZ = 3;
    tile.maximumZ = 30;
    tile.canReplaceMapContent = YES;
    //tile.boundingMapRect = MAMapRectWorld;
    
    
        return tile;
    
    
    
}

//gesture action implent
- (void)clearVC:(UITapGestureRecognizer *)tapGesture{
    if (_callOutVC.view.alpha == 1.0) {
        _callOutVC.view.alpha = 0.0;
        //reset the _anncoor to (0,0)
        _annCoor.latitude = 0.0;
        _annCoor.longitude = 0.0;
    }
    
}


//tapgesture1 action implent
-(void)harveyCliked:(UITapGestureRecognizer *)tapGesture{
    
    [self zoomAnnimation:_harveyImageView];
    [self addCsvToMap:@"hurricane-harvey-points" color:RED];
}

//tapgesture1 action implent
-(void)irmaCliked:(UITapGestureRecognizer *)tapGesture{
    [self zoomAnnimation:_irmaImageView];
    [self addCsvToMap:@"hurricane-irma-points" color:BLACK];
}

//tapgesture1 action implent
-(void)addCliked:(UITapGestureRecognizer *)tapGesture{
    
  //alter the ZQ url view to input urlstr and fetch the data from internet
    [self alterUrlView];
}


#pragma mark IBAction Methods

//dataSetImageView Cliked Method

//show the dataview or hide it
- (IBAction)dataBtn_Cliked:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        //利用CGAffin来移动
        if (self.dataSetView.tag == 0) {
            self.dataSetView.transform = CGAffineTransformMakeTranslation(0, -self.dataSetView.bounds.size.height);
            [self.dataSetView setTag:1];
        }else{
            self.dataSetView.transform = CGAffineTransformMakeTranslation(0, 0);
            [self.dataSetView setTag:0];
            
        }
       
        }];
    
}

//present the analyseviewxontroller
- (IBAction)analyseBtnCliked:(id)sender {
    
    
    
    
    
    NSLog(@"cnmcncmcncmmcn");
    UIStoryboard * vb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AnalyseViewController* videoVC = [vb instantiateViewControllerWithIdentifier:@"analyseVC"];
    
    //sort the data
    videoVC.openData = [self getData:BLUE];
    videoVC.harveyData = [self getData:RED];
    videoVC.irmaData = [self getData:BLACK];
    videoVC.lebnizData = [self getData:GREEN];
    [self presentViewController:videoVC  animated:YES completion:nil];
}



//更换地图类型
- (IBAction)typeBtn_cliked:(id)sender {
    
    if (_mapView.mapType == MKMapTypeStandard) {
        //change to google setilite
        MKTileOverlay *tile = [self mapTileOverlay];
        [_mapView insertOverlay:tile atIndex:0 level:MKOverlayLevelAboveRoads];
        NSLog(@"google setellite");
       // [_mapView setMapType:MKMapTypeSatellite];

    }else{
        //把google瓦片删除
        NSArray* annos = [NSArray arrayWithArray:_mapView.overlays];
        for (int i = 0; i < annos.count; i++) {
            id<MKOverlay> ann = [annos objectAtIndex:i];
            if ([ann isKindOfClass:[MKTileOverlay class]]) { //Add it to check if the annotation is the aircraft's and prevent it from removing
                [_mapView removeOverlay:ann];
            }

        }

        [_mapView setMapType:MKMapTypeStandard];

        NSLog(@"mapkit standard");
    }
    
//    [UIView animateWithDuration:1 animations:^{
//        //利用CGAffin来移动
//        self.dataSetView.transform = CGAffineTransformMakeTranslation(0, -self.dataSetView.bounds.size.height);//只能做一次
        //self.redView.transform = CGAffineTransformTranslate(self.redView.transform, 50, 100);//可以进行多次操作
        
//    }];
//    ————————————————
//    版权声明：本文为CSDN博主「挟飞仙以遨游」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
//    原文链接：https://blog.csdn.net/qq_41856760/article/details/81534573
}

#pragma mark MKMapViewDelegate Method

-(void) mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
    NSLog(@"Finishing loading map");
    
}


- (MKOverlayRenderer*) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        MKTileOverlayRenderer *render = [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
        return render;
    }
    
    return nil;
    
}

/**
 *
 mapview标注样式设定
 *
 **/
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[PointAnnotation class]])
    {
        
    PointAnnotationView* annoView = [[PointAnnotationView alloc] initWithAnnotationColor:annotation reuseIdentifier:@"Point_Annotation" colorNum:((PointAnnotation *)annotation).colorNum ];
        
        
        ((PointAnnotation*)annotation).annotationView = annoView;
        return annoView;
    }
    
    return nil;
}

/**
 *
 annotation点击事件
 *
 **/
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    if ([view.reuseIdentifier  isEqual: @"Point_Annotation"]){
        
        
        
        PointAnnotation * Ann = view.annotation;
        
        
        if (Ann.colorNum == BLUE) {
            NSLog(@"Point_ID:%@",Ann.idstr);
            
            //refresh the properTable in calloutVC
            [_callOutVC updatetheProperTbale:[self keyValueFromAnn:Ann]];
            
            //callout  the  calloutvc
            _callOutVC.view.alpha = 1.0;
            //record the ann's coord
            _annCoor = Ann.coordinate;
            [_callOutVC.view setCenter:[_mapView convertCoordinate:Ann.coordinate toPointToView:_mapView]];
        }
        
        if (Ann.colorNum == RED || Ann.colorNum == BLACK) {
            //refresh the properTable in calloutVC
            [_callOutVC updatetheProperTbale:[self keyValueFromHuAnn:Ann]];
            
            //callout  the  calloutvc
            _callOutVC.view.alpha = 1.0;
            //record the ann's coord
            _annCoor = Ann.coordinate;
            [_callOutVC.view setCenter:[_mapView convertCoordinate:Ann.coordinate toPointToView:_mapView]];
        }
        
        if (Ann.colorNum == GREEN ) {
            //refresh the properTable in calloutVC
            [_callOutVC updatetheProperTbale:[self keyValueFromLeAnn:Ann]];
            
            //callout  the  calloutvc
            _callOutVC.view.alpha = 1.0;
            //record the ann's coord
            _annCoor = Ann.coordinate;
            [_callOutVC.view setCenter:[_mapView convertCoordinate:Ann.coordinate toPointToView:_mapView]];
        }
        
        
    }
    
}

//当拖拽，放大，缩小，双击手势开始时调用
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //hide the VC if it is shown
    if (_callOutVC.view.alpha == 1.0) {
        _callOutVC.view.alpha =0.0;
    }
    
}

//当拖拽，放大，缩小，双击手势结束时调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    if (!(_annCoor.latitude == 0.0 && _annCoor.longitude == 0.0)) {
        _callOutVC.view.alpha =1.0;
        CGPoint point = [_mapView convertCoordinate:_annCoor toPointToView:_mapView];
        _callOutVC.view.center = point;
    }
}

//overlays 样式委托
- (MKOverlayView*) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    
    return nil;
}

@end



