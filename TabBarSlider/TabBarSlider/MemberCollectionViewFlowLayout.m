//
//  MemberCollectionViewFlowLayout.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 12/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "MemberCollectionViewFlowLayout.h"

@implementation MemberCollectionViewFlowLayout

- (id)init {
    if ((self = [super init])) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 10000.0f;
        
    }
    return self;
}

- (CGSize)collectionViewContentSize
{
    
    NSArray *memberArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupMembers"];
    return CGSizeMake([memberArray count]*50 , self.collectionView.frame.size.height);
}

@end
