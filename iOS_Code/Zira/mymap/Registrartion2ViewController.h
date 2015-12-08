//
//  Registrartion2ViewController.h
//  mymap
//
//  Created by vikram on 20/11/14.
//

#import <UIKit/UIKit.h>
#import "PaymentViewController.h"

@interface Registrartion2ViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    
    
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *LastNameTextField;
    IBOutlet UIImageView *profileImageView;
    NSMutableDictionary   *Register1ViewDict;
    


}

@property(nonatomic,retain)NSMutableDictionary   *Register1ViewDict;
- (IBAction)ProfileImageButtonAction:(id)sender;

@end
