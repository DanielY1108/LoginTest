//
//  ViewController.swift
//  Login
//
//  Created by JINSEOK on 7/1/24.
//

import UIKit
import FlexLayout
import PinLayout
// 로그인 기능을 위한 프레임워크
import AuthenticationServices
import Combine

class LoginViewController: UIViewController {
    
    // MARK: - Private Properties
    var cancellables = Set<AnyCancellable>()
    
    private let containerView = UIView()
    
    // 애플에서 기본적으로 제공하는 로그인 버튼 클래스
    private let appleSignInButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
    
    private let kakaoLoingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "카카오 로그인 여부"
        return label
    }()
    
//    private let kakaoLoginButton: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.title = "카카오 로그인"
//        config.baseBackgroundColor = .systemYellow
//        config.baseForegroundColor = .black
//        
//        let button = UIButton(configuration: config)
//        return button
//    }()
//    
//    private let kakaoLogOutButton: UIButton = {
//        var config = UIButton.Configuration.filled()
//        config.title = "카카오 로그아웃"
//        config.baseBackgroundColor = .systemYellow
//        config.baseForegroundColor = .black
//        
//        let button = UIButton(configuration: config)
//        return button
//    }()
//    
    private lazy var kakaoButton = { (_ title: String, _ action: Selector, image: UIImage?) -> UIButton in
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = image
        config.baseBackgroundColor = UIColor(red: 254, green: 229, blue: 0, alpha: 1)
        config.baseForegroundColor = .black
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    lazy var appleAuthVM: AppleAutoVM = { AppleAutoVM() }()
    lazy var kakaoAuthVM: KakaoAuthVM = { KakaoAuthVM() }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configLayout()
    }
    
    
    // MARK: - Helpers
    private func configUI() {
        
        containerView.backgroundColor = .systemBackground
        view.addSubview(containerView)
        
        // 버튼이기 때문에 addTarget을 통해 핸들러와 연결해 줍시다.
        appleSignInButton.addTarget(self, action: #selector(didTapAppleSignIn), for: .touchUpInside)
        
        let kakaoLoginButton = kakaoButton("", #selector(didTapKakaoLogin), UIImage(named: "kakao"))
        let kakaoLogoutButton = kakaoButton("로그아웃 버튼", #selector(didTapKakaoLogout), nil)
        let kakaoUnlink = kakaoButton("언링크 버튼", #selector(didTapKakaoUnlink), nil)
        let kakaoUserInfo = kakaoButton("유저 정보 버튼", #selector(didTapKakaoUserInfo), nil)
        
        containerView.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define {
                $0.addItem(appleSignInButton)
                    .width(view.frame.width-100)
                    .height(40)
                    .margin(30)
                $0.addItem(kakaoLoingLabel)
                $0.addItem(kakaoLoginButton)
                    .width(view.frame.width-100)
                    .height(40)
                    .margin(10)
                $0.addItem(kakaoLogoutButton)
                    .width(view.frame.width-100)
                    .height(40)
                $0.addItem(kakaoUnlink)
                    .width(view.frame.width-100)
                    .margin(10)
                    .height(40)
                $0.addItem(kakaoUserInfo)
                    .width(view.frame.width-100)
                    .height(40)
            }
    }
    
    private func configLayout() {
        containerView.pin.all()
        containerView.flex.layout()
    }
    
  
    
    
    // MARK: - Actions
    @objc func didTapAppleSignIn() {
        print("LoginVC - didTapAppleSignIn() called")
        
        appleAuthVM.setupAppleLoing()
    }
    
    @objc func didTapKakaoLogin() {
        print("LoginVC - didTapKakaoLogin() called")
        
        kakaoAuthVM.KakaoLogin()
        
    }
    
    @objc func didTapKakaoLogout() {
        print("LoginVC - didTapKakaoLogout() called")
        
        kakaoAuthVM.kakaoLogout()
    }
    
    @objc func didTapKakaoUnlink() {
        print("LoginVC - didTapKakaoUnlink() called")
        
        kakaoAuthVM.kakaoUnlink()
    }
    
    @objc func didTapKakaoUserInfo() {
        print("LoginVC - didTapKakaoUserInfo() called")
        
        kakaoAuthVM.getUserInfo()
    }
}


// MARK: - Extensions

// MARK: - 뷰모델 바인딩
extension LoginViewController {
    fileprivate func setBindings() {
//        self.kakaoAuthVM.$isLoggedIn.sink { [weak self] isLoggdIn in
//            guard let self = self else { return }
//            
//            self.kakaoLoingLabel.text = isLoggdIn ? "로그인 상태 " : "로그아웃 상태"
//        }
//        .store(in: &subscriptions)
        
        self.kakaoAuthVM.loginStatusInfo
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: kakaoLoingLabel)
            .store(in: &cancellables)
        
        self.appleAuthVM.$longSucces
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loginSucces in
            if loginSucces {
                let mainVC = MainViewController()
                mainVC.modalPresentationStyle = .fullScreen
                self?.present(mainVC, animated: true)
            }
        }.store(in: &cancellables)
    }
    
    
}

// MARK: - 애플 로그인




// MARK: - PreView
import SwiftUI

#if DEBUG
struct PreView: PreviewProvider {
    static var previews: some View {
        // 사용할 뷰 컨트롤러를 넣어주세요
        LoginViewController()
            .toPreview()
    }
}
#endif

