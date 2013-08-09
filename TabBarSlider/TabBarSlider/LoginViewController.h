//
//  LoginViewController.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)EmailLogin:(id)sender;
- (IBAction)FacebookLogin:(id)sender;

@end
