//
//  DriverRegister1ViewController.h
//  mymap
//
//  Created by vikram on 24/11/14.
//

#import <UIKit/UIKit.h>

#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface DriverRegister1ViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    NSString *comingFrom,*countryIdStr,*StateIdStr,*VechicleModelIDStr,*cityIdstr;
    NSMutableArray *userRecordArray;

    
    
    IBOutlet UIScrollView *ScrollView;
    IBOutlet UITextField *ChoseVechicleMakeTextField;
    IBOutlet UITextField *ChoseVechicleModelTextField;
    IBOutlet UITextField *ChoseVechicleYearTextField;
    IBOutlet UITextField *ChoseVechiclePlateNoTextField;
    IBOutlet UITextField *ChoseLicsencePlateCntryTextField;
    IBOutlet UITextField *ChoseLicsencePlateStateTextField;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIView *PickerBackGroundView;

    NSMutableArray *CountryNames,*countryIdarray;
    NSMutableArray *StateNames,*StateIdsArray;
    NSString *TextFieldType;
    NSMutableArray *CommonArray;
    NSMutableArray *VechiclesArray;
    NSMutableArray *VechicleYearArray;
    NSMutableArray *VechicleModelArray,*VechicleModelIDsArray;
    int selectedIndex;
    NSMutableArray *tempYearArr;
    int ModelSelectedIndex;


}

@property(nonatomic,retain)NSString *comingFrom;
@property(nonatomic,retain)NSMutableArray *userRecordArray;

- (IBAction)SaveAndContinueButtonAction:(id)sender;
- (IBAction)DoneButtonAction:(id)sender;
- (IBAction)SelectCountryBtn:(id)sender;
- (IBAction)SelectState:(id)sender;
- (IBAction)SelectVechicle:(id)sender;
- (IBAction)SelectVechicleYear:(id)sender;
- (IBAction)SelectVechicleModel:(id)sender;


@end
