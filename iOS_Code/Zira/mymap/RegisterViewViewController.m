//
//  RegisterViewViewController.m
//  UberLikeApp
//
//  Created by vikram on 19/11/14.
//  Copyright (c) 2014 Krishna_Mac_2. All rights reserved.
//

#import "RegisterViewViewController.h"
#import "Base64.h"
#import "Helper.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"


DriverRegister1ViewController  *DriverRegister1ViewObj;
DriverMapViewController        *DriverMapViewObj;

@interface RegisterViewViewController ()

@end

@implementation RegisterViewViewController

@synthesize UserRecordArray,EditFrom;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

    if ([EditFrom isEqualToString:@"DriverMode"])
    {
        signOutBtn.hidden=YES;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                scrollView.contentSize = CGSizeMake(320, 900);

            }
            else
            {
                scrollView.contentSize = CGSizeMake(320, 1000);

            }
        }

        
        VechicleImageView.layer.cornerRadius=4;
        VechicleImageView.layer.borderColor=[UIColor blackColor].CGColor;
        VechicleImageView.layer.borderWidth=1.0;
        
        VechMake.text=[UserRecordArray valueForKey:@"vechile_make"];
        VechModel.text=[UserRecordArray valueForKey:@"vechile_model"];
        VechNo.text=[UserRecordArray valueForKey:@"licenseplatenumber"];
        
        NSString *VechImageUrl=[UserRecordArray valueForKey:@"vechile_img_location"];
        if (![VechImageUrl isEqualToString:@""])
        {
            UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            objactivityindicator.center = CGPointMake((VechicleImageView.frame.size.width/2),(VechicleImageView.frame.size.height/2));
            [VechicleImageView addSubview:objactivityindicator];
            [objactivityindicator startAnimating];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                NSURL *imageURL=[NSURL URLWithString:[VechImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                UIImage *imgData=[UIImage imageWithData:tempData];
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                   {
                                       [VechicleImageView setImage:imgData];
                                       [objactivityindicator stopAnimating];
                                   }
                                   else
                                   {
                                       [objactivityindicator stopAnimating];
                                   }
                               });
            });
        }
    }
    else
    {
        infoLbl.hidden=YES;
        VechMake.hidden=YES;
        VechModel.hidden=YES;
        VechNo.hidden=YES;
        VechicleImageView.hidden=YES;
        editVechInfo.hidden=YES;
        
        
        signOutBtn.hidden=NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                scrollView.contentSize = CGSizeMake(320, 900);
                
            }
            else
            {
                scrollView.contentSize = CGSizeMake(320, 1000);
                
            }
        }
    }
    
    NSLog(@"%@",UserRecordArray);
    firstNameTextField.text=[UserRecordArray valueForKey:@"firstname"];
    LastNameTextField.text=[UserRecordArray valueForKey:@"lastname"];
    EmailTextField.text=[UserRecordArray valueForKey:@"email"];
    MobileNumber.text=[UserRecordArray valueForKey:@"mobile"];
    PasswordTextField.text=[UserRecordArray valueForKey:@"password"];
    
//    firstNameTextField.userInteractionEnabled=NO;
//    LastNameTextField.userInteractionEnabled=NO;
      EmailTextField.userInteractionEnabled=NO;
 //     MobileNumber.userInteractionEnabled=NO;
//    PasswordTextField.userInteractionEnabled=NO;
//    UploadImgBtn.userInteractionEnabled=NO;

    
    //Base 64 to image
    NSString *userImageUrl=[UserRecordArray valueForKey:@"image"];
   // NSData* data = [Base64 decode:Base64Str];;
    //profileImageView.image = [UIImage imageWithData:data];
    if (![userImageUrl isEqualToString:@""])
    {
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        objactivityindicator.center = CGPointMake((profileImageView.frame.size.width/2),(profileImageView.frame.size.height/2));
        [profileImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
        {
            NSURL *imageURL=[NSURL URLWithString:[userImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [profileImageView setImage:imgData];
                                  // UIImage *newImage=[Helper aspectScaleImage:imgData toSize:CGSizeMake(500, 500)];
                                  // profileImageView.image=newImage;
                                   profileImageView.contentMode = UIViewContentModeScaleAspectFit;
//                                   profileImageView.contentMode = UIViewContentModeScaleAspectFill;


                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }
    
    FrontView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    FrontView.backgroundColor=[UIColor clearColor];
  //  [self.view addSubview:FrontView];
    self.navigationController.navigationBar.hidden=NO;
    
    //Write username on image by combine first name and last name
    
    NSString *firstName=[UserRecordArray valueForKey:@"firstname"];
    NSString *lastName=[UserRecordArray valueForKey:@"lastname"];
    NSString *FullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    UserNameLabel.text=FullName;


    //self.title=@"Zira 24/7";
    
    // Right Bar Button Item //
    
    RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    RightButton.frame = CGRectMake(0, 0, 60, 40);
    [RightButton setTitle:@"Done" forState:UIControlStateNormal];
    [RightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [RightButton addTarget:self action:@selector(EditButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    ////
    
    
    //Check for rider have already account as a driver or not
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"DriverMode"] isEqualToString:@"True"])
    {
        //[driverBtn setTitle:@"SEE DRIVER MODE" forState:UIControlStateNormal];
        driverBtn.hidden=YES;
    }
    else
    {
        driverBtn.hidden=NO;
  
    }


    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)EditButtonAction:(id)sender
{
//    NSString *title=RightButton.titleLabel.text;
//    if ([title isEqualToString:@"Edit"])
//    {
//        //[FrontView removeFromSuperview];
//        firstNameTextField.userInteractionEnabled=YES;
//        LastNameTextField.userInteractionEnabled=YES;
//        EmailTextField.userInteractionEnabled=YES;
//        MobileNumber.userInteractionEnabled=YES;
//        PasswordTextField.userInteractionEnabled=YES;
//        UploadImgBtn.userInteractionEnabled=YES;
//        [firstNameTextField becomeFirstResponder];
//        
//
//        [RightButton setTitle:@"Done" forState:UIControlStateNormal];
//    }
//    else if ([title isEqualToString:@"Done"])
//    {
//        firstNameTextField.userInteractionEnabled=NO;
//        LastNameTextField.userInteractionEnabled=NO;
//        EmailTextField.userInteractionEnabled=NO;
//        MobileNumber.userInteractionEnabled=NO;
//        PasswordTextField.userInteractionEnabled=NO;
//        UploadImgBtn.userInteractionEnabled=NO;
//
//
//        //[self.view addSubview:FrontView];
//        [RightButton setTitle:@"Edit" forState:UIControlStateNormal];
//        //here we have to update profile
//        [firstNameTextField resignFirstResponder];
//        [LastNameTextField resignFirstResponder];
//        [EmailTextField resignFirstResponder];
//        [PasswordTextField resignFirstResponder];
//        [ConformPassword resignFirstResponder];
//        [MobileNumber resignFirstResponder];
//        [self EditProfileOfUser];
//    
//
//    }
    
    if ([firstNameTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter First Name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    else if ([LastNameTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Last Name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else if ([EmailTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Email Id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else if ([PasswordTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    else if ([MobileNumber.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter Mobile No" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self.view endEditing:YES];
      [self EditProfileOfUser];


}

#pragma mark - UIAlert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        if (buttonIndex==0)
        {
            if ([EditFrom isEqualToString:@"DriverMode"])
            {
                NSLog(@"%@",[self.navigationController.viewControllers objectAtIndex:2]);
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
  
            }
        }
        
    }
}


#pragma mark - Register Button Action

- (IBAction)RegisterButtonAction:(id)sender
{
    if (![self validateEmailWithString:EmailTextField.text]==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Check Your Email Address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [EmailTextField becomeFirstResponder];
        return;
    }
    if (![PasswordTextField.text isEqualToString:ConformPassword.text])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Please Check Your Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [PasswordTextField becomeFirstResponder];
        return;

    }
    
    NSData *img1Data = UIImageJPEGRepresentation(profileImageView.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"upload-btn.png"], 1.0);
    if ([img1Data isEqualToData:img2Data])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Upload User's Photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }


    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira 24/7" message:@"Updated Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];

    
}

#pragma mark - Profile Image Button Action

- (IBAction)ProfileImageButtonAction:(id)sender
{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:@"Photo Library"
                                      otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
 
}

#pragma mark - Login Here Buton Action

- (IBAction)LoginHereButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private method implementation

-(void)toggleHiddenState:(BOOL)shouldHide
{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}

#pragma mark - Sign Out Buton Action

- (IBAction)SignOutButtonAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Logout" forKey:@"Account"];
    [FBSession.activeSession closeAndClearTokenInformation];

    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Become A Driver Buton Action

- (IBAction)BecomeADriverButtonAction:(id)sender
{
    NSString *title=driverBtn.titleLabel.text;
    if ([title isEqualToString:@"SEE DRIVER MODE"])
    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Coming Soon" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        [self MoveToDriverMapView];
    }
    else
    {
        [self MoveToDriverRegister1View];
    }

}

#pragma mark - Edit Vechicle Info Button Action

- (IBAction)EditVechicleInfo:(id)sender
{
    
}

#pragma mark - Action Sheet Delegates

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker
                           animated:YES completion:nil];
    }
    if (buttonIndex==0)
    {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType  = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark - Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    UIGraphicsBeginImageContext(CGSizeMake(640,640));
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    [chosenImage drawInRect: CGRectMake(0, 0, profileImageView.frame.size.width, profileImageView.frame.size.height)];
//    
//    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    profileImageView.image = chosenImage;
    
    float actualHeight = chosenImage.size.height;
    float actualWidth = chosenImage.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 1.0;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [chosenImage drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //imagedata = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self imageUpload];
    
    
   // profileImageView.image = chosenImage;
//   //  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self imageUpload];
//    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [viewController.navigationItem setTitle:@""];
    
}
-(void)imageUpload
{
    UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    objactivityindicator.center = CGPointMake((VechicleImageView.frame.size.width/2),(VechicleImageView.frame.size.height/2));
    [VechicleImageView addSubview:objactivityindicator];
    [objactivityindicator startAnimating];

    
    NSData *imagedata = UIImageJPEGRepresentation(profileImageView.image,0.5f);
    
    NSString *imagePostUrl = [NSString stringWithFormat:@"%@/ImageUpload",Kwebservices];
    
    NSString *fileName = [NSString stringWithFormat:@"profilePic%ld%c%c.png", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://server.url"]];
    NSDictionary *parameters = @{@"":@""};
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    AFHTTPRequestOperation *op = [manager POST:imagePostUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imagedata name:fileName fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        [objactivityindicator stopAnimating];

        if (![responseObject isKindOfClass:[NSNull class]])
        {
            
            [kappDelegate HideIndicator];
            
              NSString *messageStr=[responseObject valueForKey:@"message"];
            imageNameStr = [responseObject valueForKey:@"ImageName"];
            
            
//            [Register1ViewDict setValue:imagestr forKey:@"ImageCode"];
//            [Register1ViewDict setValue:firstNameTextField.text forKey:@"FirstName"];
//            [Register1ViewDict setValue:LastNameTextField.text forKey:@"LastName"];
//            [self MoveToAddCreditCardView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [kappDelegate HideIndicator];
        [objactivityindicator stopAnimating];

        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ARA" message:@"Failed to upload selected profile picture" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return ;
    }];
    [op start];
}

#pragma mark - Move Up View

-(void)moveUpView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if(self.view.frame.origin.y==0)
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-158,self.view.frame.size.width,self.view.frame.size.height);
    }
    [UIView commitAnimations];
}
#pragma mark - Move Down View

-(void)moveDownView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}

#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [firstNameTextField resignFirstResponder];
    [LastNameTextField resignFirstResponder];
    [EmailTextField resignFirstResponder];
    [PasswordTextField resignFirstResponder];
    [ConformPassword resignFirstResponder];
    [MobileNumber resignFirstResponder];

    
    return YES;
}

#pragma mark - Validation for email

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - Edit Profile Web Service

-(void)EditProfileOfUser
{
    [kappDelegate ShowIndicator];
    [Base64 initialize];
    NSData* data = UIImageJPEGRepresentation(profileImageView.image, 0.5f);
    NSString *ImageCode = [Base64 encode:data];
    
    webservice=1;

    NSLog(@"1212%@",firstNameTextField.text);
    NSLog(@"2323%@",imageNameStr);
    NSLog(@"34343%@",LastNameTextField.text);
    NSLog(@"12454512%@",PasswordTextField.text);
    NSLog(@"12156552%@",MobileNumber.text);

    if (imageNameStr == nil){
        imageNameStr = @"";
    }
    
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc]init];
    [jsonDict setObject:imageNameStr forKey:@"ImageName"];
    [jsonDict setObject:firstNameTextField.text forKey:@"firstname"];
    [jsonDict setObject:LastNameTextField.text forKey:@"lastname"];
    [jsonDict setObject:PasswordTextField.text forKey:@"password"];
    [jsonDict setObject:MobileNumber.text forKey:@"phonenumber"];
    [jsonDict setObject:@"" forKey:@"creditcardnumber"];
    [jsonDict setObject:@"" forKey:@"creditcardexpiry"];
    [jsonDict setObject:@"" forKey:@"cvv"];
    [jsonDict setObject:EmailTextField.text forKey:@"email"];
    [jsonDict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    

    
    
    jsonRequest = [jsonDict JSONRepresentation];
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterRider",Kwebservices]];
    
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
            
            int result=[[userDetailDict valueForKey:@"result"]intValue ];
            if (result==1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=100;
                [alert show];
            }
        }
    }
}

#pragma mark - Move To Driver Register1 View

-(void)MoveToDriverRegister1View
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil];
        }
        else
        {
            DriverRegister1ViewObj=[[DriverRegister1ViewController alloc]initWithNibName:@"DriverRegister1ViewController" bundle:nil];
        }
        [self.navigationController pushViewController:DriverRegister1ViewObj animated:YES];
    }
}

#pragma mark - Move To Driver Map View

-(void)MoveToDriverMapView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            DriverMapViewObj=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController_iphone4" bundle:nil];
        }
        else
        {
            DriverMapViewObj=[[DriverMapViewController alloc]initWithNibName:@"DriverMapViewController" bundle:nil];
        }
        [self.navigationController pushViewController:DriverMapViewObj animated:YES];
    }
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end






