//
//  FareEstimateViewController.m
//  mymap
//
//  Created by vikram on 11/12/14.
//

#import "FareEstimateViewController.h"
#import "SelectSourceViewController.h"
SelectSourceViewController *SelectSourceViewObj;

@interface FareEstimateViewController ()

@end

@implementation FareEstimateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
    }
    return self;
}


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    
    FareLabel.text=@"$0.00";

    self.title=@"FARE ESTIMATE";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];
    
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
    
    
    NSDictionary* userInfo = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FareDetails"] mutableCopy];
    
    SourceLabel.text=[userInfo valueForKey:@"SourceText"];
    DestinationLabel.text=[userInfo valueForKey:@"DestinationText"];
    SourceLatitude=[[userInfo valueForKey:@"SourceLat"] floatValue];
    SourceLongitude=[[userInfo valueForKey:@"SourceLong"] floatValue];
    DestinationLatitude=[[userInfo valueForKey:@"DestLat"] floatValue];
    DestinationLongitude=[[userInfo valueForKey:@"DestLong"] floatValue];
    
    if (DestinationLatitude!=0)
    {
        NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",SourceLatitude,SourceLongitude,DestinationLatitude,DestinationLongitude];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchData:data];
        });
        
    }




    [super viewDidLoad];
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ComingFrom"] isEqualToString:@"SourceSearch"])
    {
        
        tempArray=[[NSMutableArray alloc] init];
        tempArray=[[NSUserDefaults standardUserDefaults] valueForKey:@"SourcePlaceDict"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SourcePlaceDict"];
        NSString *sourceText=[tempArray objectAtIndex:0];
        SourceLabel.text=sourceText;
        SourceLatitude=[[tempArray objectAtIndex:1] doubleValue];
        SourceLongitude=[[tempArray objectAtIndex:2] doubleValue];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ComingFrom"] isEqualToString:@"DestinationSearch"])
    {
        tempArray=[[NSMutableArray alloc] init];
        tempArray=[[NSUserDefaults standardUserDefaults] valueForKey:@"SourcePlaceDict"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SourcePlaceDict"];
        DestinationLabel.hidden=NO;
        
        NSString *DestinationText=[tempArray objectAtIndex:0];
        DestinationLabel.text=DestinationText;
        DestinationLatitude=[[tempArray objectAtIndex:1] doubleValue];
        DestinationLongitude=[[tempArray objectAtIndex:2] doubleValue];
        
        
        NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",SourceLatitude,SourceLongitude,DestinationLatitude,DestinationLongitude];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchData:data];
        });

    }

}

#pragma mark - Fetch Data

-(void)fetchData:(NSData *)data
{
    NSError *error;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"rows"];
    NSLog(@"Data is:%@" ,results);
    
    for (int i = 0;i <[results count]; i++)
    {
        NSDictionary *result = [results objectAtIndex:i];
        NSLog(@"Data is %@", result);
        
        NSString *statusStr=[[[result objectForKey:@"elements"]valueForKey:@"status"]objectAtIndex:0];
        if ([statusStr isEqualToString:@"ZERO_RESULTS"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"RapidRide" message:@"Invalid Request." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=5;
           // [alert show];
            return;
        }
        NSString *tempdistaceStr = [[[[result objectForKey:@"elements"]valueForKey:@"distance"]valueForKey:@"text"]objectAtIndex:0];
        estimatedTimeStr = [[[[result objectForKey:@"elements"]valueForKey:@"duration"]valueForKey:@"text"]objectAtIndex:0];
        
        distanceStr =[NSString stringWithFormat:@"%@",tempdistaceStr];
        
        NSArray *distArray = [distanceStr componentsSeparatedByString:@" "];
        NSString *kmStr=[distArray objectAtIndex:1];
        distanceStr=[distanceStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if( [kmStr caseInsensitiveCompare:@"KM"] == NSOrderedSame)
        {
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"km" withString:@""];
            
            
            estimatedDistance= [distanceStr floatValue]*0.62137*1000;
            //final distance
            estimatedDistance=estimatedDistance/1000;
        }
        else{
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"m" withString:@""];
            
            estimatedDistance= [distanceStr floatValue]* 0.00062137;
        }
        
        //final dis
      //  distanceLbl.text=[NSString stringWithFormat:@"%.2f Miles",estimatedDistance];
        
        
        if (estimatedTimeStr.length>7)
        {
            NSArray *timeArray = [estimatedTimeStr componentsSeparatedByString:@" "];
            int minutes=[[timeArray objectAtIndex:2]intValue];
            int hours=[[timeArray objectAtIndex:0]intValue];
            minutes=hours*60+minutes;
            estimatedTimeStr=[NSString stringWithFormat:@"%d",minutes];
           // self.estimatedTimeLbl.text=[NSString stringWithFormat:@"%@ mins",estimatedTimeStr];
        }
        else{
            
            //final time
            //self.estimatedTimeLbl.text=[NSString stringWithFormat:@"%@",estimatedTimeStr];
        }
    }
    
    NSMutableDictionary *PriceDetailsDict=[[NSMutableDictionary alloc] init];
    PriceDetailsDict=[[[NSUserDefaults standardUserDefaults] valueForKey:@"PriceDetails"] mutableCopy];

    price_per_minute=[PriceDetailsDict valueForKey:@"PriceMintue"];
    price_per_mile=[PriceDetailsDict valueForKey:@"PriceMile"];
    surgeValue=[PriceDetailsDict valueForKey:@"SurgeValue"];
    base_fare=[PriceDetailsDict valueForKey:@"BaseFare"];

    
    NSLog(@"base fare==%@",base_fare);
    NSLog(@"estTime==%@",estimatedTimeStr);
    NSLog(@"priceMinute ==%@",price_per_minute);
    NSLog(@"estDiastanc ==%f",estimatedDistance);
    NSLog(@" priceMile==%@",price_per_mile);
    
    
    NSLog(@"%f",([estimatedTimeStr intValue]*[price_per_minute floatValue]));
    NSLog(@"%f",(estimatedDistance *[price_per_mile floatValue]));
    NSLog(@"%@",[NSString stringWithFormat:@"%f",[surgeValue  floatValue]]);
    
    
    float actualPrice=[base_fare floatValue]+([estimatedTimeStr floatValue]*[price_per_minute floatValue])+(estimatedDistance *[price_per_mile floatValue]);
    if ([surgeValue floatValue]>0)
    {
        actualPrice=actualPrice*[surgeValue floatValue];
    }
    
    //Add Safety Charges Here
    
    
    float safetyCharges=[[[NSUserDefaults standardUserDefaults] valueForKey:@"SafetyCharges"] floatValue];
    actualPrice=actualPrice+safetyCharges;
    FareLabel.text=[NSString stringWithFormat:@"$%.2f",actualPrice];
    
  //  int NewActualPrice = (int) actualPrice;
    
    
}

#pragma mark - Cancel Button Action

- (IBAction)CancelButtonAction:(id)sender
{
    FareLabel.text=@"$0.00";

    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Source Button Action

- (IBAction)SourceButtonAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Source" forKey:@"SearchFor"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
  
        }
        else
        {
            
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
        }
        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:SelectSourceViewObj];
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
                         }];
    }
    
}

#pragma mark - Select Destination Button Action

- (IBAction)SelectDestinationButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Destination" forKey:@"SearchFor"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
  
        }
        else
        {
            
            SelectSourceViewObj= [[SelectSourceViewController alloc] init];
        }
        UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:SelectSourceViewObj];
        [self presentViewController:navigationController
                           animated:YES
                         completion:^{
                             
                         }];
    }
}

#pragma mark - Cross Button Action

- (IBAction)CrossButtonAction:(id)sender
{
    DestinationLabel.text=@"";
     FareLabel.text=@"$0.00";
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
