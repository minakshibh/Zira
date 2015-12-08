//
//  CreditCardsSelectViewController.h
//  mymap
//
//  Created by vikram on 28/11/14.
//

#import <UIKit/UIKit.h>
#import "AddCreditCardViewController.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"


@interface CreditCardsSelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

    
    IBOutlet UITableView *CreditCardListingTable;
    NSMutableArray    *CreditCardsListArray;
    NSString *GetCardId;
    int selectedIndex;

    
}

- (IBAction)AddPaymentButtonAction:(id)sender;

@end
