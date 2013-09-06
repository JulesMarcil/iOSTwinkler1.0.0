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

@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) List *list;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UILabel *listNameLabel;


- (IBAction)doneAddItem:(UIStoryboardSegue *)segue;
- (IBAction)cancelAddItem:(UIStoryboardSegue *)segue;
- (IBAction)backToList:(id)sender;
@end
