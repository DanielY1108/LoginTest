//
//  AppDelegate.swift
//  Login
//
//  Created by JINSEOK on 7/1/24.
//

import UIKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let kakaoNativeAppKey = Helper.getBundelValue("KAKAO_NATIVE_APP_KEY")
        
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        setupNaverLogin()

         return true
    }
    
    func setupNaverLogin() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        // 네이버 앱으로 인증하는 방식 활성화(true)
        instance?.isNaverAppOauthEnable = true
        // SafariViewContoller에서 인증하는 방식 활성화(true)
        instance?.isInAppOauthEnable = true
        // 인증 화면을 iPhone의 세로 모드에서만 활성화(true)
        instance?.setOnlyPortraitSupportInIphone(true)
        
        // 로그인 설정
        instance?.serviceUrlScheme = Helper.getBundelValue("NAVER_SERVICE_URL_SCHEME")
        instance?.consumerKey = Helper.getBundelValue("NAVER_CONSUMERKEY")
        instance?.consumerSecret = Helper.getBundelValue("NAVER_CONSUMER_SECRET")
        instance?.appName = Helper.getBundelValue("NAVER_APP_NAME")
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
    }
    
    // 카카오톡으로부터 받은 URL인지 확인하고 웹뷰를 여는 형식
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if (AuthApi.isKakaoTalkLoginUrl(url)) {
//            return AuthController.handleOpenUrl(url: url)
//        }
//
//        return false
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

