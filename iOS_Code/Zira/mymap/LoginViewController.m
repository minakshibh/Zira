    //
//  LoginViewController.m
//  UberLikeApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//

#import "LoginViewController.h"
#import "Base64.h"

#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <QuartzCore/QuartzCore.h>
#import "LisenceAgrementViewController.h"
#import "UIView+DCAnimationKit.h"
LisenceAgrementViewController *LisenceViewObj;

typedef void(^AlertViewActionBlock)(void);

RegisterViewViewController *registerViewObj;
ForgotPasswordViewController *ForgotPasswordViewObj;
HomeViewController            *HomeViewObj;
RegistrarionViewController    *RegistrationViewObj;


@interface LoginViewController ()<GPPSignInDelegate>

@property (nonatomic, copy) void (^confirmActionBlock)(void);
@property (nonatomic, copy) void (^cancelActionBlock)(void);


@end

@implementation LoginViewController
{
    
    NSArray *_sectionCellLabels;
    
    // These sets contain the labels corresponding to cells that have various
    // types (each cell either drills down to another table view, contains an
    // in-cell switch, or contains a slider).
    NSArray *_drillDownCells;
    NSArray *_switchCells;
    NSArray *_sliderCells;
    
    // States storing the current set of selected elements for each data picker.
    
    // Map that keeps track of which cell corresponds to which DataPickerState.
    NSDictionary *_drilldownCellState;
    
}

@synthesize progressBar;

static NSString *const kPlaceholderUserName = @"<Name>";
static NSString *const kPlaceholderEmailAddress = @"<Email>";
static NSString *const kPlaceholderAvatarImageName = @"PlaceholderAvatar.png";

// Labels for the cells that have in-cell control elements.
static NSString *const kGetUserIDCellLabel = @"Get user ID";
static NSString *const kSingleSignOnCellLabel = @"Use Single Sign-On";
static NSString *const kButtonWidthCellLabel = @"Width";

// Labels for the cells that drill down to data pickers.
static NSString *const kColorSchemeCellLabel = @"Color scheme";
static NSString *const kStyleCellLabel = @"Style";
static NSString *const kAppActivitiesCellLabel = @"App activity types";

// Strings for Alert Views.
static NSString *const kSignOutAlertViewTitle = @"Warning";
static NSString *const kSignOutAlertViewMessage =
@"Modifying this element will sign you out of G+. Are you sure you wish to continue?";
static NSString *const kSignOutAlertCancelTitle = @"Cancel";
static NSString *const kSignOutAlertConfirmTitle = @"Continue";

// Accessibility Identifiers.
static NSString *const kCredentialsButtonAccessibilityIdentifier = @"Credentials";

#pragma mark - View lifecycle

- (void)gppInit {
    //  _sectionCellLabels = @[
    //    @[ kColorSchemeCellLabel, kStyleCellLabel, kButtonWidthCellLabel ],
    //    @[ kAppActivitiesCellLabel, kGetUserIDCellLabel, kSingleSignOnCellLabel ]
    //  ];
    //
    //  // Groupings of cell types.
    //  _drillDownCells = @[
    //    kColorSchemeCellLabel,
    //    kStyleCellLabel,
    //    kAppActivitiesCellLabel
    //  ];
    //
    //  _switchCells = @[ kGetUserIDCellLabel, kSingleSignOnCellLabel ];
    //  _sliderCells = @[ kButtonWidthCellLabel ];
    //
    //  // Initialize data picker states.
    //  NSString *dictionaryPath =
    //      [[NSBundle mainBundle] pathForResource:@"DataPickerDictionary"
    //                                      ofType:@"plist"];
    //  NSDictionary *configOptionsDict =
    //      [NSDictionary dictionaryWithContentsOfFile:dictionaryPath];
    //
    //  NSDictionary *colorSchemeDict =
    //      [configOptionsDict objectForKey:kColorSchemeCellLabel];
    //  NSDictionary *styleDict = [configOptionsDict objectForKey:kStyleCellLabel];
    //  NSDictionary *appActivitiesDict =
    //      [configOptionsDict objectForKey:kAppActivitiesCellLabel];
    //
    //  _colorSchemeState =
    //      [[DataPickerState alloc] initWithDictionary:colorSchemeDict];
    //  _styleState = [[DataPickerState alloc] initWithDictionary:styleDict];
    //  _appActivitiesState =
    //      [[DataPickerState alloc] initWithDictionary:appActivitiesDict];
    //
    //  _drilldownCellState = @{
    //    kColorSchemeCellLabel :   _colorSchemeState,
    //    kStyleCellLabel :         _styleState,
    //    kAppActivitiesCellLabel : _appActivitiesState
    //  };
    //
    // Make sure the GPPSignInButton class is linked in because references from
    // xib file doesn't count.
    [GPPSignInButton class];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    // Sync the current sign-in configurations to match the selected
    // app activities in the app activity picker.
    if (signIn.actions) {
        //        [_appActivitiesState.selectedCells removeAllObjects];
        //
        //        for (NSString *appActivity in signIn.actions) {
        //            [_appActivitiesState.selectedCells
        //             addObject:[appActivity lastPathComponent]];
        //        }
    }
    
    signIn.delegate = self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self gppInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self gppInit];
    }
    return self;
}



#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [self logout];
    
    //[self.zira swing:NULL];
    //[self.zira expandIntoView:self.view finished:NULL];
    
//    NSMutableAttributedString * attributedString= [[NSMutableAttributedString alloc] initWithString:@"ZIRA.ZIRA.ZIRA"];
//    [attributedString addAttrib   ute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,5)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(5,6)];
//   //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11,5)];
//    self.zira.attributedText = attributedString;
    
    
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
//    self.navigationItem.hidesBackButton = YES;
//
//
//    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];
//
//    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Account"] isEqualToString:@"Login"])
//    {
//        [self MoveToHomeView];
//    }
//    
//    //Login with facebook
//    [self toggleHiddenState:YES];
//    self.lblLoginStatus.text = @"";
//    
//    self.loginButton.delegate = self;
//    self.loginButton.readPermissions = @[@"public_profile", @"email"];
//    
//    [super viewDidLoad];
//    [self gppInit];
//    self.credentialsButton.accessibilityIdentifier = kCredentialsButtonAccessibilityIdentifier;
  //  [self test];

//    [[GPPSignIn sharedInstance] signOut];
//    [self reportAuthStatus];
//    [self updateButtons];

    // Do any additional setup after loading the view from its nib.
}
-(void)test
{
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"id",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/User",@"http://112.196.24.205:1075/Service1.svc"]];
    
    [self postWebservices];
}
-(void)DownTimeCal
{
    TimerValue=TimerValue-1;
    Timerlbl.text=[NSString stringWithFormat:@"%d",TimerValue];
    if (TimerValue==0)
    {
        [DownTimer invalidate];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You missed a request!" message:@"You did not attempt to accept this request. if you're unavailable, Please turn off driver mode." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
#pragma mark - Accept Button Action
-(void)logout
{
    [kappDelegate ShowIndicator];
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"amrikhappy@yahoo.in",@"useremail",nil];
    
  //  jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"49",@"riderid",@" Alfa Romeo",@"vehicle_make",@"54",@"vehicle_model",@"2009",@"vehicle_year",@"dsfd4566",@"licensePlateNumber",@"16",@"licensePlateCountry",@"201",@"licensePlateState",@"dasfasd",@"address1",@"adsfadsfdsf",@"address2",@"5",@"city",@"230",@"state",@"136118",@"zipcode",@"asdas+6564d",@"drivingLicenseNumber",@"185",@"drivingLicenseState",@"2010-12-16 00:00:00",@"drivingLicenseExpirationDate",@"19971216",@"dateofbirth",@"asdasdasdasd",@"socialSecurityNumber",@"Img_5c24cca5-8e72-49b5-b96a-03ee74d05e45.png",@"licenseImage",@"Img_30947179-82ee-499f-8722-537fa3221729.png",@"medicalCertificateImage",@"Img_f7c34f15-ccc3-49fb-8cad-c9d62b526f78.png",@"vehicleImage",@"Img_f463f8f6-4921-4abf-b2e5-37ae8e59fc0d.png",@"rcImage",nil];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Logout",Kwebservices]];
    
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    //urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://112.196.24.205:821/ZiraMobileService.svc/GetStateList"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    //  data = [NSData dataWithContentsOfURL:urlString];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
    
}

-(IBAction)AcceptButtonAction:(id)sender
{
    [DownTimer invalidate];
    progressBar.progress = 0.0;
    progressFloat = 0.0;
    counter = 0.0;
    [AcceptBtn removeFromSuperview];
    [progressTimer invalidate];
    [animatedView removeFromSuperview];
    [ProgressBarView removeFromSuperview];
    
    //call accept web service
    //[self AcceptRideRequest];
    
}
-(void)progressUpdate
{
    if (progressFloat <100.0)
    {
        counter = counter-1;
        progressFloat = counter/fileSize;
        progressBar.progress = progressFloat;
        [self performSelector:@selector(progressUpdate) withObject:nil afterDelay:0.2];
    }
}


-(void)cancelRideTimerCount
{
    
}
-(void)DisableView
{
    progressBar.progress = 0.0;
    progressFloat = 0.0;
    counter = 0.0;
    
    [AcceptBtn removeFromSuperview];
    [progressTimer invalidate];
    [animatedView removeFromSuperview];
    [ProgressBarView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.navigationItem.hidesBackButton = YES;

    [FBSession.activeSession closeAndClearTokenInformation];
    UserEmailTextField.text=@"";
    PasswordTextField.text=@"";
    [UserEmailTextField resignFirstResponder];
    [PasswordTextField resignFirstResponder];
    
  
    [[GPPSignIn sharedInstance] signOut];
    [self reportAuthStatus];
    [self updateButtons];

    
    
    [self adoptUserSettings];
    [[GPPSignIn sharedInstance] trySilentAuthentication];
    [self reportAuthStatus];
    [self updateButtons];
    [super viewWillAppear:animated];
}

#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Authentication error: %@", error];
        return;
    }
    [self reportAuthStatus];
    [self updateButtons];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Failed to disconnect: %@", error];
    } else {
        _signInAuthStatus.text =
        [NSString stringWithFormat:@"Status: Disconnected"];
    }
    [self refreshUserInfo];
    [self updateButtons];
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    [[self navigationController] pushViewController:viewController animated:YES];
}

#pragma mark - Helper methods

// Updates the GPPSignIn shared instance and the GPPSignInButton
// to reflect the configuration settings that the user set
- (void)adoptUserSettings
{
   // GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    // There should only be one selected color scheme
    //    for (NSString *scheme in _colorSchemeState.selectedCells) {
    //        if ([scheme isEqualToString:@"Light"]) {
   // _signInButton.colorScheme = kGPPSignInButtonColorSchemeLight;
    
    _signInButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"google1.png"]];

    //        } else {
    //            _signInButton.colorScheme = kGPPSignInButtonColorSchemeDark;
    //        }
    //    }
    
    // There should only be one selected style
    //    for (NSString *style in _styleState.selectedCells) {
    GPPSignInButtonStyle newStyle;
    //        if ([style isEqualToString:@"Standard"]) {
    newStyle = kGPPSignInButtonStyleStandard;
    self.signInButtonWidthSlider.enabled = YES;
    //        } else if ([style isEqualToString:@"Wide"]) {
    //            newStyle = kGPPSignInButtonStyleWide;
    //            self.signInButtonWidthSlider.enabled = YES;
    //        } else {
    //            newStyle = kGPPSignInButtonStyleIconOnly;
    //            self.signInButtonWidthSlider.enabled = NO;
    //        }
    //        if (self.signInButton.style != newStyle) {
    //            self.signInButton.style = newStyle;
    //            self.signInButtonWidthSlider.minimumValue = [self minimumButtonWidth];
    //        }
    self.signInButtonWidthSlider.value = _signInButton.frame.size.width;
    //    }
    
    // There may be multiple app activity types supported
    //    NSMutableArray *supportedAppActivities = [[NSMutableArray alloc] init];
    //    for (NSString *appActivity in _appActivitiesState.selectedCells) {
    //        NSString *schema =
    //        [NSString stringWithFormat:@"http://schemas.google.com/%@",
    //         appActivity];
    //        [supportedAppActivities addObject:schema];
    //    }
    //    signIn.actions = supportedAppActivities;
}

// Temporarily force the sign in button to adopt its minimum allowed frame
// so that we can find out its minimum allowed width (used for setting the
// range of the width slider).
- (CGFloat)minimumButtonWidth {
    CGRect frame = self.signInButton.frame;
    self.signInButton.frame = CGRectZero;
    
    CGFloat minimumWidth = self.signInButton.frame.size.width;
    self.signInButton.frame = frame;
    
    return minimumWidth;
}

- (void)reportAuthStatus {
    if ([GPPSignIn sharedInstance].authentication) {
        _signInAuthStatus.text = @"Status: Authenticated";
    } else {
        // To authenticate, use Google+ sign-in button.
        _signInAuthStatus.text = @"Status: Not authenticated";
    }
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo
{
    if ([GPPSignIn sharedInstance].authentication == nil) {
        self.userName.text = kPlaceholderUserName;
        self.userEmailAddress.text = kPlaceholderEmailAddress;
        self.userAvatar.image = [UIImage imageNamed:kPlaceholderAvatarImageName];
        return;
    }
    
    self.userEmailAddress.text = [GPPSignIn sharedInstance].userEmail;
    GmailId=[GPPSignIn sharedInstance].userEmail;
    LoginWith=@"gmail";
    
    
    GTLPlusPerson *person = [GPPSignIn sharedInstance].googlePlusUser;
    if (person == nil) {
        return;
    }
    NSLog(@"%@",person);
    
    //Get User firstname and lastname
    NSString *GmailName=person.displayName;
    NSArray* arr = [GmailName componentsSeparatedByString:@" "];
    GmailFirstName=[arr objectAtIndex:0];
    GmailLastName=[arr objectAtIndex:1];
    
    //get gmail image
    
    NSString *imageURLStr = person.image.url;
    NSURL *url = [NSURL URLWithString:imageURLStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [Base64 initialize];
    GmailImageBase64 = [Base64 encode:data];

    
    
    
    [self GmailLoginWebService];
    
    
    // The googlePlusUser member will be populated only if the appropriate
    // scope is set when signing in.
    self.userName.text = person.displayName;
    
    // Load avatar image asynchronously, in background
    dispatch_queue_t backgroundQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroundQueue, ^{
        NSData *avatarData = nil;
        NSString *imageURLString = person.image.url;
        if (imageURLString) {
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            avatarData = [NSData dataWithContentsOfURL:imageURL];
        }
        
        if (avatarData) {
            // Update UI from the main thread when available
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userAvatar.image = [UIImage imageWithData:avatarData];
            });
        }
    });
}

// Adjusts "Sign in", "Sign out", and "Disconnect" buttons to reflect
// the current sign-in state (ie, the "Sign in" button becomes disabled
// when a user is already signed in).
- (void)updateButtons {
    BOOL authenticated = ([GPPSignIn sharedInstance].authentication != nil);
    
    self.signInButton.enabled = !authenticated;
    self.signOutButton.enabled = authenticated;
    self.disconnectButton.enabled = authenticated;
    self.credentialsButton.hidden = !authenticated;
    
    if (authenticated) {
        self.signInButton.alpha = 0.5;
        self.signOutButton.alpha = self.disconnectButton.alpha = 1.0;
    } else {
        self.signInButton.alpha = 1.0;
        self.signOutButton.alpha = self.disconnectButton.alpha = 0.5;
    }
}

// Creates and shows an UIAlertView asking the user to confirm their action as it will log them
// out of their current G+ session

- (void)showSignOutAlertViewWithConfirmationBlock:(void (^)(void))confirmationBlock
                                      cancelBlock:(void (^)(void))cancelBlock {
    if ([[GPPSignIn sharedInstance] authentication]) {
        self.confirmActionBlock = confirmationBlock;
        self.cancelActionBlock = cancelBlock;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kSignOutAlertViewTitle
                                                            message:kSignOutAlertViewMessage
                                                           delegate:self
                                                  cancelButtonTitle:kSignOutAlertCancelTitle
                                                  otherButtonTitles:kSignOutAlertConfirmTitle, nil];
        [alertView show];
    }
}

#pragma mark - IBActions

- (IBAction)signOut:(id)sender {
    [[GPPSignIn sharedInstance] signOut];
    [self reportAuthStatus];
    [self updateButtons];
}

- (IBAction)disconnect:(id)sender {
    [[GPPSignIn sharedInstance] disconnect];
}


- (void)toggleUserID:(UISwitch *)sender {
    if ([[GPPSignIn sharedInstance] authentication]) {
        [self showSignOutAlertViewWithConfirmationBlock:^(void) {
            [GPPSignIn sharedInstance].shouldFetchGoogleUserID = sender.on;
        }
                                            cancelBlock:^(void) {
                                                [sender setOn:!sender.on animated:YES];
                                            }];
    } else {
        [GPPSignIn sharedInstance].shouldFetchGoogleUserID = sender.on;
    }
}

- (void)toggleSingleSignOn:(UISwitch *)sender {
    [GPPSignIn sharedInstance].attemptSSO = sender.on;
}

- (void)changeSignInButtonWidth:(UISlider *)sender {
    CGRect frame = self.signInButton.frame;
    frame.size.width = sender.value;
    self.signInButton.frame = frame;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        if (_cancelActionBlock) {
            _cancelActionBlock();
        }
    } else {
        if (_confirmActionBlock) {
            _confirmActionBlock();
            [self refreshUserInfo];
            [self updateButtons];
        }
    }
    
    _cancelActionBlock = nil;
    _confirmActionBlock = nil;
}

#pragma mark - Private method implementation

-(void)toggleHiddenState:(BOOL)shouldHide
{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}

#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    LoginWith=@"facebook";
    self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    //http://graph.facebook.com/10203073619193382/picture?type=large
    
    NSLog(@"%@", user);
    self.profilePicture.profileID = user.id;
    self.lblUsername.text = user.name;
    self.lblEmail.text = [user objectForKey:@"email"];
    
    FacebookEmailId=[user objectForKey:@"email"];
    FacebookFirstName=[user objectForKey:@"first_name"];
    FacebookLastName=[user objectForKey:@"last_name"];
  //  FacebookPhoneNo=[user objectForKey:@"mobile_number"];
FacebookPhoneNo=@"";
    FacebookID=[user objectForKey:@"id"];
    
    //Get Facebook Image
    NSString *urlStr=[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",FacebookID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [Base64 initialize];
    FacebookImageBase64 = [Base64 encode:data];
    

    
    if ([kappDelegate checkForInternetConnection]==YES)
    {
        [self FacebookLoginWebService];
    }
}


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.lblLoginStatus.text = @"You are logged out";
    
    [self toggleHiddenState:YES];
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}


#pragma mark - Login Button Action

- (IBAction)LoginButtonAction:(id)sender
{
    if (![self validateEmailWithString:UserEmailTextField.text]==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Enter Valid Email id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   else if ([PasswordTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Enter Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if([kappDelegate checkForInternetConnection]==YES)
        {
            [kappDelegate ShowIndicator];
            [UserEmailTextField resignFirstResponder];
            [PasswordTextField resignFirstResponder];
            [self LoginWebService];

        }

//        [self MoveToHomeView];
    }
   
}

#pragma mark - Forgot Password Button Action

- (IBAction)ForgotPasswordButton:(id)sender
{
    [self MoveToForgotPasswordView];
}

#pragma mark - Register Button Action

- (IBAction)RegisterButtonAction:(id)sender
{
    [self MoveToRegistrationView];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [UserEmailTextField resignFirstResponder];
    [PasswordTextField resignFirstResponder];
    
    return YES;
}// called when 'return' key pressed. return NO to ignore.

#pragma mark - Validation for email

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Move to Register View

-(void)MoveToRegisterView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            registerViewObj=[[RegisterViewViewController alloc]initWithNibName:@"RegisterViewViewController" bundle:nil];
            [self.navigationController pushViewController:registerViewObj animated:YES];
        }
        else
        {
            registerViewObj=[[RegisterViewViewController alloc]initWithNibName:@"RegisterViewViewController" bundle:nil];
            [self.navigationController pushViewController:registerViewObj animated:YES];
        }
    }

}

#pragma mark - Move to Register View

-(void)MoveToForgotPasswordView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            ForgotPasswordViewObj=[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:ForgotPasswordViewObj animated:YES];
   
        }
        else
        {
            ForgotPasswordViewObj=[[ForgotPasswordViewController alloc]initWithNibName:@"ForgotPasswordViewController" bundle:nil];
            [self.navigationController pushViewController:ForgotPasswordViewObj animated:YES];
        }
    }
    
}

#pragma mark - Move to Home View

-(void)MoveToHomeView
{
    [UserEmailTextField resignFirstResponder];
    [PasswordTextField resignFirstResponder];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:NO];
        }
        else
        {
            HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:NO];
        }
    }
    
}
#pragma mark - Move to Lisence View

-(void)MoveToLisenceView
{
    [UserEmailTextField resignFirstResponder];
    [PasswordTextField resignFirstResponder];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            LisenceViewObj=[[LisenceAgrementViewController alloc]initWithNibName:@"LisenceAgrementViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:LisenceViewObj animated:NO];
  
        }
        else
        {
            LisenceViewObj=[[LisenceAgrementViewController alloc]initWithNibName:@"LisenceAgrementViewController" bundle:nil];
            [self.navigationController pushViewController:LisenceViewObj animated:NO];
        }
    }
    
}
#pragma mark - Move to Registration View

-(void)MoveToRegistrationView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            RegistrationViewObj=[[RegistrarionViewController alloc]initWithNibName:@"RegistrarionViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:RegistrationViewObj animated:YES];
        }
        else
        {
            RegistrationViewObj=[[RegistrarionViewController alloc]initWithNibName:@"RegistrarionViewController" bundle:nil];
            [self.navigationController pushViewController:RegistrationViewObj animated:YES];
        }
    }
}

#pragma mark - Login Web Service

-(void)LoginWebService
{
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:UserEmailTextField.text,@"useremail",PasswordTextField.text,@"password",[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceUDID"],@"UserDevicename",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Login",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Facebook Login Web Service

-(void)FacebookLoginWebService
{
    webservice=2;
    
//    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:FacebookEmailId,@"UserEmail",LoginWith,@"Trigger",@"-1",@"userid",FacebookImageBase64,@"userimage",FacebookFirstName,@"firstname",FacebookLastName,@"lastname",@"",@"password",@"",@"phonenumber",nil];
    FacebookPhoneNo=@"12345678909";
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:FacebookEmailId,@"UserEmail",LoginWith,@"Trigger",FacebookFirstName,@"FirstName",FacebookLastName,@"LastName",FacebookPhoneNo,@"MobileNumber",nil];
    
    
 //   jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:FacebookEmailId,@"UserEmail",LoginWith,@"Trigger",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/LoginWithFacebook",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Gmail Login Web Service

-(void)GmailLoginWebService
{
    [kappDelegate ShowIndicator];
    webservice=3;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GmailId,@"UserEmail",LoginWith,@"Trigger",nil];
    
   // jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:GmailId,@"UserEmail",LoginWith,@"Trigger",@"-1",@"userid",GmailImageBase64,@"userimage",GmailFirstName,@"firstname",GmailLastName,@"lastname",@"",@"password",@"",@"phonenumber",nil];

    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/LoginWithFacebook",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Post JSON Web Service

-(void)postWebservices
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    //  data = [NSData dataWithContentsOfURL:urlString];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}

#pragma mark - Response Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    UIAlertView *alert;
    alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Network Connection lost, Please Check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
   // [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
   // [self.activityIndicatorObject stopAnimating];
   // self.view.userInteractionEnabled=YES;
   // self.disablImg.hidden=YES;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    responseString= [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];

    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (webservice==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:UserEmailTextField.text forKey:@"user"];
                [[NSUserDefaults standardUserDefaults] setValue:PasswordTextField.text forKey:@"pass"];

                NSLog(@"%@",userDetailDict);
                [[NSUserDefaults standardUserDefaults] setValue:[userDetailDict valueForKey:@"userid"] forKey:@"UserId"];
                [[NSUserDefaults standardUserDefaults] setValue:[userDetailDict valueForKey:@"mobile"] forKey:@"Mobile"];
                
                //user default for credit card list
                NSMutableArray *arr=[userDetailDict valueForKey:@"listCreditCards"];
                [[NSUserDefaults standardUserDefaults] setValue:arr forKey:@"CreditCardList"];
                //////////////////////////
                
                //user default for PromoCode list
                NSMutableArray *PromoArr=[userDetailDict valueForKey:@"listPromoCodes"];
                [[NSUserDefaults standardUserDefaults] setValue:PromoArr forKey:@"PromoCodeList"];
                //////////////////////////

                [[NSUserDefaults standardUserDefaults] setValue:@"Login" forKey:@"Account"];
                
                if ([[userDetailDict valueForKey:@"isdrivermodeactivated"] isEqualToString:@"true"])
                {
                [[NSUserDefaults standardUserDefaults] setValue:@"True" forKey:@"DriverMode"];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DriverMode"];
  
                }
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Aggrement"] isEqualToString:@"Accept"])
                {
                    [self MoveToHomeView];
                }
                else
                {
                    [self MoveToLisenceView];
                }
            }
        }
        
    }
    else if (webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                [[NSUserDefaults standardUserDefaults] setValue:[userDetailDict valueForKey:@"userid"] forKey:@"UserId"];
                
                [[NSUserDefaults standardUserDefaults] setValue:@"Login" forKey:@"Account"];
                
                if ([[userDetailDict valueForKey:@"isdrivermodeactivated"] isEqualToString:@"True"])
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"True" forKey:@"DriverMode"];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DriverMode"];
                }
                [self MoveToHomeView];
            }
        }
        
    }
    else if (webservice==3)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                [[GPPSignIn sharedInstance] signOut];
                [self reportAuthStatus];
                [self updateButtons];
                
                
                
                [self adoptUserSettings];
                [[GPPSignIn sharedInstance] trySilentAuthentication];
                [self reportAuthStatus];
                [self updateButtons];

                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                NSLog(@"%@",userDetailDict);
                [[NSUserDefaults standardUserDefaults] setValue:[userDetailDict valueForKey:@"userid"] forKey:@"UserId"];
                [[NSUserDefaults standardUserDefaults] setValue:@"Login" forKey:@"Account"];
                
                if ([[userDetailDict valueForKey:@"isdrivermodeactivated"] isEqualToString:@"True"])
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"True" forKey:@"DriverMode"];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"DriverMode"];
                    
                }
                [self MoveToHomeView];
            }
        }
        
    }
    
}



@end
