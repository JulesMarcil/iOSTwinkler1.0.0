//
//  WalkthroughViewController.h
//  Twinkler
//
//  Created by Arnaud Drizard on 14/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customPageControl.h"

@interface WalkthroughViewController : GAITrackedViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;
@property (weak, nonatomic) IBOutlet UIView *fifthView;
@property (weak, nonatomic) IBOutlet UIView *sixthView;
@property (weak, nonatomic) IBOutlet customPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UILabel *catchphraseHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *catchphraseSubLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectWithFbButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *spinnerContainer;
@property (weak, nonatomic) IBOutlet UIView *devicesContainer;
@property (weak, nonatomic) IBOutlet UIImageView *twinklerLogo;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIView *whyFBLogin;
@property (weak, nonatomic) IBOutlet UIView *seeWhyContainer;
@property (weak, nonatomic) IBOutlet UIButton *oldSigninButton;
@property (weak, nonatomic) IBOutlet UILabel *alreadyRegisteredLabel;
@property (weak, nonatomic) IBOutlet UIView *whyLabelContainer;

- (IBAction)dismissView:(id)sender;
- (IBAction)facebookConnect:(id)sender;
- (IBAction)dismissFBView:(id)sender;
- (IBAction)whyFBShow:(id)sender;

@end
