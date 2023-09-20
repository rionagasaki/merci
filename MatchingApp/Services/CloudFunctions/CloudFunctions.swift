//
//  FetchToken.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/05.
//

import Foundation
import FirebaseFunctions
import Combine
import AmazonChimeSDK

class CloudFunctions: CloudFunctionsService  {
    lazy private var functions = Functions.functions()
    
    func onCall<T: CloudFunctionsModelable>(_ model: T, completionHandler: @escaping(Result<T.Response, AppError>) -> Void) {
        
        self.functions.httpsCallable(model.functionsName).call(model.requestParams) { result, error in
            if let error = error as NSError? {
                print(error)
                completionHandler(.failure(.firestore(error)))
                return
            }
            
            guard let data = result?.data as? [String: Any] else {
                completionHandler(.failure(.other(.unexpectedError)))
                return
            }
            
            let jsonData: Data
            
            do {
                jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            } catch {
                completionHandler(.failure(.other(.unexpectedError)))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(T.Response.self, from: jsonData)
                completionHandler(.success(response))
            } catch {
                print(error)
                completionHandler(.failure(.firestore(error)))
            }
        }
    }
    
    func onCallWithNoResp<T: NoRespCloudFunctionsModelable>(_ model: T, completionHandler: @escaping (Result<Void, AppError>) -> Void) {
        self.functions.httpsCallable(model.functionsName).call(model.requestParams) { result, error in
            if let error = error as NSError? {
                print(error)
                completionHandler(.failure(.firestore(error)))
                return
            }
            completionHandler(.success(()))
        }
    }
    
    static func getCreateMeetingResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateMeetingResponse {
        let meeting = joinMeetingResponse.meeting.meetingInfo
        let meetingResp = CreateMeetingResponse(meeting:
                                                    Meeting(
                                                        externalMeetingId: meeting.externalMeetingId,
                                                        mediaPlacement: MediaPlacement(
                                                            audioFallbackUrl: meeting.mediaPlacement.audioFallbackUrl ?? "",
                                                            audioHostUrl: meeting.mediaPlacement.audioHostUrl,
                                                            signalingUrl: meeting.mediaPlacement.signalingUrl,
                                                            turnControlUrl: meeting.mediaPlacement.turnControlUrl ?? "",
                                                            eventIngestionUrl: meeting.mediaPlacement.eventIngestionUrl
                                                        ),
                                                        mediaRegion: meeting.mediaRegion,
                                                        meetingId: meeting.meetingId,
                                                        primaryMeetingId: meeting.primaryMeetingId
                                                    )
        )
        return meetingResp
    }
    
    static func getCreateAttendeeResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateAttendeeResponse {
        let attendee = joinMeetingResponse.attendee.attendeeInfo
        let attendeeResp = CreateAttendeeResponse(attendee:
                                                    Attendee(attendeeId: attendee.attendeeId,
                                                             externalUserId: attendee.externalUserId,
                                                             joinToken: attendee.joinToken)
        )
        return attendeeResp
    }
}

