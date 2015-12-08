//
//  AppDelegate.m
//  mymap
//
//  Created by Parveen Sharma on 11/5/14.
//

#import "AppDelegate.h"
#import "SDKDemoAPIKey.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MarkersViewController.h"
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import <GooglePlus/GooglePlus.h>
#import "DriverInfoViewController.h"
#import "DriverMapViewController.h"
#import "BeginTripViewController.h"
#import "RatingViewController.h"
#import "SplashViewController.h"
#import "PayPalMobile.h"
#import "PaypalViewController.h"
//google wallet
#import "BKSConstants.h"
#import "BKSUtils.h"
#import "CatalogItem.h"
#import "GoogleWalletSDK/GoogleWalletSDK.h"
#import <AVFoundation/AVFoundation.h>




@interface AppDelegate ()<GPPDeepLinkDelegate>
{
    AVAudioPlayer *audioPlayer;
}
@end


@implementation AppDelegate{
    id services_;
}

static NSString * const kClientID =
@"646082081102-f35ip5n8ep8b06vtgremtefdhdgqc8lr.apps.googleusercontent.com";

@synthesize SourceArray,progressBar;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //required background modes
    //App registers for location updates in item 0
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationIconBadgeNumber = 0;

    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if ([kAPIKey length] == 0) {
        // Blow up if APIKey has not yet been set.
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString *format = @"Configure APIKey inside SDKDemoAPIKey.h for your "
        @"bundle `%@`, see README.GoogleMapsSDKDemos for more information";
        @throw [NSException exceptionWithName:@"SDKDemoAppDelegate"
                                       reason:[NSString stringWithFormat:format, bundleId]
                                     userInfo:nil];
    }
    
    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUDID=myDevice1.UUIDString;
    NSLog(@"Device udid is %@",deviceUDID);
    user_UDID_Str=deviceUDID;
    [[NSUserDefaults standardUserDefaults] setValue:user_UDID_Str forKey:@"DeviceUDID"];

    
    [GMSServices provideAPIKey:kAPIKey];
    services_ = [GMSServices sharedServices];
    
    [GPPSignIn sharedInstance].clientID = kClientID;
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];

    
    [FBLoginView class];
    [FBProfilePictureView class];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }


    // Log the required open source licenses!  Yes, just NSLog-ing them is not
    // enough but is good for a demo.
    SplashViewController *SplashVC;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        CGSize result1 = [[UIScreen mainScreen] bounds].size;
        if(result1.height == 480)
        {
            SplashVC=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];

        }
        else
        {
            SplashVC=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
        }
    }
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:SplashVC];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];


    self.window.rootViewController=nav;
    [self.window makeKeyAndVisible];
    SourceArray=[[NSMutableArray alloc] init];
    
    NSLog(@"Open source licenses:\n%@", [GMSServices openSourceLicenseInfo]);
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox:@"AXgU8hAKmJzYJfRBNtvL4ZqlA1NxxwZNhHahXHZy4y3_LNdVmrIRutKJj46S"}];
    
    //Get current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];

    [self.locationManager stopUpdatingLocation];

    
    NSLog(@"%f %f",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RemoveNotifView:)
                                                 name:@"RemoveNotifView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"hideNotif"
                                               object:nil];
    
    
    
    return YES;
}
- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"hideNotif"])
        NSLog (@"Successfully received the test notification!");
    
    [animatedView setHidden:NO];
}
- (void) RemoveNotifView:(NSNotification *) notification
{
    [animatedView removeFromSuperview];
}

-(void)RiderLocationOnMap
{
    NSMutableDictionary *UserInfo=[[NSMutableDictionary alloc] init];
    [UserInfo setValue:@"30.712840" forKey:@"Latitude"];
    [UserInfo setValue:@"76.691576" forKey:@"Longitude"];
    [UserInfo setValue:@"44" forKey:@"TripId"];

    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"refreshView" object:self userInfo:UserInfo];



}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
   // return [FBAppCall handleOpenURL:url
                //  sourceApplication:sourceApplication];
   // return [GPPURLHandler handleURL:url
                  //sourceApplication:sourceApplication
                       //  annotation:annotation];
    
    if ([GPPURLHandler handleURL:url
               sourceApplication:sourceApplication
                      annotation:annotation])
    {
        return YES;
    }
   else if ([GWAWalletClient handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation])
    {
        return YES;
    }

    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];

}

#pragma mark - Check For Internet Connection
-(BOOL)checkForInternetConnection
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [reach currentReachabilityStatus];
    
    [self stringFromStatus:status];
    
    if (internetConn)
    {
        return YES;
        //        [self displayComposerSheet];
        
    }
    else
    {
        UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No internet connectivity" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [al show];
        // [self hideActivityIndicator];
        return NO;
    }
    return NO;
}

-(void)ShowWaitngView
{
    DisableBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
    DisableBackView.backgroundColor=[UIColor blackColor];
    DisableBackView.alpha=0.5;
    [self.window addSubview:DisableBackView];
    
    UIFont * customFont = [UIFont fontWithName:@"Helvetica" size:22]; //custom font
    NSString * text = @"Please wait while we are searching for a driver...";
    
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 300, 200)];
    
    fromLabel.text = text;
    fromLabel.font = customFont;
    fromLabel.numberOfLines = 3;
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    fromLabel.adjustsFontSizeToFitWidth = YES;
    fromLabel.minimumScaleFactor = 10.0f/12.0f;
    fromLabel.clipsToBounds = YES;
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.textColor = [UIColor whiteColor];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    [DisableBackView addSubview:fromLabel];
    
}

-(void)HideWaitngView{
    [DisableBackView removeFromSuperview];
}

#pragma mark - Show Indicator

-(void)ShowIndicator
{
    
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 700)];

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        activityIndicatorObject.center = CGPointMake(160, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 700)];

    }else if ([[UIScreen mainScreen] bounds].size.height == 736)
    {
        activityIndicatorObject.center = CGPointMake(207, 250);
        DisableView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 414, 800)];
        

    }
    DisableView.backgroundColor=[UIColor blackColor];
    DisableView.alpha=0.5;
    [self.window addSubview:DisableView];
    
    activityIndicatorObject.color=[UIColor grayColor];
    [DisableView addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];
}

#pragma mark - Hide Indicator

-(void)HideIndicator
{
    [activityIndicatorObject stopAnimating];
    [DisableView removeFromSuperview];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken1
{
    NSLog(@"My token is: %@", deviceToken1);
    //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Register" message:[NSString stringWithFormat:@"%@",deviceToken1] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //    [alert show];
    NSString *str=[NSString stringWithFormat:@"%@",deviceToken1];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token without space %@",str);
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"Token without <> %@",str);
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"DeviceToken"];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [kappDelegate HideIndicator];
   // UIApplicationState state = [application applicationState];
    NSString *messageStr = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    //check for send request notification
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"MODE"] isEqualToString:@"DRIVER"])
    {
    if ([messageStr containsString:@"sent"])
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            CGSize result1 = [[UIScreen mainScreen] bounds].size;
            [animatedView removeFromSuperview];
            
            if(result1.height == 480)
            {
                animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)];
            }
            else
            {
                animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 80)];
            }
        }
        
        TimerValue=20;
        DownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(DownTimeCal) userInfo:nil repeats:YES];
        
        animatedView.backgroundColor=[UIColor whiteColor];
        [self.window addSubview:animatedView];
    
        DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        DriverImgView.backgroundColor=[UIColor grayColor];
        DriverImgView.layer.masksToBounds = YES;
        DriverImgView.layer.cornerRadius=35;
        [animatedView addSubview:DriverImgView];
    
        DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 12, 250, 25)];
        DriverNameLbl.textColor=[UIColor blackColor];

        [animatedView addSubview:DriverNameLbl];
    
        MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 25, 250, 40)];
        [MessageLbl setFont:[UIFont systemFontOfSize:11]];
        MessageLbl.numberOfLines=3;
        MessageLbl.textColor=[UIColor blackColor];

        [animatedView addSubview:MessageLbl];
    
        NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
        NSLog(@"%@",arr);
        NSString *username=[arr objectAtIndex:0];
        NSString *Message=[arr objectAtIndex:1];
        NSString *ImageUrl=[arr objectAtIndex:2];
        TripId=[arr objectAtIndex:3];

    
        DriverNameLbl.text=username;
        MessageLbl.text=Message;
        UIImage* myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString:ImageUrl]]];
        [DriverImgView setImage:myImage];
    
        //progress bar
        progressBar=[[UIProgressView alloc] initWithFrame:CGRectMake(20, 90, 260, 3)];
        
        ProgressBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 170)];
        
        ProgressBarView.backgroundColor=[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(42, 110, 235, 20)];
        lbl.text=@"Touch Anywhere to Accept";
        [lbl setFont:[UIFont fontWithName:@"Helvetica Bold" size:18]];
        lbl.textColor=[UIColor blackColor];
        [ProgressBarView addSubview:lbl];
        
        Timerlbl=[[UILabel alloc] initWithFrame:CGRectMake(130, 20, 60, 60)];
        Timerlbl.text=[NSString stringWithFormat:@"%d",TimerValue];
        Timerlbl.textAlignment = NSTextAlignmentCenter;
        [Timerlbl setFont:[UIFont fontWithName:@"Helvetica Bold" size:50]];
        Timerlbl.textColor=[UIColor colorWithRed:11/255.0f green:172/255.0f blue:136/255.0f alpha:1.0f];
        [ProgressBarView addSubview:Timerlbl];
        
        [ProgressBarView addSubview:progressBar];
    
        progressBar.progress = 100.0;
        counter = 100.0;
        progressFloat = 0.0;
        fileSize = 100;
    
        [self.window addSubview:ProgressBarView];
    
        AcceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [AcceptBtn addTarget:self
                  action:@selector(AcceptButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        AcceptBtn.frame = CGRectMake(10, 50, 300, 400);
        [self.window addSubview:AcceptBtn];
    
        [self progressUpdate];
        [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(DisableView) userInfo:nil repeats:NO];
        
        //timer background sound
        NSString *path = [NSString stringWithFormat:@"%@/newsound.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        [audioPlayer play];

        }
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"MODE"] isEqualToString:@"RIDER"])
    {
        [self HideWaitngView];

        if ([messageStr containsString:@"ended"])
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                CGSize result1 = [[UIScreen mainScreen] bounds].size;
                [animatedView removeFromSuperview];
                
                if(result1.height == 480)
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)];
                }
                else
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 490, 320, 80)];
                }
            }
            animatedView.backgroundColor=[UIColor whiteColor];
            [self.window addSubview:animatedView];
            
            DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
            DriverImgView.backgroundColor=[UIColor grayColor];
            DriverImgView.layer.masksToBounds = YES;
            
            DriverImgView.layer.cornerRadius=35;
            [animatedView addSubview:DriverImgView];
            
            DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 12, 250, 25)];
            [animatedView addSubview:DriverNameLbl];
            
            MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 25, 250, 40)];
            [MessageLbl setFont:[UIFont systemFontOfSize:11]];
            MessageLbl.numberOfLines=3;
            [animatedView addSubview:MessageLbl];
            
            NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
            NSLog(@"%@",arr);
            NSString *username=[arr objectAtIndex:0];
            NSString *Message=[arr objectAtIndex:1];
            NSString *ImageUrl=[arr objectAtIndex:2];
            EndRideTripId=[arr objectAtIndex:3];
            
            DriverNameLbl.text=username;
            MessageLbl.text=Message;
            UIImage* myImage = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:
                                 [NSURL URLWithString:ImageUrl]]];
            [DriverImgView setImage:myImage];
            
            UIButton * RideEndBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [RideEndBtn addTarget:self
                           action:@selector(EndRideButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            RideEndBtn.frame = CGRectMake(0, 0, 320, 80);
            [animatedView addSubview:RideEndBtn];

        }

        else if ([messageStr containsString:@"arrived"])
        {
            [self DisableView];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                [animatedView removeFromSuperview];
                
                CGSize result1 = [[UIScreen mainScreen] bounds].size;
                if(result1.height == 480)
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)];
                }
                else
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 490, 320, 80)];
                }
            }
            animatedView.backgroundColor=[UIColor whiteColor];
            [self.window addSubview:animatedView];
            
            DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
            DriverImgView.backgroundColor=[UIColor grayColor];
            DriverImgView.layer.masksToBounds = YES;
            
            DriverImgView.layer.cornerRadius=35;
            
            [animatedView addSubview:DriverImgView];
            
            DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 12, 250, 25)];
            [animatedView addSubview:DriverNameLbl];
            
            MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 25, 250, 40)];
            [MessageLbl setFont:[UIFont systemFontOfSize:11]];
            MessageLbl.numberOfLines=3;
            [animatedView addSubview:MessageLbl];
            
            NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
            NSLog(@"%@",arr);
            NSString *username=[arr objectAtIndex:0];
            NSString *Message=[arr objectAtIndex:1];
            NSString *ImageUrl=[arr objectAtIndex:2];
            ArivedTripId=[arr objectAtIndex:3];
            
            DriverNameLbl.text=username;
            MessageLbl.text=Message;
            UIImage* myImage = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:
                                 [NSURL URLWithString:ImageUrl]]];
            [DriverImgView setImage:myImage];
            
            
            
            UIButton * ArrivedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [ArrivedBtn addTarget:self
                           action:@selector(ArrivedButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            ArrivedBtn.frame = CGRectMake(0, 0, 320, 80);
            [animatedView addSubview:ArrivedBtn];
            
        }
        
    
        else if ([messageStr containsString:@"begun"])
        {
            [animatedView removeFromSuperview];
            
            
            NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
            NSLog(@"%@",arr);
            NSString *username=[arr objectAtIndex:0];
            NSString *Message=[arr objectAtIndex:1];
            NSString *ImageUrl=[arr objectAtIndex:2];
            BegunTripId=[arr objectAtIndex:3];
            [[NSUserDefaults standardUserDefaults]setValue:BegunTripId forKey:@"EndRideTripId"];
            
            [self GetRiderTripDetails];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
            
        }
    
        else if ([messageStr containsString:@"Payment"])
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                [animatedView removeFromSuperview];
                
                CGSize result1 = [[UIScreen mainScreen] bounds].size;
                if(result1.height == 480)
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)];
                }
                else
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 490, 320, 80)];
                }
            }
            animatedView.backgroundColor=[UIColor whiteColor];
            [self.window addSubview:animatedView];
            
            DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
            DriverImgView.backgroundColor=[UIColor grayColor];
            DriverImgView.layer.masksToBounds = YES;
            DriverImgView.layer.cornerRadius=35;
            
            [animatedView addSubview:DriverImgView];
            
            DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 12, 250, 25)];
            [animatedView addSubview:DriverNameLbl];
            
            MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 25, 250, 40)];
            [MessageLbl setFont:[UIFont systemFontOfSize:11]];
            MessageLbl.numberOfLines=3;
            [animatedView addSubview:MessageLbl];
            
            
            MessageLbl.text=messageStr;
            
            
            UIButton * Pyment = [UIButton buttonWithType:UIButtonTypeCustom];
            [Pyment addTarget:self
                       action:@selector(PaymentButton:)
             forControlEvents:UIControlEventTouchUpInside];
            Pyment.frame = CGRectMake(0, 0, 320, 80);
            [animatedView addSubview:Pyment];
            
        }
    
        else if ([messageStr containsString:@"divide"])
        {
            NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
            NSLog(@"%@",arr);
            
            NSString *splitFareMsg=[arr objectAtIndex:0];
            splitFareRiderId=[arr objectAtIndex:1];
            splitFareAmount=[arr objectAtIndex:2];
            splitFareTripId=[arr objectAtIndex:3];
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:splitFareMsg delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
            alert.tag=978;
            [alert show];
        }
    
        else if ([messageStr containsString:@"cancelled"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Ride has been cancelled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [animatedView removeFromSuperview];
            
        }
        else if ([messageStr containsString:@"acceptsplit"])
        {
            messageStr=[messageStr stringByReplacingOccurrencesOfString:@"acceptsplit" withString:@""];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Hello" message:messageStr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    
        else if ([messageStr containsString:@"rejectsplit"])
        {
            messageStr=[messageStr stringByReplacingOccurrencesOfString:@"rejectsplit" withString:@""];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Hello" message:messageStr delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if ([messageStr containsString:@"few"])
        {
            canclTimerCount=0;
            CancelRideTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestTimer) userInfo:nil repeats:YES];
        
            //check for accept/reject ride notification
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                [animatedView removeFromSuperview];

                CGSize result1 = [[UIScreen mainScreen] bounds].size;
                if(result1.height == 480)
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)];
                }
                else
                {
                    animatedView=[[UIView alloc] initWithFrame:CGRectMake(0, 490, 320, 80)];
                }
            }

        
            animatedView.backgroundColor=[UIColor whiteColor];
            [self.window addSubview:animatedView];
            
            DriverImgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
            DriverImgView.backgroundColor=[UIColor grayColor];
            DriverImgView.layer.masksToBounds = YES;
            DriverImgView.layer.cornerRadius=35;
            [animatedView addSubview:DriverImgView];
            
            
            DriverNameLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 12, 250, 25)];
            [animatedView addSubview:DriverNameLbl];
            
            MessageLbl=[[UILabel alloc] initWithFrame:CGRectMake(80, 25, 250, 40)];
            [MessageLbl setFont:[UIFont systemFontOfSize:11]];
            MessageLbl.numberOfLines=3;
            [animatedView addSubview:MessageLbl];
            
            RiderImgView=[[UIImageView alloc] initWithFrame:CGRectMake(animatedView.frame.size.width-75, 5, 70, 70)];
            RiderImgView.backgroundColor=[UIColor grayColor];
            RiderImgView.layer.masksToBounds = YES;
            RiderImgView.layer.cornerRadius=35;
            [animatedView addSubview:RiderImgView];
            [animatedView bringSubviewToFront:RiderImgView];
            
            UIButton * DriverDetailsViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [DriverDetailsViewBtn addTarget:self
                                     action:@selector(DriverDetailsButton:)
                           forControlEvents:UIControlEventTouchUpInside];
            DriverDetailsViewBtn.frame = CGRectMake(0, 0, 320, 80);
            [animatedView addSubview:DriverDetailsViewBtn];
            
            DriverInfoStr=messageStr;
            NSArray *arr=[messageStr componentsSeparatedByString:@"@"];
            NSLog(@"%@",arr);
            NSString *username=[arr objectAtIndex:0];
            NSString *Message=[arr objectAtIndex:1];
            NSString *ImageUrl=[arr objectAtIndex:2];
            NSString *riderImageUrl;
            if(arr.count>3)
            {
            riderImageUrl = [arr objectAtIndex:4];
            }
            
            // NSString *TripId=[arr objectAtIndex:3];
            //  NSString *DriverId=[arr objectAtIndex:4];
            
            DriverNameLbl.text=username;
            MessageLbl.text=Message;
            UIImage* myImage = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:
                                 [NSURL URLWithString:ImageUrl]]];
            
            UIImage* myImage1 = [UIImage imageWithData:
                                [NSData dataWithContentsOfURL:
                                 [NSURL URLWithString:riderImageUrl]]];
            [DriverImgView setImage:myImage];
            [RiderImgView setImage:myImage1];
        }
    }
}

-(void)DownTimeCal
{
    TimerValue=TimerValue-1;
    Timerlbl.text=[NSString stringWithFormat:@"%d",TimerValue];
    if (TimerValue==4)
    {
        [audioPlayer play];
    }
    if (TimerValue==0)
    {
        [audioPlayer stop];
        [DownTimer invalidate];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"You missed a request!" message:@"You did not attempt to accept this request. if you're unavailable, Please turn off driver mode." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
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

- (void)animationTimerFired:(NSTimer*)theTimer
{
//    int re=rand()%10;
//    if (re==2) {
//        progress+=0.025;
//        [pgv setProgress:progress];
//    }
    
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

#pragma mark - Accept Button Action

-(IBAction)AcceptButtonAction:(id)sender
{
    [audioPlayer stop];
    [DownTimer invalidate];
    progressBar.progress = 0.0;
    progressFloat = 0.0;
    counter = 0.0;
    [AcceptBtn removeFromSuperview];
    [progressTimer invalidate];
    [animatedView removeFromSuperview];
    [ProgressBarView removeFromSuperview];
    
    //call accept web service
    [self AcceptRideRequest];
  
}

#pragma mark - Driver Details Button Action

-(IBAction)DriverDetailsButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
    [self MoveToDriverInfoView];
}

#pragma mark - Arrived Button Action

-(IBAction)ArrivedButton:(id)sender
{
    [animatedView removeFromSuperview];

}
-(IBAction)CancelStatus:(id)sender
{
   CancelRideWithPay=@"yes";
}

#pragma mark - End Ride Button Action

-(IBAction)EndRideButton:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];

    [animatedView removeFromSuperview];
    [self MoveToRatingView];
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10)
    {
        if (buttonIndex==1)
        {
            [CancelRideTimer invalidate];
            [self CancelRideRequest];
        }
    }
    else if (alertView.tag==978)
    {
        if (buttonIndex==1)
        {
            //accept here
            
            [self AcceptSplitFare];
            
        }
        else if(buttonIndex==0)
        {
          //reject here
            [self RejectSplitFare];
            
        }
    }
}


#pragma mark - Begun Button Action

-(IBAction)BegunButton:(id)sender
{
    [self GetRiderTripDetails];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"ComingFrom"];
    [animatedView removeFromSuperview];
   
}
#pragma mark -  Get Trip Details

-(void)GetRiderTripDetails
{
    webservice=3;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:BegunTripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetDetailsByTripId",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark -  Accept Split Fare Request

-(void)AcceptSplitFare
{
    webservice=4;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:splitFareRiderId,@"RiderId",@"accept",@"Trigger",splitFareAmount,@"Amount",splitFareTripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptRejectPendingFareRequest",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark -  Reject Split Fare Request

-(void)RejectSplitFare
{
    webservice=5;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:splitFareRiderId,@"RiderId",@"reject",@"Trigger",splitFareAmount,@"Amount",splitFareTripId,@"TripId",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptRejectPendingFareRequest",Kwebservices]];
    
    [self postWebservices];
}


-(IBAction)PaymentButton:(id)sender
{
      [animatedView removeFromSuperview];
}

#pragma mark - Move to Driver Info View

-(void)MoveToDriverInfoView
{
    animatedView.hidden=YES;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize results = [[UIScreen mainScreen] bounds].size;
        if(results.height == 480)
        {
           // [self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            DriverInfoViewController *DriverInfoView=[[DriverInfoViewController alloc]initWithNibName:@"DriverInfoViewController" bundle:nil];
            DriverInfoView.DriverDetailStr=DriverInfoStr;
            [navigationController pushViewController:DriverInfoView animated:YES];

        }
        else
        {
           // [self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            DriverInfoViewController *DriverInfoView=[[DriverInfoViewController alloc]initWithNibName:@"DriverInfoViewController" bundle:nil];
            DriverInfoView.DriverDetailStr=DriverInfoStr;
            [navigationController pushViewController:DriverInfoView animated:YES];
        }
    }
}

#pragma mark - Move to Begin Trip View

-(void)MoveToBeginTrip
{
    NSString *str=@"YES";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize results = [[UIScreen mainScreen] bounds].size;
        if(results.height == 480)
        {
            //[self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            BeginTripViewController *BeginTripView=[[BeginTripViewController alloc]initWithNibName:@"" bundle:nil];
            BeginTripView.ComingFromNotification=str;
            BeginTripView.DestinationLat=DestinationLat;
            BeginTripView.DestinationLong=DestinationLong;
            [navigationController pushViewController:BeginTripView animated:YES];
        }
        else
        {
            //[self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            BeginTripViewController *BeginTripView=[[BeginTripViewController alloc]initWithNibName:@"BeginTripViewController" bundle:nil];
            BeginTripView.ComingFromNotification=str;
            BeginTripView.DestinationLat=DestinationLat;
            BeginTripView.DestinationLong=DestinationLong;
            BeginTripView.DestinationAddress=DestinationAddress;
            [navigationController pushViewController:BeginTripView animated:YES];
        }
    }
}

#pragma mark - Move to Rating View

-(void)MoveToRatingView
{
    
    NSString *str=@"YES";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize results = [[UIScreen mainScreen] bounds].size;
        if(results.height == 480)
        {
            //[self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            RatingViewController *RatingView=[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            RatingView.ComingFromNotification=str;
            RatingView.EndRideTripIdFromNotif=EndRideTripId;

            [navigationController pushViewController:RatingView animated:YES];
        }
        else
        {
            //[self DisableView];
            UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
            RatingViewController *RatingView=[[RatingViewController alloc]initWithNibName:@"RatingViewController" bundle:nil];
            RatingView.ComingFromNotification=str;
            RatingView.EndRideTripIdFromNotif=EndRideTripId;
            [navigationController pushViewController:RatingView animated:YES];
        }
    }
}


#pragma mark - Check Network Status
-(void)stringFromStatus:(NetworkStatus)status
{
    //	NSString *string;
    switch(status)
    {
        case NotReachable:
            //string = @"Not Reachable";
            internetConn=NO;
            break;
        case ReachableViaWiFi:
            //string = @"Reachable via WiFi";
            internetConn=YES;
            break;
        case ReachableViaWWAN:
            //string = @"Reachable via WWAN";
            internetConn=YES;
            break;
        default:
            //string = @"Unknown";
            internetConn=YES;
            break;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Accept Ride Request

-(void)AcceptRideRequest
{
    [kappDelegate ShowIndicator];
    webservice=1;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:TripId,@"tripid",@"accepted",@"status",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/AcceptOrRejectRequest",Kwebservices]];
    
    [self postWebservices];
}

#pragma mark - Cancel Ride Request

-(void)CancelRideRequest
{
    //Arrived/BeginTrip
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    now = [NSDate date];
    currentTime= [dateFormatter stringFromDate:now];
    
    [kappDelegate ShowIndicator];
    
    webservice=2;
    
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:ArivedTripId,@"TripId",@"cancel",@"Status",currentTime,@"Timestamp",@"",@"Latitude",@"",@"Longitude",@"",@"TripMilesActual",@"",@"TripTimeActual",@"",@"TripAmountActual",@"rider",@"Trigger",CancelRideWithPay,@"PaymentStatus",[[NSUserDefaults standardUserDefaults] valueForKey:@"CancelRideCharges"],@"CancellationCharges",nil];
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/NotifyRegardingArrival",Kwebservices]];
    
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
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
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
                NSLog(@"%@",userDetailDict);
                
                NSMutableDictionary *UserInfo=[[NSMutableDictionary alloc] init];
                [UserInfo setValue:[userDetailDict valueForKey:@"rider_lat"] forKey:@"Latitude"];
                [UserInfo setValue:[userDetailDict valueForKey:@"rider_long"] forKey:@"Longitude"];
                [UserInfo setValue:[userDetailDict valueForKey:@"rider_sourceAddress"] forKey:@"source_address"];
                [UserInfo setValue:[userDetailDict valueForKey:@"rider_destinationAddress"] forKey:@"destination_address"];

                [UserInfo setValue:[userDetailDict valueForKey:@"tripid"] forKey:@"TripId"];
                
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"refreshView" object:self userInfo:UserInfo];

            }
        }
    }
    else if (webservice==2)
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
                
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
                
            }
        }
    }
    else if (webservice==3)
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
                NSLog(@"%@",userDetailDict);
                DestinationAddress=[userDetailDict valueForKey:@"ending_loc"];
                DestinationLat=[userDetailDict valueForKey:@"end_lat"];
                DestinationLong=[userDetailDict valueForKey:@"end_lon"];
                [self MoveToBeginTrip];
            }
        }
    }
    else if (webservice==4)
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
                NSLog(@"%@",userDetailDict);
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else if (webservice==5)
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
                NSLog(@"%@",userDetailDict);
              
            }
        }
    }
}

-(int)requestTimer;
{
    
    canclTimerCount=canclTimerCount+1;
    if (canclTimerCount==300)
    {
        [CancelRideTimer invalidate];
        
    }
    return canclRiderTimer;
    
}

@end
