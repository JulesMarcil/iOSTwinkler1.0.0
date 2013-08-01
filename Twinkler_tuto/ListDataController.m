//
//  ListDataController.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 01/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "ListDataController.h"
#import "List.h"
#import "AFJSONRequestOperation.h"

@interface ListDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ListDataController

- (void)initializeDefaultDataList {
    NSMutableArray *localListList = [[NSMutableArray alloc] init];
    self.listList = localListList;
    
    NSURL *listsURL = [NSURL URLWithString:@"http://localhost:8888/Twinkler1.2.3/web/app_dev.php/group/app/lists"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:listsURL];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *dataArray = JSON;
    
        for(id key in dataArray) {
        
            List *list = [[List alloc] initWithName:key[@"name"]
                                              items:key[@"items"]
                                         identifier:key[@"id"]];
        
            [self addListWithList:list];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"listsWithJSONFinishedLoading" object:nil];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"NSError: %@",error.localizedDescription);
    }];
    [operation start];
}

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
