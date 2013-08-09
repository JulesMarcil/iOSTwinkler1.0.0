//
//  Profile.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *friendNumber;

-(id) initWithName:(NSString *)name
      friendNumber:(NSNumber *)friendNumber;

-(void) loadProfile;

@end
