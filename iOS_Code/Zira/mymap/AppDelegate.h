//
//  AppDelegate.h
//  mymap
//
//  Created by Parveen Sharma on 11/5/14.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ProgressGradientView.h"
#import <CoreLocation/CoreLocation.h>


#import "Reachability.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"



@class GTMOAuth2Authentication;



@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
{
    
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

    
    ProgressGradientView *pgv;
    CGFloat progress;
    NSTimer *progressTimer;
    UIView  *ProgressBarView;
    UIButton *AcceptBtn;

    
    BOOL            internetConn;
    UIView          *DisableView ,*DisableBackView;
    UIActivityIndicatorView *activityIndicatorObject;
    NSMutableArray *SourceArray;
    NSString* user_UDID_Str ,*registrationIDStr,*message,*result;
    
    UIView *animatedView;
    UIImageView*DriverImgView,*RiderImgView;
    UILabel *DriverNameLbl;
    UILabel *MessageLbl;
    NSString *TripId;
    NSString *DriverInfoStr;
    
    NSDate *now;
    NSString *currentTime;
    NSString *ArivedTripId;
    NSString *EndRideTripId;
    NSString *BegunTripId;
    NSString *DestinationLat;
    NSString *DestinationAddress;

    NSString *DestinationLong;
    NSTimer *CancelRideTimer;
    NSString *CancelRideWithPay;
    
    float counter;
    float progressFloat;
    float fileSize;
    
    NSString *splitFareRiderId;
    NSString *splitFareAmount;
    NSString *splitFareTripId;
    int canclRiderTimer;
    
    UILabel *Timerlbl;
    int TimerValue;
    int canclTimerCount;
    NSTimer *DownTimer;

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *SourceArray;
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) UINavigationController *navigationController;

@property(nonatomic, strong) CLLocationManager *locationManager;



-(BOOL)checkForInternetConnection;
-(void)ShowIndicator;
-(void)HideIndicator;

-(void)ShowWaitngView;
-(void)HideWaitngView;
-(int)requestTimer;


@end
