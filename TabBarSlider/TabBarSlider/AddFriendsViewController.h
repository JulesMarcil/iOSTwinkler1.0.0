//
//  AddFriendsViewController.h
//  Twinkler
//
//  Created by Jules Marcilhacy on 21/10/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate>

- (IBAction)dismissModal:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@end
