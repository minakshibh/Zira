//
//  LisenceAgrementViewController.m
//  mymap
//
//  Created by vikram on 19/12/14.
//

#import "LisenceAgrementViewController.h"
#import "HomeViewController.h"

@interface LisenceAgrementViewController ()

@end

@implementation LisenceAgrementViewController

- (void)viewDidLoad
{
    self.navigationItem.hidesBackButton = YES;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            scrollView.contentSize = CGSizeMake(320, 480);
        }
        else
        {
            scrollView.contentSize = CGSizeMake(320, 568);
        }
    }

    textView.contentInset = UIEdgeInsetsZero;
    [textView sizeToFit];
    [textView setClipsToBounds:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Move to Home View

-(void)MoveToHomeView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            HomeViewController*HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController_iphone4" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:YES];
        }
        else
        {
           HomeViewController*HomeViewObj=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            [self.navigationController pushViewController:HomeViewObj animated:YES];
        }
    }
    
}

- (IBAction)AcceptBtn:(id)sender
{
    [self MoveToHomeView];
    [[NSUserDefaults standardUserDefaults] setValue:@"Accept" forKey:@"Aggrement"];

}

- (IBAction)RejectBtn:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"Reject" forKey:@"Aggrement"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
