//
//  PayWithCreditCardViewController.m
//  mymap
//
//  Created by vikram on 31/12/14.
//

#import "PayWithCreditCardViewController.h"
#import "HomeViewController.h"

@interface PayWithCreditCardViewController ()

@end

@implementation PayWithCreditCardViewController
@synthesize GetDriverId,getRiderId,GetTripId,GetFare;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    DropDownTableView.hidden=YES;
    DropDownTableView.layer.cornerRadius=8;
    flag=1;

    
    //Add  Picker View
    PickerBgView.frame=CGRectMake(0, 360, 320, 236);
    [self.view addSubview:PickerBgView];
    [self.view bringSubviewToFront:PickerBgView];
    PickerBgView.hidden=YES;
    
//    self.navigationItem.hidesBackButton = YES;
    
    CardTypeArray=[[NSMutableArray alloc] initWithObjects:@"Visa",@"Mastercard",@"American Express", nil];
    
    monthArray=[[NSMutableArray alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    
    yearArray=[NSMutableArray new];
    for (int i=1970; i<=2170; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    month=[monthArray objectAtIndex:0];
    Year=[yearArray objectAtIndex:0];
    MonthYearValue=[NSString stringWithFormat:@"%@/%@",month,Year];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Done Button Action

- (IBAction)DoneButtonAction:(id)sender
{
    PickerBgView.hidden=YES;
}

#pragma mark - Expiry Date Button Action

- (IBAction)ExpiryDateBtnAction:(id)sender
{
    PickerBgView.hidden=NO;
    ExpiryDateTextField.text=MonthYearValue;
    
}

#pragma mark - Done Payment Button Action

- (IBAction)DonePaymentButtonAction:(id)sender
{
    if ([CreditCardNoTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Credit Card No." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    if ([CVVTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter CVV No." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if ([ExpiryDateTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Card Expiry Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if ([CardTypeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Card Type" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    [self PayWithCard];
}

#pragma mark - Card Type Button Action

- (IBAction)CardTypeBtn:(id)sender
{
    {
        if (flag==1)
        {
            flag=0;
            DropDownTableView.hidden=NO;
        }
        else
        {
            flag=1;
            DropDownTableView.hidden=YES;
        }
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CardTypeArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
    cell.textLabel.font=[UIFont fontWithName:@"Arial" size:16];
    cell.backgroundColor=[UIColor lightGrayColor];
    cell.textLabel.text = [CardTypeArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cardType=[CardTypeArray objectAtIndex:indexPath.row];
    CardTypeTextField.text=cardType;
    DropDownTableView.hidden=YES;
    flag=1;
    
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
    [FirstNameTextfield resignFirstResponder];
    [LastNameTextfield resignFirstResponder];
    
    return YES;
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
    
    MonthYearValue=[NSString stringWithFormat:@"%@/%@",month,Year];
    ExpiryDateTextField.text=MonthYearValue;
    
}

#pragma mark - Add New Credit Card

-(void)PayWithCard
{
    [kappDelegate ShowIndicator];
    
    NSString *ExpDateVal=ExpiryDateTextField.text;
    ExpDateVal=[ExpDateVal stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    float  newFare=[GetFare floatValue];
    GetFare=[NSString stringWithFormat:@"%.2f",newFare];
    
//    NSString *cardType=CardTypeTextField.text;
//    if ([cardType isEqualToString:@"American Express"])
//    {
//        cardType=@"Amex";
//    }

    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:CreditCardNoTextField.text,@"CCNumber",ExpDateVal,@"ExpDate",CVVTextField.text,@"CVV",GetFare,@"Amount",getRiderId,@"riderid",GetDriverId,@"driverid",GetTripId,@"tripid",FirstNameTextfield.text,@"FirstName",LastNameTextfield.text,@"LastName",nil];
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/PayThroughCreditCard",Kwebservices]];
    
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
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Your Credit Card Number Is Not Valid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    CreditCardNoTextField.text=@"";
                    [CreditCardNoTextField becomeFirstResponder];
                    
                    [CVVTextField resignFirstResponder];
                    [ExpiryDateTextField resignFirstResponder];
                    
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Thanks For Payment" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=5678;
                [alert show];

            }
        }
        
    }
    
}

#pragma mark - UIAlert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==5678)
    {
        if (buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"View"];
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


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
