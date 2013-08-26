//
//  InviteViewController.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 26/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface InviteViewController : UIViewController
@property (strong, nonatomic) Group *group;

- (IBAction)doneAdd:(id)sender;

@end
