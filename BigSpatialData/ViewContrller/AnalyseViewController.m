//
//  AnalyseViewController.m
//  BigSpatialData
//
//  Created by Apple on 2019/11/16.
//  Copyright © 2019 zzcBjergsen. All rights reserved.
//

#import "AnalyseViewController.h"
#import <MapKit/MapKit.h>
#import "XDSDropDownMenu.h"

@interface AnalyseViewController ()<XDSDropDownMenuDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *irmaImageView;
@property (weak, nonatomic) IBOutlet UILabel *irmaLabel;
@property (weak, nonatomic) IBOutlet UILabel *harveyLabel;
@property (weak, nonatomic) IBOutlet UILabel *labnizLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (weak, nonatomic) IBOutlet UIButton *anTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *xBtn;
@property (weak, nonatomic) IBOutlet UIButton *yBtn;
@property (weak, nonatomic) IBOutlet UIButton *overBtn;

@property (weak, nonatomic) IBOutlet UIView *showView;




@property (nonatomic, strong) UIColor *dcolor;
@property (nonatomic, strong) MKMapView *mapview;
@property (nonatomic,assign) CGRect rectOfShow;

@property (nonatomic, strong)  NSArray *dropDownMenuArray;

@end

@implementation AnalyseViewController{
    
    XDSDropDownMenu *antypeDropDownMenu;
    XDSDropDownMenu *xDropDownMenu;
    XDSDropDownMenu *yDropDownMenu;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dcolor = _irmaLabel.backgroundColor;
    [self setGestureToLabel:[self arrayOfLabel]];
    
    [self initTheMapView];
    [self initScrollView];
    [self setButtons];
    [self setArray];

    
    [self createTimer:[self sortAnnsByTime:[NSMutableArray arrayWithArray:_irmaData]]];


}


#pragma mark --IBAction Methods

- (IBAction)anTypebtn_Cliked:(id)sender {
    NSArray *arr = @[@"动画",@"柱状图",@"折线图"];
    antypeDropDownMenu.delegate = self;//代理
    [self setupDropDownMenu:antypeDropDownMenu withTitleArray:arr andButton:sender andDirection:@"down"];
    [self hideOtherDropDownMenu:antypeDropDownMenu];
}

- (IBAction)xBtn_cliked:(id)sender {
}

- (IBAction)yBtn_cliked:(id)sender {
}

#pragma mark --CustomMethods
//解析日期的大小
-(int)dateInteger:(NSString *) date{
    
    NSString * date1 = [[date componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString * date2 = [[date componentsSeparatedByString:@"."] objectAtIndex:1];
    NSArray * dateArry = [NSArray arrayWithObjects:@"Jan", @"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sept",@"Oct",@"Nov",@"Dec",nil];
    return ((((int)[dateArry indexOfObject:date1]+1) * 100) + [date2 intValue]);
}

//解析时间的先后
-(int)timeInteger:(NSString *) time{
    NSString * subStr = [time substringToIndex:2];
    return [subStr intValue];
}

//根据时间排序地图上的地物
-(NSArray *)sortAnnsByTime:(NSMutableArray *) Anns{
    
    for (int i = 0; Anns.count!=0 && i<Anns.count; i++) {
        for (int j = 0; j<Anns.count-i-1; j++) {
            PointAnnotation * Ann = (PointAnnotation *) Anns[j];
            PointAnnotation * Ann1 = (PointAnnotation *) Anns[j+1];
            
                        if (([Ann.time intValue] > [Ann1.time intValue]&&Ann.colorNum == BLUE) || ((([self dateInteger:Ann.hurricane.date] *100 + [self timeInteger:Ann.hurricane.time])> ([self dateInteger:Ann1.hurricane.date] *100 + [self timeInteger:Ann1.hurricane.time]))&&((Ann.colorNum == RED)||(Ann.colorNum == BLACK)))) {
                            [Anns exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                        }
        }
    }
    
    return [NSArray arrayWithArray:Anns];
}

//NSTimer
-(void)createTimer:(NSArray *) inputArray{
    
    //初始化
    //_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //执行操作
    //}];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:inputArray repeats:YES];
    
    //加入runloop循环池
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
        [[NSRunLoop currentRunLoop] run];
        });
}

-(void) showTimer:(NSArray *)Array mapview:(MKMapView *) mapView currentIndex : (int)curentIndex{

    id<MKAnnotation>  Ann;

    for (Ann in mapView.annotations) {
        if ([Ann isKindOfClass:[PointAnnotation class]]) {
            [mapView removeAnnotation:Ann];
        }
    }
    if (Array.count > 0) {
        PointAnnotation * Ann1 = [Array objectAtIndex:curentIndex];
        [mapView addAnnotation:Ann1];
        
        MKCoordinateRegion region = {0};
        region.center = Ann1.coordinate;
        region.span.latitudeDelta = 100;
        region.span.longitudeDelta = 100;
        [self.mapview setRegion:region animated:YES];
        
    }
    
    
}

-(void) timerStart:(NSTimer *) timer{
    static int index = 0;
    NSArray * inputArray = (NSArray *)timer.userInfo;
    if (index == inputArray.count -1) {
        [timer invalidate];
        timer = nil;
        return;
    }
    [self showTimer:inputArray mapview:_mapview currentIndex:index++];
    
}



//点击——showview的放大缩小事件
-(void) zoomTheShowView:(UIGestureRecognizer *)gr{
    UIView * showView = (UIView *) gr.view;
    if (showView.tag == 0) {
        //zoom out
        [showView setFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height)];
        [_mapview setFrame:showView.bounds];
        [showView setTag:1];
    }else{
        //zoom  in
        [showView setFrame:_rectOfShow];
        [_mapview setFrame:showView.bounds];
        [showView setTag:0];
        
    }
    
}

- (void)setArray{
    
    //初始化所有DropDownMenu下拉菜单
    antypeDropDownMenu = [[XDSDropDownMenu alloc] init];
    xDropDownMenu = [[XDSDropDownMenu alloc] init];
    yDropDownMenu = [[XDSDropDownMenu alloc] init];
    
    
    //将所有DropDownMenu加入dropDownMenuArray数组
    self.dropDownMenuArray = @[antypeDropDownMenu,xDropDownMenu,yDropDownMenu];
    
    //将所有dropDownMenu的初始tag值设为1000
    for (__strong XDSDropDownMenu *nextDropDownMenu in self.dropDownMenuArray) {
        nextDropDownMenu.tag = 1000;
    }
}

//set the button size
- (void)setButtons{
    for(UIButton *btn in @[_anTypeBtn,_xBtn,_yBtn,_overBtn]){
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [[UIColor blackColor] CGColor];
        btn.layer.borderWidth = 0.5;
        btn.layer.masksToBounds = YES;
    }
}

//init the scrollview
-(void) initScrollView{
    
    [_harveyLabel setBackgroundColor:UIColor.clearColor];
    [_irmaLabel setBackgroundColor:UIColor.clearColor];
    [_labnizLabel setBackgroundColor:UIColor.clearColor];
    [_openLabel setBackgroundColor:UIColor.clearColor];

    
    
    if (_harveyData.count == 0) {
        [_harveyLabel setUserInteractionEnabled:NO];
        [_harveyLabel setBackgroundColor:_dcolor];
    }
    if (_irmaData.count == 0) {
        [_irmaLabel setUserInteractionEnabled:NO];
        [_irmaLabel setBackgroundColor:_dcolor];
    }
    if (_lebnizData.count == 0) {
        [_labnizLabel setUserInteractionEnabled:NO];
        [_labnizLabel setBackgroundColor:_dcolor];
    }
    if (_openData.count == 0) {
        [_openLabel setUserInteractionEnabled:NO];
        [_openLabel setBackgroundColor:_dcolor];
    }
    
}



//init the mapview
-(void) initTheMapView{
    
    _mapview = [[MKMapView alloc] initWithFrame:CGRectMake(0,0, _showView.bounds.size.width, _showView.bounds.size.height)];
    _mapview.mapType = MKMapTypeStandard;
    [_showView addSubview:_mapview];
    _mapview.delegate = self;
    
    
    _rectOfShow = _showView.frame;
    UITapGestureRecognizer * tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTheShowView:)];
    [_showView addGestureRecognizer:tap];
}

-(NSArray *)arrayOfLabel{
    return [NSArray arrayWithObjects:_irmaLabel,_harveyLabel,_labnizLabel,_openLabel, nil];
}

-(void) setGestureToLabel:(NSArray *)labels{
    UILabel * label;
    for (label in labels) {
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setColorOfLabel:)];
        [label addGestureRecognizer:tapGesture];
        [label setUserInteractionEnabled:YES];
    }
}

-(void) setColorOfLabel: (UIGestureRecognizer *)gr{
    
    UIView * labelView = (UIView *)gr.view;
    if (labelView.tag == 0) {
        [labelView setTag:1];
        [labelView setBackgroundColor:UIColor.clearColor];
    }else{
        [labelView setTag:0];
        [labelView setBackgroundColor:_dcolor];
    }
}

#pragma mark - 设置dropDownMenu

/*
 判断是显示dropDownMenu还是收回dropDownMenu
 */

- (void)setupDropDownMenu:(XDSDropDownMenu *)dropDownMenu withTitleArray:(NSArray *)titleArray andButton:(UIButton *)button andDirection:(NSString *)direction{
    
    //    CGRect btnFrame = button.frame; //如果按钮在UIIiew上用这个
    
    CGRect btnFrame = [self getBtnFrame:button];//如果按钮在UITabelView上用这个
    
    
    if(dropDownMenu.tag == 1000){
        
        /*
         如果dropDownMenu的tag值为1000，表示dropDownMenu没有打开，则打开dropDownMenu
         */
        
        //初始化选择菜单
        [dropDownMenu showDropDownMenu:button withButtonFrame:btnFrame arrayOfTitle:titleArray arrayOfImage:nil animationDirection:direction];
        
        //添加到主视图上
        [self.view addSubview:dropDownMenu];
        
        //将dropDownMenu的tag值设为2000，表示已经打开了dropDownMenu
        dropDownMenu.tag = 2000;
        
    }else {
        
        /*
         如果dropDownMenu的tag值为2000，表示dropDownMenu已经打开，则隐藏dropDownMenu
         */
        
        [dropDownMenu hideDropDownMenuWithBtnFrame:btnFrame];
        dropDownMenu.tag = 1000;
    }
}

#pragma mark - 隐藏其它DropDownMenu
/*
 在点击按钮的时候，隐藏其它打开的下拉菜单（dropDownMenu）
 */
- (void)hideOtherDropDownMenu:(XDSDropDownMenu *)dropDownMenu{
    
    for ( int i = 0; i < self.dropDownMenuArray.count; i++ ) {
        
        if( self.dropDownMenuArray[i] !=  dropDownMenu){
            
            XDSDropDownMenu *dropDownMenuNext = self.dropDownMenuArray[i];
            
            //            CGRect btnFrame = ((UIButton *)self.buttonArray[i]).frame;//如果按钮在UIIiew上用这个
            
            NSArray * array = @[_anTypeBtn,_xBtn,_yBtn,_overBtn];
            
            CGRect btnFrame = [self getBtnFrame:array[i]];//如果按钮在UITabelView上用这个
            
            [dropDownMenuNext hideDropDownMenuWithBtnFrame:btnFrame];
            dropDownMenuNext.tag = 1000;
        }
    }
}

#pragma mark - 获取按钮在self.view的坐标(按钮在UITableView上使用这个方法)
/*
 因为按钮在UITableView上是放在cell的contentView上的，所以要通过以下方法获得其在self.view上坐标
 */

- (CGRect )getBtnFrame:(UIButton *)button{
    return [button.superview convertRect:button.frame toView:self.view];
}



#pragma mark - 下拉菜单代理
/*
 在点击下拉菜单后，将其tag值重新设为1000
 */

- (void) setDropDownDelegate:(XDSDropDownMenu *)sender{
    sender.tag = 1000;
}

#pragma mark --MKmapview delegate methods
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
        
        
        
//        PointAnnotation * Ann = view.annotation;
        
        
//        if (Ann.colorNum == BLUE) {
//            NSLog(@"Point_ID:%@",Ann.idstr);
//
//            //refresh the properTable in calloutVC
//            [_callOutVC updatetheProperTbale:[self keyValueFromAnn:Ann]];
//
//            //callout  the  calloutvc
//            _callOutVC.view.alpha = 1.0;
//            //record the ann's coord
//            _annCoor = Ann.coordinate;
//            [_callOutVC.view setCenter:[_mapView convertCoordinate:Ann.coordinate toPointToView:_mapView]];
//        }
//
//        if (Ann.colorNum == RED || Ann.colorNum == BLACK) {
//            //refresh the properTable in calloutVC
//            [_callOutVC updatetheProperTbale:[self keyValueFromHuAnn:Ann]];
//
//            //callout  the  calloutvc
//            _callOutVC.view.alpha = 1.0;
//            //record the ann's coord
//            _annCoor = Ann.coordinate;
//            [_callOutVC.view setCenter:[_mapView convertCoordinate:Ann.coordinate toPointToView:_mapView]];
//        }
//
//        if (Ann.colorNum == GREEN ) {
//            //refresh the properTable in calloutVC
//            [_callOutVC updatetheProperTbale:[self keyValueFromLeAnn:Ann]];
//
//            //callout  the  calloutvc
//            _callOutVC.view.alpha = 1.0;
//            //record the ann's coord
//            _annCoor = Ann.coordinate;
//            [_callOutVC.view setCenter:[_mapView convertCoordinate:Ann.coordinate toPointToView:_mapView]];
//        }
//
//
    }
    
}

//当拖拽，放大，缩小，双击手势开始时调用
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{

}

//当拖拽，放大，缩小，双击手势结束时调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    

}

@end
