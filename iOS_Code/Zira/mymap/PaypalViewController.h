//
//  PaypalViewController.h
//  mymap
//
//  Created by vikram on 15/12/14.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

//google wallet
#import "CatalogItem.h"
#import "GoogleWalletSDK/GWAWalletButton.h"
#import <AddressBookUI/AddressBookUI.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

#import "TKPeoplePickerController.h"



@interface PaypalViewController : UIViewController<PayPalPaymentDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate, TKPeoplePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    NSString *TransactionId;
    
    NSDate *now;
    NSString *currentTime;
    
    NSMutableArray  *TripDetailArray;
    NSDecimalNumber *FareValue;
    
    NSString *DriverId;
    NSString *RiderId;
    NSString *TripId;
    NSMutableArray *PhoneNoArray;
    NSString *ContactsStr;
    
    NSString *phoneCode;
    IBOutlet UIButton *sendBtn;
    NSString *FareStr;
    int contactsCount;
    int TempVar;
    IBOutlet UILabel *FareLbl;
    IBOutlet UILabel *TipLbl;
    IBOutlet UILabel *TotalFare;
    IBOutlet UIView *TipViewOutlet;
    UIPickerView *TipPicker;
    NSMutableArray *tipArray;
    IBOutlet UITextField *TipTextField;
  
}
- (IBAction)btnNoTip:(id)sender;

@property(nonatomic,retain)NSMutableArray  *TripDetailArray;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(nonatomic,retain)NSString *TripId;

//google wallet
@property(nonatomic, strong) CatalogItem *catalogItem;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, weak) IBOutlet UILabel *productPriceLabel;
@property(nonatomic, weak) IBOutlet UILabel *estimatedShippingCostLabel;
@property(nonatomic, weak) IBOutlet GWAWalletButton *walletButton;

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;


- (IBAction)SendBtnAction:(id)sender;

- (IBAction)PayWithPayPalBtnAction:(id)sender;
- (IBAction)SplitFare:(id)sender;
- (IBAction)DebitCreditCardsBtnAction:(id)sender;
- (IBAction)NoThanksBtnAction:(id)sender;
- (IBAction)DoneTipViewBtn:(id)sender;

@end
