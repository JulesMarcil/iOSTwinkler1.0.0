//
//  Group.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSDictionary *activeMember;
@property (nonatomic, strong) NSString *currency;

-(id) initWithName:(NSString *)name
        identifier:(NSNumber *)identifier
           members:(NSArray *)members
      activeMember:(NSDictionary *)activeMember
          currency:(NSString *)currency;
@end
