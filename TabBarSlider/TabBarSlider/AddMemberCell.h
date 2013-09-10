//
//  AddMemberCell.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 25/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *memberProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *memberButton;
@property (weak, nonatomic) IBOutlet UIView *deleteMemberView;

- (IBAction)memberAction:(id)sender;

@end
