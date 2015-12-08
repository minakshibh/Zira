//
//  PromoCodeViewController.m
//  mymap
//
//  Created by vikram on 28/11/14.
//

#import "PromoCodeViewController.h"

@interface PromoCodeViewController ()

@end

@implementation PromoCodeViewController
@synthesize comingFrom;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    self.title=@"PROMO CODE";
    if ([comingFrom isEqualToString:@"Slider"])
    {
    }
    else
    {
    // Right Bar Button Item //
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    RightButton.frame = CGRectMake(20, 0, 30, 30);
   // [RightButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [RightButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [RightButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateHighlighted];
    [RightButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    ////
    }

    
     [self setNeedsStatusBarAppearanceUpdate];
    
      [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];
    
    PromoCodeListArray=[[NSMutableArray alloc] init];
    PromoCodeListArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"PromoCodeList"] mutableCopy];
    
    if (PromoCodeListArray.count>0)
    {
    if ([PromoCodeListArray count]==1)
    {
        promoCodeTable.frame=CGRectMake(25, 71, 271, 50);
    }
    else if ([PromoCodeListArray count]==2)
    {
        promoCodeTable.frame=CGRectMake(25, 71, 271, 80);
    }
    }
    else
    {
        promoCodeTable.hidden=YES;
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#pragma mark - Cancel Button Action

- (IBAction)CancelButtonAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)DoneButtonAction:(id)sender
{
    if ([PromoCodeTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Promo Code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [self ApplyPromoCode];
        [PromoCodeTextField resignFirstResponder];
    }
}

#pragma mark - Login Web Service

-(void)ApplyPromoCode
{
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderId",PromoCodeTextField.text,@"PromoCode",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AddPromoCode",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Navigation Controller Delegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PromoCodeListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (PromoCodeListArray.count>0)
    {
        
     cell.textLabel.text = [[PromoCodeListArray objectAtIndex:indexPath.row] valueForKey:@"promocode"];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];

    if (cell.accessoryType==UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        PromoCodeTextField.text=@"";
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        PromoCodeTextField.text=[[PromoCodeListArray objectAtIndex:indexPath.row] valueForKey:@"promocode"];
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
                PromoCodeTextField.text=@"";
                
            }
            else
            {
                
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                PromoCodeTextField.text=@"";
            }
        }
        
    }
    
}

#pragma mark - Text Field Delegates

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [PromoCodeTextField resignFirstResponder];

    return YES;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
