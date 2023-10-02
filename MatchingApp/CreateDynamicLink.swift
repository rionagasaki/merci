//
//  CreateDynamicLink.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/29.
//

import Foundation
import FirebaseDynamicLinks

class DynamicLink {
    func createDynamicLink(completionHandler: @escaping (Result<URL, AppError>)->Void){
        var component = URLComponents()
        component.scheme = "https"
        component.host = "matchingapp.site"
        component.path = "/"
        
        guard let linkParameter = component.url else { return }
        
        let domain = "https://matchingapp.page.link"
        
        guard let linkBuilder = DynamicLinkComponents(
            link: linkParameter,
            domainURIPrefix: domain
        ) else { return }
        
        if let myBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
        }
        linkBuilder.iOSParameters?.appStoreID = "6450633838"
        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title =  "merci"
        linkBuilder.socialMetaTagParameters?.descriptionText = "匿名お悩み通話、チャット"
        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/matchingapp-b77af.appspot.com/o/Group%2027.png?alt=media&token=99f34185-72a4-4cb5-9ac5-a8a2faffc4c8&_gl=1*vnlxhl*_ga*NjA2OTAyNTEyLjE2OTU1MzkwOTI.*_ga_CW55HF8NVT*MTY5NTk5OTA2NC4yOC4xLjE2OTU5OTkxMzIuNjAuMC4w")
        
        guard let longParam = linkBuilder.url else { return }
        
        linkBuilder.shorten { url, _, error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else if let url = url {
                completionHandler(.success(url))
            }
        }
    }
}
