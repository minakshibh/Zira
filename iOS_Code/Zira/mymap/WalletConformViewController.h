//
//  WalletConformViewController.h
//  mymap
//
//  Created by vikram on 17/12/14.
//

#import <UIKit/UIKit.h>
#import "GoogleWalletSDK/GoogleWalletSDK.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"



@interface WalletConformViewController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UILabel *priceOutlet;
    NSDate *now;
    NSString *currentTime;
    NSString *WalletTransactionId;
    
    NSString *DriverId;
    NSString *RiderId;
    NSString *FareStr;



    
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

  
}
@property (nonatomic,retain)NSString *DriverId;
@property (nonatomic,retain)NSString *RiderId;
@property (nonatomic,retain)NSString *FareStr;


@property (nonatomic,retain)NSString *priceLabel;
@property(nonatomic, strong) GWAMaskedWallet *maskedWallet;

- (IBAction)confirmPurchase:(id)sender ;
- (IBAction)Change:(id)sender;


@end
