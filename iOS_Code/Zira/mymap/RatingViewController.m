//
//  RatingViewController.m
//  mymap
//
//  Created by vikram on 16/12/14.
//

#import "RatingViewController.h"
#import "PaypalViewController.h"
#import "DriverMapViewController.h"

@interface RatingViewController ()

@end

@implementation RatingViewController

@synthesize GetTripId,ComingFromNotification,EndRideTripIdFromNotif;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    TripDetailArr=[[NSMutableArray alloc] init];
    self.navigationItem.hidesBackButton = YES;

    RatingValue=@"0";
    commentTextView.layer.cornerRadius=5.0;
    commentTextView.layer.borderColor=[UIColor grayColor].CGColor;
    commentTextView.layer.borderWidth=1.0;
    
    //set image to buttons
    
    [firstStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [secondStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [thirdStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [fourthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [fifthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    
    if ([ComingFromNotification isEqualToString:@"YES"])
    {
        [self GetRiderTripDetails];
    }
    else
    {
        [self GetDriverTripDetails];
    }


    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - First Button Action

- (IBAction)FirstButtonAction:(id)sender
{
    RatingValue=@"1";

    [firstStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [secondStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [thirdStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [fourthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [fifthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
}

#pragma mark - Second Button Action

- (IBAction)SecondButtonAction:(id)sender
{
    RatingValue=@"2";

    [firstStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [secondStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [thirdStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [fourthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [fifthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
   
}

#pragma mark - Third Button Action

- (IBAction)ThirdButtonAction:(id)sender
{
    RatingValue=@"3";

    [firstStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [secondStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [thirdStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [fourthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
    [fifthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
}

#pragma mark - Fourth Button Action

- (IBAction)FourthButtonAction:(id)sender
{
    RatingValue=@"4";

    [firstStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [secondStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [thirdStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [fourthStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [fifthStar setImage:[UIImage imageNamed:@"starbig.png"] forState:UIControlStateNormal];
}

#pragma mark - Fifth Button Action

- (IBAction)FifthButtonAction:(id)sender
{
    RatingValue=@"5";

    [firstStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [secondStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [thirdStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [fourthStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
    [fifthStar setImage:[UIImage imageNamed:@"star_activebig.png"] forState:UIControlStateNormal];
}

#pragma mark - Move To Paypal View

-(void)MoveToPayPalView
{
        PaypalViewController *PayPalView=[[PaypalViewController alloc]initWithNibName:@"PaypalViewController" bundle:nil];
        PayPalView.TripDetailArray=TripDetailArr;
        PayPalView.TripId=EndRideTripIdFromNotif;
        [self.navigationController pushViewController:PayPalView animated:YES];
    
}


#pragma mark - Done Button Action

- (IBAction)DoneButtonAction:(id)sender
{
    if ([commentTextView.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ZiraApp24/7" message:@"Please Enter Comment" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([ComingFromNotification isEqualToString:@"YES"])
    {
        [self RiderToDriverRating];

    }
    else
    {
        [self DriverToRiderRating];

    }
}

#pragma mark - UITextField Delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [commentTextView resignFirstResponder];
}

#pragma mark - Rating Web Service

-(void)DriverToRiderRating
{
    webservice=1;
    
    if (EndRideTripIdFromNotif.length==0)
    {
        EndRideTripIdFromNotif= [[NSUserDefaults standardUserDefaults]valueForKey:@"EndRideTripId"];
    }
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:DriverId,@"DriverId",RiderId,@"RiderId",GetTripId,@"TripId",RatingValue,@"Rating",commentTextView.text,@"Feedback",@"driver",@"Sender",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);;
    
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RiderToDriverRating",Kwebservices]];
    
    [self postWebservices];
}

-(void)RiderToDriverRating
{
    webservice=2;
    
    if (EndRideTripIdFromNotif.length==0)
    {
        EndRideTripIdFromNotif= [[NSUserDefaults standardUserDefaults]valueForKey:@"EndRideTripId"];
    }
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:DriverId,@"DriverId",RiderId,@"RiderId",EndRideTripIdFromNotif,@"TripId",RatingValue,@"Rating",commentTextView.text,@"Feedback",@"rider",@"Sender",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RiderToDriverRating",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark -  Get Trip Details

-(void)GetRiderTripDetails
{
    [kappDelegate ShowIndicator];
    self.view.userInteractionEnabled=NO;
    
    webservice=3;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:EndRideTripIdFromNotif,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDetailsByTripId",Kwebservices]];
    
    [self postWebservices];
}
-(void)GetDriverTripDetails
{
    [kappDelegate ShowIndicator];
    self.view.userInteractionEnabled=NO;
    webservice=4;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GetTripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDetailsByTripId",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==200)
    {
        if (buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"Hide" forKey:@"DriverViewButtons"];
           // [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
            [self MoveToDriverView];
   
        }
    }
}

-(void)MoveToDriverView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverMapViewController *DriverMapView=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:DriverMapView animated:NO];
        }
        else
        {
          DriverMapViewController *DriverMapView=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController" bundle:nil];
            [self.navigationController pushViewController:DriverMapView animated:NO];
        }
    }

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
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Thanks for your feedback" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=200;
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EndRideTripId"];

                [alert show];
            }
        }
        
    }
    if (webservice==2)
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
                //Move to payment screen
                NSLog(@"%@",userDetailDict);
                [self MoveToPayPalView];

               // [self MoveToPayPalView];
            }
        }
        
    }
    if (webservice==3)
    {
        [kappDelegate HideIndicator];
        self.view.userInteractionEnabled=YES;
        
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
                DriverId=[userDetailDict valueForKey:@"driverid"];
                RiderId=[userDetailDict valueForKey:@"riderid"];
                
                NSString *mystr=[userDetailDict valueForKey:@"trip_total_amount"];
                if ([mystr isEqualToString:@""])
                {
                    
                }
                else
                {
                    if (mystr.length>5)
                    {
                        mystr=[mystr substringToIndex:5];
                    }
                    
                float fare=[[NSString stringWithFormat:@"%@",mystr] floatValue];
                float total=fare;
                totalFare.text=[NSString stringWithFormat:@"$%.1f",total];
                }
                TripDetailArr=[userDetailDict mutableCopy];
            }
        }
    }
    if (webservice==4)
    {
        [kappDelegate HideIndicator];
        self.view.userInteractionEnabled=YES;
        
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
                DriverId=[userDetailDict valueForKey:@"driverid"];
                RiderId=[userDetailDict valueForKey:@"riderid"];
                
                NSString *mystr=[userDetailDict valueForKey:@"trip_total_amount"];
                if ([mystr isEqualToString:@""])
                {
                    
                }
                else
                {
                    mystr=[mystr substringToIndex:2];
                    
                    float fare=[[NSString stringWithFormat:@"%@",mystr] floatValue];
                   // NSInteger safetyFee=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SafetyCharges"] integerValue];
                    float total=fare;
                    totalFare.text=[NSString stringWithFormat:@"$%.1f",total];
                }
            }
        }
    }
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [commentTextView resignFirstResponder];
}
#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
