//
//  RatingViewController.h
//  mymap
//
//  Created by vikram on 16/12/14.
//

#import <UIKit/UIKit.h>

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"




@interface RatingViewController : UIViewController<UITextViewDelegate,UIAlertViewDelegate>
{
    
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

    
    //stars buttons outlet
    IBOutlet UIButton *firstStar;
    IBOutlet UIButton *secondStar;
    IBOutlet UIButton *thirdStar;
    IBOutlet UIButton *fourthStar;
    IBOutlet UIButton *fifthStar;
    
    //text view outlet
    IBOutlet UITextView *commentTextView;
    
    NSString *RatingValue;
    
    NSString *GetTripId;
    
    NSString *ComingFromNotification;
    
    NSString *EndRideTripIdFromNotif;
    
    NSString *DriverId;
    NSString *RiderId;
    IBOutlet UILabel *totalFare;
    
    NSMutableArray *TripDetailArr;

    
    
}

@property(nonatomic,retain)NSString *GetTripId;
@property(nonatomic,retain)NSString *ComingFromNotification;
@property(nonatomic,retain) NSString *EndRideTripIdFromNotif;


- (IBAction)FirstButtonAction:(id)sender;
- (IBAction)SecondButtonAction:(id)sender;
- (IBAction)ThirdButtonAction:(id)sender;
- (IBAction)FourthButtonAction:(id)sender;
- (IBAction)FifthButtonAction:(id)sender;

- (IBAction)DoneButtonAction:(id)sender;

@end
