//
//  mapViewController.m
//  
//
//  Created by eidision on 15/5/11.
//
//

#import "mapViewController.h"
#import "titleView.h"
#import "cityTableViewController.h"
#import "myNetworking.h"
#import "Reachability.h"
#import "UIViewController+MJPopupViewController.h"
#import "MJSecondDetailViewController.h"
#import "DejalActivityView.h"
#import "startUp.h"

@interface mapViewController ()<MJSecondPopupDelegate, startupViewDelegate>{
    MJSecondDetailViewController *secondDetailViewController;
    startUp *startupView;
    
    CGFloat screen_width;
    CGFloat screen_height;
    
    titleView *topView;
    
    double xSum;
    double ySum;
    CLLocationCoordinate2D regionCoord;
    MKMapView *mapview;
    
    NSString *cityName;
    NSString *olderCity;
    
    NSString *portalId;
    
    NSMutableDictionary *portalInfo;
    
    NSMutableArray *currentAnnotations;
    AnnotationInMap *select_annotation;
    
    BOOL networkConnected;
}

@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"重庆" forKey:@"cityName"];
    olderCity = @"";
    
    [self connectedToNetWork];
    
    //获取屏幕分辨率
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    screen_width = size.width;
    screen_height = size.height;
    
    UIBarButtonItem *chooseButton = [[UIBarButtonItem alloc] initWithTitle:@"切换城市" style:UIBarButtonItemStylePlain target:self action:@selector(selectCity)];
    [chooseButton setTitleTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                           }
                                forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = chooseButton;
    
    UIBarButtonItem *freshButton = [[UIBarButtonItem alloc] initWithTitle:@"   刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    [freshButton setTitleTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                           //NSTextAlignmentCenter
                                           }
                                forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = freshButton;
    
    topView = [[titleView alloc] init];
    self.navigationItem.titleView = topView;
    
    //draw the map
    mapview = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, screen_width, screen_height - 64)];
    mapview.delegate = self;
    mapview.mapType = MKMapTypeStandard;
    [self.view addSubview:mapview];
    
    NSString *first = [[NSUserDefaults standardUserDefaults] stringForKey:@"intro_screen_viewed"];
    if (!first) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self.navigationController setNavigationBarHidden:YES];
        startupView = [[startUp alloc] initWithFrame:self.view.frame];
        startupView.delegate = self;
        [self.view addSubview:startupView];
        NSLog(@"here");
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO];
        //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar"]]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //判断是否网络异常，并提醒
    //NSLog(@"ifReadOnly value: %@" ,networkConnected?@"YES":@"NO");
    if (networkConnected) {
        //拿到cityName
        cityName = [[NSUserDefaults standardUserDefaults] stringForKey:@"cityName"];
        //如果没有选择city
        if (!cityName){
            [self alertWithTitle:@"未选择城市" withMsg:@"请先选择想观察的城市"];
        }else if (![cityName isEqualToString:olderCity]){
            topView.subtitleLable.text = cityName;
            //NSLog(@"fuckhere");
            
            [self loadMap];
            //[self relocate];
            if (xSum == 0.0 || ySum == 0.0) {
                NSLog(@"here:%f%f", xSum, ySum);
                [self alertWithTitle:@"网络异常" withMsg:@"网络不给力，请稍后重试"];
            }
        }
    }else{
        [self alertWithTitle:@"网络异常" withMsg:@"请先检查网络连接后再试"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -city
-(void)selectCity{
    olderCity = cityName;
    
    cityTableViewController *citytableViewController = [[cityTableViewController alloc] init];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    //[backButton setImage:[UIImage imageNamed:@"back"]];
    [backButton setTitleTextAttributes:@{
                                         NSFontAttributeName: [UIFont systemFontOfSize:16],
                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                         }
                              forState:UIControlStateNormal];
    [self.navigationItem setBackBarButtonItem:backButton];

    //[self.navigationController pushViewController:attentionView animated:NO];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:citytableViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

-(void)refresh
{
    //判断是否网络异常，并提醒
    //NSLog(@"ifReadOnly value: %@" ,networkConnected?@"YES":@"NO");
    if (networkConnected) {
        //拿到cityName
        cityName = [[NSUserDefaults standardUserDefaults] stringForKey:@"cityName"];
        //如果没有选择city
        if (!cityName){
            [self alertWithTitle:@"未选择城市" withMsg:@"请先选择想观察的城市"];
        }else{
            //topView.subtitleLable.text = cityName;
            //NSLog(@"fuckhere");
            
            [self loadMap];
            //[self relocate];
            if (xSum == 0.0 || ySum == 0.0) {
                NSLog(@"here:%f%f", xSum, ySum);
                [self alertWithTitle:@"网络异常" withMsg:@"网络不给力，请稍后重试"];
            }
        }
    }else{
        [self alertWithTitle:@"网络异常" withMsg:@"请先检查网络连接后再试"];
    }
}

-(void)loadinfo
{
    portalInfo = [[NSMutableDictionary alloc] init];
    [portalInfo setObject:@{@"name":@"重庆藏金阁电镀工业园", @"address":@[@"106.628",@"29.611"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"1"];
    [portalInfo setObject:@{@"name":@"重庆中法水务唐家沱污水处理公司", @"address":@[@"106.634",@"29.602"], @"no_exce":@[@"废水", @"废气",@"固废"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"2"];
    [portalInfo setObject:@{@"name":@"重庆大班石化仓储有限公司", @"address":@[@"106.633",@"29.607"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"3"];
    [portalInfo setObject:@{@"name":@"中石化渝辉油料有限公司唐家沱油库", @"address":@[@"106.63",@"29.604"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"4"];
    [portalInfo setObject:@{@"name":@"重庆英达实业柏树湾油库", @"address":@[@"106.626",@"29.62"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"5"];
    [portalInfo setObject:@{@"name":@"中航油重庆石油有限公司唐家沱油库", @"address":@[@"106.632",@"29.605"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"6"];
    [portalInfo setObject:@{@"name":@"中国航空油料有限责任公司唐家沱油库", @"address":@[@"106.633",@"29.604"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"7"];
    [portalInfo setObject:@{@"name":@"中石油天然气股份有限公司重庆销售分公司朝阳河油库", @"address":@[@"106.629",@"29.619"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"8"];
    [portalInfo setObject:@{@"name":@"重庆顺泰铁塔制造有限公司", @"address":@[@"106.63",@"29.611"], @"no_exce":@[@"废水", @"废气"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"9"];
    [portalInfo setObject:@{@"name":@"重庆兆隆食品有限公司", @"address":@[@"106.635",@"29.607"], @"no_exce":@[@"废水"], @"exce":@[], @"time":@"2015-05-10 09：30"} forKey:@"10"];
    /*UIView *viewToUse = self.view;
    [DejalBezelActivityView activityViewForView:viewToUse withLabel:@"登录中..." width:100];*/
}

#pragma mark -map
-(void)loadMap
{
    xSum = 0.0;
    ySum = 0.0;
    
    [self loadinfo];
    if (portalInfo) {
        //NSLog(@"count:%lu", (unsigned long)currentAnnotations.count);
        if ([currentAnnotations count]) {
            [mapview removeAnnotations:currentAnnotations];
        }
        
        currentAnnotations = [[NSMutableArray alloc] init];
        
        for (NSString *portal_id in portalInfo.allKeys) {
            NSDictionary *tempinfo = portalInfo[portal_id];
            
            if (tempinfo) {
                double x = [tempinfo[@"address"][1] doubleValue];
                double y = [tempinfo[@"address"][0] doubleValue];
                xSum += x;
                ySum += y;
                
                CLLocationCoordinate2D tempcoordinate = {x, y};
                
                AnnotationInMap *annotationInMap = [[AnnotationInMap alloc] initWithCGLocation:tempcoordinate];
                
                if (tempinfo[@"name"]) {
                    annotationInMap.title = [NSString stringWithFormat:@"%3.@", tempinfo[@"name"]];
                }
                
                //annotationInMap.subtitle = [self.addressInfo objectForKey:particularAddr][2] ;//@"ok";
                
                if ([(NSArray *)tempinfo[@"exce"] count] > 0) {
                    annotationInMap.subtitle = @"存在异常";
                }else{
                    annotationInMap.subtitle = @"指标正常";
                }
                
                annotationInMap.tag = portal_id;
                [currentAnnotations addObject:annotationInMap];
                [mapview addAnnotation:annotationInMap];
            }
        }
        NSLog(@"after");
        long portal_num = [portalInfo.allKeys count];
        CLLocationCoordinate2D coordinate = {xSum / portal_num, ySum / portal_num};
        //精度
        MKCoordinateSpan span= {0.1, 0.1};
        MKCoordinateRegion region = {coordinate, span};
        [mapview setRegion:region animated:YES];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"annotation";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:identifier];
    }
    
    if ([annotation isKindOfClass:[AnnotationInMap class]]) {
        /*if ([selectionName isEqualToString:@"SPM"]) {
            if ([((AnnotationInMap *)annotation).title doubleValue] > 1.0) {
                pinView.pinColor = MKPinAnnotationColorRed;
            }else{
                pinView.pinColor = MKPinAnnotationColorGreen;
            }
        }else{
            
        }*/
        AnnotationInMap *temp_annotation = (AnnotationInMap *)annotation;
        if ([temp_annotation.subtitle isEqualToString:@"存在异常"]) {
            pinView.pinColor = MKPinAnnotationColorRed;
        }else{
            pinView.pinColor = MKPinAnnotationColorGreen;
        }
        
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        pinView.annotation = annotation;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //[rightButton setImage:[UIImage imageNamed:@"home_map_locate"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[AnnotationInMap class]] == NO) {
        return;
    }
    
    AnnotationInMap *annotation = (AnnotationInMap *)view.annotation;
    select_annotation = annotation;
    
    //portalId = annotation.tag;
}

-(void)detail
{
    secondDetailViewController = nil;
    secondDetailViewController = [[MJSecondDetailViewController alloc] initWithNibName:@"MJSecondDetailViewController" bundle:nil];
    
    secondDetailViewController.delegate = self;
    
    secondDetailViewController.portalInfo = portalInfo[select_annotation.tag];
    [self presentPopupViewController:secondDetailViewController animationType:MJPopupViewAnimationFade];
    [mapview deselectAnnotation:select_annotation animated:YES];
}

- (void) alertWithTitle:(NSString *)title withMsg:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) connectedToNetWork {
    //检测网络是否可以连接
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            networkConnected = NO;
            break;
        case ReachableViaWWAN:
        case ReachableViaWiFi:
            networkConnected=YES;
            NSLog(@"正在使用wifi网络");
            break;  
    }
}

- (void)cancelButtonClicked:(MJSecondDetailViewController *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    secondDetailViewController = nil;
}

#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    //    [defaults synchronize];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        startupView.alpha = 0;
    } completion:^(BOOL finished) {
        [startupView removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO];
        [[NSUserDefaults standardUserDefaults] setValue:@"no_first" forKey:@"intro_screen_viewed"];
        //[self startmap];
    }];
}

@end
