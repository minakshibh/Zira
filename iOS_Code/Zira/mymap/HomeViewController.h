//
//  HomeViewController.h
//  ZiraApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PromoCodeViewController.h"
#import "CreditCardsSelectViewController.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import <AVFoundation/AVFoundation.h>



@interface HomeViewController : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

    int oneMinCount;
    
    NSTimer *Timer ,*OneMinTimer;
    NSTimer *RefreshVechTimer;
    NSTimer *Timer1;
    NSTimer *RefreshVechTimer1;
    NSString *MapStatus;
    BOOL firtTime;
    GMSMapView *MapView;
    GMSMarker* marker;
    GMSCameraPosition *camera;
    IBOutlet UITextField *SourceTextField;
    IBOutlet UILabel *SourceLabel;
    UIButton *leftButton;
    
    IBOutlet UIView *HomeViewOutlet;
    IBOutlet UIView *SearchSourceDestinationView;
    NSMutableArray *tempArray;
    
    double SourceLatitude;
    double SourceLongitude;
    double DestinationLatitude;
    double DestinationLongitude;
    
    IBOutlet UILabel *DestinationLabel;
    IBOutlet UIButton *DestinationBtnOutlet;
    IBOutlet UIButton *CrossBtnOutlet;
    
    IBOutlet UIView *RequestPickUpView;
    NSMutableArray *TempDictForUser;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *UserNameLabel;
    IBOutlet UIImageView *Destination_SearchBox;
    
    NSDate *now;
    NSString *currentTime;
    NSMutableArray *vehicleListArray;
    NSMutableArray *vehicleZoneListAray;
    double CameraLatitude;
    double CameraLongitude;
    BOOL GetProfileDetail;
   // CLLocationManager *locationManager;;
    IBOutlet UIView *PinView;
    
    NSString *minimumPrice, *maximumPrice,*userIdStr,*start_loc,*destination_loc,*suggestedFare,*riderMobileNum,*driverMobileNum,*estimatedTimeStr;
    NSString *distanceStr,*actualFare,*surgeValue;
    float estimatedDistance;
    NSString *base_fare;
    NSString *price_per_minute;
    NSString *price_per_mile;
    NSMutableArray *driverIdArray;
    NSMutableDictionary *driverInfoDict,*driverZoneDict;
    NSString *driverIdStr;
    NSString  *nearsCarMintStr;
    int tempTime;
    NSString *driverList;
    NSString *currntFulAdress;
    NSString *cityStr;
    NSString *countryStr ,*currentAddressStr;
    IBOutlet UISwitch *OnOffSwitch;
    IBOutlet UIButton *pickUpLocationBtn;
    NSString *windowBtn;
    
    NSString *EstimateTimeOfArrivel;
    IBOutlet UILabel *TimeArivelLbl;
    IBOutlet UIView *VechTypeView;
    IBOutlet UISlider *slider;
    NSString *VechTypeForRide;
    IBOutlet UIButton *xbtn;
    IBOutlet UIButton *plusbtn;
    IBOutlet UIButton *suvbtn;
    int flag;
    IBOutlet UIView *checkFareView;
    IBOutlet UIView *checkFareFrontView;
    IBOutlet UIButton *CheckFareViewBtn;
    IBOutlet UILabel *etalabel;
    IBOutlet UILabel *minFare;
    IBOutlet UILabel *maxFare;
    IBOutlet UILabel *baseFare;
    IBOutlet UILabel *mintFare;
    IBOutlet UILabel *mileFare;
    
    NSString *XCarPeoples;
    NSString *PlusCarPeoples;
    NSString *SuvCarPeoples;
    NSString *LUXCarPeoples;

    int flag1;
    int alertFlag;
    IBOutlet UILabel *CancelRideLbl;
    NSString *MinFareForZiraX;
    NSString *MinFareForZiraLUX;

    NSString *MinFareForZiraPlus;
    NSString *MinFareForZiraSUV;
    IBOutlet UIButton *LuxBtn;
    int backGroundRefreshFlag;
    NSString *splitFareTripId;
    NSString *splitFareAmount;
}
- (IBAction)RemoveHomeView:(id)sender;
- (IBAction)SettingButtonAction:(id)sender;
- (IBAction)SourceButtonAction:(id)sender;
- (IBAction)SelectDestinationButton:(id)sender;
- (IBAction)CrossButtonAction:(id)sender;
- (IBAction)RequestPickupButtonAction:(id)sender;
- (IBAction)MrkerWindowButtonAction:(id)sender;
- (IBAction)PromoCodeButtonAction:(id)sender;
- (IBAction)ChangeCreditCardBtnAction:(id)sender;
- (IBAction)OnOffSwitchBtn:(id)sender;
- (IBAction)FareEstimateButtonAction:(id)sender;
- (IBAction)OnAndOffSwitch:(id)sender;
- (IBAction)SliderValueChanged:(id)sender;
- (IBAction)XButton:(id)sender;
- (IBAction)PlusButton:(id)sender;
- (IBAction)SUVButton:(id)sender;
- (IBAction)CheckFareBtnAction:(id)sender;
- (IBAction)PaymentButton:(id)sender;
//- (IBAction)GetZiraBtn:(id)sender;
- (IBAction)SupportBtnAction:(id)sender;
- (IBAction)PromotionButtonAction:(id)sender;
- (IBAction)ZiraLuxBtnAction:(id)sender;
- (IBAction)getZiraActionBtn:(id)sender;
- (IBAction)shareBtnAction:(id)sender;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic)  NSString *FullName;

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) double current_latitude;
@property (nonatomic, assign) double current_longitude;




@end
