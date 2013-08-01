//
//  List.m
//  Twinkler_tuto
//
//  Created by Jules Marcilhacy on 01/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "List.h"

@implementation List

- (id)initWithName:(NSString *)name items:(NSArray *)items identifier:(NSNumber *)identifier
{
    self = [super init];
    if (self) {
        _identifier = identifier;
        _name = name;
        _items = items;
        return self;
    }
    return nil;
}

@end
