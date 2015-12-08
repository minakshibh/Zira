//
//  BeginTripViewController.h
//  mymap
//
//  Created by vikram on 10/12/14.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"



@interface BeginTripViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate>

{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

    
    IBOutlet UIButton *endRideBtn;
    double current_latitude;
    double current_longitude;
    GMSMapView *mapView;
    GMSMarker* marker;
    int flag;
    double oldLat;
    double oldLong;
    GMSMarker *marker2;
    GMSPolyline *rectangle;
    NSTimer*timer;
    
    NSDate *now;
    NSString *currentTime;
    
    NSString *TripId;
    NSString *ComingFromNotification;
    
    NSString *DestinationLat;
    NSString *DestinationLong;
    
    NSString *estimatedTimeStr,*distanceStr,*surgeValue,*actualFare;
    float estimatedDistance;
    NSString *price_per_minute;
    NSString *price_per_mile;
    NSString *base_fare;
    NSString *minimumPrice, *maximumPrice,*suggestedFare;
    float actualPrice;

    NSMutableDictionary *LocationsDict;
    IBOutlet UIButton *getDirectionBtn;




}

@property(nonatomic,retain) NSMutableDictionary *LocationsDict;

@property(nonatomic,retain) NSString *DestinationLat;
@property(nonatomic,retain) NSString *DestinationLong;
@property(nonatomic,retain) NSString *DestinationAddress;

@property(nonatomic,retain) NSString *ComingFromNotification;

@property(nonatomic,retain)NSString *TripId;
@property(nonatomic, strong) CLLocationManager *locationManager;
- (IBAction)GetDirections:(id)sender;

@end
