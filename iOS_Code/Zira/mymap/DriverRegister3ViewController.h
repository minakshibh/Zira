//
//  DriverRegister3ViewController.h
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


@interface DriverRegister3ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest ;
    NSString *ImageType;
    
    NSString *comingFrom;
    NSMutableArray *userRecordArray;
    IBOutlet UIScrollView *ScrollView;

    
    
    NSMutableDictionary *Register2ViewDict;
    IBOutlet UIImageView *RCLImageView;
    IBOutlet UIImageView *VechicleImageView;
    IBOutlet UIImageView *DLImageView;
    IBOutlet UIImageView *MedicalImageView;
    NSString *TriggerValue;
    IBOutlet UIButton *checkBoxBtn;
    int flag;
    
    

}
- (IBAction)ChooseRCLImage:(id)sender;
- (IBAction)ChooseVechicleImage:(id)sender;
- (IBAction)ChooseDLImage:(id)sender;
- (IBAction)ChooseMedicalImage:(id)sender;
- (IBAction)DoneButtonAction:(id)sender;
- (IBAction)CheckBoxButton:(id)sender;


@property(nonatomic,retain)NSString *comingFrom;
@property(nonatomic,retain)NSMutableArray *userRecordArray;

@property(nonatomic,retain)NSMutableDictionary *Register2ViewDict;
@end
