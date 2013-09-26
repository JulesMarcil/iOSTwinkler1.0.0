//
//  RegisterViewController.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 13/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *FBspinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIView *darkLine;
@property (weak, nonatomic) IBOutlet UIView *whiteLine;
@property (weak, nonatomic) IBOutlet UIButton *FBButton;

- (IBAction)FacebookLogin:(id)sender;
- (IBAction)EmailRegister:(id)sender;
- (IBAction)backToHP:(id)sender;

@end
