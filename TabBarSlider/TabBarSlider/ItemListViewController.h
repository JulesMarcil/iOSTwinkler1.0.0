//
//  ItemListViewController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 05/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List.h"

@interface ItemListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>  {
    IBOutlet UITableView* itemListTableView;
}

@property (strong, nonatomic) List *list;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *itemInput;
@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;

- (IBAction)addItem:(id)sender;
- (IBAction)backToLists:(id)sender;
@end
