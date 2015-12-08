//
//  FareEstimateViewController.h
//  mymap
//
//  Created by vikram on 11/12/14.
//

#import <UIKit/UIKit.h>

@interface FareEstimateViewController : UIViewController

{
    IBOutlet UILabel *DestinationLabel;
    IBOutlet UILabel *SourceLabel;
    
    double SourceLatitude;
    double SourceLongitude;
    double DestinationLatitude;
    double DestinationLongitude;
    NSMutableArray *tempArray;
    
    NSString *estimatedTimeStr,*distanceStr;
    
    float estimatedDistance;
    NSString *price_per_minute;
    NSString *price_per_mile;
    NSString *base_fare;
    NSString *surgeValue;

    IBOutlet UILabel *FareLabel;





}

- (IBAction)SourceButtonAction:(id)sender;
- (IBAction)SelectDestinationButton:(id)sender;


@end
