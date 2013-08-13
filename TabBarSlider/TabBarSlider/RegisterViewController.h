//
//  RegisterViewController.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 13/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *FBspinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)FacebookLogin:(id)sender;
- (IBAction)EmailRegister:(id)sender;

@end
