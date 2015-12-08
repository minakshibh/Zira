//
//  ForgotPasswordViewController.h
//  UberLikeApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"


@interface ForgotPasswordViewController : UIViewController <UITextFieldDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;

    
     IBOutlet UITextField *emailTextField;
}
- (IBAction)DoneButtonAction:(id)sender;

@end
