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

- (IBAction)FBConnect:(id)sender;

@end
