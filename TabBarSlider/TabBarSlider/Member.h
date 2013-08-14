//
//  Member.h
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 14/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *picturePath;

-(id) initWithName:(NSString *)name
       picturePath:(NSString *)picturePath;

@end
