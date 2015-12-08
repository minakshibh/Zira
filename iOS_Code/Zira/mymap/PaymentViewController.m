//
//  PaymentViewController.m
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import "PaymentViewController.h"
AddCreditCardViewController *AddCreditCardViewObj;

@interface PaymentViewController ()

@end

@implementation PaymentViewController
@synthesize AllRegisterDetailsDict;
#pragma mark - View Life Cycle

- (void)viewDidLoad
{
  //  self.title=@"SELECT PAYMENT";
    self.navigationItem.hidesBackButton = YES;

    // Right Bar Button Item //
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [RightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    RightButton.titleLabel.font = [UIFont systemFontOfSize:14];

    RightButton.frame = CGRectMake(0, 0, 60, 40);
    [RightButton setTitle:@"PROMO" forState:UIControlStateNormal];
    
    // [RightButton setImage:[UIImage imageNamed:@"save_btn.png"] forState:UIControlStateNormal];
    //[RightButton setImage:[UIImage imageNamed:@"save_btn.png"] forState:UIControlStateHighlighted];
    [RightButton addTarget:self action:@selector(PromoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *RightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:RightButton];
    self.navigationItem.rightBarButtonItem = RightBarButtonItem;
    
    // Left Bar Button Item //
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];

    leftButton.frame = CGRectMake(0, 0, 60, 40);
    [leftButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    //[leftButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(CancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *LeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = LeftBarButtonItem;

    
    NSLog(@"%@",AllRegisterDetailsDict);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Cancel Button Action

-(IBAction)CancelButtonAction:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"Do You Want To Cancel Your Registration?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag=1;
    [alert show];

}

#pragma mark - Promo Button Action

-(IBAction)PromoButtonAction:(id)sender
{
    
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}

#pragma mark - Move to Payment View

-(void)MoveToAddCreditCardView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            AddCreditCardViewObj=[[AddCreditCardViewController alloc]initWithNibName:@"AddCreditCardViewController" bundle:nil];
            
        }
        else
        {
            AddCreditCardViewObj=[[AddCreditCardViewController alloc]initWithNibName:@"AddCreditCardViewController" bundle:nil];
        }
        AddCreditCardViewObj.FinalRegisterDict=AllRegisterDetailsDict;
        [self.navigationController pushViewController:AddCreditCardViewObj animated:YES];
        
    }
    
}

#pragma mark - Add Credit Card Button Action

- (IBAction)AddCreditCard:(id)sender
{
    [self MoveToAddCreditCardView];
}

#pragma mark - Add Prepaid Wallet Button Action

- (IBAction)AddPrepaidWallet:(id)sender
{
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
