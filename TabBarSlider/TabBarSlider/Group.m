//
//  Group.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Group.h"

@implementation Group
-(id)initWithName:(NSString *)name{
    self=[super init];
    if(self){
        _name=name;
        return self;
    }
    return nil;
}
@end
