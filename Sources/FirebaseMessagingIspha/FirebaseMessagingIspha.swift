//
//  FirebaseMessaging.swift
//
//
//  Created by Vamsi Madduluri on 04/07/24.
//

import Foundation
import AsyncHTTPClient
@_exported import FirebaseAppIspha

public class FirebaseMessagingIspha {
    public static func getMessaging(app: FirebaseAppIspha = FirebaseAppIspha.app) throws -> MessagingClient {
        guard let serviceAccount = app.serviceAccount else {
            throw NSError(domain: "ServiceAccountError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Service Account is not initialized"])
        }
        let messagingClient = MessagingClient(serviceAccount: serviceAccount)
        return messagingClient
    }
}
