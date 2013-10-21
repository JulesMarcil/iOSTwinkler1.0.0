//
//  AddFriendsViewController.h
//  Twinkler
//
//  Created by Jules Marcilhacy on 21/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AddFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSMutableArray *filteredList;
@property (strong, nonatomic) NSMutableArray *selectedList;

- (IBAction)dismissModal:(id)sender;

@end
