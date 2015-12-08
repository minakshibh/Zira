//
//  SupportViewController.m
//  mymap
//
//  Created by vikram on 28/01/15.
//  Copyright (c) 2015 Impinge. All rights reserved.
//

#import "SupportViewController.h"

@interface SupportViewController ()

@end

@implementation SupportViewController


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Email Button Action

- (IBAction)EmailBtn:(id)sender
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        
        controller.mailComposeDelegate = self;
        
        NSString *email=@"support@zira247.com";
        NSArray *emailAddress=[email componentsSeparatedByString:@","];
        
        [controller setSubject:@"Zira24/7"];
        // [controller setToRecipients:[NSArray arrayWithObjects:emailAddress, nil]];
        [controller setToRecipients:emailAddress];
        [controller setMessageBody:@"" isHTML:NO];
        [self presentModalViewController:controller animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Please configure your mail composer" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
 
}
- (IBAction)Email2Button:(id)sender
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        
        controller.mailComposeDelegate = self;
        
        NSString *email=@"info@zira247.com";
        NSArray *emailAddress=[email componentsSeparatedByString:@","];
        
        [controller setSubject:@"Zira24/7"];
        // [controller setToRecipients:[NSArray arrayWithObjects:emailAddress, nil]];
        [controller setToRecipients:emailAddress];
        [controller setMessageBody:@"" isHTML:NO];
        [self presentModalViewController:controller animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"Please configure your mail composer" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)privacyPolicyBtn:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://zira247.com/Home/Privacy"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)helpButton:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://zira247.com/Home/Help"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)termsConditionsBtn:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://zira247.com/Home/Terms"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)jobsActionBtn:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://zira247.com/Home/Jobs"];
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - MFMail Delegates

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];

    UIAlertView *mailAlert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    switch (result)
    {
        case MFMailComposeResultSaved:
        {
            mailAlert.message = @"Message Saved";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Zira 24/7" message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
            // [mailAlert show];
        }
            break;
        case MFMailComposeResultSent:
        {
            mailAlert.message = @"Message Sent";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Zira 24/7" message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [[NSUserDefaults standardUserDefaults] setValue:@"Mail" forKey:@"Mail"];
            [Alert show];
            // [mailAlert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            mailAlert.message = @"Message Failed";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Zira 24/7" message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
            //[mailAlert show];
        }
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Message Button Action

- (IBAction)MessageBtn:(id)sender
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"headerplain.png"] forBarMetrics:UIBarMetricsDefault];

    MFMessageComposeViewController *messageComposer =[[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        
        NSString *message = @"";
        [messageComposer setBody:message];
        messageComposer.recipients = [NSArray arrayWithObjects:@"18559472247", nil];
        
        messageComposer.messageComposeDelegate = self;
        [self presentViewController:messageComposer animated:YES completion:nil];
    }
}

#pragma mark - MFMessage Delegates

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];

    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Message sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
            
        }
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Call Button Action

- (IBAction)CallBtn:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:18559472247"]];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
