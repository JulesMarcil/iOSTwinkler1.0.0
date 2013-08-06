//
//  Group.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Group.h"

@implementation Group
-(id)initWithName:(NSString *)name identifier:(NSNumber *)identifier members:(NSArray *)members activeMember:(NSDictionary *)activeMember {
    self=[super init];
    if(self){
        _name=name;
        _identifier=identifier;
        _members=members;
        _activeMember=activeMember;
        return self;
    }
    return nil;
}
@end
