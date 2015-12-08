//
//  PromoCodeViewController.h
//  mymap
//
//  Created by vikram on 28/11/14.
//

#import <UIKit/UIKit.h>

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"


@interface PromoCodeViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    IBOutlet UITextField *PromoCodeTextField;
    NSMutableArray  *PromoCodeListArray;
    IBOutlet UITableView *promoCodeTable;
    NSString *comingFrom;

}

@property(nonatomic,retain)NSString *comingFrom;

- (IBAction)CancelButtonAction:(id)sender;
- (IBAction)DoneButtonAction:(id)sender;

@end
