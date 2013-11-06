//
//  TellViewController.h
//  Twinkler
//
//  Created by Jules Marcilhacy on 23/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface TellViewController : GAITrackedViewController <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) Group *group;
@property (weak, nonatomic) IBOutlet UITextView *messageView;
@property (weak, nonatomic) IBOutlet UIView *linkCopyContainer;
@property (weak, nonatomic) IBOutlet UIView *linkContainer;
@property (weak, nonatomic) IBOutlet UITextView *linkLabel;
@property (weak, nonatomic) IBOutlet UIView *toolbar;

- (IBAction)copyAction:(id)sender;
- (IBAction)facebookAction:(id)sender;
- (IBAction)emailAction:(id)sender;
- (IBAction)smsAction:(id)sender;
- (IBAction)doneAction:(id)sender;
- (IBAction)backAction:(id)sender;

@end
