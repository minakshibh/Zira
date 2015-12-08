//
//  CreditCardsSelectViewController.m
//  mymap
//
//  Created by vikram on 28/11/14.
//

#import "CreditCardsSelectViewController.h"
AddCreditCardViewController *AddCreditCardViewObj;

@interface CreditCardsSelectViewController ()

@end

@implementation CreditCardsSelectViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    CreditCardsListArray=[[NSMutableArray alloc] init];
    CreditCardListingTable.layer.borderColor=[UIColor grayColor].CGColor;
    CreditCardListingTable.layer.borderWidth=1.0f;
    CreditCardListingTable.layer.cornerRadius=5.0;
    
    
   // CreditCardsListArray=[[[NSUserDefaults standardUserDefaults] valueForKey:@"CreditCardList"] mutableCopy];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"CrossBtn"] isEqualToString:@"hidee"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CrossBtn"];
        self.title=@"SELECT PAYMENT";
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];


    }
    else
    {
      self.title=@"SELECT PAYMENT";
    // Right Bar Button Item //
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    RightButton.frame = CGRectMake(20, 0, 30, 30);
    //[RightButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [RightButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [RightButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateHighlighted];
    [RightButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    ////

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];
        
    }

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self WebService];
}
-(void)viewWillDisappear:(BOOL)animated
{
 
}


#pragma mark - Cancel Button Action

- (IBAction)CancelButtonAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Add Payment Button Action

- (IBAction)AddPaymentButtonAction:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            AddCreditCardViewObj=[[AddCreditCardViewController alloc]initWithNibName:@"AddCreditCardViewController" bundle:nil];
            
        }
        else
        {
            AddCreditCardViewObj=[[AddCreditCardViewController alloc]initWithNibName:@"AddCreditCardViewController" bundle:nil];
        }
        AddCreditCardViewObj.CheckForAddNewCreditCard=@"YES";
        [self.navigationController pushViewController:AddCreditCardViewObj animated:YES];
        
    }
 
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CreditCardsListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (CreditCardsListArray.count>0)
    {
        NSMutableDictionary *tempDict=[CreditCardsListArray objectAtIndex:indexPath.row];
        NSString *str=[tempDict valueForKey:@"creditcardnumber"];
    
        if (![str isEqualToString:@""])
        {
            str = [str substringFromIndex: [str length] - 4];
            
           // str=[str substringWithRange:NSMakeRange(0, 4)];
        }
       
        cell.textLabel.text = [NSString stringWithFormat:@"*%@",str];
        cell.imageView.image=[UIImage imageNamed:@"visa.png"];
        if ([[tempDict valueForKey:@"isdefault"] integerValue]==1)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    if(indexPath.row == selectedIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    selectedIndex = indexPath.row;

  //  CreditCardsListArray=[[[NSUserDefaults standardUserDefaults] valueForKey:@"CreditCardList"] mutableCopy];
    
    NSMutableDictionary *tempDict=[[CreditCardsListArray objectAtIndex:indexPath.row] mutableCopy];
   
    GetCardId=[tempDict valueForKey:@"cardid"];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
 
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self MakeFavoriteCreditCard];
  
    }
    [CreditCardListingTable reloadData];
}

#pragma mark - Make Favorite Credit Card

-(void)MakeFavoriteCreditCard
{
    [kappDelegate ShowIndicator];
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"riderid",GetCardId,@"cardid",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SetSomeCardsAsDefault",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Login Web Service

-(void)WebService
{
    webservice=2;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"user"],@"useremail",[[NSUserDefaults standardUserDefaults] valueForKey:@"pass"],@"password",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Login",Kwebservices]];
    
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
  //  [alert show];
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
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Card Select as Default Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=4;
                
                [alert show];
            }
        }
    }
    else if (webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            //NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                
            }
            else
            {
                
                NSLog(@"%@",userDetailDict);
                [[NSUserDefaults standardUserDefaults] setValue:[userDetailDict valueForKey:@"userid"] forKey:@"UserId"];
                NSMutableArray *arr=[userDetailDict valueForKey:@"listCreditCards"];
                CreditCardsListArray=[arr mutableCopy];
                if ([CreditCardsListArray count]==1)
                {
                    CreditCardListingTable.frame=CGRectMake(25, 71, 271, 50);
                }
                else if ([CreditCardsListArray count]==2)
                {
                    CreditCardListingTable.frame=CGRectMake(25, 71, 271, 80);
                }
                [CreditCardListingTable reloadData];
            }
        }
        
    }
    
}

#pragma mark - UIAlert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==4)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
