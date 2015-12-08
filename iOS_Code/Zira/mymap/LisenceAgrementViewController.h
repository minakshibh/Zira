//
//  LisenceAgrementViewController.h
//  mymap
//
//  Created by vikram on 19/12/14.
//

#import <UIKit/UIKit.h>

@interface LisenceAgrementViewController : UIViewController

{
    
    IBOutlet UITextView *textView;
    IBOutlet UIScrollView *scrollView;
}
- (IBAction)AcceptBtn:(id)sender;
- (IBAction)RejectBtn:(id)sender;

@end
