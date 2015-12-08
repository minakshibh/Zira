//
//  SeeDriverLocationViewController.h
//  mymap
//
//  Created by vikram on 08/12/14.
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


@interface SeeDriverLocationViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    
    NSString *GetDriverId;
    NSString *GetTripId;
    
    double  DriverLattitude;
    double  DriverLongitude;
    
    double current_latitude;
    double current_longitude;

    
    GMSMapView *mapView;
    GMSMarker* marker;

    
}

@property(nonatomic, strong) CLLocationManager *locationManager;


@property(nonatomic,retain)NSString *GetDriverId;
@property(nonatomic,retain)NSString *GetTripId;


@end
