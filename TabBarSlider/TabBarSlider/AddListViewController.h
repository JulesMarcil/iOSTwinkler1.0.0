//
//  AddListViewController.h
//  Twinkler
//
//  Created by Arnaud Drizard on 07/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddListViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *groupNameContainer;
- (IBAction)dismissView:(id)sender;

@end
