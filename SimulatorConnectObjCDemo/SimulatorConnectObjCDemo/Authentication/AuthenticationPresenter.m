//
//  AuthenticationPresenter.m
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/18/21.
//

#import "AuthenticationPresenter.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface AuthenticationPresenter ()

@property ASWebAuthenticationSession *authSessionAS;

@end


@implementation AuthenticationPresenter

static NSString *authUrl = @"https://fsg-api.auth.us-east-1.amazoncognito.com/login";
static NSString *scope = @"openid";
static NSString *responseType = @"token";
static NSString *redirectURLEndpoint = @"oauth2redirect";
static NSString *callbackURLScheme = @"simulatorconnect";
static NSString *clientID = @"7ni0kpg1n7esk9l3cnldktt0d1";

@synthesize delegate;
@synthesize authCode;

- (void)showSignin:(UIViewController*) viewController {
    NSString *requestUrl = [NSString stringWithFormat:@"%@?scope=%@&response_type=%@&client_id=%@&redirect_uri=%@:/%@",
                            authUrl, scope, responseType, clientID, callbackURLScheme, redirectURLEndpoint];
    self.authSessionAS = [[ASWebAuthenticationSession alloc]initWithURL:[[NSURL alloc] initWithString:requestUrl]
                                                      callbackURLScheme:callbackURLScheme
                                                      completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
        if (error)
        {
            NSLog([error debugDescription]);
            if (self->delegate)
            {
                [self->delegate authFailure:error];
            }
        }
        
        if (callbackURL)
        {
            self.authCode = callbackURL.absoluteString;
        }else
        {
            self.authCode = @"";
        }
        if (self->delegate)
        {
            [self->delegate authSuccess:self.authCode];
        }
    }];

    self.authSessionAS.presentationContextProvider = viewController;
    self.authSessionAS.prefersEphemeralWebBrowserSession = true;
    [self.authSessionAS start];
}

@end
