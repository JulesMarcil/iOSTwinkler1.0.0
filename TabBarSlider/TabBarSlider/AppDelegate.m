//
//  AppDelegate.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 01/08/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "CredentialStore.h"
#import "AuthAPIClient.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *authToken = [store authToken];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        [self openSession];
        // should check for authentication token maybe ...
    }else if (authToken){
        //should refresh it maybe ...
        [self refreshAuthToken];
    }else{
        [self showLoginView];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showLoginView
{
    UIStoryboard *welcomeStoryboard = [UIStoryboard storyboardWithName:@"welcomeStoryboard" bundle: nil];
    
    LoginViewController* loginViewController = [welcomeStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:loginViewController animated:YES completion:NULL];
}

// *** Facebook login actions ***


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"Change state");
    UIStoryboard *welcomeStoryboard = [UIStoryboard storyboardWithName:@"welcomeStoryboard" bundle: nil];
    UINavigationController *navController = (UINavigationController*)[welcomeStoryboard instantiateViewControllerWithIdentifier:@"LoginNavController"];
    
    switch (state) {
        case FBSessionStateOpen:
        {
            NSLog(@"FBSessionStateOpen");
            
            UIViewController *rootViewController = (id) self.window.rootViewController;
            
            if ([[rootViewController presentedViewController] isKindOfClass:[LoginViewController class]]){
                [[rootViewController presentedViewController] dismissViewControllerAnimated:NO completion:nil];
            }
        }
            break;
        case FBSessionStateClosed:
        {
            NSLog(@"FBSessionStateClosed");
        }
        case FBSessionStateClosedLoginFailed:
        {
            NSLog(@"FBSessionStateClosedLoginFailed");
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
        }
            break;
        default:
        {
            NSLog(@"FBDefault");
        }
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
         NSLog(@"session = %@", session);
         NSLog(@"state = %u", state);
         NSLog(@"error = %@", error);
         [self FbDidLogin];
     }];
}

- (void)FbDidLogin {
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error) {
        if (!error) {
            
            [[NSUserDefaults standardUserDefaults] setObject:user.id forKey:@"facebookId"];
            [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"facebookName"];
            
            NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
            NSLog(@"%@", fbAccessToken);
            
            [[AuthAPIClient sharedClient] getPath:[NSString stringWithFormat:@"app/get/token?facebook_access_token=%@", fbAccessToken]
                                       parameters:nil
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSError * error = nil;
                                              NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                              NSLog(@"response: %@",response);
                                              NSString *authToken = [response objectForKey:@"access_token"];
                                              CredentialStore *store = [[CredentialStore alloc] init];
                                              [store setAuthToken:authToken];
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                                              
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              NSLog(@"error: %@", error);
                                          }];
        }
    }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

// refresh authentication token with refresh token, if refresh token expired then send login view (tbc)

-(void) refreshAuthToken {
    
    CredentialStore *store = [[CredentialStore alloc] init];
    NSString *refreshToken = [store refreshToken];
    
    [[AuthAPIClient sharedClient] getPath:[NSString stringWithFormat:@"oauth/v2/token?client_id=9_2yfw4otqwgo4w4wc488gggsg4c0gk4gco8g00c48ggkwowk44w&client_secret=4miogk8bd56oo444kkk0gk4os4o0wwkks4osksws4o8k8wkw0c&grant_type=refresh_token&refresh_token=%@", refreshToken]
                               parameters:nil
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      NSError * error = nil;
                                      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                      
                                      NSLog(@"response: %@",response);
                                      NSString *authToken = [response objectForKey:@"access_token"];
                                      NSString *refreshToken = [response objectForKey:@"refresh_token"];
                                      CredentialStore *store = [[CredentialStore alloc] init];
                                      [store setAuthToken:authToken];
                                      [store setRefreshToken:refreshToken];
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                                      
                                      UIViewController *rootViewController = (id) self.window.rootViewController;
                                      
                                      if ([[rootViewController presentedViewController] isKindOfClass:[LoginViewController class]]){
                                          [[rootViewController presentedViewController] dismissViewControllerAnimated:NO completion:nil];
                                      }
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"error: %@", error);
                                  }];
}


@end
