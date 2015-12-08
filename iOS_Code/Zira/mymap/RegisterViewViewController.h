//
//  RegisterViewViewController.h
//  UberLikeApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "DriverRegister1ViewController.h"
#import "DriverMapViewController.h"

#import <FacebookSDK/FacebookSDK.h>



@interface RegisterViewViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,FBLoginViewDelegate,UIAlertViewDelegate>
{
    
    NSMutableData *webData;
    int webservice;
    NSDictionary *jsonDict;
    NSURL *urlString;
    NSString *jsonRequest;
    
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *LastNameTextField;
    IBOutlet UITextField *EmailTextField;
    IBOutlet UITextField *PasswordTextField;
    IBOutlet UITextField *ConformPassword;
    IBOutlet UITextField *MobileNumber;
    IBOutlet UIImageView *profileImageView;
    
    UIButton *RightButton;
    UIView *FrontView;
    NSMutableArray *UserRecordArray;
    IBOutlet UILabel *UserNameLabel;
    IBOutlet UIButton *UploadImgBtn;
    IBOutlet UIButton *driverBtn;
    
    NSString *EditFrom,*imageNameStr;
    IBOutlet UIButton *signOutBtn;
    
    IBOutlet UIImageView *VechicleImageView;
    IBOutlet UILabel *VechMake;
    IBOutlet UILabel *VechModel;
    IBOutlet UILabel *VechNo;

    IBOutlet UILabel *infoLbl;
    IBOutlet UIButton *editVechInfo;
    
}
//facebook
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;


@property(nonatomic,retain) NSString *EditFrom;
@property(nonatomic,retain) NSMutableArray *UserRecordArray;
- (IBAction)RegisterButtonAction:(id)sender;
- (IBAction)ProfileImageButtonAction:(id)sender;
- (IBAction)LoginHereButtonAction:(id)sender;
- (IBAction)SignOutButtonAction:(id)sender;
- (IBAction)BecomeADriverButtonAction:(id)sender;
- (IBAction)EditVechicleInfo:(id)sender;

@end
