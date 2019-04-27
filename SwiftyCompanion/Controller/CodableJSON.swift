//
//  File.swift
//  SwiftyCompanion
//
//  Created by Raphael GHIRELLI on 6/12/18.
//  Copyright © 2018 Raphael GHIRELLI. All rights reserved.
//

import Foundation

struct Token: Codable {
    let access_token: String
    let expires_in: Int
}

struct TokenExpiration: Codable {
    let expires_in_seconds: Int
}

struct Coalitions: Codable {
    let id: Int?
}

struct Student: Codable {
    let login: String?
    let correction_point: Int?
    let image_url: String?
    let displayname: String?
    let phone: String?
    let cursus_users: [Cursus]?
    let projects_users: [ProjectUser]?
    let location: String?
    let email: String?
}

struct Cursus: Codable {
    let grade: String?
    let level: Double?
    let has_coalition: Bool?
    let skills: [Skills]?
    let cursus_id: Int?
}

struct Skills: Codable {
    let name: String?
    let level: Double?
}

struct ProjectUser: Codable {
    let final_mark: Int?
    let validated: Bool?
    let project: Project?
    let cursus_ids: [Int?]
    enum CodingKeys: String, CodingKey {
        case final_mark
        case validated = "validated?"
        case project
        case cursus_ids
    }
}

struct LogTime: Codable {
    let end_at: String?
    let begin_at: String?
}

struct Project: Codable {
    let name: String?
    
    let parent_id: Int?
    let slug: String?
}
