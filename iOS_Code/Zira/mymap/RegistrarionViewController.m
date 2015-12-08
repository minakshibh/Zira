//
//  RegistrarionViewController.m
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import "RegistrarionViewController.h"
Registrartion2ViewController *Registrartion2ViewObj;

#define kCountriesFileName @"countries.json"

@interface RegistrarionViewController ()

@end

@implementation RegistrarionViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

   // self.title=@"Zira24/7";
    self.navigationItem.hidesBackButton = YES;
    
    // Right Bar Button Item //
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    RightButton.frame = CGRectMake(0, 0, 20, 25);
   // [RightButton setTitle:@"Next" forState:UIControlStateNormal];
    
    [RightButton setImage:[UIImage imageNamed:@"rightarrow.png"] forState:UIControlStateNormal];
    [RightButton setImage:[UIImage imageNamed:@"rightarrow.png"] forState:UIControlStateHighlighted];
    [RightButton addTarget:self action:@selector(NextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    
    // Left Bar Button Item //
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 20, 25);
    //[leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;

    
    [self getCountryAndPhoneCode];
     [super viewDidLoad];
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

#pragma mark - Next Button Action

-(IBAction)NextButtonAction:(id)sender
{
    if (![self validateEmailWithString:EmailTextField.text]==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Check Your Email Address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([PasswordTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Check Your Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if ([MobileTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Check Your Mobile Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    [self .view endEditing:YES];
    [kappDelegate ShowIndicator];
    [self ValidateEmailMobile];
      //[self MoveToRegisterView];
}

#pragma mark - Cancel Button Action

-(IBAction)CancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Validation for email

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [EmailTextField resignFirstResponder];
    [PasswordTextField resignFirstResponder];
    [MobileTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - Move to Register View

-(void)MoveToRegisterView
{
    //Mobile No and Country code
    
    NSString *MobNoAndCode=[NSString stringWithFormat:@"%@%@",phoneCode,MobileTextField.text];

    NSMutableDictionary *TempDict=[[NSMutableDictionary alloc] init];
    [TempDict setValue:EmailTextField.text forKey:@"EmailId"];
    [TempDict setValue:PasswordTextField.text forKey:@"Password"];
    [TempDict setValue:MobNoAndCode forKey:@"Mobile"];

    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            Registrartion2ViewObj=[[Registrartion2ViewController alloc]initWithNibName:@"Registrartion2newViewController_iphone4" bundle:nil];
            Registrartion2ViewObj.Register1ViewDict=TempDict;
            [self.navigationController pushViewController:Registrartion2ViewObj animated:YES];
 
        }
        else
        {
            Registrartion2ViewObj=[[Registrartion2ViewController alloc]initWithNibName:@"Registrartion2ViewController" bundle:nil];
            Registrartion2ViewObj.Register1ViewDict=TempDict;
            [self.navigationController pushViewController:Registrartion2ViewObj animated:YES];
        }
    }
}

#pragma mark - Validate Email And Mobile

-(void)ValidateEmailMobile
{
    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:EmailTextField.text,@"useremail",PasswordTextField.text,@"password",MobileTextField.text,@"mobile",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterationValidate",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    if (webservice!=4) {
        // [self.activityIndicatorObject startAnimating];
        // self.view.userInteractionEnabled=NO;
        //self.disablImg.hidden=NO;
    }
    
    //NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchPendingRideRequests",Kwebservices]];
    
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
   // [alert show];
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
    // [self.activityIndicatorObject stopAnimating];
    // self.view.userInteractionEnabled=YES;
    // self.disablImg.hidden=YES;
    
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
           // NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                if ([[userDetailDict valueForKey:@"emailExistence"] integerValue]==1)
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Email Id Already Exist" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    EmailTextField.text=@"";
                    [EmailTextField becomeFirstResponder];
                    
                }
                
                if ([[userDetailDict valueForKey:@"phoneNumberExistence"] integerValue]==1)
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Phone Number is Already Exist" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    MobileTextField.text=@"";
                    [MobileTextField becomeFirstResponder];
                }
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                [self MoveToRegisterView];
                
            }
        }
        
    }
    
}
#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
