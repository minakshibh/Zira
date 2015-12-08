//
//  SelectSourceViewController.h
//  mymap
//
//  Created by vikram on 21/11/14.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SelectSourceViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet UITextField *SearchSourceTextField;
    IBOutlet UITableView *ResultsTableView;
    NSMutableArray      *locationArray;
    
    double current_latitude;
    double current_longitude;
    NSMutableArray *TempDictForSource;
    
    NSDictionary *location;
    int searchResults;
    NSString *address;
    double lat1;
    double lng1;


    
}

@property(nonatomic, strong) CLLocationManager *locationManager;

- (IBAction)CancelButtonAction:(id)sender;


@end
