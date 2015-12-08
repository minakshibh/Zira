//
//  SupportViewController.h
//  mymap
//
//  Created by vikram on 28/01/15.
//  Copyright (c) 2015 Impinge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface SupportViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

{
    
}
- (IBAction)EmailBtn:(id)sender;
- (IBAction)MessageBtn:(id)sender;
- (IBAction)CallBtn:(id)sender;
- (IBAction)Email2Button:(id)sender;
- (IBAction)privacyPolicyBtn:(id)sender;
- (IBAction)helpButton:(id)sender;
- (IBAction)termsConditionsBtn:(id)sender;
- (IBAction)jobsActionBtn:(id)sender;



@end
