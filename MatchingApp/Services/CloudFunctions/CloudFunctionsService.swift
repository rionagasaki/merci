//
//  CloudFunctionsService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/17.
//

import Foundation
import Combine

protocol CloudFunctionsService {
    // get strat call channel
    func onCall<T: CloudFunctionsModelable>(_ model: T, completionHandler: @escaping (Result<T.Response, AppError>) -> Void)
    
    // delete call channel
    func onCallWithNoResp<T: NoRespCloudFunctionsModelable>(_ model: T, completionHandler: @escaping (Result<Void, AppError>) -> Void)
}
