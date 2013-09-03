//
//  FeedbackViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *actionBarContainer;
@property (weak, nonatomic) IBOutlet UIView *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@end
