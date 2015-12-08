//
//  AddCreditCardViewController.m
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import "AddCreditCardViewController.h"

@interface AddCreditCardViewController ()

@end

@implementation AddCreditCardViewController
@synthesize FinalRegisterDict,CheckForAddNewCreditCard;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    NSLog(@"%@",FinalRegisterDict);

    if ([CheckForAddNewCreditCard isEqualToString:@"YES"])
    {
        self.title=@"ADD PAYMENT";
        backGrndLine.hidden=YES;
        firstRound.hidden=YES;
        secondRound.hidden=YES;
        thirdRound.hidden=YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];

    }

    //Add  Picker View
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 480)
    {
        PickerBgView.frame=CGRectMake(0, 300, self.view.frame.size.width, 236);
        
    }
    else
    {
        PickerBgView.frame=CGRectMake(0,350, self.view.frame.size.width, 236);

    }

    
    [self.view addSubview:PickerBgView];
    [self.view bringSubviewToFront:PickerBgView];
    PickerBgView.hidden=YES;

  //  self.title=@"LINK PAYMENT";
    self.navigationItem.hidesBackButton = YES;
    
//    // Right Bar Button Item //
//    
//    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    RightButton.frame = CGRectMake(0, 0, 60, 40);
//    [RightButton setTitle:@"DONE" forState:UIControlStateNormal];
//    
//    // [RightButton setImage:[UIImage imageNamed:@"save_btn.png"] forState:UIControlStateNormal];
//    //[RightButton setImage:[UIImage imageNamed:@"save_btn.png"] forState:UIControlStateHighlighted];
//    [RightButton addTarget:self action:@selector(Done1ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
//    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    
    // Left Bar Button Item //
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 20, 25);
   // [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;

    
   // monthArray=[NSMutableArray new];
   // NSArray *mnthNameArray=[NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    monthArray=[[NSMutableArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    
    yearArray=[NSMutableArray new];
    for (int i=2015; i<=2170; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    month=[monthArray objectAtIndex:0];
    Year=[yearArray objectAtIndex:0];
    MonthYearValue=[NSString stringWithFormat:@"%@%@",month,Year];
    ModifiedMonthYear=[NSString stringWithFormat:@"%@/%@",month,[Year substringFromIndex: [Year length] - 2]];


    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Done Button Action

-(IBAction)Done1ButtonAction:(id)sender
{
    if (CreditCardNoTextField.text.length<16)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Valid Credit Card Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
    else
    {
        if ([CheckForAddNewCreditCard isEqualToString:@"YES"])
        {
            
            [self AddNewCreditCard];
            [CreditCardNoTextField resignFirstResponder];
        }
        else
        {
        [kappDelegate ShowIndicator];
        [self ValidateCreditCard];
        [CreditCardNoTextField resignFirstResponder];
        }

    }
    
}

- (IBAction)DoneButtonAction:(id)sender
{
    PickerBgView.hidden=YES;
}

#pragma mark - Expiry Date Button Action

- (IBAction)ExpiryDateBtnAction:(id)sender
{
    [CreditCardNoTextField resignFirstResponder];
    [CVVTextField resignFirstResponder];
    PickerBgView.hidden=NO;
    ExpiryDateTextField.text=ModifiedMonthYear;
}

- (IBAction)DoneViewBtn:(id)sender
{
    if (CreditCardNoTextField.text.length<16)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Valid Credit Card Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   else if (CVVTextField.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Credit Card CVV Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   else if (ExpiryDateTextField.text.length==0)
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Credit Card expiry date." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       [alert show];
   }
    else
    {
        if ([CheckForAddNewCreditCard isEqualToString:@"YES"])
        {
            [kappDelegate ShowIndicator];
            [self AddNewCreditCard];
            [CreditCardNoTextField resignFirstResponder];
        }
        else
        {
            [kappDelegate ShowIndicator];
            [self ValidateCreditCard];
            [CreditCardNoTextField resignFirstResponder];
        }
    }
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [CreditCardNoTextField resignFirstResponder];
    [CVVTextField resignFirstResponder];
}

#pragma mark - Cancel Button Action

-(IBAction)CancelButtonAction:(id)sender
{
    if ([CheckForAddNewCreditCard isEqualToString:@"YES"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Do You Want To Cancel Your Registration?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag=1;
    [alert show];
        
    }
    
}

#pragma mark - Validate Credit Card

-(void)ValidateCreditCard
{
    webservice=1;
   jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:CreditCardNoTextField.text,@"creditcardnumber",MonthYearValue,@"creditcardexpiry",CVVTextField.text,@"cvv",nil];
    
  //  jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:CreditCardNoTextField.text,@"creditcardnumber",@"",@"creditcardexpiry",@"",@"cvv",nil];

    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/ValidateCreditCard",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Add New Credit Card

-(void)AddNewCreditCard
{
    webservice=3;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",CreditCardNoTextField.text,@"creditcardnumber",MonthYearValue,@"creditcardexpiry",CVVTextField.text,@"cvv",@"-1",@"cardid",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AddCreditCard",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Register New User

-(void)RegisterNewUser
{
    NSString *email=[FinalRegisterDict valueForKey:@"EmailId"];
    NSString *FirstName=[FinalRegisterDict valueForKey:@"FirstName"];
    NSString *ImageCode=[FinalRegisterDict valueForKey:@"ImageCode"];
    NSString *LastName=[FinalRegisterDict valueForKey:@"LastName"];
    NSString *Mobile=[FinalRegisterDict valueForKey:@"Mobile"];
    NSString *Password=[FinalRegisterDict valueForKey:@"Password"];
    
    NSLog(@"%@",FinalRegisterDict);
    webservice=2;
jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"-1",@"userid",email,@"email",ImageCode,@"ImageName",FirstName,@"firstname",LastName,@"lastname",Password,@"password",Mobile,@"phonenumber",CreditCardNoTextField.text,@"creditcardnumber",MonthYearValue,@"creditcardexpiry",CVVTextField.text,@"cvv",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterRider",Kwebservices]];
    
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
    
    if ([webData length]==0)
        return;
    
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
                if ([[userDetailDict valueForKey:@"isvalid"] isEqualToString:@"false"])
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Your Credit Card Number Is Not Valid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    CreditCardNoTextField.text=@"";
                    [CreditCardNoTextField becomeFirstResponder];
                    
                    [CVVTextField resignFirstResponder];
                    [ExpiryDateTextField resignFirstResponder];
                }
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                if ([kappDelegate checkForInternetConnection]==YES)
                {
                    [kappDelegate ShowIndicator];
                    [self RegisterNewUser];
                }
            }
        }
        
    }
   else if (webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"zira24/7" message:messageStr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
            else
            {
                if (messageStr.length==0)
                {
                      UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"zira24/7" message:@"Internet connetion failed Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"zira24/7" message:@"Registration Successfull" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=2;
                [alert show];

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
               UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"zira24/7" message:messageStr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
               [alert show];
               CreditCardNoTextField.text=@"";
               [CreditCardNoTextField becomeFirstResponder];
           }
           else
           {
               
               UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"zira24/7" message:@"Your card is added successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
               [alert show];
               CreditCardNoTextField.text=@"";
               [self.view endEditing:YES];
               
               CVVTextField.text=@"";
               ExpiryDateTextField.text=@"";
               
               
               NSLog(@"%@",userDetailDict);
           }
       }
       
   }
    
}

#pragma mark - UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==CreditCardNoTextField)
    {
    if(range.location==16)
    {
        return NO;
    }
    else
    {
        return YES;
    }
        
    }
    else
    {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [CreditCardNoTextField resignFirstResponder];
    [CVVTextField resignFirstResponder];
    [ExpiryDateTextField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2)
    {
        if (buttonIndex==0) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
        }
    }
   else if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
        }
    }
}

#pragma mark - Picker View Delegate
#pragma mark -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
        return [monthArray count];
    else
        return [yearArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0)
    {
        return [monthArray objectAtIndex:row];
    }
    else
    {
        return [yearArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
       
    if (component==0)
    {
        month=[monthArray objectAtIndex:row];
        
       // MonthYearValue=[NSString stringWithFormat:@"%@ %@",month,Year];
       // ExpiryDateTextField.text=MonthYearValue;
    }
    else
    {
        Year=[yearArray objectAtIndex:row];
        
    }
  
    MonthYearValue=[NSString stringWithFormat:@"%@%@",month,Year];
    ModifiedMonthYear=[NSString stringWithFormat:@"%@/%@",month,[Year substringFromIndex: [Year length] - 2]];

    ExpiryDateTextField.text=ModifiedMonthYear;

}



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
