//
//  ListDataController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//


#import "ListDataController.h"
#import "List.h"
#import "AuthAPIClient.h"

@interface ListDataController ()

- (void)initializeDefaultDataList;

@end

@implementation ListDataController

- (void)initializeDefaultDataList {
    NSMutableArray *listList = [[NSMutableArray alloc] init];
    self.listList = listList;
    
    [[AuthAPIClient sharedClient] getPath:@"group/app/lists"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"success: %@", response);
                                      for(id key in response) {
                                          
                                          List *list = [[List alloc] initWithName:key[@"name"]
                                                                            items:key[@"items"]
                                                                       identifier:key[@"id"]];
                                          
                                          [self addListWithList:list];
                                      }
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"listsWithJSONFinishedLoading" object:nil];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
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
