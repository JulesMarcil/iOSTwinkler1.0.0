//
//  ConnectViewController.h
//  Twinkler
//
//  Created by Jules Marcilhacy on 23/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface ConnectViewController : GAITrackedViewController

@property (weak, nonatomic) Group *group;
@property (weak, nonatomic) IBOutlet UITextView *messageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet UIView *labelContainerView;

- (IBAction)connectAction:(id)sender;
- (IBAction)noAction:(id)sender;

@end
