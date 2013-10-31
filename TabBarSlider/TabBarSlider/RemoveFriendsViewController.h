//
//  RemoveFriendsViewController.h
//  Twinkler
//
//  Created by Jules Marcilhacy on 22/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface RemoveFriendsViewController : GAITrackedViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView* friendTable;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) UITableView *friendTable;
@property (nonatomic, strong) Group *group;
@property (nonatomic, strong) NSMutableArray *selectedList;

- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
