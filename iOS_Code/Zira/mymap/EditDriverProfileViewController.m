//
//  EditDriverProfileViewController.m
//  mymap
//
//  Created by vikram on 15/12/14.
//

#import "EditDriverProfileViewController.h"
#import "DriverRegister1ViewController.h"
#import "RegisterViewViewController.h"
#import "HomeViewController.h"

RegisterViewViewController *RegisterViewObj;
DriverRegister1ViewController *DriverRegister1ViewObj;


#import "Base64.h"


@interface EditDriverProfileViewController ()

@end

@implementation EditDriverProfileViewController

@synthesize UserRecordArray;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            scrollView.contentSize = CGSizeMake(320, 1030);
        }
        else
        {
            scrollView.contentSize = CGSizeMake(320, 700);

        }
    }

//    // Right Bar Button Item //
//    
//    UIButton *  RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    RightButton.frame = CGRectMake(0, 0, 60, 40);
//    [RightButton setTitle:@"Edit" forState:UIControlStateNormal];
//    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
//    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
//    [RightButton addTarget:self action:@selector(EditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
//    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
//    ////
    
    if ([[UserRecordArray valueForKey:@"vechile_make"] isEqualToString:@""])
    {
        sidelbl.hidden=YES;
        sidelbl1.hidden=YES;
        sidelbl2.hidden=YES;
        sidelbl3.hidden=YES;
        sidelbl4.hidden=YES;
        sidelbl5.hidden=YES;
        sidelbl6.hidden=YES;
        sidelbl7.hidden=YES;
        sidelbl8.hidden=YES;
        sidelbl9.hidden=YES;
        driverEditBtn.hidden=YES;
        infolabel.hidden=YES;
        VechicleImageView.hidden=YES;
        VechMake.hidden=YES;
        VechModel.hidden=YES;
        VechNo.hidden=YES;
        driverInfoBgView.hidden=YES;

    }

    [self setTextToAllLabels];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Fill All Details In Labels

-(void)setTextToAllLabels
{
    //driver info
    NSString *firstName=[UserRecordArray valueForKey:@"firstname"];
    NSString *lastName=[UserRecordArray valueForKey:@"lastname"];
    NSString *FullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    DriverNameLabel.text=FullName;
    
    DriverEmail.text=[UserRecordArray valueForKey:@"email"];
    DriverPhoneNo.text=[UserRecordArray valueForKey:@"mobile"];
    
    NSString *userImageUrl=[UserRecordArray valueForKey:@"image"];
   // NSData* data = [Base64 decode:Base64Str];;
  //  DriverImageView.image = [UIImage imageWithData:data];
    if (![userImageUrl isEqualToString:@""])
    {
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        objactivityindicator.center = CGPointMake((DriverImageView.frame.size.width/2),(DriverImageView.frame.size.height/2));
        [DriverImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[userImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [DriverImageView setImage:imgData];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }

    
    //vechicle info
    VechMake.text=[UserRecordArray valueForKey:@"vechile_make"];
    VechModel.text=[UserRecordArray valueForKey:@"vechile_model"];
    VechNo.text=[UserRecordArray valueForKey:@"licenseplatenumber"];
    vechYear.text=[UserRecordArray valueForKey:@"vechile_year"];
    
    lisencePlateCntry.text=[UserRecordArray valueForKey:@"licenseplatecountry"];
    lisencePlateState.text=[UserRecordArray valueForKey:@"licenseplatestate"];
    address.text=[UserRecordArray valueForKey:@"address"];
    zipcode.text=[UserRecordArray valueForKey:@"zipcode"];
    city.text=[UserRecordArray valueForKey:@"city"];
    state.text=[UserRecordArray valueForKey:@"state"];
    DLNo.text=[UserRecordArray valueForKey:@"drivinglicensenumber"];
    DLState.text=[UserRecordArray valueForKey:@"drivinglicensestate"];
    SocialNo.text=[UserRecordArray valueForKey:@"socialsecuritynumber"];



    
    NSString *VechImageUrl=[UserRecordArray valueForKey:@"vechile_img_location"];
    if (![VechImageUrl isEqualToString:@""])
    {
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        objactivityindicator.center = CGPointMake((VechicleImageView.frame.size.width/2),(VechicleImageView.frame.size.height/2));
        [VechicleImageView addSubview:objactivityindicator];
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
 
}

#pragma mark - Edit Button Action

-(IBAction)EditButtonAction:(id)sender
{
   
    NSString *str=@"DriverView";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil];
 
        }
        else
        {
            DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil];
        }
        DriverRegister1ViewObj.userRecordArray=UserRecordArray;
        DriverRegister1ViewObj.comingFrom=str;
        [self.navigationController pushViewController:DriverRegister1ViewObj animated:YES];
    }
}

#pragma mark - Move to Register View

-(void)MoveToRegisterView
{
    NSString *str=@"DriverMode";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            RegisterViewObj=[[RegisterViewViewController alloc]initWithNibName:@"RegisterViewViewController" bundle:nil];

        }
        else
        {
            RegisterViewObj=[[RegisterViewViewController alloc]initWithNibName:@"RegisterViewViewController" bundle:nil];
        }
        RegisterViewObj.UserRecordArray=UserRecordArray;
        RegisterViewObj.EditFrom=str;
      
        [self.navigationController pushViewController:RegisterViewObj animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)EditProfileInfo:(id)sender
{
    [self MoveToRegisterView];
}

- (IBAction)EditVechInfo:(id)sender {
    NSString *str=@"DriverView";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil];
        }
        else
        {
            DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil];
        }
        DriverRegister1ViewObj.userRecordArray=UserRecordArray;
        DriverRegister1ViewObj.comingFrom=str;
        [self.navigationController pushViewController:DriverRegister1ViewObj animated:YES];
    }
}

- (IBAction)SignOutBtnAction:(id)sender
{
    [kappDelegate ShowIndicator];
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"user"],@"useremail",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Logout",Kwebservices]];
    
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
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
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
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MODE"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"DriverMode"];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:@"Logout" forKey:@"Account"];
            [FBSession.activeSession closeAndClearTokenInformation];
            
            // [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:NO];
        }
    }
    
}
@end
