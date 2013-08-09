//
//  CredentialStore.m
//  Twinkler_login
//
//  Created by Jules Marcilhacy on 02/08/13.
//  Copyright (c) 2013 Jules Marcilhacy. All rights reserved.
//

#import "CredentialStore.h"
#import "SSKeychain.h"

#define SERVICE_NAME @"Twinkler-AuthClient"
#define AUTH_TOKEN_KEY @"auth_token"
#define REFRESH_TOKEN_KEY @"refresh_token"

@implementation CredentialStore

const NSString *auth_token;
const NSString *refresh_token;

- (BOOL)isLoggedIn {
    return [self authToken] != nil;
}

- (void)clearSavedCredentials {
    [self setAuthToken:nil];
    [self setRefreshToken:nil];
}

- (NSString *)authToken {
    return [self secureValueForKey:AUTH_TOKEN_KEY];
}

- (NSString *)refreshToken {
    return [self secureValueForKey:REFRESH_TOKEN_KEY];
}

- (void)setAuthToken:(NSString *)authToken {
    [self setSecureValue:authToken forKey:AUTH_TOKEN_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"token-changed" object:self];
}

- (void)setRefreshToken:(NSString *)refreshToken {
    [self setSecureValue:refreshToken forKey:REFRESH_TOKEN_KEY];
}

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [SSKeychain setPassword:value
                     forService:SERVICE_NAME
                        account:key];
    } else {
        [SSKeychain deletePasswordForService:SERVICE_NAME account:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key {
    return [SSKeychain passwordForService:SERVICE_NAME account:key];
}

@end
