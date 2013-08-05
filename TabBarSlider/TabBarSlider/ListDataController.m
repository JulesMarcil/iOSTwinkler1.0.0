//
//  ListDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//


#import "ListDataController.h"
#import "List.h"

@interface ListDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ListDataController

- (void)initializeDefaultDataList {
    NSMutableArray *listList = [[NSMutableArray alloc] init];
    self.listList = listList;
    List *list;
    list= [[List alloc]initWithName:@"Shopping List" items:[NSArray array] identifier:[NSNumber numberWithInt:1000]];
    
    [self addListWithList:list];}

- (void)setListList:(NSMutableArray *)newList {
    if (_listList != newList) {
        _listList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.listList count];
}

- (List *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.listList objectAtIndex:theIndex];
}

- (void)addListWithList:(List *)list {
    [self.listList addObject:list];
}

@end
