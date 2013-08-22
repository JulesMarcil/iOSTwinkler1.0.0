//
//  GroupMemberViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 22/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDataSource>  {

}

@property (weak, nonatomic) IBOutlet UITableView *memberSuggestionTableView;
@property (weak, nonatomic) IBOutlet UITableView *memberTableView;
@property (weak, nonatomic) IBOutlet UITextField *memberNameTextField;
- (IBAction)goToTimeline:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
