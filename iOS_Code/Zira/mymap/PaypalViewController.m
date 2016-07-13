//
//  PaypalViewController.m
//  mymap
//
//  Created by vikram on 15/12/14.
//

#import "PaypalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WalletConformViewController.h"
#import "PayWithCreditCardViewController.h"
WalletConformViewController *WalletConformViewObj;

//google wallet
#import "BKSConstants.h"
#import "BKSUtils.h"
#import "GoogleWalletSDK/GoogleWalletSDK.h"

#import "UIImage+TKUtilities.h"
#import "HomeViewController.h"


#define kCountriesFileName @"countries.json"


#define kPayPalEnvironment PayPalEnvironmentSandbox




@interface PaypalViewController ()<GWAWalletClientDelegate>

- (void)configureView;

@property(nonatomic, strong, readwrite) IBOutlet UIButton *payNowButton;
@property(nonatomic, strong, readwrite) IBOutlet UIButton *payFutureButton;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;


@end

static NSString *const kSegueConfirm = @"Confirm";


@implementation PaypalViewController
{
    
    ///
    /// Wallet Client associated with the controller.
    ///
    GWAWalletClient *_walletClient;
    
    ///
    /// An instance of the Masked Wallet Request used that is set on the wallet
    /// button.
    ///
    GWAMaskedWalletRequest *_maskedWalletRequest;
    
    ///
    /// An instance variable that is saved in the delegate callback and used
    /// in the segue to the confirmation view controller.
    ///
    GWAMaskedWallet *_maskedWalletResponse;
    
    // Activity Indicated shown when the user clicks on the wallet button
    UIActivityIndicatorView *_activityIndicator;
}


@synthesize TripDetailArray,phoneNumber,firstName;
@synthesize TripId;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    //Tip View
    
    TipViewOutlet.layer.cornerRadius=5;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        TipPicker= [[UIPickerView alloc] initWithFrame:CGRectMake(148, 40, 50.0, 250)];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        TipPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(138, 5, 50.0, 250)];
        // this is iphone 4 xib
    }

    
    TipPicker.delegate = self;
    TipPicker.showsSelectionIndicator =YES;
    TipPicker.backgroundColor = [UIColor colorWithRed:(139.0/255.0) green:(139.0/255.0) blue:(139.0/255.0) alpha:1];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    rotate = CGAffineTransformScale(rotate, 1.0, 1.0);
    [TipPicker setTransform:rotate];
    // myPickerView.frame = CGRectMake(55, 95, 215, 10);
    TipPicker.layer.cornerRadius=2.0;
  //  [TipViewOutlet addSubview:TipPicker];

    
    tipArray=[[NSMutableArray alloc]init];
    for (int i=0;i<=200; i++)
    {
        [tipArray addObject:[NSString stringWithFormat:@"%d%%",i]];
    }

    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    TempVar=0;
    [[NSUserDefaults standardUserDefaults] setValue:@"Paypal" forKey:@"View"];
    ContactsStr=@"";

    self.navigationItem.hidesBackButton = YES;

    [super viewDidLoad];
    
    if (TripDetailArray.count>0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:TripDetailArray forKey:@"TripDetailArray"];
        FareStr=[TripDetailArray valueForKey:@"trip_total_amount"];
        FareValue=[NSDecimalNumber decimalNumberWithString:FareStr];
        
        DriverId=[TripDetailArray valueForKey:@"driverid"];
        RiderId=[TripDetailArray valueForKey:@"riderid"];
        
 
    }
    else
    {
        TripDetailArray=[[[NSUserDefaults standardUserDefaults] valueForKey:@"TripDetailArray"] mutableCopy];
        FareStr=[TripDetailArray valueForKey:@"trip_total_amount"];
        FareValue=[NSDecimalNumber decimalNumberWithString:FareStr];
        
        DriverId=[TripDetailArray valueForKey:@"driverid"];
        RiderId=[TripDetailArray valueForKey:@"riderid"];

    }
    
    NSLog(@"Driver Id == %@",DriverId);
    NSLog(@"Rider Id == %@",RiderId);
    NSLog(@"Fare Value == %@",FareStr);
    
    
    float  newFare=[FareStr floatValue];
    FareStr=[NSString stringWithFormat:@"%.1f",newFare];
    
    float fare=[[NSString stringWithFormat:@"%@",FareStr] floatValue];
    NSInteger safetyFee=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SafetyCharges"] integerValue];
    float total=fare;
    FareLbl.text=[NSString stringWithFormat:@"$%.1f",total];
    
    [TipPicker selectRow:10 inComponent:0 animated:YES];
    //set default value to picker
  //  NSString* tipStr =[tipArray objectAtIndex:10];
  //  NSString *clearStr=[tipStr  stringByReplacingOccurrencesOfString:@"%" withString:@""];
   // NSInteger DiscountValue=[clearStr integerValue];
  //  NSString *FairValue=FareLbl.text;
  //  NSInteger totalFair=[FairValue integerValue];
  //  NSInteger discountedFair=totalFair*DiscountValue/100;
  //  NSInteger FairValueAfterDiscounted=totalFair+discountedFair;
  //  TipLbl.text=[NSString stringWithFormat:@"%ld",(long)discountedFair];
    
    NSString* str = [NSString stringWithFormat:@"%@",FareLbl.text];
    str = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];
//    TotalFare.text=[NSString stringWithFormat:@"$%@",FareLbl.text];
    TotalFare.text=[NSString stringWithFormat:@"$%@",str];



    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];

    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.successView.hidden = YES;
    self.environment = kPayPalEnvironment;
    
    [self configureView];
    
    [self getCountryAndPhoneCode];

    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - get Country And Phone Code

-(void)getCountryAndPhoneCode
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    NSArray*countriesList = (NSArray *)parsedObject;
    
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    // NSString *currntCountryCode=@"IN";
    
    for (NSDictionary *countryCode1 in countriesList)
    {
        NSLog(@"%@",[countryCode1 valueForKey:@"code"]);
        if ([countryCode isEqualToString:[countryCode1 valueForKey:@"code"]])
        {
            phoneCode=[countryCode1 valueForKey:@"dial_code"];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
    
    //here google wallet
    
    
    
    _walletClient = [GWAWalletClient sharedInstance];
    // Change this environment property to point
    // to kGWAEnvironmentProduction for production.
    _walletClient.environment = kGWAEnvironmentSandbox;
    // optionally provide the email address of the user if known say via
    // Google Plus Sign In
    // Example: _walletClient.preferredAccount = @"foo@gmail.com";
    _walletClient.delegate = self;
    // Set the client id from your project on cloud.google.com/console
    _walletClient.clientId = @"955467156941-un6md3m672sr87c5n8rjvnaco327bh7a.apps.googleusercontent.com";
    // Set the client secret from your project on cloud.google.com/console
    _walletClient.clientSecret = @"2UE3CmPlM1vXnZmdU5s9_ckW";
    // Check for pre-auth
    [_walletClient checkForPreauthorization];

}
- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}

#pragma mark -  Send Button Action

- (IBAction)SendBtnAction:(id)sender
{
    if ([ContactsStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Contact No" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    [self SplitFare1];
 
}

#pragma mark -  Pay With Paypal Button Action

- (IBAction)PayWithPayPalBtnAction:(id)sender
{
    // Remove our last completed payment, just for demo purposes.
    self.resultText = nil;
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    float  newFare=[FareStr floatValue];
    FareStr=[NSString stringWithFormat:@"%.1f",newFare];
    PayPalItem *item1 = [PayPalItem itemWithName:@"Fare"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:FareStr]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];

    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    


    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Zira24/7";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - Split Fare Button Action

- (IBAction)SplitFare:(id)sender
{
//    ABPeoplePickerNavigationController *picker =
//    [[ABPeoplePickerNavigationController alloc] init];
//    picker.peoplePickerDelegate = self;
//    //headerplain.png
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];
//
//
//
//    
//   // [self presentModalViewController:picker animated:YES];
//    [self presentViewController:picker animated:YES completion:nil];
    
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Want to Split Fare?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No,Thanks", nil];
//    alert.tag=1908;
//    [alert show];
    
    PhoneNoArray=[[NSMutableArray alloc] init];
    ContactsStr=@"";
    
    TKPeoplePickerController *controller = [[TKPeoplePickerController alloc] initPeoplePicker];
    controller.actionDelegate = self;
    controller.navigationItem.hidesBackButton = YES;
    
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
   

}

#pragma mark - No Thanks Button Action

- (IBAction)NoThanksBtnAction:(id)sender
{
    [self DirectPaymentAfterRide];
}

#pragma mark - Done Tip View Button Action

- (IBAction)DoneTipViewBtn:(id)sender
{
    NSString* TipTextStr = [TipTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    TipTextField.text  = TipTextStr;
    if([TipTextStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Kindly enter the tip before continue..." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

        return;
    }
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([TipTextStr rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ZIRA" message:@"Enter only numeric values." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    [TipViewOutlet setHidden:YES];
}


#pragma mark - Debit Credit Card  Button Action

- (IBAction)DebitCreditCardsBtnAction:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
          PayWithCreditCardViewController *creditCardViewObj=[[PayWithCreditCardViewController alloc]initWithNibName:@"PayWithCreditCardViewController" bundle:nil];
            [self.navigationController pushViewController:creditCardViewObj animated:YES];
        }
        else
        {
            PayWithCreditCardViewController *creditCardViewObj=[[PayWithCreditCardViewController alloc]initWithNibName:@"PayWithCreditCardViewController" bundle:nil];
            creditCardViewObj.GetDriverId=DriverId;
            creditCardViewObj.getRiderId=RiderId;
            creditCardViewObj.GetFare=FareStr;
            creditCardViewObj.GetTripId=TripId;
            
            [self.navigationController pushViewController:creditCardViewObj animated:YES];
        }
    }

}


#pragma mark - TKContactsMultiPickerControllerDelegate

- (void)tkPeoplePickerController:(TKPeoplePickerController*)picker didFinishPickingDataWithInfo:(NSArray*)contacts
{
    NSLog(@"%@",contacts);
    
    contactsCount = contacts.count;
    
   // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ABAddressBookRef addressBook = ABAddressBookCreate();
        [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            TKContact *contact = (TKContact*)obj;
            NSLog(@"%@",contact.name);
            
            
            NSNumber *personID = [NSNumber numberWithInt:contact.recordID];
            ABRecordID abRecordID = (ABRecordID)[personID intValue];
            ABRecordRef abPerson = ABAddressBookGetPersonWithRecordID(addressBook, abRecordID);
            [self displayPerson:abPerson];
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CFRelease(addressBook);
        });
    });
    
    
}
- (void)displayPerson:(ABRecordRef)person
{
    TempVar=TempVar+1;
   // NSString* name = (__bridge  NSString*)ABRecordCopyValue(person,
                                                //   kABPersonFirstNameProperty);
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge  NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    CFRelease(phoneNumbers);
    
    if ([phone hasPrefix:@"0"])
    {
        phone = [phone substringWithRange:NSMakeRange(1, [phone length]-1)];
    }
    else if ([phone hasPrefix:phoneCode])
    {
        phone = [phone stringByReplacingOccurrencesOfString:phoneCode withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];

    }
    
    NSString *stringWithPhCode=[NSString stringWithFormat:@"%@%@",phoneCode,phone];
    [PhoneNoArray addObject:stringWithPhCode];
    NSLog(@"%@",PhoneNoArray);
    

    ContactsStr = [PhoneNoArray componentsJoinedByString:@","];
    ContactsStr=[ContactsStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    ContactsStr = [ContactsStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (contactsCount==TempVar)
    {
        [self SplitFare1];
    }
    
    
}


- (void)tkPeoplePickerControllerDidCancel:(TKPeoplePickerController*)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//#pragma mark - ABAddress Delegates
//
//- (void)peoplePickerNavigationControllerDidCancel:
//(ABPeoplePickerNavigationController *)peoplePicker
//{
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
//
//    //[self dismissModalViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
//{
//    
//    
//}
//- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
//{
//    [self displayPerson:person];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
//
//    //  [self dismissModalViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//  
//}
//
//- (BOOL)peoplePickerNavigationController:
//(ABPeoplePickerNavigationController *)peoplePicker
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person
//                                property:(ABPropertyID)property
//                              identifier:(ABMultiValueIdentifier)identifier
//{
//    return NO;
//}
//
//- (void)displayPerson:(ABRecordRef)person
//{
//    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
//                                                                    kABPersonFirstNameProperty);
//    self.firstName.text = name;
//    
//    NSString* phone = nil;
//    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
//                                                     kABPersonPhoneProperty);
//    if (ABMultiValueGetCount(phoneNumbers) > 0) {
//        phone = (__bridge_transfer NSString*)
//        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
//    } else {
//        phone = @"[None]";
//    }
//    self.phoneNumber.text = phone;
//    CFRelease(phoneNumbers);
//}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [TipTextField resignFirstResponder];
    
    return YES;
}// called when 'return' key pressed. return NO to ignore.

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    if (range.location>7)
    {
        return NO;
    }
    
    NSString* tipStr =[NSString stringWithFormat:@"%@%@",TipTextField.text,string];
    NSInteger tipFare=[tipStr integerValue];
    //$4.0
    
    NSString *FairValue=FareLbl.text;
    if ([FairValue rangeOfString:@"$"].location == NSNotFound) {
        NSLog(@"string does not contain substring");
    } else {
        FairValue = [FairValue componentsSeparatedByString:@"$"][1];
        NSLog(@"string contains substring!");
    }
    
    
    NSInteger normalFare=[FairValue integerValue];
    
    NSInteger tipAndNormalFare = tipFare+normalFare;
    
    NSString* str = [NSString stringWithFormat:@"%ld",(long)tipAndNormalFare];
    str = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];
//    TotalFare.text=[NSString stringWithFormat:@"$%ld",(long)tipAndNormalFare];
    TotalFare.text=[NSString stringWithFormat:@"$%@",str];
    
    if (range.length==1)
    {
        NSLog(@"BACK");
        TipTextField.text=@"";
        NSString* str = [NSString stringWithFormat:@"%ld",(long)normalFare];
        str = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];

//        TotalFare.text=[NSString stringWithFormat:@"$%ld",(long)normalFare];
        TotalFare.text=[NSString stringWithFormat:@"$%@",str];

    }
    return YES;
}



#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [TipTextField resignFirstResponder];
}


#pragma mark- Picker View Delegates and Data sources


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        NSString* tipStr =[tipArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        
        NSString *clearStr=[tipStr  stringByReplacingOccurrencesOfString:@"%" withString:@""];
        
        NSInteger DiscountValue=[clearStr integerValue];
    
    
        NSString *FairValue=FareLbl.text;
    
        NSInteger totalFair=[FairValue integerValue];
        
        NSInteger discountedFair=totalFair*DiscountValue/100;
        
        NSInteger FairValueAfterDiscounted=totalFair+discountedFair;
        TipLbl.text=[NSString stringWithFormat:@"$%ld",(long)discountedFair];
    
    
    NSString* str = [NSString stringWithFormat:@"%ld",(long)FairValueAfterDiscounted];
        str = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];

    NSString* str1 = [NSString stringWithFormat:@"%@",str];
    str1 = [str1 stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
        TotalFare.text=[NSString stringWithFormat:@"$%@",str1];
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 70;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView==TipPicker)
    {
        return 35;
    }
    else{
        return 50;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [tipArray objectAtIndex:row];
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  [tipArray count];
    
}
-(UIView *) pickerView: (UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
        CGRect rect = CGRectMake(0, 0, 80, 60);
        UILabel * label = [[UILabel alloc]initWithFrame:rect];
        label.opaque = NO;
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.clipsToBounds = YES;
        label.transform = CGAffineTransformRotate(label.transform, M_PI/2);
        //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 70, 44)];
        //    label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:16];
        label.text = [tipArray objectAtIndex:row];
        label.textColor = [UIColor blackColor];
        
        return label;
}



#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    TransactionId=[[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"];
    
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Your Payment has been sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
    [self SendPayPalTransactionToServer];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"View"];


}

#pragma mark - Helpers

- (void)showSuccess {
    self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}


#pragma mark - Send Paypal Data To Server

-(void)SendPayPalTransactionToServer
{
    [kappDelegate ShowIndicator];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];

    
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TransactionId,@"transactionid",RiderId,@"riderid",DriverId,@"driverid",TripId,@"tripid",currentTime,@"starttime",currentTime,@"endtime",FareStr,@"fare",@"paypal",@"paymentmethod",currentTime,@"transactiondatetime",@"Done",@"paymentstatus",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/TripTransaction",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark -Split Fare Web Service

-(void)SplitFare1
{
    [kappDelegate ShowIndicator];
    
    webservice=2;
    
    //for notif
//    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"+15625694901",@"phonenumber",@"4",@"userid",@"187",@"tripid",nil];
    
   NSString*PhoneNum= [[NSUserDefaults standardUserDefaults] valueForKey:@"Mobile"];
    
//jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"+919888348055",@"phonenumber",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"userid",TripId,@"tripid",nil];
    
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:PhoneNum,@"phonenumber",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"userid",TripId,@"tripid",nil];

    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SplitFare",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    //  data = [NSData dataWithContentsOfURL:urlString];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

#pragma mark - Response Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    UIAlertView *alert;
    alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Network Connection lost, Please Check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];

    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (webservice==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Transaction Saved On Server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=500;
                [alert show];
            }
        }
    }
    else if (webservice==2)
    {
        ContactsStr=@"";

        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                
            }
        }
    }
    else if (webservice==3)
   {
       if (![userDetailDict isKindOfClass:[NSNull class]])
       {
           NSString *messageStr=[userDetailDict valueForKey:@"message"];
           
           int result=[[userDetailDict valueForKey:@"result"]intValue];
           if (result==1)
           {
               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//               [self.navigationController popViewControllerAnimated:true];
//               [self.navigationController popViewControllerAnimated:true];
               [alert show];
           }
           else
           {
               NSLog(@"%@",userDetailDict);
               [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"View"];

               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Thanks For Payment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
               alert.tag=1909;
               [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EndRideTripId"];

               [alert show];
               
           }
       }
   }
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==500)
    {
        if (buttonIndex==0)
        {
            [self MoveToHomeView];
  
        }
    }
   else if (alertView.tag==1908)
    {
        if (buttonIndex==0)
        {
            PhoneNoArray=[[NSMutableArray alloc] init];
            ContactsStr=@"";
            
            TKPeoplePickerController *controller = [[TKPeoplePickerController alloc] initPeoplePicker];
            controller.actionDelegate = self;
            controller.navigationItem.hidesBackButton = YES;
            
            controller.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:controller animated:YES completion:nil];
  
        }
        else if (buttonIndex==1)
        {
            [self DirectPaymentAfterRide];
        }
    }
    
   else if (alertView.tag==1909)
   {
       if (buttonIndex==0)
       {
           [self MoveToHomeView];
           
       }
   }

}

#pragma mark - Direct Payment After Ride

-(void)DirectPaymentAfterRide
{
    [kappDelegate ShowIndicator];
    webservice=3;
    if (TripId.length==0)
    {
       TripId = [[NSUserDefaults standardUserDefaults]valueForKey:@"EndRideTripId"];
    }
    NSString* TipStr = [TipTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableDictionary *jsonDict1 = [[NSMutableDictionary alloc]init];
    [jsonDict1 setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]] forKey:@"UserId"];
     [jsonDict1 setObject:TipStr forKey:@"TipAmount"];
       [jsonDict1 setObject:TripId forKey:@"TripId"];
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"UserId",TipStr,@"TipAmount",TripId,@"TripId",nil];
    
  //  jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"UserId",@"284",@"TripId",nil];
    
    jsonRequest = [jsonDict1 JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/DeductPaymentEndRide",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Move to Home View

-(void)MoveToHomeView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            HomeViewController *HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:NO];
        }
        else
        {
           HomeViewController *HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:NO];
        }
    }
}


// Google wallet work //

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation))
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark private implementation

-(void)configureView {
    _maskedWalletRequest = [[GWAMaskedWalletRequest alloc] initWithCurrencyCode:@"USD"
                                                            estimatedTotalPrice:@"340"];
    _maskedWalletRequest.phoneNumberRequired = YES;
    _maskedWalletRequest.shippingAddressRequired = YES;
    _walletButton.maskedWalletRequest = _maskedWalletRequest;
}
- (IBAction)walletButtonClicked:(id)sender
{
    [_walletButton setEnabled:NO];

}

#pragma mark - GWAWalletClientDelegate


- (void)walletClient:(GWAWalletClient *)walletClient
 didLoadMaskedWallet:(GWAMaskedWallet *)maskedWallet
{
        [_walletButton setEnabled:YES];
        _maskedWalletResponse = maskedWallet;
         [self MoveToDetailView];
    //    [self performSegueWithIdentifier:kSegueConfirm sender:self];
}
-(void)MoveToDetailView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            WalletConformViewObj=[[WalletConformViewController alloc]initWithNibName:@"WalletConformViewController" bundle:nil];
            WalletConformViewObj.priceLabel=@"137";
            WalletConformViewObj.maskedWallet=_maskedWalletResponse;
            WalletConformViewObj.DriverId=DriverId;
            WalletConformViewObj.RiderId=RiderId;
            WalletConformViewObj.FareStr=FareStr;
            [self.navigationController pushViewController:WalletConformViewObj animated:YES];
        }
        else
        {
            WalletConformViewObj=[[WalletConformViewController alloc]initWithNibName:@"WalletConformViewController" bundle:nil];
            WalletConformViewObj.priceLabel=@"137";
            WalletConformViewObj.maskedWallet=_maskedWalletResponse;
            WalletConformViewObj.DriverId=DriverId;
            WalletConformViewObj.RiderId=RiderId;
            WalletConformViewObj.FareStr=FareStr;
            [self.navigationController pushViewController:WalletConformViewObj animated:YES];
        }
    }

    
}

- (void)walletClient:(GWAWalletClient *)walletClient
didFailToLoadMaskedWalletWithError:(NSError *)error
{
    
}
- (void)walletClient:(GWAWalletClient *)walletClient
   didLoadFullWallet:(GWAFullWallet *)fullWallet
{
    
}

- (void)walletClient:(GWAWalletClient *)walletClient
didFailToLoadFullWalletWithError:(NSError *)error {
    
}

- (void)walletClient:(GWAWalletClient *)walletClient userIsPreauthorized:(BOOL)userIsPreauthorized
{
    NSLog(@"userIsPreauthorized %@", userIsPreauthorized ? @"YES" : @"NO");
}


#pragma mark -  Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnNoTip:(id)sender {
    
    TipTextField.text = @"0";
    
    [TipViewOutlet setHidden:YES];
}
@end
