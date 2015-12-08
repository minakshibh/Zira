//
//  DriverMapViewController.h
//  mymap
//
//  Created by vikram on 02/12/14.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>



@interface DriverMapViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate>

{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest;
    NSString *FullName;
    NSMutableArray *TempDictForUser;
    UIButton* leftButton ;
    
   double current_latitude;
   double current_longitude;
    GMSMapView *mapView;
    GMSMarker* marker;
    
    NSTimer *timer, *fiveMinTimer;
    int timerCount;
    
    IBOutlet UIButton *AriveBtnOutlet;
    
    NSDate *now;
    NSString *currentTime;
    
    double riderLatitude;
    double riderLongitude;
    NSString *Rider;
    NSString *TripId;
    IBOutlet UIButton *RouteBtn;
    IBOutlet UIView *HomeViewOutlet;
    IBOutlet UISwitch *OnOffBtn;
    
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *UserNameLabel;
    
    NSString *DestinationLat;
    NSString *DestinationLong;
    NSString *Source;
    NSString *Destination;
    
    NSTimer *CancelRideTimer;
    NSString *CancelRideWithPay;
    IBOutlet UIButton *CancelBtn;
    NSString*driver_vehicle_type;
    
    UIView *animatedView;
    UIImageView*DriverImgView;
    UILabel *DriverNameLbl;
    UILabel *MessageLbl;
    NSString *ActiveRideTripId;
    int TimerValue;
    NSTimer *DownTimer;
    UIView  *ProgressBarView;
    UILabel *Timerlbl;
    float counter;
    float progressFloat;
    float fileSize;
    UIButton *AcceptBtn;
    NSTimer *progressTimer;
    NSMutableArray *ActiveRidesArray;




   // GMSCameraPosition *camera;


}

@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;

-(void)ShowRiderOnMap;

- (IBAction)ArriveButtonAction:(id)sender;
- (IBAction)RouteOnMapButton:(id)sender;
- (IBAction)OnOffSwitch:(id)sender;
- (IBAction)ShowDriverProfile:(id)sender;
- (IBAction)CancelButtonAction:(id)sender;

@property(nonatomic, strong) CLLocationManager *locationManager;
//- (IBAction)routeDirectionBtn:(id)sender;


@end
