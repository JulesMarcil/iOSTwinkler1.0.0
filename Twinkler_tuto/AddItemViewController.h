//
//  AddItemViewController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 01/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemViewController : UITableViewController
<UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *item;
@property (weak, nonatomic) IBOutlet UITextField *itemNameInput;

@end
