//
//  PayWithCreditCardViewController.h
//  mymap
//
//  Created by vikram on 31/12/14.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"


@interface PayWithCreditCardViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    
    
    IBOutlet UITextField *CreditCardNoTextField;
    IBOutlet UITextField *CVVTextField;
    IBOutlet UITextField *ExpiryDateTextField;
    IBOutlet UIView *PickerBgView;
    IBOutlet UIPickerView *PickerView;
    IBOutlet UITextField *CardTypeTextField;
    
    NSMutableArray *monthArray;
    NSMutableArray *yearArray;
    NSString *MonthYearValue;
    
    NSString *month;
    NSString *Year;
    NSMutableArray *CardTypeArray;
    IBOutlet UITableView *DropDownTableView;
    int flag;
    
    NSString *getRiderId;
    NSString *GetDriverId;
    NSString *GetTripId;
    NSString *GetFare;
    IBOutlet UITextField *FirstNameTextfield;
    IBOutlet UITextField *LastNameTextfield;


  
    
    
}

@property(nonatomic,retain)NSString *getRiderId;
@property(nonatomic,retain)NSString *GetDriverId;
@property(nonatomic,retain)NSString *GetTripId;
@property(nonatomic,retain)NSString *GetFare;



- (IBAction)DoneButtonAction:(id)sender;
- (IBAction)ExpiryDateBtnAction:(id)sender;
- (IBAction)DonePaymentButtonAction:(id)sender;
- (IBAction)CardTypeBtn:(id)sender;



@end
