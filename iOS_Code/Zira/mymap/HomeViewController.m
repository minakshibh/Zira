 //
//  HomeViewController.m
//  ZiraApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//

#import "HomeViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "RegisterViewViewController.h"
#import "SelectSourceViewController.h"
#import "Base64.h"
#import "DriverMapViewController.h"
#import "DriverRegister1ViewController.h"
#import "FareEstimateViewController.h"
#import "PaypalViewController.h"
#import "RatingViewController.h"
#import "EditDriverProfileViewController.h"
#import "DriverInfoViewController.h"
#import "SupportViewController.h"
#import "PromotionViewController.h"
#import "BeginTripViewController.h"
#import "ShareViewController.h"

RegisterViewViewController * RegisterViewObj;
SelectSourceViewController *SelectSourceViewObj;
PromoCodeViewController    *PromoCodeViewObj;
CreditCardsSelectViewController *CreditCardSelectView;
DriverMapViewController * DriverMapViewObj;
DriverRegister1ViewController *DriverRegister1ViewObj;
FareEstimateViewController    *FareEstimateViewObj;
EditDriverProfileViewController *EditDriverProfileView;
DriverInfoViewController       *DriverInfoViewObj;
SupportViewController          *SupportViewObj;
PromotionViewController         *PromotionViewObj;
BeginTripViewController       *BeginTripViewObj;
ShareViewController           *ShareViewObj;


@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize current_latitude,current_longitude,audioPlayer,FullName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        flag=0;
        flag1=0;
        TempDictForUser=[[NSMutableArray alloc] init];
        vehicleListArray=[[NSMutableArray alloc] init];
        vehicleZoneListAray=[[NSMutableArray alloc] init];

    }
    return self;
}

#pragma mark - View Life Cycle
-(void)logout
{
    [kappDelegate ShowIndicator];
     jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"asd@asd.com",@"useremail",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Logout",Kwebservices]];
    
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
- (void)viewDidLoad
{
//    [self logout];
    if (VechTypeForRide.length==0)
    {
        VechTypeForRide=@"ZiraE";
        [xbtn setImage:[UIImage imageNamed:@"1hover.png"] forState:UIControlStateNormal];
        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
    }
//    NSString *path = [NSString stringWithFormat:@"%@/newsound.wav", [[NSBundle mainBundle] resourcePath]];
//    NSURL *soundUrl = [NSURL fileURLWithPath:path];
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
//    [audioPlayer play];

    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

    alertFlag=0;
    
  //  VechTypeView.hidden=NO;
    VechTypeView.layer.cornerRadius=5;
    slider.backgroundColor=[UIColor clearColor];
    //[slider setThumbImage:[UIImage imageNamed:@"header_user_icon.png"] forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"sliderthumb.png"]
                                forState:UIControlStateNormal];

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"MODE"] isEqualToString:@"DRIVER"])
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverMode"] isEqualToString:@"True"])
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height == 480)
                {
                    DriverMapViewObj=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController_iphone4" bundle:nil];
                }
                else
                {
                    DriverMapViewObj=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController" bundle:nil];
                }
                [self.navigationController pushViewController:DriverMapViewObj animated:NO];
            }
        }
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"View"] isEqualToString:@"Paypal"])
    {
        [self MoveToPayPalView];
    }
    
    MapStatus=@"ShowMap";
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.cornerRadius=35;


    PinView.hidden=YES;
    
   // self.title=@"Zira 24/7";
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
    RequestPickUpView.hidden=YES;
    DestinationBtnOutlet.hidden=YES;
    DestinationLabel.hidden=YES;
    Destination_SearchBox.hidden=YES;
    DropLocation.hidden = YES;
    CrossBtnOutlet.hidden=YES;
    self.navigationItem.hidesBackButton = YES;

//    // Right Bar Button Item //
//    
//    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    RightButton.frame = CGRectMake(0, 0, 60, 40);
//    [RightButton setTitle:@"Rating" forState:UIControlStateNormal];
//    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
//    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
//    [RightButton addTarget:self action:@selector(LogoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
//    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
//                 ////
    
    // Left Bar Button Item //
    
    
                  ////

    //Get current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //[self.locationManager requestWhenInUseAuthorization];
       // [self.locationManager requestAlwaysAuthorization];
    }

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;
    
    NSLog(@"%f %f",current_latitude,current_longitude);
    sleep(1);

  //  [kappDelegate ShowIndicator];
    
    [SearchSourceDestinationView setFrame:CGRectMake(27, 92, self.view.frame.size.width-54, 126)];
   
    //Get user details
    
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    // [leftButton setTitle:@"Home" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"header_user_icon.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"header_user_icon.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(HomeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",self.view.frame.size.height] forKey:@"view_height"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",self.view.frame.size.width] forKey:@"view_width"];

    
    
    //---menu button
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    // [leftButton setTitle:@"Home" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"header_user_icon.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"header_user_icon.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(HomeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:leftButton];
    
    //leftButton.userInteractionEnabled=NO;
    [HomeViewOutlet removeFromSuperview];
    [self.view addSubview:HomeViewOutlet];
    HomeViewOutlet.hidden=YES;
    [self.view setUserInteractionEnabled:NO];
    [self GetUserProfileService];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];

    alertFlag=0;
    backGroundRefreshFlag=0;

   // RefreshVechTimer= [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"RIDER" forKey:@"MODE"];

    OnOffSwitch.on=NO;

  

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ComingFrom"] isEqualToString:@"SourceSearch"])
    {
        tempArray=[[NSMutableArray alloc] init];
        tempArray=[[NSUserDefaults standardUserDefaults] valueForKey:@"SourcePlaceDict"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SourcePlaceDict"];
        NSString *sourceText=[tempArray objectAtIndex:0];
        SourceLabel.text=sourceText;
        SourceLatitude=[[tempArray objectAtIndex:1] doubleValue];
        SourceLongitude=[[tempArray objectAtIndex:2] doubleValue];
        
       // [MapView removeFromSuperview];
        camera = [GMSCameraPosition cameraWithLatitude:SourceLatitude longitude:SourceLongitude zoom:15];
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 505) camera:camera];
            [MapView animateToCameraPosition:camera];

        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 370) camera:camera];
            [MapView animateToCameraPosition:camera];

        }
        else
        {
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 505) camera:camera];
            [MapView animateToCameraPosition:camera];

        }
        
        [self.view bringSubviewToFront:SearchSourceDestinationView];
        [MapView bringSubviewToFront:SearchSourceDestinationView];
        [self.view bringSubviewToFront:RequestPickUpView];
        [MapView bringSubviewToFront:RequestPickUpView];

        
        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(SourceLatitude ,SourceLongitude);
        marker.icon = [UIImage imageNamed:@"map_pointer.png"];
        PinView.hidden=NO;
        [self.view bringSubviewToFront:PinView];
        [MapView bringSubviewToFront:PinView];

        MapView.selectedMarker=marker;
     
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ComingFrom"] isEqualToString:@"DestinationSearch"])
    {
        tempArray=[[NSMutableArray alloc] init];
        tempArray=[[NSUserDefaults standardUserDefaults] valueForKey:@"SourcePlaceDict"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SourcePlaceDict"];
        DestinationLabel.hidden=NO;
        Destination_SearchBox.hidden=NO;
        DropLocation.hidden = NO;
        CrossBtnOutlet.hidden=NO;
        
        NSString *DestinationText=[tempArray objectAtIndex:0];
        DestinationLabel.text=DestinationText;
        DestinationLatitude=[[tempArray objectAtIndex:1] doubleValue];
        DestinationLongitude=[[tempArray objectAtIndex:2] doubleValue];
        
        //get all details from source and destination
        
        NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",SourceLatitude,SourceLongitude,DestinationLatitude,DestinationLongitude];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchData:data];
        });
    }
    [self.locationManager startUpdatingLocation];
    [self.view bringSubviewToFront:leftButton];
}

-(void)viewWillDisappear:(BOOL)animated
{
   // [RefreshVechTimer invalidate];
}

#pragma mark - Fetch all data of ride

-(void)fetchData:(NSData *)data
{
    NSError *error;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"rows"];
    NSLog(@"Data is:%@" ,results);
    
    for (int i = 0;i <[results count]; i++)
    {
        NSDictionary *result = [results objectAtIndex:i];
        NSLog(@"Data is %@", result);
        
        NSString *statusStr=[[[result objectForKey:@"elements"]valueForKey:@"status"]objectAtIndex:0];
        if ([statusStr isEqualToString:@"ZERO_RESULTS"])
        {
          //  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Invalid Request." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //[alert show];
            return;
        }
        NSString *tempdistaceStr = [[[[result objectForKey:@"elements"]valueForKey:@"distance"]valueForKey:@"text"]objectAtIndex:0];
        estimatedTimeStr = [[[[result objectForKey:@"elements"]valueForKey:@"duration"]valueForKey:@"text"]objectAtIndex:0];
        
        distanceStr =[NSString stringWithFormat:@"%@",tempdistaceStr];
        
        NSArray *distArray = [distanceStr componentsSeparatedByString:@" "];
        NSString *kmStr=[distArray objectAtIndex:1];
        distanceStr=[distanceStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        
        if([kmStr caseInsensitiveCompare:@"KM"] == NSOrderedSame)
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
        else{
           // self.estimatedTimeLbl.text=[NSString stringWithFormat:@"%@",estimatedTimeStr];
        }
    }
    
    NSMutableDictionary *PriceDetailsDict=[[NSMutableDictionary alloc] init];
    PriceDetailsDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"PriceDetails"] mutableCopy];
    
    price_per_minute=[PriceDetailsDict valueForKey:@"PriceMintue"];
    price_per_mile=[PriceDetailsDict valueForKey:@"PriceMile"];
    surgeValue=[PriceDetailsDict valueForKey:@"SurgeValue"];
    base_fare=[PriceDetailsDict valueForKey:@"BaseFare"];

    
    NSLog(@"base fare==%@",base_fare);
    NSLog(@"estTime==%@",estimatedTimeStr);
    NSLog(@"priceMinute ==%@",price_per_minute);
    NSLog(@"estDiastanc ==%f",estimatedDistance);
    NSLog(@" priceMile==%@",price_per_mile);
    NSLog(@"%f",([estimatedTimeStr intValue]*[price_per_minute floatValue]));
    NSLog(@"%f",(estimatedDistance *[price_per_mile floatValue]));
    NSLog(@"%@",[NSString stringWithFormat:@"%f",[surgeValue  floatValue]]);
    
    
    float actualPrice=[base_fare floatValue]+([estimatedTimeStr floatValue]*[price_per_minute floatValue])+(estimatedDistance *[price_per_mile floatValue]) ;
    if ([surgeValue floatValue]>0) {
        actualPrice=actualPrice*[surgeValue floatValue];
    }
    
    //NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", myFloat];
   // int NewActualPrice = (int) actualPrice;
    
    actualFare=[NSString stringWithFormat:@"%.2f",actualPrice];
    
    //Add Safety Charges Here
    if (vehicleZoneListAray.count>0)
    {
        float safetyCharges=[[[vehicleZoneListAray objectAtIndex:0] valueForKey:@"safetycharges"] floatValue];
        float totalFARE=actualPrice+safetyCharges;
        actualFare=[NSString stringWithFormat:@"%.2f",totalFARE];
  
    }

    
  //  priceLbl.text=[NSString stringWithFormat:@"$%d",NewActualPrice];
    minimumPrice =[NSString stringWithFormat:@"%.2f",actualPrice-actualPrice*20/100];
    maximumPrice =[NSString stringWithFormat:@"%.2f",actualPrice+actualPrice*500/100];
    suggestedFare=[NSString stringWithString:actualFare];
   // self.ownProceLbl.text=[NSString stringWithFormat:@"$%d",NewActualPrice];
   // [self addPickerView];
}

#pragma mark - Add Map and Show Pin

-(void)AddMapViewAndFallPin
{
    //Create Map view
    [kappDelegate HideIndicator];
    camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:15];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 505) camera:camera];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 370) camera:camera];
    }
    else
    {
        MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 525) camera:camera];
    }
    
    MapView.settings.compassButton = YES;
    MapView.settings.myLocationButton = YES;
    MapView.delegate = self;
    MapView.myLocationEnabled = YES;
    MapView.layer.borderColor = [UIColor whiteColor].CGColor;
    MapView.layer.borderWidth = 1.5;
    MapView.layer.cornerRadius = 5.0;
    [MapView setClipsToBounds:YES];
    [self.view addSubview:MapView];
    
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude);
    marker.icon = [UIImage imageNamed:@"map_pointer.png"];
    // marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
   // marker.map = MapView;
    MapView.selectedMarker=marker;
    PinView.hidden=NO;
    
    [self.view bringSubviewToFront:PinView];
    [MapView bringSubviewToFront:PinView];
    [self.view bringSubviewToFront:SearchSourceDestinationView];
    [MapView bringSubviewToFront:SearchSourceDestinationView];
    [self.view bringSubviewToFront:RequestPickUpView];
    [MapView bringSubviewToFront:RequestPickUpView];
    [self.view bringSubviewToFront:VechTypeView];
    [MapView bringSubviewToFront:VechTypeView];

}
#pragma mark - Update Location On Map

-(void)UpdateLocationOnMap
{
    [MapView removeFromSuperview];
    camera = [GMSCameraPosition cameraWithLatitude:current_latitude longitude:current_longitude zoom:15];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 505) camera:camera];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 370) camera:camera];
    }
    else
    {
        MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 505) camera:camera];
    }
    MapView.settings.compassButton = YES;
    MapView.settings.myLocationButton = YES;
    MapView.delegate = self;
    MapView.myLocationEnabled = YES;
    MapView.layer.borderColor = [UIColor whiteColor].CGColor;
    MapView.layer.borderWidth = 1.5;
    MapView.layer.cornerRadius = 5.0;
    [MapView setClipsToBounds:YES];
    [self.view addSubview:MapView];
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(current_latitude ,current_longitude);
    marker.icon = [UIImage imageNamed:@"map_pointer.png"];
    PinView.hidden=NO;
    [self.view bringSubviewToFront:PinView];

    [MapView bringSubviewToFront:PinView];


    // marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
   // marker.map = MapView;
    MapView.selectedMarker=marker;
    
    
    [self.view bringSubviewToFront:SearchSourceDestinationView];
    [MapView bringSubviewToFront:SearchSourceDestinationView];
    [self.view bringSubviewToFront:RequestPickUpView];
    [MapView bringSubviewToFront:RequestPickUpView];
    
    [self FetchVehicleList];
   
}

- (void)didTapAdd
{
    if (marker.map == nil)
    {
        marker.map = (GMSMapView *)self.view;
    }
    else
    {
        marker.map = nil;
    }
    
    marker.map = nil;
    marker = [[GMSMarker alloc] init];
    marker.title = @"Melbourne";
    
    marker.snippet = @"Population: 4,169,103";
    marker.position = CLLocationCoordinate2DMake(-37.81969, 144.966085);
    marker.map = (GMSMapView *)self.view;
}

#pragma mark - Home Button Action

-(IBAction)HomeButtonAction:(id)sender
{
       // [kappDelegate ShowIndicator];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
    [self.view bringSubviewToFront:HomeViewOutlet];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [HomeViewOutlet setFrame:CGRectMake(0, 64, 250, 460)];

        }
        else
        {
            [HomeViewOutlet setFrame:CGRectMake(0, 64, 250, self.view.frame.size.height-64)];

        }
    }
    
    if (![self.view.subviews containsObject:HomeViewOutlet])
    {
//       [self.view addSubview:HomeViewOutlet];
//       HomeViewOutlet.hidden=YES;

    }
      //  self.navigationController.navigationBar.hidden=YES;
        //[kappDelegate ShowIndicator];
//        [self GetUserProfileService];

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

#pragma mark - Remove Home View Button Action

- (IBAction)RemoveHomeView:(id)sender
{
    self.navigationController.navigationBar.hidden=NO;
    [HomeViewOutlet removeFromSuperview];
}

#pragma mark - Setting Button Action

- (IBAction)SettingButtonAction:(id)sender
{
    alertFlag=2;
    [self HideShowSlider];
    [self EditDriverProfileView];
}

#pragma mark - Source Button Action

- (IBAction)SourceButtonAction:(id)sender
{
    alertFlag=2;

    [[NSUserDefaults standardUserDefaults] setValue:@"Source" forKey:@"SearchFor"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
        }
        else
        {
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
        }
        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:SelectSourceViewObj];
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
        }];
    }
}

#pragma mark - Select Destination Button Action

- (IBAction)SelectDestinationButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Destination" forKey:@"SearchFor"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
        }
        else
        {
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
        }
        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:SelectSourceViewObj];
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
        }];
    }
}

#pragma mark - Cross Button Action

- (IBAction)CrossButtonAction:(id)sender
{
    DestinationLatitude=0.00;;
    DestinationLongitude=0.00;
    DestinationLabel.text=@"";
    DestinationLabel.hidden=YES;
    Destination_SearchBox.hidden=YES;
    DropLocation.hidden = YES;
    CrossBtnOutlet.hidden=YES;
}

#pragma mark - Request Pick Up Button Action

- (IBAction)RequestPickupButtonAction:(id)sender
{
    if ([SourceLabel.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Start Location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([DestinationLabel.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select End Location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if (vehicleListArray.count>0)
    {
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No Vechicle is available in this region" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   
    [self RequestToDriver];
}

#pragma mark - Window Marker Button Action

- (IBAction)MrkerWindowButtonAction:(id)sender
{
    //VechTypeView.hidden=YES;
    NSLog(@"yes"); // And now this should work.
   // windowBtn=@"Pressed";
    [SearchSourceDestinationView setFrame:CGRectMake(15, 92, self.view.frame.size.width-30, 126)];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ComingFrom"] isEqualToString:@"SourceSearch"])
    {
       // [MapView removeFromSuperview];
        camera = [GMSCameraPosition cameraWithLatitude:SourceLatitude longitude:SourceLongitude zoom:17];
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 505) camera:camera];
            [MapView animateToCameraPosition:camera];

        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 370) camera:camera];
            [MapView animateToCameraPosition:camera];
        }
        else
        {
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 505) camera:camera];
            [MapView animateToCameraPosition:camera];
        }
      //  MapView.settings.compassButton = YES;
       // MapView.settings.myLocationButton = YES;
      //  MapView.delegate = self;
      //  MapView.myLocationEnabled = YES;
       // MapView.layer.borderColor = [UIColor whiteColor].CGColor;
      //  MapView.layer.borderWidth = 1.5;
       // MapView.layer.cornerRadius = 5.0;
        
      //  [MapView setClipsToBounds:YES];
       // [self.view addSubview:MapView];
        [self.view bringSubviewToFront:SearchSourceDestinationView];
        [MapView bringSubviewToFront:SearchSourceDestinationView];
        
        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(SourceLatitude ,SourceLongitude);
        // marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        marker.icon = [UIImage imageNamed:@"map_pointer.png"];
        PinView.hidden=NO;
        
        [self.view bringSubviewToFront:PinView];
        [MapView bringSubviewToFront:PinView];
        
        //marker.map = MapView;
        
        MapView.selectedMarker=marker;
        DestinationBtnOutlet.hidden=NO;
        
        [self.view bringSubviewToFront:RequestPickUpView];
        [MapView bringSubviewToFront:RequestPickUpView];
        RequestPickUpView.hidden=NO;
       // [self ShowVechiclesOnMap];
        // Left Bar Button Item //
        leftButton.hidden=YES;
        UIButton* leftCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftCancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        leftCancelButton.frame = CGRectMake(0, 0, 60, 40);
        [leftCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [leftCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
        [leftCancelButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftCancelButton];
        self.navigationItem.leftBarButtonItem = LeftBarButtonItem;
        
        ////
    }
    else
    {
      //  [MapView removeFromSuperview];
        camera = [GMSCameraPosition cameraWithLatitude:CameraLatitude longitude:CameraLongitude zoom:17];
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:0.2f] forKey:kCATransactionAnimationDuration];
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            //MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 505) camera:camera];
            [MapView animateToCameraPosition:camera];

        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 370) camera:camera];
            [MapView animateToCameraPosition:camera];

        }
        else
        {
           // MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, 320, 505) camera:camera];
            [MapView animateToCameraPosition:camera];

        }
        [CATransaction commit];

       // MapView.settings.compassButton = YES;
       // MapView.settings.myLocationButton = YES;
       // MapView.delegate = self;
      //  MapView.myLocationEnabled = YES;
      //  MapView.layer.borderColor = [UIColor whiteColor].CGColor;
       // MapView.layer.borderWidth = 1.5;
        
      //  MapView.layer.cornerRadius = 5.0;
        
      //  [MapView setClipsToBounds:YES];
      //  [self.view addSubview:MapView];
        [self.view bringSubviewToFront:SearchSourceDestinationView];
        [MapView bringSubviewToFront:SearchSourceDestinationView];
        
        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(CameraLatitude ,CameraLongitude);
        // marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        marker.icon = [UIImage imageNamed:@"map_pointer.png"];
        PinView.hidden=NO;
        
        [self.view bringSubviewToFront:PinView];
        [MapView bringSubviewToFront:PinView];
        
        //marker.map = MapView;
        
        MapView.selectedMarker=marker;
        DestinationBtnOutlet.hidden=NO;
        
        [self.view bringSubviewToFront:RequestPickUpView];
        [MapView bringSubviewToFront:RequestPickUpView];
        RequestPickUpView.hidden=NO;
        // [self ShowVechiclesOnMap];
        // Left Bar Button Item //
        leftButton.hidden=YES;
        UIButton* leftCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftCancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        leftCancelButton.frame = CGRectMake(0, 0, 60, 40);
        [leftCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [leftCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
        [leftCancelButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftCancelButton];
        self.navigationItem.leftBarButtonItem = LeftBarButtonItem;
        
        SourceLabel.text=currntFulAdress;

        ////
    }
    
}

#pragma mark - Promo Code Button Action

- (IBAction)PromoCodeButtonAction:(id)sender
{
    alertFlag=2;

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PromoCodeViewObj= [[PromoCodeViewController alloc] init];
        }
        else
        {
            PromoCodeViewObj= [[PromoCodeViewController alloc] init];
        }
        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:PromoCodeViewObj];
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
        }];
    }
}

#pragma mark - Change Credit Card Button Action

- (IBAction)ChangeCreditCardBtnAction:(id)sender
{
    alertFlag=2;

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            CreditCardSelectView= [[CreditCardsSelectViewController alloc] init];
        }
        else
        {
            CreditCardSelectView= [[CreditCardsSelectViewController alloc] init];
        }
        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:CreditCardSelectView];
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
        }];
    }
}

#pragma mark - On Off Switch Button Action

- (IBAction)OnAndOffSwitch:(id)sender
{
    if (OnOffSwitch.on==NO)
    {
        
    }
    else
    {
        [self HideShowSlider];
        
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverMode"] isEqualToString:@"True"])
        {
            if ([[TempDictForUser valueForKey:@"vehicle_status"] integerValue]==1)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Your Vechicle is Not Conformed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                OnOffSwitch.on=NO;
                return;
            }
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"RemoveNotifView"
             object:self];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                [RefreshVechTimer invalidate];
                [Timer invalidate];
                [RefreshVechTimer1 invalidate];
                [Timer1 invalidate];
                
                
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height == 480)
                {
                    DriverMapViewObj=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController_iphone4" bundle:nil];
  
                }
                else
                {
                    DriverMapViewObj=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController" bundle:nil];
                }
             
                [self.navigationController pushViewController:DriverMapViewObj animated:YES];
            }
            
        }
        else
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height == 480)
                {
                    DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil
                                            ];
                }
                else
                {
                    DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil];
                }
                [RefreshVechTimer invalidate];
                [Timer invalidate];
                [RefreshVechTimer1 invalidate];
                [Timer1 invalidate];
                [self.navigationController pushViewController:DriverRegister1ViewObj animated:YES];
            }
        }
    }
}

#pragma mark - Slider Value Changed Button Action

- (IBAction)SliderValueChanged:(id)sender
{
    NSInteger sliderValue=slider.value;
    NSLog(@"%ld",(long)sliderValue);
    //[_slider setValue:0.9 animated:YES];
    if (sliderValue<50)
    {
      [slider setValue:0 animated:YES];
        VechTypeForRide=@"ZiraE";
    }
    else if (sliderValue>0&&sliderValue<100)
    {
        [slider setValue:50 animated:YES];
        VechTypeForRide=@"ZiraPlus";
    }
    else if (sliderValue>50)
    {
        [slider setValue:100 animated:YES];
        VechTypeForRide=@"ZiraTaxi";
    }
}

#pragma mark - X Button Action

- (IBAction)XButton:(id)sender
{
    VechTypeForRide=@"ZiraE";
    [xbtn setImage:[UIImage imageNamed:@"1hover.png"] forState:UIControlStateNormal];
    [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];

    if (vehicleZoneListAray.count>0)
    {
        for (int k=0; k<vehicleZoneListAray.count; k++)
        {
            if ( k==0)
            {
                XCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];

                NSString *XPriceMintue=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"];
                XPriceMintue=[XPriceMintue substringToIndex:2];

                NSString *XPriceMile=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"];
                XPriceMile=[XPriceMile substringToIndex:2];
                    
                NSString *XBaseFare=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"];
                XBaseFare=[XBaseFare substringToIndex:2];
                
                NSString *NewminFare=[[NSUserDefaults standardUserDefaults]valueForKey:@"SafetyCharges"];
                   //  NSString *fareStr=[[NSUserDefaults standardUserDefaults]valueForKey:@"CancelRideCharges"];
                    
                NSString *cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"CancellationFee"];
               
                if ([cancelfeeStr isKindOfClass:[NSNull class]])
                {
                    cancelfeeStr=@"";
                }
                float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                NSString *fareStr=[NSString stringWithFormat:@"$%.1f",cancelCharge];
                    
//              float MinFare=[[NSString stringWithFormat:@"%@",MinFareForZiraX] floatValue];
//               NSString *NewminFare=[NSString stringWithFormat:@"%.1f",MinFare];
                    
                    
                minFare.text=[NSString stringWithFormat:@"$%@",NewminFare];
                CancelRideLbl.text=[NSString stringWithFormat:@"%@",fareStr];

                [self.view addSubview:checkFareView];
                [self.view addSubview:checkFareFrontView];
                    
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    if(result.height == 480)
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 200)];
                    }
                    else
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 250)];
                    }
                }
                
                [self.view bringSubviewToFront:checkFareFrontView];
                [MapView bringSubviewToFront:checkFareFrontView];
                [checkFareView bringSubviewToFront:checkFareFrontView];
                    
                checkFareFrontView.layer.cornerRadius=6.0;
                checkFareView.alpha=0.7;
                    
                //set values to labels
                    
                NSString *time=TimeArivelLbl.text;
                if ([TimeArivelLbl.text isEqualToString:@""])
                {
                    etalabel.text=@"-";
                }
                else
                {
                    etalabel.text=time;
                }
                float priceMin=[XPriceMintue floatValue];
                float priceMile=[XPriceMile floatValue];
                float priceBase=[XBaseFare floatValue];
                float carPeople=[XCarPeoples floatValue];

                mintFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMin,@"/MIN"];
                mileFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMile,@"/Mile"];
                baseFare.text=[NSString stringWithFormat:@"$%.2f %@",priceBase,@"BASE FARE"];
                maxFare.text=[NSString stringWithFormat:@"$%.2f %@",carPeople,@"PPL"];
            }
        }
    }
        
    [RefreshVechTimer1 invalidate];
    [Timer1 invalidate];
    RefreshVechTimer1= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(UpdateVechicleOnMapInBackground) userInfo:nil repeats:YES];
    
    Timer1= [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:NO];
  
}

#pragma mark - Plus Button Action

- (IBAction)PlusButton:(id)sender
{
    VechTypeForRide=@"ZiraPlus";
    [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [plusbtn setImage:[UIImage imageNamed:@"2hover.png"] forState:UIControlStateNormal];
    [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];

    if (vehicleZoneListAray.count>0)
    {
        for (int k=0; k<vehicleZoneListAray.count; k++)
        {
            if ( k==1)
            {
                XCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                
                NSString *XPriceMintue=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"];
                XPriceMintue=[XPriceMintue substringToIndex:2];
                
                NSString *XPriceMile=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"];
                XPriceMile=[XPriceMile substringToIndex:2];
                
                NSString *XBaseFare=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"];
                XBaseFare=[XBaseFare substringToIndex:2];
                
                
                
                NSString *NewminFare=[[NSUserDefaults standardUserDefaults]valueForKey:@"SafetyCharges"];
           //     NSString *fareStr=[[NSUserDefaults standardUserDefaults]valueForKey:@"CancelRideCharges"];
                
                NSString *cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"CancellationFee"];
                
                if ([cancelfeeStr isKindOfClass:[NSNull class]])
                {
                    cancelfeeStr=@"";
                }
                float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                
                
                NSString *fareStr=[NSString stringWithFormat:@"%.1f",cancelCharge];


                //                    float CancelCharges=[[[vehicleZoneListAray objectAtIndex:0] valueForKey:@"cancellationcharges"] floatValue];
                //                    NSString *fareStr=[NSString stringWithFormat:@"%.1f",CancelCharges];
                
                //                    float MinFare=[[NSString stringWithFormat:@"%@",MinFareForZiraX] floatValue];
                //                    NSString *NewminFare=[NSString stringWithFormat:@"%.1f",MinFare];
                
                
                minFare.text=[NSString stringWithFormat:@"$%@",NewminFare];
                CancelRideLbl.text=[NSString stringWithFormat:@"$%@",fareStr];
                
                
                [self.view addSubview:checkFareView];
                [self.view addSubview:checkFareFrontView];
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    if(result.height == 480)
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 200)];
                    }
                    else
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 250)];
                    }
                    
                }
                
                
                [self.view bringSubviewToFront:checkFareFrontView];
                [MapView bringSubviewToFront:checkFareFrontView];
                [checkFareView bringSubviewToFront:checkFareFrontView];
                
                
                checkFareFrontView.layer.cornerRadius=6.0;
                checkFareView.alpha=0.7;
                
                //set values to labels
                
                NSString *time=TimeArivelLbl.text;
                if ([TimeArivelLbl.text isEqualToString:@""])
                {
                    etalabel.text=@"-";
                }
                else
                {
                    etalabel.text=time;
                }
                
                float priceMin=[XPriceMintue floatValue];
                float priceMile=[XPriceMile floatValue];
                float priceBase=[XBaseFare floatValue];
                float carPeople=[XCarPeoples floatValue];
                
                mintFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMin,@"/MIN"];
                mileFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMile,@"/Mile"];
                baseFare.text=[NSString stringWithFormat:@"$%.2f %@",priceBase,@"BASE FARE"];
                maxFare.text=[NSString stringWithFormat:@"$%.2f %@",carPeople,@"PPL"];
            }
        }
    }
    
    [RefreshVechTimer1 invalidate];
    [Timer1 invalidate];
    RefreshVechTimer1= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(UpdateVechicleOnMapInBackground) userInfo:nil repeats:YES];
    
    Timer1= [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:NO];
}

#pragma mark - XUV Button Action

- (IBAction)SUVButton:(id)sender
{
    VechTypeForRide=@"ZiraTaxi";
    
    [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [suvbtn setImage:[UIImage imageNamed:@"3hover.png"] forState:UIControlStateNormal];
    [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];

    
    if (vehicleZoneListAray.count>0)
    {
        for (int k=0; k<vehicleZoneListAray.count; k++)
        {
            if ( k==2)
            {
                XCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                
                NSString *XPriceMintue=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"];
                XPriceMintue=[XPriceMintue substringToIndex:2];
                
                NSString *XPriceMile=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"];
                XPriceMile=[XPriceMile substringToIndex:2];
                
                NSString *XBaseFare=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"];
                XBaseFare=[XBaseFare substringToIndex:2];
                
                NSString *NewminFare=[[NSUserDefaults standardUserDefaults]valueForKey:@"SafetyCharges"];
           //     NSString *fareStr=[[NSUserDefaults standardUserDefaults]valueForKey:@"CancelRideCharges"];
                NSString *cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"CancellationFee"];
                
                if ([cancelfeeStr isKindOfClass:[NSNull class]])
                {
                    cancelfeeStr=@"";
                }
                float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                NSString *fareStr=[NSString stringWithFormat:@"$%.1f",cancelCharge];


                
                //                    float CancelCharges=[[[vehicleZoneListAray objectAtIndex:0] valueForKey:@"cancellationcharges"] floatValue];
                //                    NSString *fareStr=[NSString stringWithFormat:@"%.1f",CancelCharges];
                
                //                    float MinFare=[[NSString stringWithFormat:@"%@",MinFareForZiraX] floatValue];
                //                    NSString *NewminFare=[NSString stringWithFormat:@"%.1f",MinFare];
                
                
                minFare.text=[NSString stringWithFormat:@"$%@",NewminFare];
                CancelRideLbl.text=[NSString stringWithFormat:@"%@",fareStr];
                
                [self.view addSubview:checkFareView];
                [self.view addSubview:checkFareFrontView];
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    if(result.height == 480)
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 200)];
                    }
                    else
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 250)];
                    }
                }
                
                [self.view bringSubviewToFront:checkFareFrontView];
                [MapView bringSubviewToFront:checkFareFrontView];
                [checkFareView bringSubviewToFront:checkFareFrontView];
                
                checkFareFrontView.layer.cornerRadius=6.0;
                checkFareView.alpha=0.7;
                
                //set values to labels
                
                NSString *time=TimeArivelLbl.text;
                if ([TimeArivelLbl.text isEqualToString:@""])
                {
                    etalabel.text=@"-";
                }
                else
                {
                    etalabel.text=time;
                }
                float priceMin=[XPriceMintue floatValue];
                float priceMile=[XPriceMile floatValue];
                float priceBase=[XBaseFare floatValue];
                float carPeople=[XCarPeoples floatValue];
                
                mintFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMin,@"/MIN"];
                mileFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMile,@"/Mile"];
                baseFare.text=[NSString stringWithFormat:@"$%.2f %@",priceBase,@"BASE FARE"];
                maxFare.text=[NSString stringWithFormat:@"$%.2f %@",carPeople,@"PPL"];
            }
        }
    }
    [RefreshVechTimer1 invalidate];
    [Timer1 invalidate];
    RefreshVechTimer1= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(UpdateVechicleOnMapInBackground) userInfo:nil repeats:YES];
    
    Timer1= [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:NO];

}
#pragma mark - Luxory Button Action

- (IBAction)ZiraLuxBtnAction:(id)sender
{
    VechTypeForRide=@"ZiraLux";
    
    [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [LuxBtn setImage:[UIImage imageNamed:@"4hover.png"] forState:UIControlStateNormal];
    

    if (vehicleZoneListAray.count>0)
    {
        for (int k=0; k<vehicleZoneListAray.count; k++)
        {
            if ( k==3)
            {
                XCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                
                NSString *XPriceMintue=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"];
                XPriceMintue=[XPriceMintue substringToIndex:2];
                
                NSString *XPriceMile=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"];
                XPriceMile=[XPriceMile substringToIndex:2];
                
                NSString *XBaseFare=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"];
                XBaseFare=[XBaseFare substringToIndex:2];
                
                
                
                NSString *NewminFare=[[NSUserDefaults standardUserDefaults]valueForKey:@"SafetyCharges"];
              //  NSString *fareStr=[[NSUserDefaults standardUserDefaults]valueForKey:@"CancelRideCharges"];
                
                NSString *cancelfeeStr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"CancellationFee"];
                
                if ([cancelfeeStr isKindOfClass:[NSNull class]])
                {
                    cancelfeeStr=@"";
                }
                float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                NSString *fareStr=[NSString stringWithFormat:@"$%.1f",cancelCharge];

                minFare.text=[NSString stringWithFormat:@"$%@",NewminFare];
                CancelRideLbl.text=[NSString stringWithFormat:@"%@",fareStr];
                
                
                [self.view addSubview:checkFareView];
                [self.view addSubview:checkFareFrontView];
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                {
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    if(result.height == 480)
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 160, self.view.frame.size.width-20, 200)];
                    }
                    else
                    {
                        [checkFareFrontView setFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 250)];
                    }
                }
                
                
                [self.view bringSubviewToFront:checkFareFrontView];
                [MapView bringSubviewToFront:checkFareFrontView];
                [checkFareView bringSubviewToFront:checkFareFrontView];
                
                
                checkFareFrontView.layer.cornerRadius=6.0;
                checkFareView.alpha=0.7;
                
                //set values to labels
                
                NSString *time=TimeArivelLbl.text;
                if ([TimeArivelLbl.text isEqualToString:@""])
                {
                    etalabel.text=@"-";
                }
                else
                {
                    etalabel.text=time;
                }
                
                float priceMin=[XPriceMintue floatValue];
                float priceMile=[XPriceMile floatValue];
                float priceBase=[XBaseFare floatValue];
                float carPeople=[XCarPeoples floatValue];
                
                mintFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMin,@"/MIN"];
                mileFare.text=[NSString stringWithFormat:@"$%.2f%@",priceMile,@"/Mile"];
                baseFare.text=[NSString stringWithFormat:@"$%.2f %@",priceBase,@"BASE FARE"];
                maxFare.text=[NSString stringWithFormat:@"$%.2f %@",carPeople,@"PPL"];
                
            }
        }
    }
    
    [RefreshVechTimer1 invalidate];
    [Timer1 invalidate];
    RefreshVechTimer1= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(UpdateVechicleOnMapInBackground) userInfo:nil repeats:YES];
    
    Timer1= [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:NO];
}

#pragma mark - Get Zira Button Action

- (IBAction)getZiraActionBtn:(id)sender
{
    
     [self HideShowSlider];
}

#pragma mark - Share Button Action

- (IBAction)shareBtnAction:(id)sender
{
    [self HideShowSlider];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            ShareViewObj=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
            [self.navigationController pushViewController:ShareViewObj animated:YES];
        }
        else
        {
            ShareViewObj=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
            [self.navigationController pushViewController:ShareViewObj animated:YES];
        }
    }
}

#pragma mark - Check fare Button Action

- (IBAction)CheckFareBtnAction:(id)sender
{
    [checkFareView removeFromSuperview];
    [checkFareFrontView removeFromSuperview];
}

#pragma mark - Payment Button Action

- (IBAction)PaymentButton:(id)sender
{
    alertFlag=2;
    [[NSUserDefaults standardUserDefaults] setValue:@"hidee" forKey:@"CrossBtn"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            CreditCardSelectView=[[CreditCardsSelectViewController alloc]initWithNibName:@"CreditCardsSelectViewController" bundle:nil];
            [self.navigationController pushViewController:CreditCardSelectView animated:YES];

        }
        else
        {
            CreditCardSelectView=[[CreditCardsSelectViewController alloc]initWithNibName:@"CreditCardsSelectViewController" bundle:nil];
            [self.navigationController pushViewController:CreditCardSelectView animated:YES];
        }
    }
}

#pragma mark - Get Zira Button Action

- (IBAction)GetZiraBtn:(id)sender
{
    [self HideShowSlider];
}

#pragma mark - Support Button Action

- (IBAction)SupportBtnAction:(id)sender
{
    alertFlag=2;
    [self MoveToSupportView];
}

#pragma mark - Promotion Button Action

- (IBAction)PromotionButtonAction:(id)sender
{
    alertFlag=2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PromoCodeViewObj=[[PromoCodeViewController alloc]initWithNibName:@"PromoCodeViewController" bundle:nil];
        }
        else
        {
            PromoCodeViewObj=[[PromoCodeViewController alloc]initWithNibName:@"PromoCodeViewController" bundle:nil];
        }
        PromoCodeViewObj.comingFrom=@"Slider";
        [self.navigationController pushViewController:PromoCodeViewObj animated:YES];

    }
   // [self MoveToPromotionView];
}



#pragma mark - Fare Estimate Button Action

- (IBAction)FareEstimateButtonAction:(id)sender
{
    alertFlag=2;

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
    
    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
    [tempDict setValue:SourceLabel.text forKey:@"SourceText"];
    [tempDict setValue:DestinationLabel.text forKey:@"DestinationText"];
    [tempDict setValue:[NSString stringWithFormat:@"%f",SourceLatitude] forKey:@"SourceLat"];
    [tempDict setValue:[NSString stringWithFormat:@"%f",SourceLongitude] forKey:@"SourceLong"];
    [tempDict setValue:[NSString stringWithFormat:@"%f",DestinationLatitude] forKey:@"DestLat"];
    [tempDict setValue:[NSString stringWithFormat:@"%f",DestinationLongitude] forKey:@"DestLong"];
    
    [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"FareDetails"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            FareEstimateViewObj= [[FareEstimateViewController alloc] init];
        }
        else
        {
            FareEstimateViewObj= [[FareEstimateViewController alloc] init];
        }
        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:FareEstimateViewObj];
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
        }];
    }
}



#pragma mark - Move to Register View

-(void)MoveToRegisterView
{
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
        [self.navigationController pushViewController:RegisterViewObj animated:YES];
    }
}
#pragma mark - Edit Driver Profile View

-(void)EditDriverProfileView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self.locationManager stopUpdatingLocation];
        [RefreshVechTimer invalidate];
        [Timer invalidate];
        [RefreshVechTimer1 invalidate];
        [Timer1 invalidate];

        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            EditDriverProfileView=[[EditDriverProfileViewController alloc]initWithNibName:@"EditDriverProfileViewController" bundle:nil];
        }
        else
        {
            EditDriverProfileView=[[EditDriverProfileViewController alloc]initWithNibName:@"EditDriverProfileViewController" bundle:nil];
        }
        EditDriverProfileView.UserRecordArray=TempDictForUser;
        [self.navigationController pushViewController:EditDriverProfileView animated:YES];
    }
}
#pragma mark - Driver Info View

-(void)DriverInfoView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverInfoViewObj=[[DriverInfoViewController alloc]initWithNibName:@"DriverInfoViewController" bundle:nil];
        }
        else
        {
            DriverInfoViewObj=[[DriverInfoViewController alloc]initWithNibName:@"DriverInfoViewController" bundle:nil];
        }
        [self.navigationController pushViewController:DriverInfoViewObj animated:YES];
    }
}

#pragma mark - Support  View

-(void)MoveToSupportView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            SupportViewObj=[[SupportViewController alloc]initWithNibName:@"SupportViewController" bundle:nil];
        }
        else
        {
            SupportViewObj=[[SupportViewController alloc]initWithNibName:@"SupportViewController" bundle:nil];
        }
        [self.navigationController pushViewController:SupportViewObj animated:YES];
    }
}

#pragma mark - Promotion  View

-(void)MoveToPromotionView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PromotionViewObj=[[PromotionViewController alloc]initWithNibName:@"PromotionViewController" bundle:[NSBundle mainBundle]];
        }
        else
        {
            PromotionViewObj=[[PromotionViewController alloc]initWithNibName:@"PromotionViewController" bundle:[NSBundle mainBundle]];
        }
        [self.navigationController pushViewController:PromotionViewObj animated:YES];
    }
}


#pragma mark - Logout Button Action

-(IBAction)LogoutButtonAction:(id)sender
{
   // [[NSUserDefaults standardUserDefaults] setValue:@"Logout" forKey:@"Account"];
   // [self.navigationController popViewControllerAnimated:YES];
    [self MoveToBeginTripView];
}
-(void)MoveToPayPalView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PaypalViewController *PayPalView=[[PaypalViewController alloc]initWithNibName:@"PaypalViewController" bundle:nil];
            [self.navigationController pushViewController:PayPalView animated:NO];
        }
        else
        {
           PaypalViewController *PayPalView=[[PaypalViewController alloc]initWithNibName:@"PaypalViewController" bundle:nil];
            [self.navigationController pushViewController:PayPalView animated:NO];
        }
    }
}

-(void)MoveToBeginTripView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            BeginTripViewObj=[[BeginTripViewController alloc]initWithNibName:@"BeginTripViewController" bundle:nil];
            [self.navigationController pushViewController:BeginTripViewObj animated:NO];
        }
        else
        {
            BeginTripViewObj=[[BeginTripViewController alloc]initWithNibName:@"BeginTripViewController" bundle:nil];
            [self.navigationController pushViewController:BeginTripViewObj animated:NO];
        }
    }
}

-(void)MoveToRatingView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            RatingViewController *RatingView=[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            [self.navigationController pushViewController:RatingView animated:YES];
        }
        else
        {
            RatingViewController *RatingView=[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            [self.navigationController pushViewController:RatingView animated:YES];
        }
    }
}

#pragma mark - Get Pickup Location Button Action

-(IBAction)GetPickupLocationButtonAction:(id)sender
{
    
}

#pragma mark - CLLocation Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation*currentLocation;
    
    if (locations.count>0)
    {
        currentLocation = [locations objectAtIndex:0];
    }
 //   NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    current_latitude=currentLocation.coordinate.latitude;
    current_longitude=currentLocation.coordinate.longitude;
    
    if ([MapStatus isEqualToString:@"ShowMap"])
    {
        MapStatus=@"";
        SourceLatitude=current_latitude;
        SourceLongitude=current_longitude;
        [self AddMapViewAndFallPin];
        
  
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
    {
                       if (error)
                       {
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       if (placemarks.count>0)
                       {
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           
                           NSLog(@"placemark.ISOcountryCode %@",placemark.addressDictionary);
                           NSLog(@"placemark.ISOcountryCode %@ %@ %@",[placemark.addressDictionary valueForKey:@"SubLocality"],[placemark.addressDictionary valueForKey:@"City"],[placemark.addressDictionary valueForKey:@"Country"]);
                           cityStr=[placemark.addressDictionary valueForKey:@"City"];
                           countryStr=[placemark.addressDictionary valueForKey:@"Country"];
                           currentAddressStr=[placemark.addressDictionary valueForKey:@"SubLocality"];
                           NSArray* addressArray=[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
                           NSLog(@"array count .. %lu",(unsigned long)addressArray.count);
                           currntFulAdress= [NSString stringWithFormat:@"%@",addressArray];
                           if (addressArray.count>0) {
                               for (int j=0;j<addressArray.count; j++)
                               {
                                   if (j==0)
                                   {
                                       currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];
                                   }
                                   else{
                                       
                                       if (currntFulAdress.length==0) {
                                           currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];
                                           
                                       }
                                       else
                                       {
                                           currntFulAdress=[NSString stringWithFormat:@"%@,%@",currntFulAdress,[addressArray objectAtIndex:j]];
                                           
                                       }
                                   }
                               }
                           }
                           if (currentAddressStr.length==0) {
                               currntFulAdress=[NSString stringWithFormat:@"%@",currntFulAdress];
                               
                           }
                           else{
                               currntFulAdress=[NSString stringWithFormat:@"%@ ,%@",currentAddressStr,currntFulAdress];
                               
                           }
                           
                            NSLog(@"full address %@",currntFulAdress);
                          // SourceLabel.text=currntFulAdress;
            }
        }];
    }

}

#pragma marks - MAP VIEW Delegates

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    CameraLatitude=position.target.latitude;
    CameraLongitude=position.target.longitude;
    
    CLLocation *CameraLocation = [[CLLocation alloc] initWithLatitude:CameraLatitude longitude:CameraLongitude];
    
    CLGeocoder *geocoder1 = [[CLGeocoder alloc] init];
    [geocoder1 reverseGeocodeLocation:CameraLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
        {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         if (placemarks.count>0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSLog(@"placemark.ISOcountryCode %@",placemark.addressDictionary);
             NSLog(@"placemark.ISOcountryCode %@ %@ %@",[placemark.addressDictionary valueForKey:@"SubLocality"],[placemark.addressDictionary valueForKey:@"City"],[placemark.addressDictionary valueForKey:@"Country"]);
             cityStr=[placemark.addressDictionary valueForKey:@"City"];
             countryStr=[placemark.addressDictionary valueForKey:@"Country"];
             currentAddressStr=[placemark.addressDictionary valueForKey:@"SubLocality"];
             NSArray* addressArray=[placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
             NSLog(@"array count .. %lu",(unsigned long)addressArray.count);
             currntFulAdress= [NSString stringWithFormat:@"%@",addressArray];
             if (addressArray.count>0) {
                 for (int j=0;j<addressArray.count; j++)
                 {
                     if (j==0)
                     {
                         currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];
                     }
                     else
                     {
                         if (currntFulAdress.length==0) {
                             currntFulAdress=[NSString stringWithFormat:@"%@",[addressArray objectAtIndex:j]];
                             
                         }
                         else
                         {
                             currntFulAdress=[NSString stringWithFormat:@"%@,%@",currntFulAdress,[addressArray objectAtIndex:j]];
                         }
                     }
                 }
             }
             if (currentAddressStr.length==0) {
                 //currntFulAdress=[NSString stringWithFormat:@"%@",currntFulAdress];
                 
             }
             else{
                 //currntFulAdress=[NSString stringWithFormat:@"%@ ,%@",currentAddressStr,currntFulAdress];
                 
             }
             
             NSLog(@"full address %@",currntFulAdress);
            // SourceLabel.text=currntFulAdress;
             [pickUpLocationBtn setTitle:currntFulAdress forState:UIControlStateNormal];
         }
     }];
    
    current_latitude=position.target.latitude;
    current_longitude=position.target.longitude;
    marker.position = CLLocationCoordinate2DMake(position.target.latitude ,position.target.longitude);
    
     if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"MODE"] isEqualToString:@"DRIVER"])
     {
         [RefreshVechTimer invalidate];
         [Timer invalidate];
         [RefreshVechTimer1 invalidate];
         [Timer1 invalidate];
         RefreshVechTimer= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(UpdateVechicleOnMapInBackground) userInfo:nil repeats:YES];
         
         Timer= [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:NO];
         
         if (!GetProfileDetail)
         {
             [RefreshVechTimer invalidate];
             [Timer invalidate];
             [RefreshVechTimer1 invalidate];
             [Timer1 invalidate];
         }
     }
}
-(void)UpdateVechicleOnMap
{
    if (alertFlag==2)
    {
        
    }
    else
    {
        alertFlag=1;
    }

  //  [kappDelegate ShowIndicator];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    webservice=2;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",[NSString stringWithFormat:@"%f",CameraLatitude],@"latitude",[NSString stringWithFormat:@"%f",CameraLongitude],@"longitude",@"10",@"distance",currentTime,@"currenttime",VechTypeForRide,@"VechileType",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchVehicleList",Kwebservices]];
    
    [self postWebservices];
    
}
-(void)UpdateVechicleOnMapInBackground
{
    if (backGroundRefreshFlag==0)
    {
        backGroundRefreshFlag=1;
    //  [kappDelegate ShowIndicator];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    webservice=2;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",[NSString stringWithFormat:@"%f",CameraLatitude],@"latitude",[NSString stringWithFormat:@"%f",CameraLongitude],@"longitude",@"10",@"distance",currentTime,@"currenttime",VechTypeForRide,@"VechileType",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchVehicleList",Kwebservices]];
    
    [self postWebservices];
        
    }
}

//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
//{
//    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 172, 39)];
//    view.layer.cornerRadius=5.0;
//    view.backgroundColor=[UIColor clearColor];
//    [view setUserInteractionEnabled:YES];
//    
//    UIButton *GetPickUpLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [GetPickUpLocationBtn addTarget:self
//               action:@selector(GetPickupLocationButtonAction:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [GetPickUpLocationBtn setBackgroundImage:[UIImage imageNamed:@"info_window.png"] forState:UIControlStateNormal];
//
//  //  [GetPickUpLocationBtn setTitle:@"GET PICKUP LOCATION   >" forState:UIControlStateNormal];
//    GetPickUpLocationBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:14];
//    GetPickUpLocationBtn.frame = CGRectMake(0, 0, 172, 39);
//    [view addSubview:GetPickUpLocationBtn];
//    
//    UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, -2, 172, 39)];
//    textLabel.backgroundColor=[UIColor clearColor];
//    textLabel.text=@"SET PICKUP LOCATION   >";
//    textLabel.textColor=[UIColor whiteColor];
//    [textLabel setFont:[UIFont fontWithName:@"Helvetica-bold" size:12]];
//    [view addSubview:textLabel];
//
//    
//    return view;
//}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker*)Marker
{
    NSLog(@"yes"); // And now this should work.
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ComingFrom"] isEqualToString:@"SourceSearch"])
    {
        
        [MapView removeFromSuperview];
        camera = [GMSCameraPosition cameraWithLatitude:SourceLatitude longitude:SourceLongitude zoom:18];
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 505) camera:camera];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 370) camera:camera];
        }
        else
        {
            MapView = [GMSMapView mapWithFrame: CGRectMake(0,65, self.view.frame.size.width, 505) camera:camera];
        }
        
        MapView.settings.compassButton = YES;
        MapView.settings.myLocationButton = YES;
        MapView.delegate = self;
        MapView.myLocationEnabled = YES;
        MapView.layer.borderColor = [UIColor whiteColor].CGColor;
        MapView.layer.borderWidth = 1.5;
        
        MapView.layer.cornerRadius = 5.0;
        
        [MapView setClipsToBounds:YES];
        [self.view addSubview:MapView];
        [self.view bringSubviewToFront:SearchSourceDestinationView];
        [MapView bringSubviewToFront:SearchSourceDestinationView];
        
        marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(SourceLatitude ,SourceLongitude);
        // marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        marker.icon = [UIImage imageNamed:@"map_pointer.png"];
        PinView.hidden=NO;
        
        [self.view bringSubviewToFront:PinView];
        [MapView bringSubviewToFront:PinView];
        
        //marker.map = MapView;
        
        MapView.selectedMarker=marker;
        DestinationBtnOutlet.hidden=NO;
        
        [self.view bringSubviewToFront:RequestPickUpView];
        [MapView bringSubviewToFront:RequestPickUpView];
        RequestPickUpView.hidden=NO;
        [self ShowVechiclesOnMap];
        // Left Bar Button Item //
        leftButton.hidden=YES;
        UIButton* leftCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftCancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        leftCancelButton.frame = CGRectMake(0, 0, 60, 40);
        [leftCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [leftCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
        [leftCancelButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftCancelButton];
        self.navigationItem.leftBarButtonItem = LeftBarButtonItem;
        
        ////
        
    }
}
#pragma mark - Cancel Button Action

-(IBAction)CancelButtonAction:(id)sender
{
//    vehicleListArray=[[NSMutableArray alloc] init];
//    vehicleZoneListAray=[[NSMutableArray alloc] init];
  //  SearchSourceDestinationView.frame=CGRectMake(27, 92, 320, 126);

    RequestPickUpView.hidden=YES;
    SourceLabel.text=@"";
    [self viewDidLoad];
}

#pragma mark - Text Field Delegates

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [SourceTextField resignFirstResponder];
    return YES;
}

#pragma mark - Get Profile Web Service

-(void)GetUserProfileService
{
     GetProfileDetail=NO;
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"UserId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
   urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetProfiles",Kwebservices]];

    [self postWebservices];
}

#pragma mark - Fetch Vehicle List

-(void)RequestToDriver
{
    [kappDelegate ShowIndicator];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    NSLog(@"%f",SourceLatitude);
    if (SourceLatitude==0)
    {
        NSLog(@"sfdr");
        SourceLatitude=current_latitude;
        SourceLongitude=current_longitude;
    }
    webservice=3;
    
    [Timer invalidate];
    [Timer1 invalidate];
    
    NSString*vehicleNameStr=[NSString stringWithFormat:@"%@VehicleIdstr",VechTypeForRide];
    
    NSString*vehicleIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:vehicleNameStr];
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderId",driverIdStr,@"driverId",driverList,@"DriverList",@"",@"requestType",SourceLabel.text,@"starting_loc",DestinationLabel.text,@"ending_loc",[NSString stringWithFormat:@"%f",SourceLongitude],@"start_long",[NSString stringWithFormat:@"%f",DestinationLongitude],@"end_long",[NSString stringWithFormat:@"%f",SourceLatitude],@"start_lat",[NSString stringWithFormat:@"%f",DestinationLatitude],@"end_lat",currentTime,@"trip_request_date",currentTime,@"trip_request_pickup_date",@"",@"trip_miles_est",[NSString stringWithFormat:@""],@"trip_miles_act",@"",@"trip_time_est",[NSString stringWithFormat:@""],@"trip_time_act",actualFare,@"offered_fare",actualFare,@"setfare",vehicleIdStr,@"vehicle_type",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RequestRide",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Fetch Vehicle List

-(void)FetchVehicleList
{
    //[kappDelegate ShowIndicator];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    webservice=2;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",[NSString stringWithFormat:@"%f",current_latitude],@"latitude",[NSString stringWithFormat:@"%f",current_longitude],@"longitude",@"10",@"distance",currentTime,@"currenttime",VechTypeForRide,@"VechileType",nil];

    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchVehicleList",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Register Device for Push Notifications

-(void)RegisterDevice
{
    webservice=4;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"RiderId",@"rider",@"Role",@"",@"DriverId",[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],@"DeviceUDId",[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"],@"TokenID",@"ios",@"Trigger",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterDevice",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Get Pending Split Fare

-(void)GetPendingSplitFare
{
    webservice=5;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"UserId",[[NSUserDefaults standardUserDefaults] valueForKey:@"Mobile"],@"mobile",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetPendingSplitFare",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Show Vechicles On Map View

-(void)ShowVechiclesOnMap
{
    [MapView clear];
    driverIdArray =[[NSMutableArray alloc]init];
    NSMutableArray *tempDriverIdArray=[[NSMutableArray alloc]init];

    if (vehicleListArray.count>0)
    {
        for (int i=0; i<[vehicleListArray count]; i++)
        {
            double latitude=[[[vehicleListArray objectAtIndex:i] valueForKey:@"latitude"]floatValue];
            double longitude=[[[vehicleListArray objectAtIndex:i] valueForKey:@"longitude"]floatValue];
            GMSMarker *vehicleMarker = [[GMSMarker alloc]init];
            CLLocationCoordinate2D local = CLLocationCoordinate2DMake(latitude, longitude);
            vehicleMarker.position = local;
            vehicleMarker.icon = [UIImage imageNamed:@"car_icon.png"];
            vehicleMarker.map = MapView;
            
            
            if (vehicleZoneListAray.count>0 && i<vehicleZoneListAray.count)
            {
                driverZoneDict=[vehicleZoneListAray objectAtIndex:i];
            }
            surgeValue=[driverZoneDict valueForKey:@"surgeValue"];
            driverInfoDict= [vehicleListArray objectAtIndex:i];
            NSString*driverid=[driverInfoDict valueForKey:@"driverid"];

            
            [driverIdArray addObject:[driverInfoDict valueForKey:@"driverid"]];
            estimatedTimeStr=[driverInfoDict valueForKey:@"Time" ];
            if (estimatedTimeStr.length>7)
            {
                NSArray *timeArray = [estimatedTimeStr componentsSeparatedByString:@" "];
                int minutes=[[timeArray objectAtIndex:2]intValue];
                int hours=[[timeArray objectAtIndex:0]intValue];
                minutes=hours*60+minutes;
                estimatedTimeStr=[NSString stringWithFormat:@"%d",minutes];
            }
            
            NSDictionary *tempDriveridDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:driverid,@"driverId",estimatedTimeStr,@"time" ,surgeValue,@"surgeValue" ,nil];
            [tempDriverIdArray addObject:tempDriveridDict];
            
            
            if (tempDriverIdArray.count>0)
            {
                for (int m=0;m<tempDriverIdArray.count; m++)
                {
                   // driverIdArray=[[NSMutableArray alloc]init];
                    
                    int driverTime=[[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"]intValue];
                    if (m==0)
                    {
                      //  NSString *drivrstr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                        
                            driverIdStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                            nearsCarMintStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"];
                            surgeValue=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"surgeValue"];
                    }
                    else if ( m>0 && driverTime<tempTime)
                    {
                        
                       // NSString *drivrstr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                        
                            nearsCarMintStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"time"];
                            driverIdStr=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"driverId"];
                            surgeValue=[[tempDriverIdArray objectAtIndex:m]valueForKey:@"surgeValue"];
                    }
                    
                    tempTime=driverTime;
                }
            }
        }
        driverList=[driverIdArray componentsJoinedByString:@";"];
    }
    else
    {
      //  [MapView clear];

       // UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No Vechicles Available in this region" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
      //  [alert show];

    }
}

#pragma mark -  Accept Split Fare Request

-(void)AcceptSplitFare
{
    webservice=6;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"RiderId",@"accept",@"Trigger",splitFareAmount,@"Amount",splitFareTripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptRejectPendingFareRequest",Kwebservices]];
    
    [self postWebservices];
}
#pragma mark -  Reject Split Fare Request

-(void)RejectSplitFare
{
    webservice=7;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"RiderId",@"reject",@"Trigger",splitFareAmount,@"Amount",splitFareTripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptRejectPendingFareRequest",Kwebservices]];
    
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

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2012)
    {
        if (buttonIndex==1)
        {
            [self AcceptSplitFare];
        }
        else if (buttonIndex==0)
        {
            [self RejectSplitFare];
        }
    }
}
#pragma mark - Response Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //[kappDelegate HideIndicator];

    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    backGroundRefreshFlag=0;

    [kappDelegate HideIndicator];
    
    UIAlertView *alert;
    alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Network Connection lost, Please check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alert show];
    
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   // [kappDelegate HideIndicator];
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.view.userInteractionEnabled=YES;
    leftButton.userInteractionEnabled=YES;
    
    backGroundRefreshFlag=0;
    
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    NSString*msg=[userDetailDict valueForKey:@"message"];
    if ([msg isEqualToString:@"Request Submitted Successful"])
    {
        [vehicleListArray removeAllObjects];
        [self ShowVechiclesOnMap];
        [self UpdateVechicleOnMapInBackground];
        NSLog(@"%@",userDetailDict);
        
        RequestPickUpView.hidden=YES;
        SourceLabel.text=@"";
        [self viewDidLoad];
        oneMinCount=0;
        OneMinTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(OneMinTimerCount) userInfo:nil repeats:YES];
        
        [kappDelegate ShowWaitngView];
    }
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        if (userDetailDict.count==5)
        {
            webservice=6;
        }
        NSString *firstName=[userDetailDict valueForKey:@"firstname"];
        if (firstName.length!=0)
        {
            webservice=1;
        }
    }
    
    if (webservice==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                //[alert show];
            }
            else
            {
                TempDictForUser=[userDetailDict mutableCopy];
                
                NSString *firstName=[TempDictForUser valueForKey:@"firstname"];
                NSString *lastName=[TempDictForUser valueForKey:@"lastname"];
                FullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                
                UserNameLabel.textColor=[UIColor colorWithRed:34/255.0 green:179/255.0 blue:136/255.0 alpha:1];
                UserNameLabel.text=FullName;
                NSString *userImageUrl=[TempDictForUser valueForKey:@"image"];
                
                NSString *prefVehicle=[TempDictForUser valueForKey:@"PreferedVehicleType"];
                //prefVehicle=@"";
                if ([prefVehicle isKindOfClass:[NSNull class]])
                {
                    prefVehicle=@"";
                }
                
                if (prefVehicle.length==0)
                {
                    VechTypeForRide=@"ZiraE";
                    [xbtn setImage:[UIImage imageNamed:@"1hover.png"] forState:UIControlStateNormal];
                    [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                    [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                    [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    
                }
                else {
                    VechTypeForRide=[NSString stringWithFormat:@"%@",prefVehicle];
                    
                    if ([VechTypeForRide isEqualToString:@"ZiraPlus"])
                    {
                        [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2hover.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    }
                    else if ([VechTypeForRide isEqualToString:@"ZiraTaxi"])
                    {
                        [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3hover.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    }
                    else if ([VechTypeForRide isEqualToString:@"ZiraLux"])
                    {
                        [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4hover.png"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [xbtn setImage:[UIImage imageNamed:@"1hover.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    }
                }
                
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
                [self RegisterDevice];
            }
        }
        
    }
    else if (webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            //  NSString *messageStr=[userDetailDict valueForKey:@"message"];
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                [MapView clear];
                [vehicleZoneListAray removeAllObjects];
                [vehicleListArray removeAllObjects];
            }
            else
            {
                vehicleListArray=[userDetailDict valueForKey:@"ListVehicleInfo"];
                vehicleZoneListAray=[userDetailDict valueForKey:@"ListZoneInfo"];
                NSLog(@"%@",vehicleZoneListAray);
                
                NSString*cancelfeeStr=[userDetailDict valueForKey:@"CancellationFee"];
                if ([cancelfeeStr isKindOfClass:[NSNull class]])
                {
                    cancelfeeStr=@"";
                }
                float cancelCharge=[[NSString stringWithFormat:@"%@",cancelfeeStr] floatValue];
                
                NSString *safetyCharges=[userDetailDict valueForKey:@"SafetyFee"];
                if ([safetyCharges isKindOfClass:[NSNull class]])
                {
                    safetyCharges=@"";
                }
                float safety=[[NSString stringWithFormat:@"%@",safetyCharges] floatValue];
                
                [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%.1f",safety] forKey:@"SafetyCharges"];
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",cancelCharge] forKey:@"CancelRideCharges"];
                
                if (vehicleListArray.count>0)
                {
                    EstimateTimeOfArrivel=[[vehicleListArray objectAtIndex:0] valueForKey:@"Time"];
                    TimeArivelLbl.text=EstimateTimeOfArrivel;
                }
                
                NSString *prefVechType=[userDetailDict valueForKey:@"preffervehicletype"];
                [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"preffervehicletype"];
                [[NSUserDefaults standardUserDefaults ]setValue:prefVechType forKey:@"preffervehicletype"];
                
                if ([prefVechType isEqualToString:@"ZiraE"])
                {
                    // [slider setValue:0 animated:NO];
                    if (flag1==0)
                    {
                        flag1=1;
                        [xbtn setImage:[UIImage imageNamed:@"1hover.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    }
                    
                    //  VechTypeForRide=@"1";
                    
                    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                    
                    
                    if (vehicleZoneListAray.count>0)
                    {
                        for (int k=0; k<vehicleZoneListAray.count; k++)
                        {
                            NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                            
                            if ([Vehicletypestr  isEqualToString:prefVechType])
                            {
                                XCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                                // MinFareForZiraX=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MinFare"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                                int VehicleIdstr=[[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileID"]intValue];
                                [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%d",VehicleIdstr] forKey:@"ZiraEVehicleIdstr"];
                            }
                        }
                    }
                }
                else if ([prefVechType isEqualToString:@"ZiraPlus"])
                {
                    if (flag1==0)
                    {
                        flag1=1;
                        [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2hover.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    }
                    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                    if (vehicleZoneListAray.count>0)
                    {
                        for (int k=0; k<vehicleZoneListAray.count; k++)
                        {
                            
                            NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                            if ([Vehicletypestr  isEqualToString:prefVechType])
                                
                            {
                                PlusCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                                // MinFareForZiraPlus=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MinFare"];
                                int VehicleIdstr=[[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileID"]intValue];
                                [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%d",VehicleIdstr] forKey:@"ZiraPlusVehicleIdstr"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                
                                [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                            }
                        }
                    }
                }
                else if ([prefVechType isEqualToString:@"ZiraTaxi"])
                {
                    // [slider setValue:100 animated:NO];
                    if (flag1==0)
                    {
                        flag1=1;
                        [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3hover.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    }
                    
                    // VechTypeForRide=@"3";
                    
                    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                    if (vehicleZoneListAray.count>0)
                    {
                        for (int k=0; k<vehicleZoneListAray.count; k++)
                        {
                            NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                            if ([Vehicletypestr  isEqualToString:prefVechType])
                            {
                                SuvCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                                // MinFareForZiraSUV=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MinFare"];
                                int VehicleIdstr=[[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileID"]intValue];
                                [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%d",VehicleIdstr] forKey:@"ZiraTaxiVehicleIdstr"];
                                
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                
                                [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                            }
                        }
                    }
                }
                else if ([prefVechType isEqualToString:@"ZiraLux"])
                {
                    // [slider setValue:100 animated:NO];
                    if (flag1==0)
                    {
                        flag1=1;
                        [xbtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4hover.png"] forState:UIControlStateNormal];
                    }
                    
                    // VechTypeForRide=@"4";
                    
                    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                    if (vehicleZoneListAray.count>0)
                    {
                        for (int k=0; k<vehicleZoneListAray.count; k++)
                        {
                            NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                            if ([Vehicletypestr  isEqualToString:prefVechType])
                            {
                                LUXCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                                // MinFareForZiraLUX=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MinFare"];
                                int VehicleIdstr=[[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileID"]intValue];
                                [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%d",VehicleIdstr] forKey:@"ZiraLuxVehicleIdstr"];
                                
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                
                                [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                            }
                        }
                    }
                }
                else
                {
                    if (flag1==0)
                    {
                        flag1=1;
                        [xbtn setImage:[UIImage imageNamed:@"1hover.png"] forState:UIControlStateNormal];
                        [plusbtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
                        [suvbtn setImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
                        [LuxBtn setImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
                    }
                    
                    // VechTypeForRide=@"1";
                    
                    NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
                    if (vehicleZoneListAray.count>0)
                    {
                        for (int k=0; k<vehicleZoneListAray.count; k++)
                        {
                            NSString* Vehicletypestr=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileName"];
                            if ([Vehicletypestr  isEqualToString:prefVechType])
                            {
                                XCarPeoples=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VehicleCapacity"];
                                //  MinFareForZiraX=[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MinFare"];
                                int VehicleIdstr=[[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"VechileID"]intValue];
                                [[NSUserDefaults standardUserDefaults ]setValue:[NSString stringWithFormat:@"%d",VehicleIdstr] forKey:@"ZiraEVehicleIdstr"];
                                
                                
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Minprice"] forKey:@"PriceMintue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"MilesPrice"] forKey:@"PriceMile"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"Surgeprice"] forKey:@"SurgeValue"];
                                [tempDict setValue:[[vehicleZoneListAray objectAtIndex:k] valueForKey:@"BasePrice"] forKey:@"BaseFare"];
                                
                                [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"PriceDetails"];
                            }
                        }
                    }
                }
                [self ShowVechiclesOnMap];
            }
        }
    }
    else if (webservice==3   && [msg isEqualToString:@"Request Submitted Successful"])
  //      else if (webservice==3   && ([msg isEqualToString:@"Request Submitted Successful"] ||[msg rangeOfString:@"Success" options:NSCaseInsensitiveSearch].location != NSNotFound))
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                [MapView clear];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                
                [vehicleListArray removeAllObjects];
                [self ShowVechiclesOnMap];
                
                [self UpdateVechicleOnMapInBackground];
                NSLog(@"%@",userDetailDict);
                
                RequestPickUpView.hidden=YES;
                SourceLabel.text=@"";
                oneMinCount=0;
                OneMinTimer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(OneMinTimerCount) userInfo:nil repeats:YES];
                
                [kappDelegate ShowWaitngView];
            Timer1 = [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:NO];
            }
            [self viewDidLoad];
        }
    }
    else if (webservice==4)
    {
        GetProfileDetail=YES;
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"MODE"] isEqualToString:@"DRIVER"])
        {
            if (GetProfileDetail)
            {
                RefreshVechTimer1= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(UpdateVechicleOnMapInBackground) userInfo:nil repeats:YES];
                
                Timer1= [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(UpdateVechicleOnMap) userInfo:nil repeats:NO];
            }
        }
        if (flag==0)
        {
            flag=1;
            [self GetPendingSplitFare];
        }
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            // NSString *messageStr=[userDetailDict valueForKey:@"message"];
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                [MapView clear];
                // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                // [alert show];
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
            // NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                // [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                if ([[userDetailDict valueForKey:@"amount"] isKindOfClass:[NSNull class]]||[[userDetailDict valueForKey:@"amount"] isEqualToString:@""])
                {
                    
                }
                else
                {
                    splitFareTripId=[userDetailDict valueForKey:@"tripid"];
                    float amount=[[userDetailDict valueForKey:@"amount"] floatValue];
                    splitFareAmount=[NSString stringWithFormat:@"%.1f",amount];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@%@",@"Your Pending split fare is=",splitFareAmount] delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
                    alert.tag=2012;
                    [alert show];
                }
            }
        }
    }
    else if (webservice==6)
    {
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
            }
        }
    }
    else if (webservice==7)
    {
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
            }
        }
    }else if([msg isEqualToString:@"Request did not submit"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Request did not submit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
    
}

-(void)OneMinTimerCount
{
    oneMinCount=oneMinCount+1;
    if (oneMinCount==60)
    {
        [OneMinTimer invalidate];
        [kappDelegate HideWaitngView];
    }
}
-(void)moveToBeginTrip :(NSString*) tripId :(NSDictionary*) tripData
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize results = [[UIScreen mainScreen] bounds].size;
        if(results.height == 480)
        {
            //[self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            BeginTripViewController *BeginTripView=[[BeginTripViewController alloc]initWithNibName:@"" bundle:nil];
            BeginTripView.ComingFromNotification=@"YES";
            BeginTripView.TripId=tripId;
            NSString* DestinationLat=[tripData valueForKey:@"end_lat"];
            NSString* DestinationLong=[tripData valueForKey:@"end_lon"];
            NSString*DestinationAddress=[tripData valueForKey:@"ending_loc"];
            
            
            BeginTripView.DestinationLat=DestinationLat;
            BeginTripView.DestinationLong=DestinationLong;
            BeginTripView.DestinationAddress=DestinationAddress;
            
            [navigationController pushViewController:BeginTripView animated:YES];
        }
        else
        {
            //[self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            BeginTripViewController *BeginTripView=[[BeginTripViewController alloc]initWithNibName:@"BeginTripViewController" bundle:nil];
            BeginTripView.ComingFromNotification=@"YES";
            BeginTripView.TripId=tripId;
            NSString* DestinationLat=[tripData valueForKey:@"end_lat"];
            NSString* DestinationLong=[tripData valueForKey:@"end_lon"];
            NSString*DestinationAddress=[tripData valueForKey:@"ending_loc"];
            
            BeginTripView.DestinationLat=DestinationLat;
            BeginTripView.DestinationLong=DestinationLong;
            BeginTripView.DestinationAddress=DestinationAddress;
            [navigationController pushViewController:BeginTripView animated:YES];
        }
    }
}
#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void )getActiveTrips{
//
//    webservice=8;
//    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",nil];
//    
//    
//    jsonRequest = [jsonDict JSONRepresentation];
//    NSLog(@"jsonRequest is %@", jsonRequest);
//    
//    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetLastActiveTripswithStatus",Kwebservices]];
//    [self postWebservices];
//
//}


@end
