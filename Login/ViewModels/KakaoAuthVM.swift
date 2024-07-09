//
//  KakaoAuthVM.swift
//  Login
//
//  Created by JINSEOK on 7/2/24.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

// 콤바인을 위해 ObservableObject
class KakaoAuthVM: ObservableObject {
    // 카카오톡 실행 가능 여부 확인
    
    // rx에서 disposeBag이랑 같은 원리 (메모리 처리)
    var cancellables = Set<AnyCancellable>()
    
    // 콤바인: 값의 변경이 일어나면 자동으로 업데이트 (원리는 wilset과 원리, rx의 옵저버블과 비슷)
    @Published var isLoggedIn: Bool = false
    
    lazy var loginStatusInfo: AnyPublisher<String?, Never> = $isLoggedIn.compactMap { $0 ? "카카오 로그인 성공" : "카카오 로그아웃" }.eraseToAnyPublisher()
    
    @MainActor // // 카카오 로그인은 UI를 건들이기 때문에, 메인쓰레이드에서 작동되게 어노테이션을 설정해 줌
    func kakaoLonginWithApp() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor // 카카오는 UI를 건들이기 때문에, 메인쓰레이드에서 작동되게 어노테이션을 설정해 줌
    func kakaoLoginWithAccount() async -> Bool {
        
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    
    func getUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                
                //do something
                let userName = user?.kakaoAccount?.name
                let userEmail = user?.kakaoAccount?.email
                let userProfile = user?.kakaoAccount?.profile?.profileImageUrl
                
                print("이름: \(userName)")
                print("이메일: \(userEmail)")
                print("프로필: \(userProfile)")
            }
        }
    }
    
    //     여기다 @MainActor를 사용하면 될 줄 알았는데, 알 수 없는 에러로 위에서 사용
    func KakaoLogin() {
        print("KakaoAuthVM - handelKakaoLogin() called")
        
        Task {
            // 카카오톡 실행 가능 여부 확인
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오톡 앱으로 로그인 인증
                isLoggedIn = await kakaoLonginWithApp()
            } else { // 카톡이 설치가 안 되어 있을 때
                // 카카오 계정으로 로그인
                isLoggedIn = await kakaoLoginWithAccount()
            }
        }
    }
    
    @MainActor // 카카오는 UI를 건들이기 때문에, 메인쓰레이드에서 작동되게 어노테이션을 설정해 줌
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                self.isLoggedIn = false
            }
        }
    }
    
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation { contineation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    contineation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    contineation.resume(returning: true)
                }
            }
        }
    }
    
    /// 연결 끊기
    func kakaoUnlink() {
        // 연결 끊기 요청 성공 시 로그아웃 처리가 함께 이뤄져 토큰이 삭제됩니다.
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
            }
        }
    }
}


