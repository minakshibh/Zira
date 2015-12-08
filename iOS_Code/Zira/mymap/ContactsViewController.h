//
//  ContactsViewController.h
//  mymap
//
//  Created by vikram on 19/12/14.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>


@interface ContactsViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@end
