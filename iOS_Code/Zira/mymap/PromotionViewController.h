//
//  PromotionViewController.h
//  mymap
//
//  Created by vikram on 29/01/15.
//  Copyright (c) 2015 Impinge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UITableView *promoCodeTable;
    NSMutableArray  *PromoCodeListArray;


}

@end
