//
//  DriverMapViewController.m
//  mymap
//
//  Created by vikram on 02/12/14.
//

#import "DriverMapViewController.h"
#import "DrawDriverRouteViewController.h"
#import "BeginTripViewController.h"
#import "Base64.h"
#import "RegisterViewViewController.h"
#import "EditDriverProfileViewController.h"
#import "HomeViewController.h"

RegisterViewViewController *RegisterViewObj;

BeginTripViewController *BeginTripViewObj;

DrawDriverRouteViewController *DrawDriverRouteViewObj;

EditDriverProfileViewController  *editDriverProfileViewObj;

@interface DriverMapViewController ()

@end

@implementation DriverMapViewController

@synthesize progressBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        TempDictForUser=[[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshView" object:nil];

    }
    return self;
}

-(void)refreshView:(NSNotification *) notification
{
    NSDictionary* userInfo = notification.userInfo;
    riderLatitude=[[userInfo valueForKey:@"Latitude"]doubleValue];
    riderLongitude=[[userInfo valueForKey:@"Longitude"]doubleValue];
    Source=[userInfo valueForKey:@"source_address"];
    Destination=[userInfo valueForKey:@"destination_address"];
    
    TripId=[userInfo valueForKey:@"TripId"];
    NSLog(@"userInfo valueForKey:%@",TripId);


    AriveBtnOutlet.hidden=NO;
    RouteBtn.hidden=NO;
    CancelBtn.hidden=YES;
    [AriveBtnOutlet setTitle:@"ARRIVED" forState:UIControlStateNormal];
    
    [self GetRiderTripDetails];
    
    Rider=@"Show";
  

}
-(IBAction)CancelStatus:(id)sender
{
    CancelRideWithPay=@"yes";
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [[NSUserDefaults standardUserDefaults] setValue:@"DRIVER" forKey:@"MODE"];
    ActiveRidesArray=[[NSMutableArray alloc] init];

    OnOffBtn.on=YES;
    
    self.navigationItem.hidesBackButton = YES;

    // Left Bar Button Item //
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    // [leftButton setTitle:@"Home" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"header_user_icon.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"header_user_icon.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(HomeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;

    ////
    
//    //Add Slider
//    
//    [self.view bringSubviewToFront:HomeViewOutlet];
//    [HomeViewOutlet setFrame:CGRectMake(0, 64, 250, 568)];
//    [self.view addSubview:HomeViewOutlet];
//    HomeViewOutlet.hidden=YES;
    
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.cornerRadius=35;

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
    
    
    
    //Add Slider
    
    [HomeViewOutlet setFrame:CGRectMake(0, 64, 250, self.view.frame.size.height-64)];
    [self.view addSubview:HomeViewOutlet];
    HomeViewOutlet.hidden=YES;
    [self.view bringSubviewToFront:HomeViewOutlet];
    [mapView bringSubviewToFront:HomeViewOutlet];
    
   
    
    //riderLatitude=30.712840;
   // riderLongitude=76.691576;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    //add map view with camera
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:15];
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 510) camera:camera];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width,420) camera:camera];
    }
    else
    {
        mapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
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
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude );
    
    marker.icon = [UIImage imageNamed:@"car_icon.png"];
    marker.map = mapView;
    [self ShowRiderOnMap];
    
    
    
    [self.view bringSubviewToFront:AriveBtnOutlet];
    [mapView bringSubviewToFront:AriveBtnOutlet];
    
    [self.view bringSubviewToFront:RouteBtn];
    [mapView bringSubviewToFront:RouteBtn];
    
    [self.view bringSubviewToFront:CancelBtn];
    [mapView bringSubviewToFront:CancelBtn];
    
    //---- map view end
    
    CancelRideWithPay=@"no";
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverViewButtons"] isEqualToString:@"Hide"])
    {
      [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DriverViewButtons"];
        AriveBtnOutlet.hidden=YES;
        RouteBtn.hidden=YES;
        CancelBtn.hidden=YES;
    }
    if (FullName.length==0)
    {
        [self GetDriverProfileService];
        
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
//        AriveBtnOutlet.hidden=YES;
//        RouteBtn.hidden=YES;
//        CancelBtn.hidden=YES;
//        [timer invalidate];
//
//        [self SetDriverModeOff];
//
//        [self.locationManager stopUpdatingLocation];
    }
    
    [super viewWillDisappear:animated];
}
#pragma mark - Home Button Action

-(IBAction)HomeButtonAction:(id)sender
{
    [self HideShowSlider];
}

#pragma mark - Hide Show Slider Action

-(void)HideShowSlider
{
    if (HomeViewOutlet.hidden==YES)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [HomeViewOutlet.layer addAnimation:transition forKey:nil];
        [self.view bringSubviewToFront:HomeViewOutlet];
        // [sideView addSubview:self.view];
        HomeViewOutlet.hidden=NO;
        return ;
    }
    else
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [HomeViewOutlet.layer addAnimation:transition forKey:nil];
        HomeViewOutlet.hidden=YES;
        return ;
    }
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // [mapView clear];
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    // [locationManager stopUpdatingLocation];
    current_longitude=newLocation.coordinate.longitude;
    current_latitude=newLocation.coordinate.latitude;
    CLLocationCoordinate2D local;
    local= CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker.position = local;
    marker.map = mapView;
    //GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local];
   // [mapView animateWithCameraUpdate:cams];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation*currentLocation;
    
    if (locations.count>0)
    {
        currentLocation = [locations objectAtIndex:0];
    }
    
   // [mapView clear];
    current_longitude=currentLocation.coordinate.longitude;
    current_latitude=currentLocation.coordinate.latitude;
    CLLocationCoordinate2D local;
    local= CLLocationCoordinate2DMake(current_latitude, current_longitude);
    marker.position = local;
    marker.map = mapView;
    if ([Rider isEqualToString:@"show"])
    {
        Rider=@"";
        [self ShowRiderOnMap];
  
    }
    //GMSCameraUpdate *cams = [GMSCameraUpdate setTarget:local];
   // [mapView animateWithCameraUpdate:cams];
}

#pragma mark - Show Rider on Map

-(void)ShowRiderOnMap
{
    GMSMarker* RiderMarker = [[GMSMarker alloc] init];
    RiderMarker.position = CLLocationCoordinate2DMake(riderLatitude ,riderLongitude);
    RiderMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];

    RiderMarker.map = mapView;
}

#pragma mark - Arrive Button Action

- (IBAction)ArriveButtonAction:(id)sender
{
    NSString *title=AriveBtnOutlet.titleLabel.text;
    if ([title isEqualToString:@"BEGIN TRIP"])
    {
        RouteBtn.hidden=YES;
        AriveBtnOutlet.hidden=YES;
        CancelBtn.hidden=YES;
        [self BeginNotify];
        [self MoveToBeginTripView];
    }
    else
    {
        CancelRideTimer=[NSTimer scheduledTimerWithTimeInterval:300.0f
                                                         target:self
                                                       selector:@selector(CancelStatus:)
                                                       userInfo:nil
                                                        repeats:NO];
        [self ArrivelNotify];
        CancelBtn.hidden=NO;
        RouteBtn.hidden=YES;
        [AriveBtnOutlet setTitle:@"BEGIN TRIP" forState:UIControlStateNormal];
    }
}

#pragma mark - Move To Begin trip View

-(void)MoveToBeginTripView
{
    NSMutableDictionary *TempDict=[[NSMutableDictionary alloc] init];
    [TempDict setValue:[NSString stringWithFormat:@"%f",current_latitude] forKey:@"DriverLatitude"];
    [TempDict setValue:[NSString stringWithFormat:@"%f",current_longitude] forKey:@"DriverLongitude"];
    [TempDict setValue:[NSString stringWithFormat:@"%f",riderLatitude] forKey:@"RiderLatitude"];
    [TempDict setValue:[NSString stringWithFormat:@"%f",riderLongitude] forKey:@"RiderLongitude"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            BeginTripViewObj=[[BeginTripViewController alloc]initWithNibName:@"BeginTripViewController" bundle:nil];
        }
        else
        {
            BeginTripViewObj=[[BeginTripViewController alloc]initWithNibName:@"BeginTripViewController" bundle:nil];
        }
        BeginTripViewObj.TripId=TripId;
        NSLog(@" BeginTripViewObj.TripId: %@",TripId);
        BeginTripViewObj.DestinationLat=DestinationLat;
        BeginTripViewObj.DestinationLong=DestinationLong;
        BeginTripViewObj.DestinationAddress=Destination;
        [timer invalidate];
        [self.navigationController pushViewController:BeginTripViewObj animated:YES];
    }
}


#pragma mark - Route On Map Button Action

- (IBAction)RouteOnMapButton:(id)sender
{
    
    
//    NSMutableDictionary *TempDict=[[NSMutableDictionary alloc] init];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",current_latitude] forKey:@"DriverLatitude"];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",current_longitude] forKey:@"DriverLongitude"];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",riderLatitude] forKey:@"RiderLatitude"];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",riderLongitude] forKey:@"RiderLongitude"];
//
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
//        DrawDriverRouteViewObj.LocationsDict=TempDict;
//        DrawDriverRouteViewObj.Source=Source;
//        DrawDriverRouteViewObj.Destination=Destination;
//        [self.navigationController pushViewController:DrawDriverRouteViewObj animated:YES];
    
        
        
        NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
        
        Source = [Source stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
        if ([[UIApplication sharedApplication] canOpenURL:testURL])
        {
            NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@&x-success=sourceapp://?resume=true&x-source=AirApp",Source];
            
            NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
            [[UIApplication sharedApplication] openURL:directionsURL];
        }
        else
        {
            NSString *directionsRequest = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&x-success=sourceapp://?resume=true&x-source=AirApp",Source];
            
            NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
            [[UIApplication sharedApplication] openURL:directionsURL];
            
            NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
    
    
//    NSMutableDictionary *TempDict=[[NSMutableDictionary alloc] init];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",current_latitude] forKey:@"DriverLatitude"];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",current_longitude] forKey:@"DriverLongitude"];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",riderLatitude] forKey:@"RiderLatitude"];
//    [TempDict setValue:[NSString stringWithFormat:@"%f",riderLongitude] forKey:@"RiderLongitude"];
//    
//    
//    Source = [Source stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    
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
//        DrawDriverRouteViewObj.LocationsDict=TempDict;
//        DrawDriverRouteViewObj.findAddressStr=Source;
//        DrawDriverRouteViewObj.Destination=Destination;
//        [self.navigationController pushViewController:DrawDriverRouteViewObj animated:YES];
//    }

}

#pragma mark - On Off Switch

- (IBAction)OnOffSwitch:(id)sender
{
  //  [self.navigationController popViewControllerAnimated:YES];
    AriveBtnOutlet.hidden=YES;
    RouteBtn.hidden=YES;
    CancelBtn.hidden=YES;
    [timer invalidate];
    
    
    [self.locationManager stopUpdatingLocation];
    [[NSUserDefaults standardUserDefaults] setValue:@"RIDER" forKey:@"MODE"];
    
    [self SetDriverModeOff];
    [self MoveToHomeView];


}

#pragma mark - Check For Pending Request

-(void)CheckForPendingRequest
{
    if (ActiveRidesArray.count>0)
    {
        for (int i=0; i<[ActiveRidesArray count]; i++)
        {
            NSString *dateString =[[ActiveRidesArray objectAtIndex:i] valueForKey:@"requesttime"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSDate *serverDate = [[NSDate alloc] init];
            serverDate = [dateFormatter dateFromString:dateString];
            
            
            NSDate *date1 = [NSDate date];
            int diff = [date1 timeIntervalSinceDate:serverDate];
            if (diff <= 20)
            {
                
                ActiveRideTripId=[[ActiveRidesArray objectAtIndex:i] valueForKey:@"tripid"];
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    CGSize result1 = [[UIScreen mainScreen] bounds].size;
                    if(result1.height == 480)
                    {
                        animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)];
                    }
                    else
                    {
                        animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 80)];
                    }
                }
                
                TimerValue=20;
                DownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:YES];
                
                animatedView.backgroundColor=[UIColor whiteColor];
                [self.view addSubview:animatedView];
                
                DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
                DriverImgView.backgroundColor=[UIColor lightGrayColor];
                DriverImgView.layer.masksToBounds = YES;

                DriverImgView.layer.cornerRadius=35;
                [animatedView addSubview:DriverImgView];
                
                DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 12, 250, 25)];
                DriverNameLbl.textColor=[UIColor blackColor];
                [animatedView addSubview:DriverNameLbl];
                
                MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 25, 250, 40)];
                [MessageLbl setFont:[UIFont systemFontOfSize:11]];
                MessageLbl.textColor=[UIColor blackColor];

                MessageLbl.numberOfLines=3;
                [animatedView addSubview:MessageLbl];
                
                DriverNameLbl.text=[[ActiveRidesArray objectAtIndex:i] valueForKey:@"ridername"];
                MessageLbl.text=@"Sent You a ride request";
                NSString *imgStr=[[ActiveRidesArray objectAtIndex:i] valueForKey:@"riderimage"];
                        UIImage* myImage = [UIImage imageWithData:
                                            [NSData dataWithContentsOfURL:
                                             [NSURL URLWithString:imgStr]]];
                        [DriverImgView setImage:myImage];
                
                //progress bar
                progressBar=[[UIProgressView alloc] initWithFrame:CGRectMake(20, 90, 260, 3)];
                
                ProgressBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 170)];
                
                ProgressBarView.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
                UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(42, 110, 235, 20)];
                lbl.text=@"Touch Anywhere to Accept";
                [lbl setFont:[UIFont fontWithName:@"Helvetica Bold" size:18]];
                lbl.textColor=[UIColor blackColor];
                [ProgressBarView addSubview:lbl];
                
                Timerlbl=[[UILabel alloc] initWithFrame:CGRectMake(130, 20, 60, 60)];
                Timerlbl.text=[NSString stringWithFormat:@"%d",TimerValue];
                Timerlbl.textAlignment = NSTextAlignmentCenter;
                [Timerlbl setFont:[UIFont fontWithName:@"Helvetica Bold" size:50]];
                Timerlbl.textColor=[UIColor colorWithRed:11/255.0f green:172/255.0f blue:136/255.0f alpha:1.0f];
                [ProgressBarView addSubview:Timerlbl];
                
                [ProgressBarView addSubview:progressBar];
                
                progressBar.progress = 100.0;
                counter = 100.0;
                progressFloat = 0.0;
                fileSize = 100;
                
                [self.view addSubview:ProgressBarView];
                
                AcceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [AcceptBtn addTarget:self
                              action:@selector(AcceptButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
                AcceptBtn.frame = CGRectMake(10, 50, 300, 400);
                [self.view addSubview:AcceptBtn];
                
                [self progressUpdate];
                [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(DisableView) userInfo:nil repeats:NO];
            }
            else
            {
                NSLog(@">20");
            }
        }
    }
    

   
}

-(void)DownTimeCal
{
    TimerValue=TimerValue-1;
    Timerlbl.text=[NSString stringWithFormat:@"%d",TimerValue];
    if (TimerValue==0)
    {
        [DownTimer invalidate];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You missed a request!" message:@"You did not attempt to accept this request. if you're unavailable, Please turn off driver mode." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}
#pragma mark - Accept Button Action

-(IBAction)AcceptButtonAction:(id)sender
{
    [DownTimer invalidate];
    progressBar.progress = 0.0;
    progressFloat = 0.0;
    counter = 0.0;
    [AcceptBtn removeFromSuperview];
    [progressTimer invalidate];
    [animatedView removeFromSuperview];
    [ProgressBarView removeFromSuperview];
    
    //call accept web service
    [self AcceptRideRequest];
    
}
-(void)progressUpdate
{
    if (progressFloat <100.0)
    {
        counter = counter-1;
        progressFloat = counter/fileSize;
        progressBar.progress = progressFloat;
        [self performSelector:@selector(progressUpdate) withObject:nil afterDelay:0.2];
    }
}
-(void)DisableView
{
    progressBar.progress = 0.0;
    progressFloat = 0.0;
    counter = 0.0;
    
    [AcceptBtn removeFromSuperview];
    [progressTimer invalidate];
    [animatedView removeFromSuperview];
    [ProgressBarView removeFromSuperview];
}

#pragma mark - Accept Ride Request

-(void)AcceptRideRequest
{
    [kappDelegate ShowIndicator];
    webservice=10;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:ActiveRideTripId,@"tripid",@"accepted",@"status",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"json dict: acceptride: %@",jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptOrRejectRequest",Kwebservices]];
    
    [self postWebservices];
}
#pragma mark - Get Active Trips

//-(void)GetActiveTrips
//{
//    [kappDelegate ShowIndicator];
//    webservice=11;
//    
//    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"UserId",nil];
//    
//    jsonRequest = [jsonDict JSONRepresentation];
//    NSLog(@"jsonRequest is %@", jsonRequest);
//    
//    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetActiveTrips",Kwebservices]];
//    
//    [self postWebservices];
//}

#pragma mark - Move To Home View

-(void)MoveToHomeView
{
    [timer invalidate];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [timer invalidate];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
        HomeViewController *HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:YES];
        }
        else
        {
            HomeViewController *HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:NO];
        }
    }

}

#pragma mark - Show Driver Profile

- (IBAction)ShowDriverProfile:(id)sender
{
    [self HideShowSlider];
    [self EditDriverProfileView];
}

#pragma mark - Cancel Button Action

- (IBAction)CancelButtonAction:(id)sender
{
    RouteBtn.hidden=YES;
    CancelBtn.hidden=YES;
    AriveBtnOutlet.hidden=YES;
    [self CancelRideRequest];
}

#pragma mark - Move to Register View

-(void)MoveToRegisterView
{
    NSString *str=@"DriverMode";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            RegisterViewObj=[[RegisterViewViewController alloc]initWithNibName:@"RegisterViewViewController" bundle:nil];
        }
        else
        {
            RegisterViewObj=[[RegisterViewViewController alloc]initWithNibName:@"RegisterViewViewController" bundle:nil];
        }
        RegisterViewObj.UserRecordArray=TempDictForUser;
        RegisterViewObj.EditFrom=str;
        [timer invalidate];
        [self.navigationController pushViewController:RegisterViewObj animated:YES];
    }
}

#pragma mark - Edit Driver Profile View

-(void)EditDriverProfileView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            editDriverProfileViewObj=[[EditDriverProfileViewController alloc]initWithNibName:@"EditDriverProfileViewController" bundle:nil];
        }
        else
        {
            editDriverProfileViewObj=[[EditDriverProfileViewController alloc]initWithNibName:@"EditDriverProfileViewController" bundle:nil];
        }
        editDriverProfileViewObj.UserRecordArray=TempDictForUser;
        [timer invalidate];
        [self.navigationController pushViewController:editDriverProfileViewObj animated:YES];
    }
}

#pragma mark - Set Driver Mode On

-(void)SetDriverModeOn
{
   // [kappDelegate ShowIndicator];
    
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"Riderid",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",@"Activate",@"Trigger",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SwitchBetweenMode",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Set Driver Mode Off

-(void)SetDriverModeOff
{
    //[kappDelegate ShowIndicator];
    
    webservice=2;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"Riderid",[NSString stringWithFormat:@"%f",current_longitude],@"Longitude",[NSString stringWithFormat:@"%f",current_latitude],@"Latitude",@"Busy",@"Trigger",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SwitchBetweenMode",Kwebservices]];
    
    [self postWebservices];
}


#pragma mark - Register Device for Push Notifications

-(void)RegisterDevice
{
    webservice=3;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"RiderId",@"driver",@"Role",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"DriverId",[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],@"DeviceUDId",[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"],@"TokenID",@"ios",@"Trigger",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterDevice",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Update Driver Location

-(void)UpdateDriverLocation
{
  //  [kappDelegate ShowIndicator];
    webservice=4;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"DriverId",[NSString stringWithFormat:@"%f",current_longitude],@"longitude",[NSString stringWithFormat:@"%f",current_latitude],@"latitude",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/UpdateDriverLocation",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Arrivel Notify Web Service

-(void)ArrivelNotify
{
    //Arrived/BeginTrip
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];

    [kappDelegate ShowIndicator];
    
    webservice=5;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",@"Arrived",@"Status",currentTime,@"Timestamp",@"",@"Latitude",@"",@"Longitude",@"",@"TripMilesActual",@"",@"TripTimeActual",@"",@"TripAmountActual",@"",@"Trigger",@"",@"PaymentStatus",@"",@"CancellationCharges",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    
  
    

    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/NotifyRegardingArrival",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Begin Notify Web Service

-(void)BeginNotify
{
    //Arrived/BeginTrip
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    [kappDelegate ShowIndicator];
    
    webservice=6;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",@"BeginTrip",@"Status",currentTime,@"Timestamp",@"",@"Latitude",@"",@"Longitude",@"",@"TripMilesActual",@"",@"TripTimeActual",@"",@"TripAmountActual",@"",@"Trigger",@"",@"PaymentStatus",@"",@"CancellationCharges",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);

    

    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/NotifyRegardingArrival",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Cancel Ride Request

-(void)CancelRideRequest
{
    [fiveMinTimer invalidate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    [kappDelegate ShowIndicator];
    
    webservice=9;
    
    if (timerCount<300)
    {
        CancelRideWithPay=@"NO";
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",@"cancel",@"Status",currentTime,@"Timestamp",@"",@"Latitude",@"",@"Longitude",@"",@"TripMilesActual",@"",@"TripTimeActual",@"",@"TripAmountActual",@"driver",@"Trigger",CancelRideWithPay,@"PaymentStatus",@"0",@"CancellationCharges",nil];
    }
    else{
        CancelRideWithPay=@"YES";

        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",@"cancel",@"Status",currentTime,@"Timestamp",@"",@"Latitude",@"",@"Longitude",@"",@"TripMilesActual",@"",@"TripTimeActual",@"",@"TripAmountActual",@"driver",@"Trigger",CancelRideWithPay,@"PaymentStatus",[[NSUserDefaults standardUserDefaults] valueForKey:@"CancelRideCharges"],@"CancellationCharges",nil];
    }
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
  
    
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/NotifyRegardingArrival",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Get  Driver Profile Web Service

-(void)GetDriverProfileService
{
    webservice=7;
    [self.view setUserInteractionEnabled: NO];
    [leftButton setUserInteractionEnabled:NO ];
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"UserId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetProfiles",Kwebservices]];
    [self postWebservices];
}

#pragma mark -  Get Trip Details

-(void)GetRiderTripDetails
{
    webservice=8;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
  
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDetailsByTripId",Kwebservices]];
    
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
   // [alert show];
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
    
    
     NSString *messageStr=[userDetailDict valueForKey:@"message"];
    if (webservice==1)
    {
       // [self GetRiderTripDetails];
      //  [self GetActiveTrips];
        
        
        [self FetchVehicleList];
        
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
            }
        }
    }
    else if (webservice==2)
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
                
            }
        }
    }
    else if (webservice==3)
    {
        [self SetDriverModeOn];
        
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
                
            }
        }
    }
    else if (webservice==4)
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
                
            }
        }
    }
    else if (webservice==5)
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
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Request Sent Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [AriveBtnOutlet setTitle:@"BEGIN TRIP" forState:UIControlStateNormal];
                timerCount=0;
                fiveMinTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(FiveMinCal) userInfo:nil repeats:YES];
                
            }
        }
    }
    else if (webservice==6)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
               // [self MoveToBeginTripView];

            }
            else
            {
              //  NSLog(@"%@",userDetailDict);
               // UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
              //  [alert show];
               // [self MoveToBeginTripView];
                
            }
        }
    }
    else if (webservice==7)
    {
        [self.view setUserInteractionEnabled: YES];
        [leftButton setUserInteractionEnabled:YES];
        [self RegisterDevice];

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
                
                TempDictForUser=[userDetailDict mutableCopy];
                 
                NSString *firstName=[userDetailDict valueForKey:@"firstname"];
                NSString *lastName=[userDetailDict valueForKey:@"lastname"];
                FullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
               
                driver_vehicle_type=[userDetailDict valueForKey:@"vechiletypeName"];
               
                UserNameLabel.text=FullName;
                NSString *userImageUrl=[userDetailDict valueForKey:@"image"];
              //  NSData* data = [Base64 decode:Base64Str];;
               // profileImageView.image = [UIImage imageWithData:data];
                if (![userImageUrl isEqualToString:@""])
                {
                    UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    objactivityindicator.center = CGPointMake((profileImageView.frame.size.width/2),(profileImageView.frame.size.height/2));
                    [profileImageView addSubview:objactivityindicator];
                    [objactivityindicator startAnimating];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                        NSURL *imageURL=[NSURL URLWithString:[userImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                        NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                        UIImage *imgData=[UIImage imageWithData:tempData];
                        dispatch_async(dispatch_get_main_queue(), ^
                                       {
                                           if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                           {
                                               [profileImageView setImage:imgData];
                                               [objactivityindicator stopAnimating];
                                               
                                           }
                                           else
                                           {
                                               [objactivityindicator stopAnimating];
                                               
                                           }
                                       });
                    });
                }
            }
        }
    }
    else if (webservice==8 && [messageStr isEqualToString: @"Success"])
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
                
                DestinationLat=[userDetailDict valueForKey:@"end_lat"];
                DestinationLong=[userDetailDict valueForKey:@"end_lon"];
//                Source=[userDetailDict valueForKey:@"starting_loc"];
//                Destination=[userDetailDict valueForKey:@"ending_loc"];
                
                
            }
        }
//        [mapView removeFromSuperview];
        [self viewDidLoad];
        
    }
    else if (webservice==9)
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
                [self.navigationController popViewControllerAnimated:true];
                NSLog(@"%@",userDetailDict);
                
            }
        }
        
    }
    
    else if (webservice==10)
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
                
            }
        }
        
    }
    else if (webservice==11)
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
                ActiveRidesArray=[[userDetailDict valueForKey:@"listTrips"] mutableCopy];
                [self CheckForPendingRequest];
                
            }
        }
        
    }

    else if (webservice==12)
    {
        

        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            //  NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==0)
            {
                
                NSMutableArray *vehicleZoneListAray =[[NSMutableArray alloc]init];
                
                vehicleZoneListAray=[userDetailDict valueForKey:@"ListZoneInfo"];
                
                            NSString *safetyCharges=[userDetailDict valueForKey:@"SafetyFee"];
                if ([safetyCharges isKindOfClass:[NSNull class]])
                {
                    safetyCharges=@"";
                }
                    
                    float safety=[[NSString stringWithFormat:@"%@",safetyCharges] floatValue];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%.1f",safety] forKey:@"SafetyCharges"];
                
                    if ([driver_vehicle_type isEqualToString:@"ZiraE"])
                    {
                        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                        if (vehicleZoneListAray.count>0)
                        {
                            for (int k=0; k<vehicleZoneListAray.count; k++)
                            {
                                NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                                if ([Vehicletypestr  isEqualToString:driver_vehicle_type])
                                {
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                  
                                    
                                    NSString*cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k ] valueForKey:@"CancellationFee"];
                                    if ([cancelfeeStr isKindOfClass:[NSNull class]])
                                    {
                                        cancelfeeStr=@"";
                                    }
                                    
                                    float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                                    
                                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",cancelCharge] forKey:@"CancelRideCharges"];
                                    

                                    
                                    [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                                }
                            }
                            
                        }
                        
                    }
                    else if ([driver_vehicle_type isEqualToString:@"ZiraPlus"])
                    {
                        
                        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                        if (vehicleZoneListAray.count>0)
                        {
                            for (int k=0; k<vehicleZoneListAray.count; k++)
                            {
                                NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                                if ([Vehicletypestr  isEqualToString:driver_vehicle_type])
                               {
                                    
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                    
                                   
                                   NSString*cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k ] valueForKey:@"CancellationFee"];
                                   if ([cancelfeeStr isKindOfClass:[NSNull class]])
                                   {
                                       cancelfeeStr=@"";
                                   }
                                   
                                   float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                                   
                                   [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",cancelCharge] forKey:@"CancelRideCharges"];
                                   

                                   
                                    [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                                }
                            }
                        }
                        
                    }
                    else if ([driver_vehicle_type isEqualToString:@"ZiraTaxi"])
                    {
                        // [slider setValue:100 animated:NO];
                        
                        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                        if (vehicleZoneListAray.count>0)
                        {
                            for (int k=0; k<vehicleZoneListAray.count; k++)
                            {
                                NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                                if ([Vehicletypestr  isEqualToString:driver_vehicle_type])
                              {
                                    
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                  
                                  
                                  NSString*cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k ] valueForKey:@"CancellationFee"];
                                  if ([cancelfeeStr isKindOfClass:[NSNull class]])
                                  {
                                      cancelfeeStr=@"";
                                  }
                                  
                                  float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                                  
                                  [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",cancelCharge] forKey:@"CancelRideCharges"];
                                  

                                  
                                    [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                                }
                            }
                        }
                    }
                    else if ([driver_vehicle_type isEqualToString:@"ZiraLux"])
                    {
                        // [slider setValue:100 animated:NO];
                        
                        NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                        if (vehicleZoneListAray.count>0)
                        {
                            for (int k=0; k<vehicleZoneListAray.count; k++)
                            {
                                NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                                if ([Vehicletypestr  isEqualToString:driver_vehicle_type])
                                {
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                    [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                    
                                    
                                    NSString*cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k ] valueForKey:@"CancellationFee"];
                                    if ([cancelfeeStr isKindOfClass:[NSNull class]])
                                    {
                                        cancelfeeStr=@"";
                                    }
                                    
                                    float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                                    
                                    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",cancelCharge] forKey:@"CancelRideCharges"];
                                    

                                    
                                    [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                                }
                            }
                        }
                    }

                else
                {
                      
                    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                    if (vehicleZoneListAray.count>0)
                    {
                        for (int k=0; k<vehicleZoneListAray.count; k++)
                        {
                            NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                            if ([Vehicletypestr  isEqualToString:driver_vehicle_type])
                          {
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                              
                              
                              NSString*cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k ] valueForKey:@"CancellationFee"];
                              if ([cancelfeeStr isKindOfClass:[NSNull class]])
                              {
                                  cancelfeeStr=@"";
                              }
                              
                              float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                              
                              [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",cancelCharge] forKey:@"CancelRideCharges"];
                              

                              
                                [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                            }
                        }
                    }
                }
            }
        }
        [self getActiveTrips];
        
    }
    else if (webservice==13)
    {
        timer= [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(UpdateDriverLocation) userInfo:nil repeats:YES];

        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                // [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                NSString*activeTripId=[userDetailDict valueForKey:@"tripid"];
                NSString*tripStatus=[userDetailDict valueForKey:@"tripstatus"];
                NSDictionary* TripData=[userDetailDict valueForKey:@"TripData"];
                
                if ([tripStatus isEqualToString:@"begintrip"]) {
                    TripId=activeTripId;
                   [ self moveToBeginTrip:activeTripId :TripData ];
                    return;
                }
                else if ([tripStatus isEqualToString:@"arrived"]) {
                    
                    CancelBtn.hidden=NO;
                    TripId=activeTripId;
                    AriveBtnOutlet.hidden=NO;
                    [AriveBtnOutlet setTitle:@"BEGIN TRIP" forState:UIControlStateNormal];
                    
                    riderLatitude=[[NSString stringWithFormat:@"%@",[TripData valueForKey:@"start_lat" ]]doubleValue];
                    riderLongitude=[[NSString stringWithFormat:@"%@",[TripData valueForKey:@"start_lon" ]]doubleValue];
                    Source=[TripData valueForKey:@"starting_loc"];
                    Destination=[TripData valueForKey:@"ending_loc"];
                    
                    
                    [self  ShowRiderOnMap];

                    
                    return;
                    //[mapView clear];
                }
                else if ([tripStatus isEqualToString:@"accepted"])
                {
                    TripId=activeTripId;
                    
                    NSMutableDictionary *UserInfo=[[NSMutableDictionary alloc] init];
                    [UserInfo setValue:[TripData valueForKey:@"start_lat"] forKey:@"Latitude"];
                    [UserInfo setValue:[TripData valueForKey:@"start_lon"] forKey:@"Longitude"];
                    [UserInfo setValue:[TripData valueForKey:@"starting_loc"] forKey:@"source_address"];
                    [UserInfo setValue:[TripData valueForKey:@"ending_loc"] forKey:@"destination_address"];
                    [UserInfo setValue:activeTripId forKey:@"TripId"];
                    
                    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                    [nc postNotificationName:@"refreshView" object:self userInfo:UserInfo];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DriverViewButtons"];
                    
                    AriveBtnOutlet.hidden=NO;
                CancelBtn.hidden=YES;
                  //  [self refreshView:nc];
                    
                    return;
                }
            }
        }
    }
}



-(void)FetchVehicleList
{
    //[kappDelegate ShowIndicator];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    webservice=12;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",[NSString stringWithFormat:@"%f",current_latitude],@"latitude",[NSString stringWithFormat:@"%f",current_longitude],@"longitude",@"10",@"distance",currentTime,@"currenttime",[[NSUserDefaults standardUserDefaults]valueForKey:@"preffervehicletype"],@"VechileType",nil];

    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchVehicleList",Kwebservices]];
    
    [self postWebservices];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getActiveTrips{
    webservice=13;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"UserId",nil];
    
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetLastActiveTripswithStatus",Kwebservices]];
    [self postWebservices];
}


-(void)moveToBeginTrip :(NSString*) tripId :(NSDictionary*) tripData

{
    // NSString *str=@"YES";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize results = [[UIScreen mainScreen] bounds].size;
        if(results.height == 480)
        {
            //[self DisableView];
          
            BeginTripViewController *BeginTripView=[[BeginTripViewController alloc]initWithNibName:@"" bundle:nil];
            BeginTripView.ComingFromNotification=@"NO";
            BeginTripView.TripId=tripId;
            NSString* DestinationLatStr=[tripData valueForKey:@"end_lat"];
            NSString* DestinationLongStr=[tripData valueForKey:@"end_lon"];
            NSString*DestinationAddress=[tripData valueForKey:@"ending_loc"];
            
            BeginTripView.DestinationLat=DestinationLatStr;
            BeginTripView.DestinationLong=DestinationLongStr;
            BeginTripView.DestinationAddress=DestinationAddress;
            
            [self.navigationController pushViewController:BeginTripView animated:YES];
        }
        else
        {
            //[self DisableView];
            BeginTripViewController *BeginTripView=[[BeginTripViewController alloc]initWithNibName:@"BeginTripViewController" bundle:nil];
            BeginTripView.ComingFromNotification=@"NO";
            BeginTripView.TripId=tripId;
            NSString* DestinationLatStr=[tripData valueForKey:@"end_lat"];
            NSString* DestinationLongStr=[tripData valueForKey:@"end_lon"];
            NSString*DestinationAddress=[tripData valueForKey:@"ending_loc"];
            
            BeginTripView.DestinationLat=DestinationLatStr;
            BeginTripView.DestinationLong=DestinationLongStr;
            BeginTripView.DestinationAddress=DestinationAddress;
            [self.navigationController pushViewController:BeginTripView animated:YES];
        }
    }
}

-(void)FiveMinCal
{
    timerCount=timerCount+1;
    if (timerCount==300)
    {
        [fiveMinTimer invalidate];
    }
}





@end
