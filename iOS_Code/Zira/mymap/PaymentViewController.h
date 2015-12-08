//
//  PaymentViewController.h
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import <UIKit/UIKit.h>
#import "AddCreditCardViewController.h"

@interface PaymentViewController : UIViewController<UIAlertViewDelegate>

{
    
    NSMutableDictionary *AllRegisterDetailsDict;
    
}
- (IBAction)AddCreditCard:(id)sender;
- (IBAction)AddPrepaidWallet:(id)sender;

@property(nonatomic,retain)NSMutableDictionary *AllRegisterDetailsDict;
@end
