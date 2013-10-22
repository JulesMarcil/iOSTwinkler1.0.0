//
//  customSearchBar.m
//  Twinkler
//
//  Created by Arnaud Drizard on 22/10/2013.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "customSearchBar.h"

@implementation customSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setShowsCancelButton:NO animated:YES];
}

@end
