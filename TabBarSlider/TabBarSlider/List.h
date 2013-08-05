//
//  List.h
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface List : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *items;

- (id)initWithName:(NSString *)name
             items:(NSArray *)items
        identifier:(NSNumber *)identifier;

@end
