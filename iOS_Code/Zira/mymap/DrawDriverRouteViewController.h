//
//  DrawDriverRouteViewController.h
//  mymap
//
//  Created by vikram on 09/12/14.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>


@interface DrawDriverRouteViewController : UIViewController<GMSMapViewDelegate,UIWebViewDelegate>

{
    NSMutableDictionary *LocationsDict;
    GMSMapView *mapView;
    GMSMarker* marker;
    GMSMarker* marker2;
    GMSPolyline *rectangle;

    
    double DriverLatitude;
    double DriverLongitude;
    double RiderLatitude;
    double RiderLongitude;
    NSString *Source;
    NSString *Destination;


}

@property(nonatomic,retain)NSString *Source;
@property(nonatomic,retain)NSString *Destination;

@property(nonatomic,retain)NSString *findAddressStr;


@property(nonatomic,retain)NSMutableDictionary *LocationsDict;
@property (retain, nonatomic) IBOutlet UIWebView *WebViewOutlet;


@end
