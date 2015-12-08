//
//  SplashViewController.m
//  mymap
//
//  Created by Br@R on 19/01/15.

#import "SplashViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import "LoginViewController.h"


@interface SplashViewController ()

@end

@implementation SplashViewController

#pragma mark - View did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:25/255.0f green:25/255.0f blue:25/255.0f alpha:1.0f];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Video4" ofType:@"mp4"]];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    //  moviePlayer.backgroundView.backgroundColor = [UIColor colorWithRed:34/255.0f green:34/255.0f blue:34/255.0f alpha:1.0f];
    NSLog(@"%@",self.view.frame);
    [moviePlayer.view setFrame:self.view.frame];
    
    //    CGRect frame = self.view.frame;
    //    moviePlayer.view.frame = frame;
    moviePlayer.controlStyle=MPMovieControlStyleNone;
    [self.view addSubview:moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    
    //  NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    
    //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)                             name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    timer=[NSTimer scheduledTimerWithTimeInterval:4.0f
                                           target:self
                                         selector:@selector(MoveToLoginView)
                                         userInfo:nil
                                          repeats:NO];
    
    [moviePlayer play];

}
- (void) movieFinishedCallback:(NSNotification*) aNotification
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Hello" message:@"sdf" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification                object:moviePlayer];
    
     LoginViewController*LoginVC;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result1 = [[UIScreen mainScreen] bounds].size;
        if(result1.height == 480)
        {
            LoginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController_iphone4" bundle:nil];
            
        }
        else
        {
            LoginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        }
    }
    [self.navigationController pushViewController:LoginVC  animated:NO];
}
-(void)MoveToLoginView
{
    [timer invalidate];
    LoginViewController*LoginVC;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result1 = [[UIScreen mainScreen] bounds].size;
        if(result1.height == 480)
        {
            LoginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController_iphone4" bundle:nil];
            
        }
        else
        {
            LoginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        }
    }
    [self.navigationController pushViewController:LoginVC  animated:NO];
   
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneButtonClick:(NSNotification*)aNotification
{
    [moviePlayer.view removeFromSuperview];
}

- (void)MPMoviePlayerPlaybackDidFinishNotification:(NSNotification *)notification
{
  //  MPMoviePlayerController *moviePlayerController = [notification object];
  
    
    [moviePlayer.view removeFromSuperview];

}


@end
