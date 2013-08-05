//
//  ListDataController.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class List;

@interface ListDataController : NSObject

@property (nonatomic, copy) NSMutableArray *listList;

- (NSUInteger)countOfList;
- (List *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addListWithList:(List *)list;

@end
