//
//  NaverUserModel.swift
//  Login
//
//  Created by JINSEOK on 7/9/24.
//

import Foundation

struct NaverUserModel: Codable {
    let resultCode: String
    let message: String
    let value: NaverUserInfo
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "resultcode"
        case value = "response"
        case message
    }
}

struct NaverUserInfo: Codable {
    let email: String
    let nickname: String
    let profileImage: String
    let age: String
    let gender: String
    let id: String
    let name: String
    let birthday: String
    let birthyear: String
    let mobile: String
    
    enum CodingKeys: String, CodingKey {
        case email, nickname, age, gender, id, name, birthday, birthyear, mobile
        case profileImage = "profile_image"
    }
}
