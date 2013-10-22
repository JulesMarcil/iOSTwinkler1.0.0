//
//  AddFriendsViewController.h
//  Twinkler
//
//  Created by Jules Marcilhacy on 21/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class Group;

@interface AddFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSMutableArray *filteredList;
@property (strong, nonatomic) NSMutableArray *selectedList;
@property (weak, nonatomic) IBOutlet UIView *searchbarContainer;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) Group *group;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)doneAction:(id)sender;
- (IBAction)dismissModal:(id)sender;

@end
