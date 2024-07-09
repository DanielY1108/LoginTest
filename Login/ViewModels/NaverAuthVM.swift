//
//  NaverAuthVM.swift
//  Login
//
//  Created by JINSEOK on 7/5/24.
//

import UIKit
import NaverThirdPartyLogin
import Alamofire


class NaverAuthVM: NSObject {
    
    override init() {
        super.init()
        instance?.delegate = self
    }
    
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    func login() {
        instance?.requestThirdPartyLogin()
    }
    
    func logout() {
        instance?.requestDeleteToken()
    }
    
    func getNaverInfo() {
        guard let isVaildAccessToken = instance?.isValidAccessTokenExpireTimeNow() else { return }
        guard isVaildAccessToken else { return }
        
        guard let tokenType = instance?.tokenType,
              let accessToken = instance?.accessToken else { return }
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        guard let url = URL(string: urlStr) else { return }
        
        let req = AF.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: JSONEncoding.default,
                             headers: ["Authorization": authorization])
        
        req.responseDecodable(of: NaverUserModel.self) { response in
            
            switch response.result {
            case .success(let model):
                let resultCode = model.resultCode
                let message = model.message
                let value = model.value
                
                print("Result Code: \(resultCode), Message: \(message)")
                
                let email = value.email
                let nickname = value.nickname
                let age = value.age
                let gender = value.gender
                let id = value.id
                let name = value.name
                let birthday = value.birthday
                let birthyear = value.birthyear
                let mobile = value.mobile
                let profileImage = value.profileImage
                
                print("이메일: \(email)")
                print("닉네임: \(nickname)")
                print("이름: \(name)")
                print("나이: \(age)")
                print("성별: \(gender)")
                print("아이디: \(id)")
                print("생일: \(birthday)\(birthyear)")
                print("휴대폰: \(mobile)")
                
            
            case .failure(let error):
                print(error)
            }
        }
            
    }
}

extension NaverAuthVM: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 연동 해제 성공")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: (any Error)!) {
        print("에러 : \(error.localizedDescription)")
    }
    
    
}
