//
//  memberCollectionViewCell.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface memberCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *memberProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (assign, nonatomic) BOOL isSelected;
@property (weak, nonatomic) UIImageView *checkIcon;

-(void) showCheck;

@end
