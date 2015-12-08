//
//  DriverRegister2ViewController.h
//  mymap
//
//  Created by vikram on 24/11/14.
//

#import <UIKit/UIKit.h>

@interface DriverRegister2ViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

{
    
    NSString *comingFrom,*stateIdStr,*DrivingLicsenceStateIDSTR;
    NSMutableArray *userRecordArray;

    NSMutableDictionary *Register1ViewDict;
    
    IBOutlet UIScrollView *ScrollView;
    IBOutlet UIView *DetailsView;
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    
    NSMutableArray *cityNames,*cityIdsArray;
    NSString*cityIDstr;
    
    IBOutlet UITextField *Address1TextField;
    IBOutlet UITextField *ZipCodeTextField;
    IBOutlet UITextField *CityTextField;
    IBOutlet UITextField *StateTextField;
    IBOutlet UITextField *DrivingLicsenceNoTextField;
    IBOutlet UITextField *DrivingLicsenceStateTextField;
    IBOutlet UITextField *DrivingLicsenceExpDateTextField;
    IBOutlet UITextField *DOBTextField;
    IBOutlet UITextField *SocialSecurityNoTextField;
    
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIView *PickerBackGroundView;

    NSMutableArray *StateNames;
    NSString *TextFieldType;
    IBOutlet UIView *PickerBgView;
    IBOutlet UIDatePicker *DatePickerView;
    NSString *TextFieldValue;
    
}

@property(nonatomic,retain)NSString *comingFrom;
@property(nonatomic,retain)NSMutableArray *userRecordArray;

@property(nonatomic,retain) NSMutableArray *StateNames,*stateIdsArray;
@property(nonatomic,retain) NSMutableDictionary *Register1ViewDict;

- (IBAction)SaveAndContinueBtnAction:(id)sender;
- (IBAction)StateButtonAction:(id)sender;
- (IBAction)DrivingLicsenceState:(id)sender;
- (IBAction)DoneButtonAction:(id)sender;
- (IBAction)DoneViewBtn:(id)sender;
- (IBAction)DrivingLicExpDateBtnAction:(id)sender;
- (IBAction)DOBButtonAction:(id)sender;
- (IBAction)selectCityBtn:(id)sender;



@end
