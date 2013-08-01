//
//  ListDataController.h
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 01/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class List;

@interface ListDataController : NSObject

@property (nonatomic, copy) NSMutableArray *listList;

- (NSUInteger)countOfList;
- (List *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addListWithList:(List *)list;

@end
