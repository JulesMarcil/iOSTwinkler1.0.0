//
//  AddGroupViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface AddGroupViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate> {
    NSArray *currencies;
}

@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPicker;
@property (weak, nonatomic) IBOutlet UILabel *currentCurrency;
@property (strong, nonatomic) Group *group;
@property (weak, nonatomic) NSDictionary *selectedCurrency;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *groupNameContainer;
@property (weak, nonatomic) IBOutlet UIView *actionBarContainer;

- (IBAction)showPicker:(id)sender;
- (IBAction)nextButton:(id)sender;

@end
