//
//  Profile.m
//  TabBarSlider
//
//  Created by Jules Marcilhacy on 09/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "Profile.h"
#import "AuthAPIClient.h"

@implementation Profile

-(id) initWithName:(NSString *)name friendNumber:(NSNumber *)friendNumber picturePath:(NSString *)picturePath {
    self=[super init];
    if(self){
        _name=name;
        _friendNumber=friendNumber;
        return self;
    }
    return nil;
}

-(void) setName:(NSString *)name friendNumber:(NSNumber *)friendNumber picturePath:(NSString *)picturePath {
    if(self){
        _name=name;
        _friendNumber=friendNumber;
        _picturePath=picturePath;
    }
}

-(void) loadProfile {
    
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    NSLog(@"token  before loading profile: %@", authToken);
    
    [[AuthAPIClient sharedClient] getPath:@"api/profile"
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError *error = nil;
                                     NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      NSLog(@"profile loaded => %@", response);
                                      
                                      [self setName:response[@"name"] friendNumber:response[@"friendNumber"] picturePath:response[@"picturePath"]
                                       ];   
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"profileWithJSONFinishedLoading" object:nil];
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
}

@end
