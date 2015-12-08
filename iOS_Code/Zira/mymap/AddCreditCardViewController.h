//
//  AddCreditCardViewController.h
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import <UIKit/UIKit.h>

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"


@interface AddCreditCardViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    NSString *CheckForAddNewCreditCard;
    
    NSMutableDictionary *FinalRegisterDict;
    IBOutlet UITextField *CreditCardNoTextField;
    IBOutlet UITextField *CVVTextField;
    IBOutlet UITextField *ExpiryDateTextField;
    IBOutlet UIView *PickerBgView;
    IBOutlet UIPickerView *PickerView;
    
    NSMutableArray *monthArray;
    NSMutableArray *yearArray;
    NSString *MonthYearValue;
    
    NSString *month;
    NSString *Year;
    NSString*ModifiedMonthYear;
    IBOutlet UILabel *backGrndLine;
    IBOutlet UIImageView *firstRound;
    IBOutlet UIImageView *secondRound;
    IBOutlet UIImageView *thirdRound;

    
}

@property(nonatomic,retain)NSMutableDictionary *FinalRegisterDict;
@property(nonatomic,retain)  NSString *CheckForAddNewCreditCard;

- (IBAction)DoneButtonAction:(id)sender;
- (IBAction)ExpiryDateBtnAction:(id)sender;
- (IBAction)DoneViewBtn:(id)sender;

@end
