//
//  DriverInfoViewController.h
//  mymap
//
//  Created by vikram on 08/12/14.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"



@interface DriverInfoViewController : UIViewController<MFMessageComposeViewControllerDelegate,UITextFieldDelegate>

{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    int  timerCount;
    
    NSString *DriverDetailStr ,*CancelRideWithPay;
    IBOutlet UIImageView *DriverImageView;
    IBOutlet UILabel *DriverNameLabel;
    NSString *DriverId;
    NSString *TripId;
    IBOutlet UIImageView *VechicleImageView;
    IBOutlet UILabel *VechMake;
    IBOutlet UILabel *VechModel;
    IBOutlet UILabel *VechNo;
    
    //rating stars
    IBOutlet UIImageView *firstStar;
    IBOutlet UIImageView *secondStar;
    IBOutlet UIImageView *thirdStar;
    IBOutlet UIImageView *fourthStar;
    IBOutlet UIImageView *fifthStar;
    int RatingCount;
    IBOutlet UIView *msgView;
    IBOutlet UITextField *MsgTextField;
    
    
}

@property(nonatomic,retain) NSString *DriverDetailStr;

- (IBAction)MessageButtonAction:(id)sender;
- (IBAction)CallButtonAction:(id)sender;
- (IBAction)SeeDriverLocationButtonAction:(id)sender;
- (IBAction)SendBtn:(id)sender;
- (IBAction)CrossBtn:(id)sender;


@end
