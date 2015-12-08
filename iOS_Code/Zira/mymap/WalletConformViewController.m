//
//  WalletConformViewController.m
//  mymap
//
//  Created by vikram on 17/12/14.
//

#import "WalletConformViewController.h"
#import "GoogleWalletSDK/GoogleWalletSDK.h"
#import "HomeViewController.h"


@interface WalletConformViewController ()<GWAWalletClientDelegate>
{
    GWAWalletClient *_walletClient;
    GWAFullWallet *_fullWalletResponse;
    
}

@end

@implementation WalletConformViewController

@synthesize priceLabel,DriverId,RiderId,FareStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    // Ensure that the GWAWalletClient is setup with the delegate
    // in viewWillAppear:. This ensures that the correct delegate
    // gets the callbacks.
    _walletClient = [GWAWalletClient sharedInstance];
    _walletClient.environment = kGWAEnvironmentSandbox;
    _walletClient.delegate = self;
    
    NSString *str=[[NSUserDefaults standardUserDefaults] valueForKey:@"TotalFare"];
    priceOutlet.text=str;
    [super viewWillAppear:animated];
}

#pragma mark private implementation


- (IBAction)confirmPurchase:(id)sender
{
    NSMutableArray *lineItems = [[NSMutableArray alloc] init];
    
    GWALineItem *productLineItem =
    [[GWALineItem alloc] initWithItemDescription:@"Total Price"
                                       unitPrice:priceLabel
                                        quantity:@"1"];
    [lineItems addObject:productLineItem];
    
    GWACart *cart = [[GWACart alloc] initWithCurrencyCode:@"USD"
                                               totalPrice:priceLabel
                                                lineItems:lineItems];
    
    GWAFullWalletRequest *fullWalletRequest =
    [[GWAFullWalletRequest alloc] initWithGoogleTransactionId:self.maskedWallet.googleTransactionId
                                                         cart:cart
                                        merchantTransactionId:self.maskedWallet.merchantTransactionId];
    
    [_walletClient loadFullWallet:fullWalletRequest];

  
}

- (IBAction)Change:(id)sender
{
    NSLog(@"%@",self.maskedWallet.googleTransactionId);
    NSLog(@"%@",self.maskedWallet.merchantTransactionId);

    
    [_walletClient changeMaskedWalletWithGoogleTransactionId:self.maskedWallet.googleTransactionId
                                       merchantTransactionId:self.maskedWallet.merchantTransactionId];
}

#pragma mark - GWAWalletClientDelegate

- (void)walletClient:(GWAWalletClient *)walletClient
 didLoadMaskedWallet:(GWAMaskedWallet *)maskedWallet {
    // This callback and thus a GWAMaskedWallet can be returned in one of two ways.
    // 1. In response to a User clicking on changeMaskedWallet.
    // 2. In response to other UI that can be shown to a user
    // during a loadFullWallet:: call. The challenge is shown to the user based on
    // various factors used by the backing risk engine.
    // In either of the cases, the application should be prepared to update the masked wallet and
    // display the results to the user.
    self.maskedWallet = maskedWallet;
}

- (void)walletClient:(GWAWalletClient *)walletClient
didFailToLoadMaskedWalletWithError:(NSError *)error
{
    NSLog(@"Error");
}

- (void)walletClient:(GWAWalletClient *)walletClient didLoadFullWallet:(GWAFullWallet *)fullWallet
{
    // Set the full wallet response
    _fullWalletResponse = fullWallet;
    WalletTransactionId=fullWallet.googleTransactionId;
    NSLog(@"%@",WalletTransactionId);
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"View"];
    
    [self SendWalletTransactionToServer];

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Thanks For Using Google Wallet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag=1234;
   // [alert show];
    
}

#pragma mark - Send Google Wallet Data To Server

-(void)SendWalletTransactionToServer
{
    [kappDelegate ShowIndicator];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    
    webservice=1;
    
 jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:WalletTransactionId,@"transactionid",RiderId,@"riderid",DriverId,@"driverid",@"50",@"tripid",currentTime,@"starttime",currentTime,@"endtime",FareStr,@"fare",@"googlewallet",@"paymentmethod",currentTime,@"transactiondatetime",@"Done",@"paymentstatus",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/TripTransaction",Kwebservices]];
    
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
            webData = [NSMutableData data];
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data];
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
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Thanks For Using Google Wallet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=1234;
                 [alert show];
            }
        }
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1234)
    {
        if (buttonIndex==0)
        {
            [self MoveToHomeView];
        }
    }
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


- (void)walletClient:(GWAWalletClient *)walletClient
didFailToLoadFullWalletWithError:(NSError *)error {
    NSLog(@"Error");
}

- (void)walletClient:(GWAWalletClient *)walletClient userIsPreauthorized:(BOOL)userIsPreauthorized {
    NSLog(@"userIsPreauthorized %@", userIsPreauthorized ? @"YES" : @"NO");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
