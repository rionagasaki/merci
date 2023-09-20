//
//  JoinMeetingResponse.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/18.
//

import Foundation

struct CreateMediaPlacementInfo: Codable {
    var audioFallbackUrl: String?
    var audioHostUrl: String
    var signalingUrl: String
    var turnControlUrl: String?
    var eventIngestionUrl: String?

    enum CodingKeys: String, CodingKey {
        case audioFallbackUrl = "AudioFallbackUrl"
        case audioHostUrl = "AudioHostUrl"
        case signalingUrl = "SignalingUrl"
        case turnControlUrl = "TurnControlUrl"
        case eventIngestionUrl = "EventIngestionUrl"
    }
}

struct CreateMeetingInfo: Codable {
    var externalMeetingId: String?
    var primaryMeetingId: String?
    var mediaPlacement: CreateMediaPlacementInfo
    var mediaRegion: String
    var meetingId: String

    enum CodingKeys: String, CodingKey {
        case externalMeetingId = "ExternalMeetingId"
        case primaryMeetingId = "PrimaryMeetingId"
        case mediaPlacement = "MediaPlacement"
        case mediaRegion = "MediaRegion"
        case meetingId = "MeetingId"
    }
}

struct CreateAttendeeInfo: Codable {
    var attendeeId: String
    var externalUserId: String
    var joinToken: String

    enum CodingKeys: String, CodingKey {
        case attendeeId = "AttendeeId"
        case externalUserId = "ExternalUserId"
        case joinToken = "JoinToken"
    }
}

struct CreateMeeting: Codable {
    var meetingInfo: CreateMeetingInfo

    enum CodingKeys: String, CodingKey {
        case meetingInfo = "Meeting"
    }
}

struct CreateAttendee: Codable {
    var attendeeInfo: CreateAttendeeInfo

    enum CodingKeys: String, CodingKey {
        case attendeeInfo = "Attendee"
    }
}

struct JoinMeetingResponse: Codable {
    var meeting: CreateMeeting
    var attendee: CreateAttendee
}
