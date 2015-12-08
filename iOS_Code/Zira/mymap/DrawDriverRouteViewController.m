//
//  DrawDriverRouteViewController.m
//  mymap
//
//  Created by vikram on 09/12/14.
//

#import "DrawDriverRouteViewController.h"

@interface DrawDriverRouteViewController ()

@end

@implementation DrawDriverRouteViewController
@synthesize LocationsDict,WebViewOutlet,Source,Destination,findAddressStr;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    DriverLatitude=[[LocationsDict valueForKey:@"DriverLatitude"] doubleValue];
    DriverLongitude=[[LocationsDict valueForKey:@"DriverLongitude"] doubleValue];
    RiderLatitude=[[LocationsDict valueForKey:@"RiderLatitude"] doubleValue];
    RiderLongitude=[[LocationsDict valueForKey:@"RiderLongitude"] doubleValue];
    
 
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:DriverLatitude longitude:DriverLongitude zoom:15];
//    if ([[UIScreen mainScreen] bounds].size.height == 568)
//    {
//        mapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 480) camera:camera];
//    }
//    else if([[UIScreen mainScreen] bounds].size.height == 480){
//        mapView = [GMSMapView mapWithFrame: CGRectMake(10,115, 300, 300) camera:camera];
//    }
//    else
//    {
//        mapView = [GMSMapView mapWithFrame: CGRectMake(22,168, 720, 732) camera:camera];
//    }
//    mapView.settings.compassButton = YES;
//    mapView.settings.myLocationButton = YES;
//    mapView.delegate = self;
//    mapView.myLocationEnabled = YES;
//    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
//    mapView.layer.borderWidth = 1.5;
//    mapView.layer.cornerRadius = 5.0;
//    [mapView setClipsToBounds:YES];
//    [self.view addSubview:mapView];
//    
//    
//    //Add driver marker to map view
//    marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(DriverLatitude ,DriverLongitude);
//    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
//    marker.map = mapView;
//    
//    // add rider marker
//    marker2 = [[GMSMarker alloc] init];
//    marker2.position = CLLocationCoordinate2DMake(RiderLatitude ,RiderLongitude);
//    marker2.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
//    marker2.map = mapView;
//    
//    //draw line
//    
//    rectangle.map=nil;
//    
//    GMSMutablePath *path = [GMSMutablePath path];
//    [path addCoordinate:CLLocationCoordinate2DMake(@(DriverLatitude).doubleValue,@(DriverLongitude).doubleValue)];
//    [path addCoordinate:CLLocationCoordinate2DMake(@(RiderLatitude).doubleValue,@(RiderLongitude).doubleValue)];
//    rectangle = [GMSPolyline polylineWithPath:path];
//    rectangle.strokeWidth = 6.f;
//    rectangle.strokeColor=[UIColor redColor];
//    rectangle.map = mapView;


    [super viewDidLoad];
    
    CLLocationCoordinate2D start = { (DriverLatitude), (DriverLongitude) };
    CLLocationCoordinate2D end = { (RiderLatitude), (RiderLongitude) };
    
  //  30.711221, 76.686217
    
    //30.710972, 76.709119


  //  Source=@"Krishna Innovative Services, Industrial Area Mohali, Sahibzada Ajit Singh Nagar, Punjab";
   // Destination=@"Seasia Infotech, Sector 73, Sahibzada Ajit Singh Nagar, Punjab";
    
  //  Source = [Source stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    

    
  //  NSString *routeString = [NSString stringWithFormat:@"http://www.google.com/maps?saddr=%@&daddr=%@&directionsmode=driving",Source,Destination];
 
    // commented by Minakshi
    
    
  //   NSString *routeString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&x-success=sourceapp://?resume=true&x-source=AirApp",findAddressStr];
    NSString *routeString = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&x-success=sourceapp://?resume=true&x-source=AirApp",@"sector+17+chandigarh"];

    
    
//    NSString *routeString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&output=html",start.latitude,start.longitude,end.latitude,end.longitude];

    
    NSURL *url=[NSURL URLWithString:routeString];
    NSURLRequest *requestObj=[NSURLRequest requestWithURL:url];
    [self.WebViewOutlet loadRequest:requestObj];
    
  
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
