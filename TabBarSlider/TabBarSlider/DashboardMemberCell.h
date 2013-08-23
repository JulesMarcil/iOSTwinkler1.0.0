//
//  DashboardMemberCell.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 23/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *memberProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end
