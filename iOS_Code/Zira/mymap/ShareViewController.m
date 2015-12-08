//
//  ShareViewController.m
//  mymap
//
//  Created by vikram on 09/02/15.
//  Copyright (c) 2015 Impinge. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)facebookActionBtn:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.facebook.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)twitterActionBt5n:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/?lang=en"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)pintresrActionBtn:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://in.pinterest.com/"];
    [[UIApplication sharedApplication] openURL:url];

}

- (IBAction)instgramactionBtn:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://instagram.com/"];
    [[UIApplication sharedApplication] openURL:url];
}
@end
