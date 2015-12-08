//
//  RegistrarionViewController.h
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import <UIKit/UIKit.h>
#import "Registrartion2ViewController.h"

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"


@interface RegistrarionViewController : UIViewController<UITextFieldDelegate>

{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

    
    IBOutlet UITextField *EmailTextField;
    IBOutlet UITextField *PasswordTextField;
    IBOutlet UITextField *MobileTextField;
    
    NSString *phoneCode;
    
}

@end
