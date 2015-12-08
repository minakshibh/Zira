//
//  SeeDriverLocationViewController.m
//  mymap
//
//  Created by vikram on 08/12/14.
//

#import "SeeDriverLocationViewController.h"

@interface SeeDriverLocationViewController ()

@end

@implementation SeeDriverLocationViewController

@synthesize GetDriverId,GetTripId;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
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

    
    //Get Driver Location
    [self GetDriverLocation];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        
        [self.locationManager stopUpdatingLocation];
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [mapView clear];
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation*currentLocation;
    
    if (locations.count>0) {
        currentLocation = [locations objectAtIndex:0];
    }
   // NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    current_longitude=currentLocation.coordinate.longitude;
    current_latitude=currentLocation.coordinate.latitude;
 }

#pragma mark - Show Map And Driver Location

-(void)ShowMapAndDriverLocation
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:DriverLattitude longitude:DriverLongitude zoom:14];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,75, 300, 480) camera:camera];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        mapView = [GMSMapView mapWithFrame: CGRectMake(10,115, 300, 300) camera:camera];
    }
    else{
        mapView = [GMSMapView mapWithFrame: CGRectMake(22,168, 720, 732) camera:camera];
    }
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    mapView.myLocationEnabled = YES;
    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
    mapView.layer.borderWidth = 1.5;
    mapView.layer.cornerRadius = 5.0;
    [mapView setClipsToBounds:YES];
    [self.view addSubview:mapView];
    
    
    //Add Marker to map view
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(DriverLattitude ,DriverLongitude);
   // marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    marker.icon = [UIImage imageNamed:@"car_icon.png"];

    marker.map = mapView;
 
}

#pragma mark - Get Driver Location On Map

-(void)GetDriverLocation
{
    [kappDelegate ShowIndicator];
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetDriverId,@"DriverId",GetTripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDriverLocation",Kwebservices]];
    [self postWebservices];
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
            webData = [NSMutableData data] ;
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
    // [self.activityIndicatorObject stopAnimating];
    // self.view.userInteractionEnabled=YES;
    // self.disablImg.hidden=YES;
    
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
                
                if ([[userDetailDict valueForKey:@"latitude"] isEqualToString:@""])
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No Location Is Available for this driver" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;

                }
                DriverLattitude=[[userDetailDict valueForKey:@"latitude"] doubleValue];
                DriverLongitude=[[userDetailDict valueForKey:@"longitude"] doubleValue];
                [self ShowMapAndDriverLocation];
            }
        }
        
    }
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
