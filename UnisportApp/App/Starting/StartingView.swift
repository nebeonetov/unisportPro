//
//  StartingView.swift
//  UnisportApp
//
//  Created by D K on 17.04.2025.
//

import SwiftUI


struct StartingView: View {
    @StateObject private var viewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView()
                    .environmentObject(viewModel)
            } else {
                LoginView(viewModel: viewModel)
            }
        }

//        .onAppear {
//            AppDelegate.orientationLock = .portrait
//            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
//            UINavigationController.attemptRotationToDeviceOrientation()
//        }
    }
}
