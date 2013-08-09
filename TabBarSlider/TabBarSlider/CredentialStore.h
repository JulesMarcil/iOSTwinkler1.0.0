//
//  CredentialStore.h
//  Twinkler_login
//
//  Created by Jules Marcilhacy on 02/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialStore : NSObject

extern const NSString *auth_token;
extern const NSString *refresh_token;

- (BOOL)isLoggedIn;
- (void)clearSavedCredentials;
- (NSString *)authToken;
- (NSString *)refreshToken;
- (void)setAuthToken:(NSString *)authToken;
- (void)setRefreshToken:(NSString *)refreshToken;

@end
