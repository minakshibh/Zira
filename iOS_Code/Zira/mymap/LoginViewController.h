//
//  LoginViewController.h
//  UberLikeApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewViewController.h"
#import "ForgotPasswordViewController.h"
#import "HomeViewController.h"
#import "RegistrarionViewController.h"
#import <FacebookSDK/FacebookSDK.h>


#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"


@class GPPSignInButton;

@interface LoginViewController : UIViewController <UITextFieldDelegate,FBLoginViewDelegate,UIAlertViewDelegate>

{
      NSMutableData *webData;
     int webservice;
     NSDictionary *jsonDict;
     NSURL *urlString;
     NSString *jsonRequest ;
    
    
    NSString *LoginWith;
    NSString *FacebookEmailId;
    NSString *GmailId;

    
     IBOutlet UITextField *UserEmailTextField;
     IBOutlet UITextField *PasswordTextField;
    
    UIView *animatedView;
    UIImageView*DriverImgView;
    UILabel *DriverNameLbl;
    UILabel *MessageLbl;
    NSString *TripId;
    int TimerValue;
    NSTimer *DownTimer;
    UIView  *ProgressBarView;
    UILabel *Timerlbl;
    float counter;
    float progressFloat;
    float fileSize;
    UIButton *AcceptBtn;
    NSTimer *progressTimer;
    
    //Facebook Variables

    NSString *FacebookFirstName;
    NSString *FacebookLastName;
    NSString *FacebookPhoneNo;
    NSString *FacebookImage;
    NSString *FacebookID;
    NSString  *FacebookImageBase64;
    
    //Gmail Variables
    
    NSString *GmailFirstName;
    NSString *GmailLastName;
    NSString *GmailImageBase64;





    
}
@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;


@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *zira;

- (IBAction)LoginButtonAction:(id)sender;
- (IBAction)ForgotPasswordButton:(id)sender;
- (IBAction)RegisterButtonAction:(id)sender;

//gmail login

@property(weak, nonatomic) IBOutlet GPPSignInButton *signInButton;
// A label to display the result of the sign-in action.
@property(weak, nonatomic) IBOutlet UILabel *signInAuthStatus;
// A label to display the signed-in user's display name.
@property(weak, nonatomic) IBOutlet UILabel *userName;
// A label to display the signed-in user's email address.
@property(weak, nonatomic) IBOutlet UILabel *userEmailAddress;
// An image view to display the signed-in user's avatar image.
@property(weak, nonatomic) IBOutlet UIImageView *userAvatar;
// A button to sign out of this application.
@property(weak, nonatomic) IBOutlet UIButton *signOutButton;
// A button to disconnect user from this application.
@property(weak, nonatomic) IBOutlet UIButton *disconnectButton;
// A button to inspect the authorization object.
@property(weak, nonatomic) IBOutlet UIButton *credentialsButton;
// A dynamically-created slider for controlling the sign-in button width.
@property(weak, nonatomic) UISlider *signInButtonWidthSlider;

// Called when the user presses the "Sign out" button.
- (IBAction)signOut:(id)sender;
// Called when the user presses the "Disconnect" button.
- (IBAction)disconnect:(id)sender;
// Called when the user presses the "Credentials" button.
- (IBAction)showAuthInspector:(id)sender;




@end
