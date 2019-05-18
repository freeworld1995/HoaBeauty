//
//  GAuthorizer.swift
//  GoogleDrive-swift
//
//  Created by Luan's on 9/9/18.
//  Copyright © 2018 com.luan. All rights reserved.
//

import AppAuth
import GTMAppAuth

// Replace this by whatever logging framework you prefer:
//import XCGLogger
//let log = XCGLogger.default

/// The configuration I normally define separately.
struct Config {
    static let GoogleAuthClientID       = "348416555453-r2kkb71q1lomkr6fcoo3qg32faa5bb4i.apps.googleusercontent.com"
    static let GoogleAuthOIDCIssuer     = "https://accounts.google.com"
    static let GoogleAuthRedirectURI    = "com.googleusercontent.apps.348416555453-r2kkb71q1lomkr6fcoo3qg32faa5bb4i:/oauthredirect"
}

class GAuthorizer: NSObject, OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {
    
    // I usually define this somewhere central...
    static let KeychainPrefix   = "com.minhcong.fca1"  // REPLACE this with anything.
    static let KeychainItemName = KeychainPrefix + "GoogleAuthorization"
    
    static private var singleton: GAuthorizer?
    static var shared: GAuthorizer {
        if singleton == nil {
            singleton = GAuthorizer()
        }
        return singleton!
    }
    
    // To be set by any user of this object, if they want to be informed about an authorization result. Good, in particular, to take the newly adjusted authorizer and set it in whatever service one is doing the authorization for.
    var authorizationCompletion: ((Bool) -> Void)?
    // The entity that, for example, the Google Drive service needs to do its jobs.
    private(set) var authorization: GTMAppAuthFetcherAuthorization? = nil
    // The callback hook for authorization after app reentry in AppDelegate, used and reset in continueAuthorization(with).
    private var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    private var scopes = [OIDScopeOpenID, OIDScopeProfile]
    
    
    private override init() {
        super.init()
    }
    
    
    /// Adds another aspect for which to authorize for to the base set of scopes (which are: OIDScopeOpenID, OIDScopeProfile).
    /// Example: Add `kGTLAuthScopeDriveFile` to authorize for: 'Create new files and access just these files in the user's Google Drive account'. (Requires the Google Drive framework, too. The variable is from GTLDriveConstants.h in there.)
    func addScope(_ scope: String) {
        if scopes.index(of: scope) == nil {
            scopes.append(scope)
        }
    }
    
    
    // To be called to initiate authorization, for instance, following a button tap in the UI. The `authWithAutoCodeExchange` from the GTMAppAuth Objective-C example.
    func authorize(in presentingViewController: UIViewController, authorizationCompletion: @escaping ((Bool) -> Void)) {
        let issuer = URL(string: Config.GoogleAuthOIDCIssuer)!
        let redirectURI = URL(string: Config.GoogleAuthRedirectURI)!
        
        // discovers endpoints
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) {
            (configuration: OIDServiceConfiguration?, error: Error?) in
            
            if configuration == nil {
                self.setAuthorization(nil)
                return
            }
            
            // builds authentication request
            let request: OIDAuthorizationRequest = OIDAuthorizationRequest(configuration: configuration!, clientId: Config.GoogleAuthClientID, scopes: self.scopes, redirectURL: redirectURI, responseType: OIDResponseTypeCode, additionalParameters: nil)
            // (The 'kGTLAuthScopeDriveFile' is from GTLDriveConstants.h and just an attempt to add GDrive file access to the authorization scope...)
            
            // performs authentication request
            //            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            // (Swift can't extend AppDelegate by a var. So, let's keep things simple and use a global variable instead.)
            
            self.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: presentingViewController) {
                (authState: OIDAuthState?, error: Error?) in
                if let authState = authState {
                    let authorization: GTMAppAuthFetcherAuthorization = GTMAppAuthFetcherAuthorization(authState: authState)
                    self.setAuthorization(authorization)
                    authorizationCompletion(true)
                } else {
                    self.setAuthorization(nil)
                    authorizationCompletion(false)
                }
            }
        }
    }
    
    
    
    /// Returns true, iff the give URL matched a Google authorization flow in progress and was consumed properly.
    func continueAuthorization(with url: URL) -> Bool {
        if let authFlow = currentAuthorizationFlow {
            //            guard let viewController = Global.athletesViewController else {
            //                log.warning("URL callback from Google with no view controller to return to set!?? Ignoring the callback...")
            //                return false
            //            }
            //            log.debug("..the view controller to report on the result is there...")
            if authFlow.resumeAuthorizationFlow(with: url) {
                // IMPORTANT: Notice that, if the given URL is right for us here, but authentication fails or is negative, then authState::didEncounterAuthorizationError should be called internally...
                currentAuthorizationFlow = nil
                if let completion = authorizationCompletion {
                    completion(true)
                }
            } else {
                // ..we'll not end up here in this case!
                //log.info("Google authorization failed somehow, or the callback was no authorization in progress")
                //viewController.reportExportSuccess(forOption: .googleDrive, success: false) -- Wrong!
            }
            return true
        } else {
            return false
        }
        
    }
    
    /// Preserves the current authorization state both in memory and keychain.
    private func setAuthorization(_ authorization: GTMAppAuthFetcherAuthorization?) {
        if self.authorization == nil || !self.authorization!.isEqual(authorization) {
            self.authorization = authorization
            saveState()
        }
    }
    
    func isAuthorized() -> Bool {
        if let auth = authorization {
            return auth.canAuthorize()
        } else {
            return false
        }
    }
    
    
    // Used internally to save the current authorization state.
    private func saveState() {
        assert(authorization != nil)
        let keychainItemName = GAuthorizer.KeychainItemName
        if authorization!.canAuthorize() {
            GTMAppAuthFetcherAuthorization.save(authorization!, toKeychainForName: keychainItemName)
        } else {
            GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: keychainItemName)
        }
    }
    
    /// To be used in particular to load the initial authorization state on app start.
    func loadState() {
        let keychainItemName = GAuthorizer.KeychainItemName
        if let authorization: GTMAppAuthFetcherAuthorization = GTMAppAuthFetcherAuthorization(fromKeychainForName: keychainItemName) {
            setAuthorization(authorization)
        }
    }
    
    /// Clears the keychain from any Google authorization data. This is useful, for example, after an app reinstallation or for testing where an outdated authorization state can cause trouble or prevent certain tests from going through.
    func resetState() {
        GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: GAuthorizer.KeychainItemName)
        // As keychain and cached authorization token are meant to be in sync, we also have to:
        setAuthorization(nil)
    }
    
    
    // MARK: - OIDAuthStateChangeDelegate
    
    func didChange(_ state: OIDAuthState) {
        // (..whatever the significance of this. Are we supposed to do something with this information?)
    }
    
    
    // MARK: - OIDAuthStateErrorDelegate
    
    // This seems to be the hook being called when authentication, especially after the URL callback from outside, fails. Notice that the `resumeAuthorizationFlow` function that lets us try to finish authorization, doesn't let us distinguish between failed and wasn't-a-URL-for-us otherwise!
    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
        if currentAuthorizationFlow != nil {
            // Looks like there is an authorization in progress... which failed.
            currentAuthorizationFlow = nil
            // We are not authorized anymore this says, right!? So...
            setAuthorization(nil)
            if let completion = authorizationCompletion {
                completion(false)
            }
        }
    }
    
}
