//
//  List.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
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
