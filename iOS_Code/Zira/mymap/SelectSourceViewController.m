//
//  SelectSourceViewController.m
//  mymap
//
//  Created by vikram on 21/11/14.
//

#import "SelectSourceViewController.h"
#import "HomeViewController.h"

@interface SelectSourceViewController ()

@end

@implementation SelectSourceViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
    current_longitude=self.locationManager.location.coordinate.longitude;
    current_latitude=self.locationManager.location.coordinate.latitude;
    
   // NSLog(@"%f %f",current_latitude,current_longitude);

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SourcePlaceDict"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
    ResultsTableView.hidden=YES;

   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SourcePlaceDict"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];

}

#pragma mark - Cancel Button Action

- (IBAction)CancelButtonAction:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Text Field Delegates

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    //30.711147 ,76.686222
   // current_latitude=30.711147;
   // current_longitude=76.686222;
    //AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds
    
//    if (locationArray.count>0)
//    {
//        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds",SearchSourceTextField.text];
//        
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        NSURL *queryUrl = [NSURL URLWithString:url];
//      //  NSLog(@"query url%@",queryUrl);
//        dispatch_async(dispatch_get_main_queue(), ^
//                       {
//                           NSData *data = [NSData dataWithContentsOfURL:queryUrl];
//                           [self fetchData:data];
//                       });
//       // [SearchSourceTextField resignFirstResponder];
//        
//        return  YES;
//    }
   // else
   // {
    
   // current_latitude=36.778261;
   // current_longitude=-119.4179324;

    
    NSString *substring = [NSString stringWithString:SearchSourceTextField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
  //  NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%f,%f&radius=5000&sensor=false&key=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds",substring,current_latitude,current_longitude];
    
    NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%f,%f&radius=10000&sensor=false&key=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds&input=%@",current_latitude,current_longitude,substring];

    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
    {
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self fetchLocaotionList:data];
                       });
    });
        
        return YES;

   // }


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // if (locationArray.count>0)
   // {
      //  return YES;
   // }
   // else
   // {
       // NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds",SearchSourceTextField.text];
    
      //  url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
      //  NSURL *queryUrl = [NSURL URLWithString:url];
     //   dispatch_async(dispatch_get_main_queue(), ^
      //  {
        //    NSData *data = [NSData dataWithContentsOfURL:queryUrl];
      //      [self fetchData:data];
       // });
    [SearchSourceTextField resignFirstResponder];
    
    return  YES;
    //}
}

-(void)fetchData:(NSData *)data
{
    locationArray=[[NSMutableArray alloc]init];

    NSDictionary *gc;
    gc=nil;
   // NSString *str=[gc objectForKey:@"address"];
  //  NSLog(@"%@",str);
    NSError *error;
   // NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   // NSLog(@"responseString:%@",responseString);
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    
    if (results.count>0)
    {
        ResultsTableView.hidden=NO;
    }
    else
    {
        ResultsTableView.hidden=YES;
    }
    
  //  NSLog(@"Data is:%@" ,results);
    
    if (results.count>0)
    {
        for (int i = 0;i <[results count]; i++)
        {
            searchResults=searchResults+1;
            NSDictionary *result = [results objectAtIndex:i];
           // NSLog(@"Data is %@", result);
            address = [result objectForKey:@"formatted_address"];
            NSLog(@"Address is %@", address);
            NSString *name = [result objectForKey:@"name"];
            NSLog(@"name is %@", name);
            NSDictionary *geometry = [result objectForKey: @"geometry"];
            NSDictionary *locations = [geometry objectForKey:@"location"];
            NSString *lat =[locations objectForKey:@"lat"];
            NSString *lng =[locations objectForKey:@"lng"];
            NSLog(@"longitude is %@", lng);
            gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address",name,@"name", nil];
            
            location = gc;
             lat1 = [[location objectForKey:@"lat"] doubleValue];
            NSLog(@"Marker position%f",lat1);
             lng1 = [[location objectForKey:@"lng"] doubleValue];
            NSLog(@"Marker position%f",lng1);
            NSMutableDictionary *tempDict=[[NSMutableDictionary alloc] init];
            [tempDict setValue:address forKey:@"description"];
            [locationArray addObject:tempDict];
        }
    }
    [ResultsTableView reloadData];
    
//    TempDictForSource=[[NSMutableArray alloc] init];
//    [TempDictForSource addObject:address];
//
//    
//    [TempDictForSource addObject:[NSString stringWithFormat:@"%f",lat1]];
//    [TempDictForSource addObject:[NSString stringWithFormat:@"%f",lng1]];
//    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SearchFor"] isEqualToString:@"Source"])
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"SourceSearch" forKey:@"ComingFrom"];
//        [[NSUserDefaults standardUserDefaults] setValue:TempDictForSource forKey:@"SourcePlaceDict"];
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:@"DestinationSearch" forKey:@"ComingFrom"];
//        [[NSUserDefaults standardUserDefaults] setValue:TempDictForSource forKey:@"SourcePlaceDict"];
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
    
}

#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
  //  NSLog(@"%@",locationArray);
    if (locationArray.count>0)
    {
    NSMutableDictionary *tempDict=[locationArray objectAtIndex:indexPath.row];
    NSString *placesName = [tempDict objectForKey:@"description"];
    cell.textLabel.text = placesName;
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *placesName;
    if (locationArray.count>0)
    {
        NSMutableDictionary *tempDict=[locationArray objectAtIndex:indexPath.row];
        placesName = [tempDict objectForKey:@"description"];
    }
    TempDictForSource=[[NSMutableArray alloc] init];
    [TempDictForSource addObject:placesName];
    
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", placesName];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
  //  NSLog(@"query url%@",queryUrl);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        [self fetchLongitudeAndLattitude:data];
    });
    
    //[self MoveToHomeView];
}

#pragma mark - Fetch Lattitude and Longitude

-(void)fetchLongitudeAndLattitude:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    NSString *latitudeStr;
    NSString *longitudeStr;
   // NSLog(@"Data is:%@" ,results);
    NSString *addressStr;
    
  //  30.714131, 76.690016

    if (results.count>0)
    {
        for (int i = 0;i <[results count]; i++)
        {
            NSDictionary *result = [results objectAtIndex:i];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
            NSDictionary*locationDict=[geometry objectForKey:@"location"];
            addressStr=[result objectForKey:@"formatted_address"];
            latitudeStr=[locationDict objectForKey:@"lat"];
            longitudeStr=[locationDict objectForKey:@"lng"];
            
        }
    }
    
        CLLocationCoordinate2D center;
        center.latitude = [latitudeStr doubleValue];
        center.longitude = [longitudeStr doubleValue];
      //  NSLog(@"latt of address.. %.2f",[latitudeStr doubleValue]);
       // NSLog(@"long of address .. %.2f",[longitudeStr doubleValue]);
    [TempDictForSource addObject:[NSString stringWithFormat:@"%f",[latitudeStr doubleValue]]];
    [TempDictForSource addObject:[NSString stringWithFormat:@"%f",[longitudeStr doubleValue]]];

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"SearchFor"] isEqualToString:@"Source"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"SourceSearch" forKey:@"ComingFrom"];
        [[NSUserDefaults standardUserDefaults] setValue:TempDictForSource forKey:@"SourcePlaceDict"];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"DestinationSearch" forKey:@"ComingFrom"];
        [[NSUserDefaults standardUserDefaults] setValue:TempDictForSource forKey:@"SourcePlaceDict"];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Fetch Locations List

-(void)fetchLocaotionList:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"predictions"];
    NSLog(@"Data is:%@" ,results);
    if (results.count>0)
    {
        ResultsTableView.hidden=NO;
    }
    else
    {
        ResultsTableView.hidden=YES;
    }
    
    locationArray=[[NSMutableArray alloc]init];
    if (results.count>0) {
        for (int i = 0;i <[results count]; i++)
        {
            NSDictionary *result = [results objectAtIndex:i];
            NSString *placesName = [result objectForKey:@"description"];
            NSArray* tempArray = [placesName componentsSeparatedByString: @","];
            if (tempArray.count>0)
            {
                placesName =[NSString stringWithFormat:@"%@", [tempArray objectAtIndex:0]];
            }
            
            [locationArray addObject:result];
        }
    }
   // else
//    {
//        //AIzaSyARfvZ_reZBbuEILzSR9nSO6b0LdYUB0NE  working key
//        
//        //key1=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds
//        
//        //AIzaSyAXzsYEmzyNnOsSxhVMBPPgCLhUEB3gPz4
//        
//        //AIzaSyDqIWDQuj21MINIa23DzWGfrW0iB1M0l8w
//        
//        //33.874908, -118.132432
//
//        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=AIzaSyC7FBxjmMI8BgSr8HVeHUB_7OeaLf_kwds",SearchSourceTextField.text];
//        
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
//        NSURL *queryUrl = [NSURL URLWithString:url];
//        //  NSLog(@"query url%@",queryUrl);
//        dispatch_async(dispatch_get_main_queue(), ^
//                       {
//                           NSData *data = [NSData dataWithContentsOfURL:queryUrl];
//                           [self fetchData:data];
//                       });
//        // [SearchSourceTextField resignFirstResponder];
//        
//    }
  //  NSLog(@"places Array ..%@",locationArray);
    //ResultsTableView.hidden=NO;

    [ResultsTableView reloadData];
}

#pragma mark - Move to Home View

-(void)MoveToHomeView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
            HomeViewController* HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:NO];
        }
        else
        {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

           HomeViewController* HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];

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
