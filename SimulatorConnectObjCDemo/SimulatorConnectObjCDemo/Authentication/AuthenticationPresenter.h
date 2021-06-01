//
//  AuthenticationPresenter.h
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/18/21.
//

#ifndef AuthenticationPresenter_h
#define AuthenticationPresenter_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol AuthenticationDelegate <NSObject>
@optional

/// authSuccess: Called when authorization complete and code is collected from remote server
/// @param code Authorization token to be passed to FSGConnect
-(void)authSuccess:(NSString*)code;

/// authFailure: Called when an error occurred
/// @param error Authorization error
-(void)authFailure:(NSError*)error;

@end

@interface AuthenticationPresenter : NSObject

/// Authorization token
@property (strong, nonatomic) NSString *authCode;

/// Object implementing the AthenticationDelegate protocol
@property (nonatomic) id<AuthenticationDelegate> delegate;

/// Show sign in view.  Will show a popover from AuthenticationServices Web Login to allow the user to log in to their account.
/// @param viewController A valid view controller object that implements the ASWebAuthenticationPresentationContextProviding protocol
- (void)showSignin:(UIViewController*) viewController;

@end


#endif /* AuthenticationPresenter_h */
