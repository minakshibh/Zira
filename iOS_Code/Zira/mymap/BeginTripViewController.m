//
//  BeginTripViewController.m
//  mymap
//
//  Created by vikram on 10/12/14.
//

#import "BeginTripViewController.h"
#import "PaypalViewController.h"
#import "RatingViewController.h"
#import "Place.h"
#import "MapView.h"

#import "MDDirectionService.h"
#import "DrawDriverRouteViewController.h"
DrawDriverRouteViewController *DrawDriverRouteViewObj;



RatingViewController *RatingViewObj;


@interface BeginTripViewController ()
{
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}

@end

@implementation BeginTripViewController
@synthesize DestinationLat,DestinationLong,LocationsDict,DestinationAddress;


- (void)ShowMap
{
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    
    
    
    NSMutableDictionary *TempDict=[[NSMutableDictionary alloc] init];
    [TempDict setValue:[NSString stringWithFormat:@"%f",current_latitude] forKey:@"DriverLatitude"];
    [TempDict setValue:[NSString stringWithFormat:@"%f",current_longitude] forKey:@"DriverLongitude"];
    [TempDict setValue:[NSString stringWithFormat:@"%f",[DestinationLat doubleValue]] forKey:@"RiderLatitude"];
    [TempDict setValue:[NSString stringWithFormat:@"%f",[DestinationLong doubleValue]] forKey:@"RiderLongitude"];
    [TempDict setValue:[NSString stringWithFormat:@"%@",DestinationAddress ] forKey:@"DestinationAddress"];

    LocationsDict=TempDict;
    
    CLLocationCoordinate2D Originposition = CLLocationCoordinate2DMake(current_latitude,current_longitude);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:Originposition.latitude
                                                            longitude:Originposition.longitude
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;

    mapView_.delegate = self;
   // self.view = mapView_;
    mapView_.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    [self.view addSubview:mapView_];

    [self mapMyClick:Originposition isOriginCoordinates:YES];
    CLLocationCoordinate2D Destposition = CLLocationCoordinate2DMake([DestinationLat doubleValue],[DestinationLong doubleValue]);
    [self mapMyClick:Destposition isOriginCoordinates:NO];
}
- (void)didTapFitBoundsWithMarkers:(NSArray *)markers
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];;
    
    for (GMSMarker *marker in markers) {
        bounds = [bounds includingCoordinate:marker.position];
    }
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [mapView moveCamera:update];
    [mapView animateToViewingAngle:50];
}
- (void)mapMyClick:(CLLocationCoordinate2D)coordinate isOriginCoordinates:(BOOL)isOrigin
{
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker1 = [GMSMarker markerWithPosition:position];
    if (isOrigin)
    {
        marker1.icon=[UIImage imageNamed:@"green-marker.png"];
    }
    else{
        marker1.icon=[UIImage imageNamed:@"red-marker.png"];
    }
    marker1.map = mapView_;
    [waypoints_ addObject:marker1];
 
 
    
    
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    [waypointStrings_ addObject:positionString];
    if([waypoints_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        MDDirectionService *mds=[[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}
- (void)addDirections:(NSDictionary *)json {
    
    
    NSArray*array=[json objectForKey:@"routes"];
    NSDictionary *routes;
    if (array.count>0)
    {
        routes= [json objectForKey:@"routes"][0];
    }
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor=[UIColor redColor];
    polyline.strokeWidth=5.0;
    polyline.map = mapView_;
}

@synthesize TripId;
@synthesize ComingFromNotification;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;

    //driver can end ride
    if ([ComingFromNotification isEqualToString:@"YES"])
    {
            getDirectionBtn.hidden = true;
        endRideBtn.hidden=YES;
        //here is rider
    }
    else
    {
        endRideBtn.hidden=NO;

    // Right Bar Button Item //
    
//    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    RightButton.frame = CGRectMake(20, 0, 100, 40);
//    [RightButton setTitle:@"End Ride" forState:UIControlStateNormal];
//    //[RightButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
//   // [RightButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateHighlighted];
//    [RightButton addTarget:self action:@selector(EndRideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
//    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
//    ////

    }

    
    flag=0;
    //Get Current Location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    [self ShowMap];


    
    [self.view bringSubviewToFront:endRideBtn];

    [self.view bringSubviewToFront:getDirectionBtn];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        [timer invalidate];
        [self.locationManager stopUpdatingLocation];
    }
    
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - End Ride Button Action

-(IBAction)EndRideButtonAction:(id)sender
{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Are you sure want to Drop Off?" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"CONFIRM", nil];
    alert.tag=27;
    [alert show];
    
  }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==27)
    {
        if (buttonIndex!=alertView.cancelButtonIndex)
        {
            
            [timer invalidate];
            [self.locationManager stopUpdatingLocation];
            
            [self EndRide];

        }
    }
    
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // [mapView clear];
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation*currentLocation;
    
    if (locations.count>0) {
        currentLocation = [locations objectAtIndex:0];
    }
    NSLog(@"working");
    current_longitude=currentLocation.coordinate.longitude;
    current_latitude=currentLocation.coordinate.latitude;

    
    if (flag==0)
    {
        NSLog(@"OLD");
        flag=1;
        oldLat=current_latitude;
        oldLong=current_longitude;
        [self CalculateFareAndTime];
       timer= [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(CalculateFareAndTime) userInfo:nil repeats:YES];
    }

    // [mapView clear];
   
}
-(void)CalculateFareAndTime
{
    NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",oldLat,oldLong,current_latitude,current_longitude];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
  //  NSLog(@"query url%@",queryUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchData:data];
    });
  
}
#pragma mark - Fetch all data of ride

-(void)fetchData:(NSData *)data
{
    NSError *error;
  //  NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  //  NSLog(@"responseString:%@",responseString);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"rows"];
    //NSLog(@"Data is:%@" ,results);
    
    for (int i = 0;i <[results count]; i++)
    {
        NSDictionary *result = [results objectAtIndex:i];
      //  NSLog(@"Data is %@", result);
        
        NSString *statusStr=[[[result objectForKey:@"elements"]valueForKey:@"status"]objectAtIndex:0];
        if ([statusStr isEqualToString:@"ZERO_RESULTS"])
        {
            //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Invalid Request." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //[alert show];
            return;
        }
        NSString *tempdistaceStr = [[[[result objectForKey:@"elements"]valueForKey:@"distance"]valueForKey:@"text"]objectAtIndex:0];
        estimatedTimeStr = [[[[result objectForKey:@"elements"]valueForKey:@"duration"]valueForKey:@"text"]objectAtIndex:0];
        
        distanceStr =[NSString stringWithFormat:@"%@",tempdistaceStr];
        
        NSArray *distArray = [distanceStr componentsSeparatedByString:@" "];
        NSString *kmStr=[distArray objectAtIndex:1];
        distanceStr=[distanceStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        
        if( [kmStr caseInsensitiveCompare:@"KM"] == NSOrderedSame )
        {
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"km" withString:@""];
            
            
            estimatedDistance= [distanceStr floatValue]*0.62137*1000;
            estimatedDistance=estimatedDistance/1000;
        }
        else{
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"m" withString:@""];
            
            estimatedDistance= [distanceStr floatValue]* 0.00062137;
        }
        
        //  distanceLbl.text=[NSString stringWithFormat:@"%.2f Miles",estimatedDistance];
        
        if (estimatedTimeStr.length>7)
        {
            NSArray *timeArray = [estimatedTimeStr componentsSeparatedByString:@" "];
            int minutes=[[timeArray objectAtIndex:2]intValue];
            int hours=[[timeArray objectAtIndex:0]intValue];
            minutes=hours*60+minutes;
            estimatedTimeStr=[NSString stringWithFormat:@"%d",minutes];
            //self.estimatedTimeLbl.text=[NSString stringWithFormat:@"%@ mins",estimatedTimeStr];
        }
        else
        {
            // self.estimatedTimeLbl.text=[NSString stringWithFormat:@"%@",estimatedTimeStr];
        }
    }
    
    NSMutableDictionary *PriceDetailsDict=[[NSMutableDictionary alloc] init];
    PriceDetailsDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"PriceDetails"] mutableCopy];
    
    price_per_minute=[PriceDetailsDict valueForKey:@"PriceMintue"];
    price_per_mile=[PriceDetailsDict valueForKey:@"PriceMile"];
    surgeValue=[PriceDetailsDict valueForKey:@"SurgeValue"];
    base_fare=[PriceDetailsDict valueForKey:@"BaseFare"];
    
    
  //  NSLog(@"base fare==%@",base_fare);
    NSLog(@"estTime==%@",estimatedTimeStr);
   // NSLog(@"priceMinute ==%@",price_per_minute);
    NSLog(@"estDiastanc ==%f",estimatedDistance);
   // NSLog(@" priceMile==%@",price_per_mile);
   // NSLog(@"%f",([estimatedTimeStr intValue]*[price_per_minute floatValue]));
  //  NSLog(@"%f",(estimatedDistance *[price_per_mile floatValue]));
   // NSLog(@"%@",[NSString stringWithFormat:@"%f",[surgeValue  floatValue]]);
    
    
    actualPrice=[base_fare floatValue]+([estimatedTimeStr floatValue]*[price_per_minute floatValue])+(estimatedDistance *[price_per_mile floatValue]) ;
    if ([surgeValue floatValue]>0)
    {
        actualPrice=actualPrice*[surgeValue floatValue];
    }
    NSLog(@"ActualPrice=====%f",actualPrice);
    
    //NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", myFloat];
   // int NewActualPrice = (int) actualPrice;
    
    actualFare=[NSString stringWithFormat:@"%.2f",actualPrice];
    //  priceLbl.text=[NSString stringWithFormat:@"$%d",NewActualPrice];
    minimumPrice =[NSString stringWithFormat:@"%.2f",actualPrice-actualPrice*20/100];
    maximumPrice =[NSString stringWithFormat:@"%.2f",actualPrice+actualPrice*500/100];
    suggestedFare=[NSString stringWithString:actualFare];
    // self.ownProceLbl.text=[NSString stringWithFormat:@"$%d",NewActualPrice];
    // [self addPickerView];
}

-(void)DrawPathOnMap
{
    rectangle.map=nil;
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(@(oldLat).doubleValue,@(oldLong).doubleValue)];
    [path addCoordinate:CLLocationCoordinate2DMake(@(current_latitude).doubleValue,@(current_longitude).doubleValue)];
    
    marker2.position=CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker2.icon=[UIImage imageNamed:@"car_icon.png"];
    
    rectangle = [GMSPolyline polylineWithPath:path];
    rectangle.strokeWidth = 6.f;
    rectangle.strokeColor=[UIColor redColor];
    rectangle.map = mapView;
    
}

#pragma mark - Get Directions

- (IBAction)GetDirections:(id)sender
{
    
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    
    DestinationAddress = [DestinationAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    if ([[UIApplication sharedApplication] canOpenURL:testURL])
    {
        NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@&x-success=sourceapp://?resume=true&x-source=AirApp",DestinationAddress];
        
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSString *directionsRequest = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&x-success=sourceapp://?resume=true&x-source=AirApp",DestinationAddress];
        
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
        
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
   
    
    }
    

    
    
//     DestinationAddress = [DestinationAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        CGSize result = [[UIScreen mainScreen] bounds].size;
//        if(result.height == 480)
//        {
//            DrawDriverRouteViewObj=[[DrawDriverRouteViewController alloc]initWithNibName:@"DrawDriverRouteViewController" bundle:[NSBundle mainBundle]];
//        }
//        else
//        {
//            DrawDriverRouteViewObj=[[DrawDriverRouteViewController alloc]initWithNibName:@"DrawDriverRouteViewController" bundle:[NSBundle mainBundle]];
//        }
//        DrawDriverRouteViewObj.findAddressStr=DestinationAddress;
//        DrawDriverRouteViewObj.LocationsDict=LocationsDict;
//        [self.navigationController pushViewController:DrawDriverRouteViewObj animated:YES];
//    }
}

#pragma mark - End Ride

-(void)EndRide
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    [kappDelegate ShowIndicator];
    
    webservice=1;
    
    
     NSString*safetyCharges=[[NSUserDefaults standardUserDefaults]valueForKey:@"SafetyCharges"];
     actualPrice=actualPrice+[safetyCharges integerValue];
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",@"end",@"Status",currentTime,@"Timestamp",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",estimatedDistance],@"TripMilesActual",estimatedTimeStr,@"TripTimeActual",[NSString stringWithFormat:@"%f",actualPrice],@"TripAmountActual",@"",@"Trigger",@"",@"PaymentStatus",@"",@"CancellationCharges",nil];
    [[NSUserDefaults standardUserDefaults]setValue:TripId forKey:@"EndRideTripId"];

    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/NotifyRegardingArrival",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Move to Paypal View

-(void)MoveToPayPalView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PaypalViewController *PayPalView=[[PaypalViewController alloc]initWithNibName:@"PaypalViewController" bundle:nil];
            [self.navigationController pushViewController:PayPalView animated:YES];
        }
        else
        {
            PaypalViewController *PayPalView=[[PaypalViewController alloc]initWithNibName:@"PaypalViewController" bundle:nil];
            [self.navigationController pushViewController:PayPalView animated:YES];
        }
    }
}

#pragma mark - Move to Rating View

-(void)MoveToRatingView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            RatingViewObj=[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            RatingViewObj.GetTripId=TripId;
            [self.navigationController pushViewController:RatingViewObj animated:YES];
        }
        else
        {
            RatingViewObj=[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            RatingViewObj.GetTripId=TripId;
            [self.navigationController pushViewController:RatingViewObj animated:YES];
        }
    }
    
}


#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    //  data = [NSData dataWithContentsOfURL:urlString];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data];
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

#pragma mark - Response Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    UIAlertView *alert;
    alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Network Connection lost, Please Check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];

    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];

    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (webservice==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                
                NSLog(@"%@",userDetailDict);
                [timer invalidate];
                //here Rating view
                [self MoveToRatingView];
            }
        }
        
    }
    if (webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                
              //  DestinationLat=[[userDetailDict valueForKey:@"end_lat"] doubleValue];
               // DestinationLong=[[userDetailDict valueForKey:@"end_lon"] doubleValue];
                
            }
        }
        
    }
    
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
