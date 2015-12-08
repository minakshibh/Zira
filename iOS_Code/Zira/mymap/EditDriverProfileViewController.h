//
//  EditDriverProfileViewController.h
//  mymap
//
//  Created by vikram on 15/12/14.
//

#import <UIKit/UIKit.h>

@interface EditDriverProfileViewController : UIViewController

{
    
    IBOutlet UIScrollView *scrollView;
    NSMutableArray     *UserRecordArray;
    NSMutableData *webData;
    NSDictionary *jsonDict;
    NSString *jsonRequest ;
    NSURL *urlString;
    
    //Driver Variables
    
    IBOutlet UIImageView *DriverImageView;
    IBOutlet UILabel *DriverNameLabel;
    IBOutlet UILabel *DriverEmail;
    IBOutlet UILabel *DriverPhoneNo;
    
    
    
    //vech variables
    
    IBOutlet UIImageView *VechicleImageView;
    IBOutlet UILabel *VechMake;
    IBOutlet UILabel *VechModel;
    IBOutlet UILabel *VechNo;

    IBOutlet UILabel *vechYear;
    IBOutlet UILabel *lisencePlateCntry;
    IBOutlet UILabel *lisencePlateState;
    IBOutlet UILabel *address;
    IBOutlet UILabel *zipcode;
    IBOutlet UILabel *city;
    IBOutlet UILabel *state;
    IBOutlet UILabel *DLNo;
    
    IBOutlet UILabel *DLState;
    IBOutlet UILabel *SocialNo;
    
    IBOutlet UILabel *infolabel;
    IBOutlet UILabel *sidelbl;
    IBOutlet UILabel *sidelbl1;
    IBOutlet UILabel *sidelbl2;
    IBOutlet UILabel *sidelbl3;
    IBOutlet UILabel *sidelbl4;
    IBOutlet UILabel *sidelbl5;
    IBOutlet UILabel *sidelbl6;
    IBOutlet UILabel *sidelbl7;
    IBOutlet UILabel *sidelbl8;
    IBOutlet UILabel *sidelbl9;
    IBOutlet UIButton *driverEditBtn;
    IBOutlet UIView *driverInfoBgView;
    
    
    
}
- (IBAction)EditProfileInfo:(id)sender;
- (IBAction)EditVechInfo:(id)sender;
- (IBAction)SignOutBtnAction:(id)sender;

@property(nonatomic,retain) NSMutableArray  *UserRecordArray;

@end
