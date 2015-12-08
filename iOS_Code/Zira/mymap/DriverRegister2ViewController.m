//
//  DriverRegister2ViewController.m
//  mymap
//
//  Created by vikram on 24/11/14.

//

#import "DriverRegister2ViewController.h"

#import "DriverRegister3ViewController.h"

DriverRegister3ViewController  *DriverRegister3View;

@interface DriverRegister2ViewController ()

@end

@implementation DriverRegister2ViewController

@synthesize StateNames,Register1ViewDict;
@synthesize comingFrom,userRecordArray,stateIdsArray;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    if ([comingFrom isEqualToString:@"DriverView"])
    {
        NSLog(@"%@",userRecordArray);
        Address1TextField.text=[userRecordArray valueForKey:@"address"];
        ZipCodeTextField.text=[userRecordArray valueForKey:@"zipcode"];
        CityTextField.text=[userRecordArray valueForKey:@"city"];
        StateTextField.text=[userRecordArray valueForKey:@"state"];
        DrivingLicsenceNoTextField.text=[userRecordArray valueForKey:@"drivinglicensenumber"];
        DrivingLicsenceStateTextField.text=[userRecordArray valueForKey:@"drivinglicensestate"];
        NSString *drivinglicenseexpirationdatestr=[userRecordArray valueForKey:@"drivinglicenseexpirationdate"];
        NSString *dateofbirthStr=[userRecordArray valueForKey:@"dateofbirth"];
        
        NSString *yearStr = [dateofbirthStr substringWithRange:NSMakeRange(0, 4)];
        NSString*monthStr = [dateofbirthStr substringWithRange:NSMakeRange(4,2)];
        NSString*datestr=   [dateofbirthStr substringWithRange:NSMakeRange(6,2 )];

        dateofbirthStr=[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,datestr];
        
        
        yearStr = [drivinglicenseexpirationdatestr substringWithRange:NSMakeRange(0, 4)];
        monthStr = [drivinglicenseexpirationdatestr substringWithRange:NSMakeRange(4,2)];
        datestr=   [drivinglicenseexpirationdatestr substringWithRange:NSMakeRange(6,2 )];
        
        drivinglicenseexpirationdatestr=[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,datestr];

        
      
        
        
        DrivingLicsenceExpDateTextField.text=[NSString stringWithFormat:@"%@",drivinglicenseexpirationdatestr];
        DOBTextField.text=[NSString stringWithFormat:@"%@",dateofbirthStr];
        SocialSecurityNoTextField.text=[userRecordArray valueForKey:@"socialsecuritynumber"];
        stateIdStr=[userRecordArray valueForKey:@"stateID"];
        DrivingLicsenceStateIDSTR=[userRecordArray valueForKey:@"drivinglicensestateID"];
        [kappDelegate HideIndicator];
        cityIDstr = [userRecordArray valueForKey:@"cityId"];

        self.view.userInteractionEnabled=YES;
      //  [self GetCityList];
    }
    
    
    cityIdsArray =[[NSMutableArray alloc] init];
    cityNames =[[NSMutableArray alloc] init];

    
  //  self.title=@"BACKGROUND CHECK";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            ScrollView.contentSize = CGSizeMake(320, 850);

        }
        else
        {
            ScrollView.contentSize = CGSizeMake(320, 750);

        }
    }

    [ScrollView addSubview:DetailsView];
    
    

    [self.view addSubview:PickerBackGroundView];
    [self.view bringSubviewToFront:PickerBackGroundView];
    PickerBackGroundView.hidden=YES;
    
   


    
    /* Setting Padding View to text Fields */
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    Address1TextField.leftView = paddingView;
    Address1TextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    ZipCodeTextField.leftView = paddingView2;
    ZipCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    CityTextField.leftView = paddingView3;
    CityTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    StateTextField.leftView = paddingView4;
    StateTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    DrivingLicsenceNoTextField.leftView = paddingView5;
    DrivingLicsenceNoTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    DrivingLicsenceStateTextField.leftView = paddingView6;
    DrivingLicsenceStateTextField.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    DrivingLicsenceExpDateTextField.leftView = paddingView7;
    DrivingLicsenceExpDateTextField.leftViewMode = UITextFieldViewModeAlways;

    
    UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    DOBTextField.leftView = paddingView8;
    DOBTextField.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    SocialSecurityNoTextField.leftView = paddingView9;
    SocialSecurityNoTextField.leftViewMode = UITextFieldViewModeAlways;

    
  /**/
   
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetr icsDefault];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];
    
    //Add Country Picker View
    
    //Add Country Picker View
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PickerBackGroundView.frame=CGRectMake(0, self.view.frame.size.height-236, self.view.frame.size.width, 236);
            
        }
        else
        {
            PickerBackGroundView.frame=CGRectMake(0, self.view.frame.size.height-236, self.view.frame.size.width, 236);
            
        }
    }
    
    
    PickerBgView.frame=CGRectMake(0, 360, self.view.frame.size.width, 236);
    [self.view addSubview:PickerBgView];
    [self.view bringSubviewToFront:PickerBgView];
    PickerBgView.hidden=YES;
    [DatePickerView addTarget:self
                       action:@selector(datePickerDateChanged:)
             forControlEvents:UIControlEventValueChanged];
    
    
    CGRect frame = pickerView.frame;
    frame.size.width = self.view.frame.size.width;
    pickerView.frame = frame;
}
#pragma mark - Save And Continue Button Action

- (IBAction)SaveAndContinueBtnAction:(id)sender
{
    if ([Address1TextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    if ([Address2TextField.text isEqualToString:@""])
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Alternate Address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if ([ZipCodeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Zip Code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    if ([CityTextField.text isEqualToString:@""])
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select City" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    if ([StateTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select State" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([DrivingLicsenceNoTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Driving Licsence Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([DrivingLicsenceStateTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Driving Licsence State" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([DrivingLicsenceExpDateTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Driving Licsence Expiry Date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([DOBTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Select Your DOB" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([SocialSecurityNoTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Choose Social Security Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self MoveToDriverRegister3View];
}

#pragma mark - State Button Action

- (IBAction)StateButtonAction:(id)sender
{
    [Address1TextField resignFirstResponder];
    [ZipCodeTextField resignFirstResponder];
    [CityTextField resignFirstResponder];
    [StateTextField resignFirstResponder];
    [DrivingLicsenceNoTextField resignFirstResponder];
    [DrivingLicsenceStateTextField resignFirstResponder];
    [DrivingLicsenceExpDateTextField resignFirstResponder];
    [DOBTextField resignFirstResponder];
    [SocialSecurityNoTextField resignFirstResponder];
    
    TextFieldType=@"State";
    pickerView.delegate=self;
    [pickerView reloadAllComponents];

    PickerBackGroundView.hidden=NO;
       stateIdStr=[NSString stringWithFormat:@"%@",stateIdStr];

    int stateIdStrLength=stateIdStr.length;
    
    if (StateNames.count>0 && stateIdStrLength==0)
    {
        StateTextField.text=[StateNames objectAtIndex:0];
        stateIdStr=[stateIdsArray objectAtIndex:0];
        cityIDstr=@"";
        CityTextField.text=@"";
    }

  
}

#pragma mark - Driving Licsence State Button Action

- (IBAction)DrivingLicsenceState:(id)sender
{
    
    [Address1TextField resignFirstResponder];
    [ZipCodeTextField resignFirstResponder];
    [CityTextField resignFirstResponder];
    [StateTextField resignFirstResponder];
    [DrivingLicsenceNoTextField resignFirstResponder];
    [DrivingLicsenceStateTextField resignFirstResponder];
    [DrivingLicsenceExpDateTextField resignFirstResponder];
    [DOBTextField resignFirstResponder];
    [SocialSecurityNoTextField resignFirstResponder];
    
    TextFieldType=@"DLState";
    PickerBackGroundView.hidden=NO;
    DrivingLicsenceStateTextField.text=[StateNames objectAtIndex:0];
    DrivingLicsenceStateIDSTR=[stateIdsArray objectAtIndex:0];

    
}

#pragma mark - Done Button Action

- (IBAction)DoneButtonAction:(id)sender
{
    PickerBackGroundView.hidden=YES;
}

- (IBAction)DoneViewBtn:(id)sender
{
    PickerBgView.hidden=YES;

}

- (IBAction)DrivingLicExpDateBtnAction:(id)sender
{
    TextFieldValue=@"DL";
    [Address1TextField resignFirstResponder];
    [ZipCodeTextField resignFirstResponder];
    [CityTextField resignFirstResponder];
    [StateTextField resignFirstResponder];
    [DrivingLicsenceNoTextField resignFirstResponder];
    [DrivingLicsenceStateTextField resignFirstResponder];
    [DrivingLicsenceExpDateTextField resignFirstResponder];
    [DOBTextField resignFirstResponder];
    [SocialSecurityNoTextField resignFirstResponder];
    PickerBgView.hidden=NO;
}

- (IBAction)DOBButtonAction:(id)sender
{
    TextFieldValue=@"DOB";

    [Address1TextField resignFirstResponder];
    [ZipCodeTextField resignFirstResponder];
    [CityTextField resignFirstResponder];
    [StateTextField resignFirstResponder];
    [DrivingLicsenceNoTextField resignFirstResponder];
    [DrivingLicsenceStateTextField resignFirstResponder];
    [DrivingLicsenceExpDateTextField resignFirstResponder];
    [DOBTextField resignFirstResponder];
    [SocialSecurityNoTextField resignFirstResponder];
    PickerBgView.hidden=NO;

}

- (IBAction)selectCityBtn:(id)sender {
   
    
    [Address1TextField resignFirstResponder];
    [ZipCodeTextField resignFirstResponder];
    [CityTextField resignFirstResponder];
    [StateTextField resignFirstResponder];
    [DrivingLicsenceNoTextField resignFirstResponder];
    [DrivingLicsenceStateTextField resignFirstResponder];
    [DrivingLicsenceExpDateTextField resignFirstResponder];
    [DOBTextField resignFirstResponder];
    [SocialSecurityNoTextField resignFirstResponder];
    TextFieldType=@"City";
    if (cityIdsArray.count==0)
    {
        [self GetCityList];
        [pickerView reloadAllComponents];


    }else{
        [pickerView reloadAllComponents];

        PickerBackGroundView.hidden=NO;
        
        cityIDstr=[NSString stringWithFormat:@"%@",cityIDstr];
        
        int cityIdStrLength=cityIDstr.length;

        if ( cityIdsArray.count>0 && cityIdStrLength==0) {
            CityTextField.text=[cityNames objectAtIndex:0];
            cityIDstr=[cityIdsArray objectAtIndex:0];
        }
    }
   
}


#pragma mark - Move To Driver Register3 View

-(void)MoveToDriverRegister3View
{
    //Get DL Expire Date
    NSString *DLExpiryDate=DrivingLicsenceExpDateTextField.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *startingDate = [dateFormatter dateFromString:DLExpiryDate];
    //startingDate=[NSString stringWithFormat:@"%@ 00:00:00.000",startingDate];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *DLdate = [dateFormatter1 stringFromDate:startingDate];
    
    //Get DOB  Date
    
    NSString *DOB=DOBTextField.text;
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd"];
    NSDate *DOBdate = [dateFormatter2 dateFromString:DOB];
    
    NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *DOBLatestDate = [dateFormatter3 stringFromDate:DOBdate];
    
    [Register1ViewDict setValue:Address1TextField.text forKey:@"Address1"];
    [Register1ViewDict setValue:ZipCodeTextField.text forKey:@"ZipCode"];
    [Register1ViewDict setValue:CityTextField.text forKey:@"City"];
    [Register1ViewDict setValue:StateTextField.text forKey:@"State"];
    [Register1ViewDict setValue:stateIdStr forKey:@"StateID"];
    
    [Register1ViewDict setValue:DrivingLicsenceNoTextField.text forKey:@"DrivingLicsenceNo"];
    [Register1ViewDict setValue:DrivingLicsenceStateTextField.text forKey:@"DrivingLicsenceState"];
    [Register1ViewDict setValue:DrivingLicsenceStateIDSTR forKey:@"DrivingLicsenceStateID"];
    [Register1ViewDict setValue:cityIDstr forKey:@"cityId"];

    

    if (DLdate==nil || DOBLatestDate==nil)
    {
        
        [Register1ViewDict setValue:DrivingLicsenceExpDateTextField.text forKey:@"DrivingLicsenceExpDate"];
        [Register1ViewDict setValue:DOBTextField.text forKey:@"DOB"];
    }
    else
    {
        [Register1ViewDict setValue:DLdate forKey:@"DrivingLicsenceExpDate"];
        [Register1ViewDict setValue:DOBLatestDate forKey:@"DOB"];
    }

    [Register1ViewDict setValue:SocialSecurityNoTextField.text forKey:@"SocialSecurityNo"];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverRegister3View=[[DriverRegister3ViewController alloc]initWithNibName:@"DriverRegister3ViewController" bundle:nil];
        }
        else
        {
            DriverRegister3View=[[DriverRegister3ViewController alloc]initWithNibName:@"DriverRegister3ViewController" bundle:nil];
        }
        DriverRegister3View.Register2ViewDict=Register1ViewDict;
        if ([comingFrom isEqualToString:@"DriverView"])
        {
            NSString *str=@"DriverView";
            DriverRegister3View.userRecordArray=userRecordArray;
            DriverRegister3View.comingFrom=str;
        }

        [self.navigationController pushViewController:DriverRegister3View animated:YES];
        
    }
    
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [Address1TextField resignFirstResponder];
    [ZipCodeTextField resignFirstResponder];
    [CityTextField resignFirstResponder];
    [StateTextField resignFirstResponder];
    [DrivingLicsenceNoTextField resignFirstResponder];
    [DrivingLicsenceStateTextField resignFirstResponder];
    [DrivingLicsenceExpDateTextField resignFirstResponder];
    [DOBTextField resignFirstResponder];
    [SocialSecurityNoTextField resignFirstResponder];
    
    return YES;
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([TextFieldType isEqualToString:@"City"])
    {
         return cityNames.count;
    }
    else
    {
         return StateNames.count;
    }
   
}

- (NSString *)pickerView:(UIPickerView *)pickerView  titleForRow:(NSInteger)row  forComponent:(NSInteger)component
{
    if ([TextFieldType isEqualToString:@"City"])
    {
        return cityNames[row];
    }
    else
    {
        return StateNames[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if ([TextFieldType isEqualToString:@"State"])
    {
        NSString *stateValue=[StateNames objectAtIndex:row];
        stateIdStr=[stateIdsArray objectAtIndex:row];
        StateTextField.text=stateValue;
        cityIDstr=[NSString stringWithFormat:@""];
        [cityIdsArray removeAllObjects];
        [cityNames removeAllObjects];
        CityTextField.text=@"";
        
    }
    else if ([TextFieldType isEqualToString:@"DLState"])
    {
        NSString *stateValue=[StateNames objectAtIndex:row];
        DrivingLicsenceStateIDSTR=[stateIdsArray objectAtIndex:row];
        DrivingLicsenceStateTextField.text=stateValue;
    }
    else if ([TextFieldType isEqualToString:@"City"])
    {
        NSString *cityValue=[cityNames objectAtIndex:row];
        cityIDstr=[cityIdsArray objectAtIndex:row];
        CityTextField.text=cityValue;
    }
    
}
- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker
{
      //  NSLog(@"Selected date = %@", paramDatePicker.date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:paramDatePicker.date];
    
   // NSLog(@"%@",date);
    if ([TextFieldValue isEqualToString:@"DL"])
    {
      DrivingLicsenceExpDateTextField.text=date;
    }
    else if ([TextFieldValue isEqualToString:@"DOB"])
    {
      DOBTextField.text=date;
    }

    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GetCityList
{
    [kappDelegate ShowIndicator];
    
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:stateIdStr,@"Statename",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetCityList",Kwebservices]];
    
    [self postWebservices];
}
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
    self.view.userInteractionEnabled=YES;
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
                [cityNames removeAllObjects];
                [cityIdsArray removeAllObjects];
              //  NSLog(@"%@",userDetailDict);
                
                
                NSMutableArray *tempArr=[userDetailDict valueForKey:@"ListCity"];
                for (int i=0; i<[tempArr count]; i++)
                {
                    NSString *str=[[tempArr objectAtIndex:i] valueForKey:@"CityName"];
                    NSString *tempstateIdStr=[NSString stringWithFormat:@"%ld",(long)[[[tempArr objectAtIndex:i] valueForKey:@"CityId"]integerValue]];
                    [cityIdsArray addObject:tempstateIdStr];
                    [cityNames addObject:str];
                }
                
                if (cityNames.count>0)
                {
                    [pickerView reloadAllComponents];
                    PickerBackGroundView.hidden=NO;
                    CityTextField.text=[cityNames objectAtIndex:0];
                    cityIDstr=[cityIdsArray objectAtIndex:0];
                    [pickerView selectRow:0 inComponent:0 animated:YES];
                }
                else
                {
                    PickerBackGroundView.hidden=YES;
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No city Available for this state" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                
            }
        }
        
    }
}

@end
