//
//  InviteViewController.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 26/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface InviteViewController : UIViewController <MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) NSString *link;
@property (weak, nonatomic) IBOutlet UITextView *linkLabel;
@property (weak, nonatomic) IBOutlet UIView *linkContainer;
@property (weak, nonatomic) IBOutlet UIButton *shareSMSButton;
@property (weak, nonatomic) IBOutlet UIButton *shareEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *shareFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)shareViaSMS:(id)sender;
- (IBAction)shareViaEmail:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
