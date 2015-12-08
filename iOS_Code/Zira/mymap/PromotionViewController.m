//
//  PromotionViewController.m
//  mymap
//
//  Created by vikram on 29/01/15.
//  Copyright (c) 2015 Impinge. All rights reserved.
//

#import "PromotionViewController.h"

@interface PromotionViewController ()

@end

@implementation PromotionViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:247/255.0f blue:238/255.0f alpha:1.0f];
    
    PromoCodeListArray=[[NSMutableArray alloc] init];
    PromoCodeListArray=[[[NSUserDefaults standardUserDefaults]valueForKey:@"PromoCodeList"] mutableCopy];
    
    promoCodeTable.layer.cornerRadius=5.0;
    promoCodeTable.layer.borderColor=[UIColor lightGrayColor].CGColor;
    promoCodeTable.layer.borderWidth=2.0;
    
    if (PromoCodeListArray.count>0)
    {
        if ([PromoCodeListArray count]==1)
        {
            promoCodeTable.frame=CGRectMake(25, 71, 271, 50);
        }
        else if ([PromoCodeListArray count]==2)
        {
            promoCodeTable.frame=CGRectMake(25, 71, 271, 80);
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Zira24/7" message:@"No Promocode is Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

        promoCodeTable.hidden=YES;
    }


    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PromoCodeListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (PromoCodeListArray.count>0)
    {
        
        cell.textLabel.text = [[PromoCodeListArray objectAtIndex:indexPath.row] valueForKey:@"promocode"];
        
    }
    
    return cell;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
