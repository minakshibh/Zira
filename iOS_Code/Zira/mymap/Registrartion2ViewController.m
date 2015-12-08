//
//  Registrartion2ViewController.m
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import "Registrartion2ViewController.h"
#import "Base64.h"
#import "AddCreditCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"


PaymentViewController *PaymentViewObj;
AddCreditCardViewController *CreditCardViewObj;

@interface Registrartion2ViewController ()

@end

@implementation Registrartion2ViewController

@synthesize Register1ViewDict;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];

 //   self.title=@"Zira24/7";
    self.navigationItem.hidesBackButton = YES;
    
    // Right Bar Button Item //
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    RightButton.frame = CGRectMake(0, 0, 20, 25);
   // [RightButton setTitle:@"Next" forState:UIControlStateNormal];
    
     [RightButton setImage:[UIImage imageNamed:@"rightarrow.png"] forState:UIControlStateNormal];
    [RightButton setImage:[UIImage imageNamed:@"rightarrow.png"] forState:UIControlStateHighlighted];
    [RightButton addTarget:self action:@selector(NextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    
    // Left Bar Button Item //
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 20, 25);
   // [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"leftarrow.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Next Button Action

-(IBAction)NextButtonAction:(id)sender
{
    NSData *img1Data = UIImageJPEGRepresentation(profileImageView.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"dummyImg.png"], 1.0);
    if ([img1Data isEqualToData:img2Data])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zira24/7" message:@"Upload User's Photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([firstNameTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter first name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if ([LastNameTextField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Please Enter last name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    else
    {
        [self imageUpload];
        
    }

}

#pragma mark - Move to Payment View

-(void)MoveToPaymentView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            PaymentViewObj=[[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];

        }
        else
        {
            PaymentViewObj=[[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
        }
        PaymentViewObj.AllRegisterDetailsDict=Register1ViewDict;
        [self.navigationController pushViewController:PaymentViewObj animated:YES];

    }
    
}

#pragma mark - Move to Add Credit Card View

-(void)MoveToAddCreditCardView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
          CreditCardViewObj=[[AddCreditCardViewController alloc]initWithNibName:@"AddCreditCardViewController" bundle:nil];
            
        }
        else
        {
          CreditCardViewObj=[[AddCreditCardViewController alloc]initWithNibName:@"AddCreditCardViewController" bundle:nil];
        }
        
        CreditCardViewObj.FinalRegisterDict=Register1ViewDict;
        [self.navigationController pushViewController:CreditCardViewObj animated:YES];
        
    }
    
}

#pragma mark - Cancel Button Action

-(IBAction)CancelButtonAction:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

#pragma mark - Profile Image Button Action

- (IBAction)ProfileImageButtonAction:(id)sender
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [firstNameTextField resignFirstResponder];
    [LastNameTextField resignFirstResponder];

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    
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
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

#pragma mark - Image Picker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
 //   UIGraphicsBeginImageContext(CGSizeMake(250,180));
    
  //  CGContextRef context = UIGraphicsGetCurrentContext();
    
    //[chosenImage drawInRect: CGRectMake(0, 0, 200, 105)];
    
//    
//    CGSize imgSize= chosenImage.size;
//    
//    CGSize size = CGSizeMake(400, 250);
//    UIGraphicsBeginImageContext(size);
//    [chosenImage drawInRect: CGRectMake(0, 0, 320,150)];
//    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
//    profileImageView.contentMode = UIViewContentModeScaleAspectFit;
//    UIGraphicsEndImageContext();
//    
//    profileImageView.image = chosenImage;
    
    
    
    
    
    
    
    
    
    
    
    CGSize newSize = CGSizeMake(640, 1156);
    CGFloat widthRatio = newSize.width/chosenImage.size.width;
    CGFloat heightRatio = newSize.height/chosenImage.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(chosenImage.size.width*heightRatio,chosenImage.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(chosenImage.size.width*widthRatio,chosenImage.size.height*widthRatio);
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width,newSize.height));
   // UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [chosenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    profileImageView.contentMode = UIViewContentModeScaleAspectFit;

    profileImageView.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//- (void)imagePickerController:(UIImagePickerController *)picker
//        didFinishPickingImage:(UIImage *)image
//                  editingInfo:(NSDictionary *)editingInfo
//{
//    profileImageView.image = image;
//    
//    [picker dismissViewControllerAnimated:YES completion:NULL];
//}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [viewController.navigationItem setTitle:@""];

}


#pragma mark - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (textField.tag==1 || textField.tag==2)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [firstNameTextField resignFirstResponder];
    [LastNameTextField resignFirstResponder];
    return YES;
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UPLOAD USER Image

-(void)imageUpload
{
    [kappDelegate ShowIndicator];

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
        
        if (![responseObject isKindOfClass:[NSNull class]])
        {
            
            [kappDelegate HideIndicator];

          //  NSString *messageStr=[responseObject valueForKey:@"message"];
            NSString *imagestr = [responseObject valueForKey:@"ImageName"];
            [Register1ViewDict setValue:imagestr forKey:@"ImageCode"];
            [Register1ViewDict setValue:firstNameTextField.text forKey:@"FirstName"];
            [Register1ViewDict setValue:LastNameTextField.text forKey:@"LastName"];
            [self MoveToAddCreditCardView];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [kappDelegate HideIndicator];

        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ARA" message:@"Failed to upload selected profile picture" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return ;
    }];
    [op start];
}


@end
