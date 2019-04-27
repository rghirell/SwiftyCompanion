//
//  TokenGenerator.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/12/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import Foundation
import p2_OAuth2

protocol SetUserInfosDelegate {
    func setUserInfos(token: String)
    func fetchInfos()
}

class APIController {
    var oauth2: OAuth2!

    init?() {
        let success = self.authorizeUser()
        if !success { return nil }
    }

    private func authorizeUser() -> Bool {
        let dispatchGroup = DispatchGroup()
        var result = false
        oauth2 = OAuth2ClientCredentials(settings: [
            "client_id": "KEY",
            "client_secret": "KEY",
            "token_uri": "https://api.intra.42.fr/oauth/token",
            ] as OAuth2JSON)
        oauth2.verbose = true
        dispatchGroup.enter()
        oauth2.authorize() { authParameters, error in
            if let params = authParameters {
                print(self.oauth2.accessToken)
                print("Authorized! Access token is in `oauth2.accessToken`")
                print("Authorized! Additional parameters: \(params)")
                result = true
                dispatchGroup.leave()
            }
            else {
                print("Authorization was canceled or went wrong: \(error)")
                dispatchGroup.leave()
                result = false
            }
        }
        return result
    }
}
