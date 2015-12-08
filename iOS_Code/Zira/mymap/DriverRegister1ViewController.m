//
//  DriverRegister1ViewController.m
//  mymap
//
//  Created by vikram on 24/11/14.
//

#import "DriverRegister1ViewController.h"
#import "DriverRegister2ViewController.h"


DriverRegister2ViewController *DriverRegister2ViewObj;

@interface DriverRegister1ViewController ()

@end

@implementation DriverRegister1ViewController
@synthesize comingFrom,userRecordArray;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    //self.title=@"VEHICLE INFORMATION";
    CountryNames=[[NSMutableArray alloc] init];
    countryIdarray=[[NSMutableArray alloc]init];
    StateNames=[[NSMutableArray alloc] init];
    StateIdsArray=[[NSMutableArray alloc] init];
    
    CommonArray=[[NSMutableArray alloc] init];
    VechiclesArray=[[NSMutableArray alloc] init];
    VechicleModelArray=[[NSMutableArray alloc] init];
    
    //filed years in year array
    VechicleYearArray=[NSMutableArray new];
    

    
    [self GetCountryList];
     self.view.userInteractionEnabled=NO;
    if ([comingFrom isEqualToString:@"DriverView"])
    {
        //NSLog(@"%@",userRecordArray);
        ChoseVechicleMakeTextField.text=[userRecordArray valueForKey:@"vechile_make"];
        ChoseVechicleModelTextField.text=[userRecordArray valueForKey:@"vechile_model"];
        ChoseVechicleYearTextField.text=[userRecordArray valueForKey:@"vechile_year"];
        ChoseVechiclePlateNoTextField.text=[userRecordArray valueForKey:@"licenseplatenumber"];
        ChoseLicsencePlateCntryTextField.text=[userRecordArray valueForKey:@"licenseplatecountry"];
        ChoseLicsencePlateStateTextField.text=[userRecordArray valueForKey:@"licenseplatestate"];
      
        cityIdstr=[userRecordArray valueForKey:@"cityId"];
       
        countryIdStr=[userRecordArray valueForKey:@"licenseplatecountryID"];
        
        StateIdStr=[userRecordArray valueForKey:@"licenseplatestateID"];
        VechicleModelIDStr=[userRecordArray valueForKey:@"vechile_modelID"];
        [kappDelegate HideIndicator];
        self.view.userInteractionEnabled=YES;

    }
    
   
 
    ScrollView.contentSize = CGSizeMake(320, 670);
    
    
    
    /* Setting Padding View to text Fields */
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    ChoseVechicleMakeTextField.leftView = paddingView;
    ChoseVechicleMakeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    ChoseVechicleModelTextField.leftView = paddingView1;
    ChoseVechicleModelTextField.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    ChoseVechicleYearTextField.leftView = paddingView2;
    ChoseVechicleYearTextField.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    ChoseVechiclePlateNoTextField.leftView = paddingView3;
    ChoseVechiclePlateNoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    ChoseLicsencePlateCntryTextField.leftView = paddingView4;
    ChoseLicsencePlateCntryTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    ChoseLicsencePlateStateTextField.leftView = paddingView5;
    ChoseLicsencePlateStateTextField.leftViewMode = UITextFieldViewModeAlways;
    /**/


    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
   // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];

    //Add Country Picker View
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PickerBackGroundView.frame=CGRectMake(0,  self.view.frame.size.height-236, self.view.frame.size.width, 236);
        }
        else
        {
            PickerBackGroundView.frame=CGRectMake(0, self.view.frame.size.height-236, self.view.frame.size.width, 236);
        }
    }
    
    [self.view addSubview:PickerBackGroundView];
    [self.view bringSubviewToFront:PickerBackGroundView];
    PickerBackGroundView.hidden=YES;

    CGRect frame = pickerView.frame;
    frame.size.width = self.view.frame.size.width;
    pickerView.frame = frame;
    
}
#pragma mark - Save And Continue Button Action

- (IBAction)SaveAndContinueButtonAction:(id)sender
{
    if ([ChoseVechicleMakeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Vechicle" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([ChoseVechicleModelTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Vechicle Model" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([ChoseVechicleYearTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Vechicle Year" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([ChoseVechiclePlateNoTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Vechicle Plate Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([ChoseLicsencePlateCntryTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Licsence Plate Countty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([ChoseLicsencePlateStateTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Licsence Plate State" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self MoveToDriverRegister2View];
}

#pragma mark - Done Button Action

- (IBAction)DoneButtonAction:(id)sender
{
    PickerBackGroundView.hidden=YES;
}

#pragma mark - Select Country Button Action

- (IBAction)SelectCountryBtn:(id)sender
{
    [ChoseVechicleMakeTextField resignFirstResponder];
    [ChoseVechicleModelTextField resignFirstResponder];
    [ChoseVechicleYearTextField resignFirstResponder];
    [ChoseVechiclePlateNoTextField resignFirstResponder];
    [ChoseLicsencePlateCntryTextField resignFirstResponder];
    [ChoseLicsencePlateStateTextField resignFirstResponder];
    
    
    TextFieldType=@"Country";
    [CommonArray removeAllObjects];
    CommonArray=[CountryNames mutableCopy];
    [pickerView reloadAllComponents];
    [pickerView selectRow:0 inComponent:0 animated:YES];
    PickerBackGroundView.hidden=NO;
    countryIdStr=[NSString stringWithFormat:@"%@",countryIdStr];
   
    if ([countryIdStr isEqualToString:@"(null)"]||[countryIdStr isEqualToString:@"(NULL)"]|| countryIdStr==nil) {
        countryIdStr=@"";
    }
    
    int countryIdStrLength=countryIdStr.length;

    if (CommonArray.count>0 && countryIdStrLength==0)
    {
        ChoseLicsencePlateCntryTextField.text=[CommonArray objectAtIndex:0];
        countryIdStr=[countryIdarray objectAtIndex:0];
        ChoseLicsencePlateStateTextField.text=@"";
    }
    
}

#pragma mark - Select State Button Action

- (IBAction)SelectState:(id)sender
{
    [ChoseVechicleMakeTextField resignFirstResponder];
    [ChoseVechicleModelTextField resignFirstResponder];
    [ChoseVechicleYearTextField resignFirstResponder];
    [ChoseVechiclePlateNoTextField resignFirstResponder];
    [ChoseLicsencePlateCntryTextField resignFirstResponder];
    [ChoseLicsencePlateStateTextField resignFirstResponder];
    
    if ([ChoseLicsencePlateCntryTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Country First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    TextFieldType=@"State";
    [self GetStateList];
    
    PickerBackGroundView.hidden=NO;
}

#pragma mark - Select Vechicle Button Action

- (IBAction)SelectVechicle:(id)sender
{
    TextFieldType=@"Vechicle";
    selectedIndex=0;
    
    [ChoseVechicleMakeTextField resignFirstResponder];
    [ChoseVechicleModelTextField resignFirstResponder];
    [ChoseVechicleYearTextField resignFirstResponder];
    [ChoseVechiclePlateNoTextField resignFirstResponder];
    [ChoseLicsencePlateCntryTextField resignFirstResponder];
    [ChoseLicsencePlateStateTextField resignFirstResponder];
    ChoseVechicleModelTextField.text=@"";
    ChoseVechicleYearTextField.text=@"";

   // [self GetVechiclesList];
    if (VechiclesArray.count==0)
    {
        [self GetVechiclesList];
    }
    
    if (VechiclesArray.count>0)
    {
        CommonArray=[VechiclesArray mutableCopy];
        [pickerView reloadAllComponents];
        PickerBackGroundView.hidden=NO;
     }
}

#pragma mark - Select Vechicle Year Button Action

- (IBAction)SelectVechicleYear:(id)sender
{
    TextFieldType=@"VechicleYear";
    [ChoseVechicleMakeTextField resignFirstResponder];
    [ChoseVechicleModelTextField resignFirstResponder];
    [ChoseVechicleYearTextField resignFirstResponder];
    [ChoseVechiclePlateNoTextField resignFirstResponder];
    [ChoseLicsencePlateCntryTextField resignFirstResponder];
    [ChoseLicsencePlateStateTextField resignFirstResponder];
    
    if ([ChoseVechicleModelTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Vechicle Model First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    [VechicleYearArray removeAllObjects];
   NSInteger YearValue= [components year]+1;
    
    NSInteger vechYearValue=[[tempYearArr objectAtIndex:ModelSelectedIndex] integerValue];
    if (vechYearValue==0)
    {
        vechYearValue=2005;
    }
    
    for (int i=vechYearValue; i<=YearValue; i++)
    {
        [VechicleYearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }

    
    [CommonArray removeAllObjects];
    
    CommonArray=[VechicleYearArray mutableCopy];
    [pickerView reloadAllComponents];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    PickerBackGroundView.hidden=NO;
    if ( CommonArray.count>0)
    {
        ChoseVechicleYearTextField.text=[CommonArray objectAtIndex:0];
    }
}

#pragma mark - Select Vechicle Model Button Action

- (IBAction)SelectVechicleModel:(id)sender
{
    
    TextFieldType=@"VechicleModel";
    ModelSelectedIndex=0;
    if ([ChoseVechicleMakeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Vechicle First" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [ChoseVechicleMakeTextField resignFirstResponder];
    [ChoseVechicleModelTextField resignFirstResponder];
    [ChoseVechicleYearTextField resignFirstResponder];
    [ChoseVechiclePlateNoTextField resignFirstResponder];
    [ChoseLicsencePlateCntryTextField resignFirstResponder];
    [ChoseLicsencePlateStateTextField resignFirstResponder];
    ChoseVechicleYearTextField.text=@"";
    
    tempYearArr=[[NSMutableArray alloc] init];
    VechicleModelIDsArray=[[NSMutableArray alloc]init];
    
    NSMutableArray *mainModelArr=[[NSMutableArray alloc] init];

  
    NSMutableArray *arr;
    for (int i=0;i< VechicleModelArray.count; i++)
    {
          NSString *vehicleMakeNameStr=[[VechicleModelArray objectAtIndex:i] valueForKey:@"vehicleMakeName"];
        
        if ([ChoseVechicleMakeTextField.text isEqualToString:vehicleMakeNameStr])
        {
             arr=[[VechicleModelArray objectAtIndex:i] valueForKey:@"listModalData"];
        }
        
    }
   // NSMutableArray *arr=[[VechicleModelArray objectAtIndex:selectedIndex] valueForKey:@"listModalData"];
   
    for (int i=0; i<[arr count]; i++)
    {
        NSString *model=[[arr objectAtIndex:i] valueForKey:@"vehiclemodalName"];
        [mainModelArr addObject:model];
        NSString *year=[[arr objectAtIndex:i] valueForKey:@"vehiclemodalYear"];
        [tempYearArr addObject:year];
        NSString *vehiclemodalId=[[arr objectAtIndex:i] valueForKey:@"vechilemodelID"];
        [VechicleModelIDsArray addObject:vehiclemodalId];
    }
    [CommonArray removeAllObjects];
    CommonArray=[mainModelArr mutableCopy];
    
    
    [pickerView reloadAllComponents];
    [pickerView selectRow:0 inComponent:0 animated:NO];
    PickerBackGroundView.hidden=NO;
    if (VechicleModelIDsArray.count>0)
    {
        ChoseVechicleModelTextField.text=[CommonArray objectAtIndex:0];
        VechicleModelIDStr=[VechicleModelIDsArray objectAtIndex:0];
 
    }
  }

#pragma mark - Move To Driver Register2 View

-(void)MoveToDriverRegister2View
{
    NSMutableDictionary *TempDict=[[NSMutableDictionary alloc] init];
    [TempDict setValue:ChoseVechicleMakeTextField.text forKey:@"ChoseVechicleMake"];
    [TempDict setValue:ChoseVechicleModelTextField.text forKey:@"ChoseVechicleModel"];
    [TempDict setValue:ChoseVechicleYearTextField.text forKey:@"ChoseVechicleYear"];
    [TempDict setValue:ChoseVechiclePlateNoTextField.text forKey:@"ChoseVechiclePlateNo"];
    [TempDict setValue:ChoseLicsencePlateCntryTextField.text forKey:@"ChoseLicsencePlateCntry"];
    [TempDict setValue:ChoseLicsencePlateStateTextField.text forKey:@"ChoseLicsencePlateState"];
    
    
    [TempDict setValue:VechicleModelIDStr forKey:@"ChoseVechicleModelID"];
    [TempDict setValue:countryIdStr forKey:@"ChoseLicsencePlateCntryID"];
    [TempDict setValue:StateIdStr forKey:@"ChoseLicsencePlateStateID"];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverRegister2ViewObj=[[DriverRegister2ViewController alloc]initWithNibName:@"DriverRegister2ViewController" bundle:nil];
 
        }
        else
        {
            DriverRegister2ViewObj=[[DriverRegister2ViewController alloc]initWithNibName:@"DriverRegister2ViewController" bundle:nil];
        }
        DriverRegister2ViewObj.StateNames=StateNames;
        DriverRegister2ViewObj.stateIdsArray=StateIdsArray;
        DriverRegister2ViewObj.Register1ViewDict=TempDict;
        if ([comingFrom isEqualToString:@"DriverView"])
        {
            NSString *str=@"DriverView";
            DriverRegister2ViewObj.userRecordArray=userRecordArray;
            DriverRegister2ViewObj.comingFrom=str;
        }
        [self.navigationController pushViewController:DriverRegister2ViewObj animated:YES];
        
    }
    
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==ChoseLicsencePlateCntryTextField)
    {
        PickerBackGroundView.hidden=NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [ChoseVechicleMakeTextField resignFirstResponder];
    [ChoseVechicleModelTextField resignFirstResponder];
    [ChoseVechicleYearTextField resignFirstResponder];
    [ChoseVechiclePlateNoTextField resignFirstResponder];
    [ChoseLicsencePlateCntryTextField resignFirstResponder];
    [ChoseLicsencePlateStateTextField resignFirstResponder];
    
    return YES;
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return CommonArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row  forComponent:(NSInteger)component
{
    return CommonArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    
    if ([TextFieldType isEqualToString:@"Country"])
    {
    NSString *countryValue=[CommonArray objectAtIndex:row];
    countryIdStr=[countryIdarray objectAtIndex:row];
    ChoseLicsencePlateCntryTextField.text=countryValue;
        StateIdStr=@"";
        ChoseLicsencePlateStateTextField.text=@"";

    }
    else if ([TextFieldType isEqualToString:@"State"])
    {
        NSString *stateValue=[CommonArray objectAtIndex:row];
        StateIdStr=[StateIdsArray objectAtIndex:row];
        ChoseLicsencePlateStateTextField.text=stateValue;
    }
    else if ([TextFieldType isEqualToString:@"Vechicle"])
    {
        selectedIndex=row;

        NSString *VechicleName=[CommonArray objectAtIndex:row];
        ChoseVechicleMakeTextField.text=VechicleName;
    }
    else if ([TextFieldType isEqualToString:@"VechicleYear"])
    {
        NSString *VechicleYear=[CommonArray objectAtIndex:row];
        ChoseVechicleYearTextField.text=VechicleYear;
   
    }
    else if ([TextFieldType isEqualToString:@"VechicleModel"])
    {
        ModelSelectedIndex=row;
        NSString *Model=[CommonArray objectAtIndex:row];
        ChoseVechicleModelTextField.text=Model;
        VechicleModelIDStr=[VechicleModelIDsArray objectAtIndex:row];
    }

}

#pragma mark - Get Country List

-(void)GetCountryList
{
    [kappDelegate ShowIndicator];
    self.view.userInteractionEnabled=NO;

    webservice=1;
 
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetCountryList",Kwebservices]];
    
    [self postWebservices];
}
#pragma mark - Get State List

-(void)GetStateList
{
    self.view.userInteractionEnabled=NO;
    [kappDelegate ShowIndicator];
    [pickerView reloadAllComponents];

    self.view.userInteractionEnabled=NO;
    webservice=2;
    
     jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:countryIdStr,@"countryname",nil];
    
     jsonRequest = [jsonDict JSONRepresentation];
    // NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetStateList",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Get Vechicle List

-(void)GetVechiclesList
{
    [kappDelegate ShowIndicator];
    self.view.userInteractionEnabled=NO;

    webservice=3;
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetVehicleModals",Kwebservices]];
    
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
    self.view.userInteractionEnabled=YES;

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
    
    NSArray*stateList=[userDetailDict valueForKey:@"ListState"];
    NSArray*ListCountry=[userDetailDict valueForKey:@"ListCountry"];
    NSArray*ListVehicleMakeName=[userDetailDict valueForKey:@"ListVehicleMakeName"] ;
  
    if (stateList.count!=0)
    {
        webservice=2;
    }
   else if (ListCountry.count!=0)
    {
        webservice=1;
    }
    else
    {
        webservice=3;
    }
    
    
    if (webservice==1)
    {
        self.view.userInteractionEnabled=YES;

        [self GetVechiclesList];

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

                [CountryNames removeAllObjects];
                [countryIdarray removeAllObjects];
                [CommonArray removeAllObjects];
                
              //  NSLog(@"%@",userDetailDict);
                NSMutableArray *tempArr=[userDetailDict valueForKey:@"ListCountry"];
                
                for (int i=0; i<[tempArr count]; i++)
                {
                    NSString *str=[[tempArr objectAtIndex:i] valueForKey:@"countryName"];
                     NSString *countryId=[NSString stringWithFormat:@"%ld",(long)[[[tempArr objectAtIndex:i] valueForKey:@"countryId"]integerValue]];
                    [CountryNames addObject:str];
                    [countryIdarray addObject:countryId];
                }
            }
        }
    }
    else if (webservice==2)
    {
        self.view.userInteractionEnabled=YES;

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
                [StateNames removeAllObjects];
                [StateIdsArray removeAllObjects];
                [CommonArray removeAllObjects];
              //  NSLog(@"%@",userDetailDict);
                NSMutableArray *tempArr=[userDetailDict valueForKey:@"ListState"];
                
                
                for (int i=0; i<[tempArr count]; i++)
                {
                    NSString *str=[[tempArr objectAtIndex:i] valueForKey:@"StateName"];
                    NSString *tempstateIdStr=[NSString stringWithFormat:@"%ld",(long)[[[tempArr objectAtIndex:i] valueForKey:@"StateId"]integerValue]];
                    [StateIdsArray addObject:tempstateIdStr];
                    [StateNames addObject:str];
                }
                
                CommonArray=[StateNames mutableCopy];
                if (CommonArray.count>0)
                {
                    [pickerView reloadAllComponents];
                  //  PickerBackGroundView.hidden=NO;
                    if ([NSString stringWithFormat:@"%@",StateIdStr].length==0)
                    {
                        ChoseLicsencePlateStateTextField.text=[CommonArray objectAtIndex:0];
                        StateIdStr=[StateIdsArray objectAtIndex:0];

                    }
                    [pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else if(StateIdsArray.count==0)
                {
                    PickerBackGroundView.hidden=YES;
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No State Available for this Country" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];

                }
                else{
                    PickerBackGroundView.hidden=YES;
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No city Available for this state" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
    }
    else if (webservice==3)
    {
        self.view.userInteractionEnabled=YES;

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
                countryIdStr=[NSString stringWithFormat:@"%@",countryIdStr];
                
                if ([countryIdStr isEqualToString:@"(null)"]||[countryIdStr isEqualToString:@"(NULL)"]|| countryIdStr==nil) {
                    countryIdStr=@"";
                }
                int countryIdStrLength=countryIdStr.length;

                if (countryIdStrLength!=0)
                {
                    [self GetStateList];
                }
                
                [VechiclesArray removeAllObjects];
              //  NSLog(@"%@",userDetailDict);
                NSMutableArray *tempArr=[userDetailDict valueForKey:@"ListVehicleMakeName"];
                VechicleModelArray=[tempArr mutableCopy];
              //  NSLog(@"VechicleModelArray>>%@",VechicleModelArray);
                
                for (int i=0; i<[tempArr count]; i++)
                {
                    NSString *str=[[tempArr objectAtIndex:i] valueForKey:@"vehicleMakeName"];
                    [VechiclesArray addObject:str];
                }
                [CommonArray removeAllObjects];
                CommonArray=[VechiclesArray mutableCopy];
                if (CommonArray.count>0)
                {
                    [pickerView reloadAllComponents];
                    //PickerBackGroundView.hidden=NO;
                    if (ChoseVechicleMakeTextField.text.length==0) {
                          ChoseVechicleMakeTextField.text=[CommonArray objectAtIndex:0];
                    }
                  
                    [pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else
                {
                    PickerBackGroundView.hidden=YES;
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No Vechicle Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
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
