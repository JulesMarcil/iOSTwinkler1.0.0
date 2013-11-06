
//
//  memberCollectionViewCell.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "memberCollectionViewCell.h"

@implementation memberCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *checkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 12)];
        self.checkIcon = checkIcon;
        [self.checkIcon setFrame:CGRectMake(0, 0, 16, 12)];
        self.checkIcon.image=[UIImage imageNamed: @"green-check"];
        [self addSubview:self.checkIcon];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)showCheck{

    self.memberProfilePic.alpha=1;
    self.isSelected=YES;
}

@end
