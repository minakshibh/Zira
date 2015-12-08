//
//  DriverInfoViewController.m
//  mymap
//
//  Created by vikram on 08/12/14.
//

#import "DriverInfoViewController.h"
#import "SeeDriverLocationViewController.h"
SeeDriverLocationViewController *SeeDriverLocationViewObj;

@interface DriverInfoViewController ()

@end

@implementation DriverInfoViewController
@synthesize DriverDetailStr;


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    DriverImageView.layer.cornerRadius=4;
    DriverImageView.layer.borderColor=[UIColor blackColor].CGColor;
    DriverImageView.layer.borderWidth=1.0;
    
    VechicleImageView.layer.cornerRadius=4;
    VechicleImageView.layer.borderColor=[UIColor blackColor].CGColor;
    VechicleImageView.layer.borderWidth=1.0;
    
    msgView.layer.cornerRadius=5.0;
    msgView.hidden=YES;
    
    // Left Bar Button Item //
    
   UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 53, 13);
   // [leftButton setTitle:@"< Back" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back_img.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back_img.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(BackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;
    
    
    // Right Bar Button Item //
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 60, 13);
    [rightButton setTitle: @"Cancel" forState: UIControlStateNormal];

    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightBarButtonItem;

    
    
    
    
    
    
    ////

    NSArray *arr=[DriverDetailStr componentsSeparatedByString:@"@"];
    NSLog(@"%@",arr);
    NSString *username=[arr objectAtIndex:0];
  //  NSString *Message=[arr objectAtIndex:1];
    NSString *ImageUrl=[arr objectAtIndex:2];
    
    TripId=[arr objectAtIndex:3];
    NSLog(@"arr objectAtIndex:3: %@",TripId);
    //NSString *vehicleImageUrl=[arr objectAtIndex:4];
    DriverId=[arr objectAtIndex:5];
    
    //UIAlertView*alrt=[[UIAlertView alloc]initWithTitle:@"jsonDict" message:[NSString stringWithFormat:@"%@ ,,,,, %@",DriverDetailStr ,DriverId] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
   // [alrt show];

    DriverNameLabel.text=username;
    
    UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        objactivityindicator.center = CGPointMake((DriverImageView.frame.size.width/2),(DriverImageView.frame.size.height/2));
        [DriverImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[ImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [DriverImageView setImage:imgData];
                                   //  [UserImageDict setObject:imgData forKey:UrlString];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   //[self.imageview setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });

    [self GetUserProfileService];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated
{
}

#pragma mark - Back Button Action

-(IBAction)BackButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"hideNotif"
     object:self];
}

#pragma mark - RightBar Button Action

-(IBAction)rightButtonAction:(id)sender
{
    [self CancelRideRequest];
}



-(void)CancelRideRequest
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* now = [NSDate date];
    NSString*currentTime= [dateFormatter stringFromDate:now];
    
    [kappDelegate ShowIndicator];
    
    webservice=3;
    timerCount= [kappDelegate requestTimer];
    
    if (timerCount<300)
    {
        CancelRideWithPay=@"NO";
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",@"cancel",@"Status",currentTime,@"Timestamp",@"",@"Latitude",@"",@"Longitude",@"",@"TripMilesActual",@"",@"TripTimeActual",@"",@"TripAmountActual",@"rider",@"Trigger",CancelRideWithPay,@"PaymentStatus",@"0",@"CancellationCharges",nil];
    }
    else{
        CancelRideWithPay=@"YES";
        
         jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"TripId",@"cancel",@"Status",currentTime,@"Timestamp",@"",@"Latitude",@"",@"Longitude",@"",@"TripMilesActual",@"",@"TripTimeActual",@"",@"TripAmountActual",@"rider",@"Trigger",CancelRideWithPay,@"PaymentStatus",[[NSUserDefaults standardUserDefaults] valueForKey:@"CancelRideCharges"],@"CancellationCharges",nil];
    }
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
   urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/NotifyRegardingArrival",Kwebservices]];
    
    [self postWebservices];
}



#pragma mark - Message Button Action

- (IBAction)MessageButtonAction:(id)sender
{
//    if(![MFMessageComposeViewController canSendText])
//    {
//        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [warningAlert show];
//        return;
//    }
//    
//   // NSArray *recipents = @[@"", @""];
//   // NSString *message = @"";
//    
//    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
//    messageController.messageComposeDelegate = self;
//   // [messageController setRecipients:recipents];
//   // [messageController setBody:message];
//    
//    // Present message view controller on screen
//    [self presentViewController:messageController animated:YES completion:nil];
    
//    [self SendMessageCallToDriver];
    msgView.hidden=NO;
    [MsgTextField becomeFirstResponder];
    
}

#pragma mark - Message Controller Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Call Button Action

- (IBAction)CallButtonAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:111"]];
}

#pragma mark - See Driver Location Button Action

- (IBAction)SeeDriverLocationButtonAction:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            SeeDriverLocationViewObj=[[SeeDriverLocationViewController alloc]initWithNibName:@"SeeDriverLocationViewController" bundle:nil];
            SeeDriverLocationViewObj.GetDriverId=DriverId;
            SeeDriverLocationViewObj.GetTripId=TripId;
            [self.navigationController pushViewController:SeeDriverLocationViewObj animated:YES];
        }
        else
        {
            SeeDriverLocationViewObj=[[SeeDriverLocationViewController alloc]initWithNibName:@"SeeDriverLocationViewController" bundle:nil];
            SeeDriverLocationViewObj.GetDriverId=DriverId;
            SeeDriverLocationViewObj.GetTripId=TripId;
            [self.navigationController pushViewController:SeeDriverLocationViewObj animated:YES];
        }
        NSLog(@" SeeDriverLocationViewObj.GetTripId : %@",TripId);
    }
}

#pragma mark - Send Button Action

- (IBAction)SendBtn:(id)sender
{
    msgView.hidden=YES;
    [MsgTextField resignFirstResponder];
    [self SendMessageCallToDriver];
}

- (IBAction)CrossBtn:(id)sender
{
    MsgTextField.text=@"";
    msgView.hidden=YES;
    [MsgTextField resignFirstResponder];
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [MsgTextField resignFirstResponder];
    return YES;
}

#pragma mark - Rating

-(void)Rating
{
    if (RatingCount==0)
    {
        [firstStar setImage: [UIImage imageNamed:@"star.png"]];
        [secondStar setImage:[UIImage imageNamed:@"star.png"]];
        [thirdStar setImage: [UIImage imageNamed:@"star.png"]];
        [fourthStar setImage:[UIImage imageNamed:@"star.png"]];
        [fifthStar setImage: [UIImage imageNamed:@"star.png"]];
    }
    else if (RatingCount==1)
    {
        [firstStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [secondStar setImage:[UIImage imageNamed:@"star.png"]];
        [thirdStar setImage: [UIImage imageNamed:@"star.png"]];
        [fourthStar setImage:[UIImage imageNamed:@"star.png"]];
        [fifthStar setImage: [UIImage imageNamed:@"star.png"]];
    }
    else if (RatingCount==2)
    {
        [firstStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [secondStar setImage:[UIImage imageNamed:@"star_active.png"]];
        [thirdStar setImage: [UIImage imageNamed:@"star.png"]];
        [fourthStar setImage:[UIImage imageNamed:@"star.png"]];
        [fifthStar setImage: [UIImage imageNamed:@"star.png"]];
    }
    else if (RatingCount==3)
    {
        [firstStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [secondStar setImage:[UIImage imageNamed:@"star_active.png"]];
        [thirdStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [fourthStar setImage:[UIImage imageNamed:@"star.png"]];
        [fifthStar setImage: [UIImage imageNamed:@"star.png"]];
    }
    else if (RatingCount==4)
    {
        [firstStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [secondStar setImage:[UIImage imageNamed:@"star_active.png"]];
        [thirdStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [fourthStar setImage:[UIImage imageNamed:@"star_active.png"]];
        [fifthStar setImage: [UIImage imageNamed:@"star.png"]];
    }
    else if (RatingCount==5)
    {
        [firstStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [secondStar setImage:[UIImage imageNamed:@"star_active.png"]];
        [thirdStar setImage: [UIImage imageNamed:@"star_active.png"]];
        [fourthStar setImage:[UIImage imageNamed:@"star_active.png"]];
        [fifthStar setImage: [UIImage imageNamed:@"star_active.png"]];
    }
}

#pragma mark - Get Profile Web Service

-(void)GetUserProfileService
{
    [kappDelegate ShowIndicator];
    self.view.userInteractionEnabled=NO;
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:DriverId,@"UserId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    UIAlertView*alrt=[[UIAlertView alloc]initWithTitle:@"jsonDict" message:jsonRequest delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
   // [alrt show];
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetProfiles",Kwebservices]];
    
    [self postWebservices];
}
#pragma mark - Send Message Call To Driver

-(void)SendMessageCallToDriver
{
    webservice=2;
    NSString *msg=MsgTextField.text;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:DriverId,@"Id",msg,@"message",@"sms",@"trigger",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SendMessages",Kwebservices]];
    
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
    self.view .userInteractionEnabled=YES;

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
    self.view .userInteractionEnabled=YES;
    
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
                 
                 NSString *VechImageUrl=[userDetailDict valueForKey:@"vechile_img_location"];
                 if (![VechImageUrl isEqualToString:@""])
                 {
                     UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                     objactivityindicator.center = CGPointMake((VechicleImageView.frame.size.width/2),(VechicleImageView.frame.size.height/2));
                     [DriverImageView addSubview:objactivityindicator];
                     [objactivityindicator startAnimating];
                     
                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                         NSURL *imageURL=[NSURL URLWithString:[VechImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                         NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                         UIImage *imgData=[UIImage imageWithData:tempData];
                         dispatch_async(dispatch_get_main_queue(), ^
                                        {
                                            if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                            {
                                                [VechicleImageView setImage:imgData];
                                                [objactivityindicator stopAnimating];
                                                
                                            }
                                            else
                                            {
                                                [objactivityindicator stopAnimating];
                                                
                                            }
                                        });
                     });
  
                 }
                 
                 VechMake.text=[userDetailDict valueForKey:@"vechile_make"];
                 VechModel.text=[userDetailDict valueForKey:@"vechile_model"];
                 VechNo.text=[userDetailDict valueForKey:@"licenseplatenumber"];
                 RatingCount=[[userDetailDict valueForKey:@"driver_rating"] integerValue];
                 
               //  RatingCount=3;
                 [self Rating];
                 
             }
        }
        
    }
    else if (webservice==2)
    {
        MsgTextField.text=@"";
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            //NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Driver is not Registered with Twilio account" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Message has been sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
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
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=3;
                
                [alert show];
                
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==3)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
