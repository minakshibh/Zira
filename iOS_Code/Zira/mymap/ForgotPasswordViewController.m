//
//  ForgotPasswordViewController.m
//  UberLikeApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
   // self.title=@"Zira 24/7";

    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Done Button Action

- (IBAction)DoneButtonAction:(id)sender
{
    if ([self validateEmailWithString:emailTextField.text]==YES)
    {
        if ([kappDelegate checkForInternetConnection]==YES)
        {
            [kappDelegate ShowIndicator];
            [self ForGotPasswordWebService];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Enter Valid Email id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [emailTextField resignFirstResponder];
    
    return YES;
}// called when 'return' key pressed. return NO to ignore.

#pragma mark - Validation for email

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - Login Web Service

-(void)ForGotPasswordWebService
{
    [emailTextField resignFirstResponder];
    webservice=1;
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:emailTextField.text,@"UserEmail",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RecoverPassword",Kwebservices]];
    
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
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                NSLog(@"%@",userDetailDict);
                emailTextField.text=@"";
            }
        }
        
    }
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
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
