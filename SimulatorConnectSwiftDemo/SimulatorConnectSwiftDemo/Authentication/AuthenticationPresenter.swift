//
//  AuthenticationPresenter.swift
//  SimulatorConnectSwiftDemo
//
//  Created by Chad Godsey on 5/18/21.
//

import Foundation
import AuthenticationServices


class AuthenticationPresenter : NSObject {
    static public let shared = AuthenticationPresenter()
    
    // MARK: Constants
    static let authUrl = "https://fsg-api.auth.us-east-1.amazoncognito.com/login"
    static let scope = "openid"
    static let responseType = "token"
    static let redirectURLEndpoint = "oauth2redirect"
    static let callbackURLScheme = "simulatorconnect"
    static let clientID = "7ni0kpg1n7esk9l3cnldktt0d1"
    
    public func showSignIn(completion: @escaping((String?, Error?) -> Void))
    {
        // Use the URL and callback scheme specified by the authorization provider.
        guard let authURL = URL(string: "\(AuthenticationPresenter.authUrl)?scope=\(AuthenticationPresenter.scope)&response_type=\(AuthenticationPresenter.responseType)&client_id=\(AuthenticationPresenter.clientID)&redirect_uri=\(AuthenticationPresenter.callbackURLScheme):/\(AuthenticationPresenter.redirectURLEndpoint)") else { return }

        // Initialize the session.
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: AuthenticationPresenter.callbackURLScheme)
        { callbackURL, error in
            // Handle the callback.
            guard error == nil, let callbackURL = callbackURL else { return }

            // The callback URL format depends on the provider. For this example:
            //   exampleauth://auth?token=1234
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            let code = queryItems?.filter({ $0.name == "code" }).first?.value
            print("Got code \(String(describing: code))")
            completion(code, nil)
        }
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        if !session.start() {
          print("Failed to start ASWebAuthenticationSession")
        }
        
    }
}


extension AuthenticationPresenter: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
