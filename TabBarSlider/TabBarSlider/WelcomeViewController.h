//
//  welcomeViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 12/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIImageView *bckgdImage;
@property (weak, nonatomic) IBOutlet UIView *spinnerContainer;
@property (weak, nonatomic) IBOutlet UIButton *connectWithFbButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIView *whyFBLogin;
@property (weak, nonatomic) IBOutlet UIView *whyLabelContainer;
@property (weak, nonatomic) IBOutlet UIView *seeWhyContainer;

- (IBAction)FBConnect:(id)sender;
- (IBAction)dismissFBView:(id)sender;
- (IBAction)whyFBSHow:(id)sender;

@end
