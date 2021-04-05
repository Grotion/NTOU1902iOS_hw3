//
//  ntou1902iOS_hw3App.swift
//  ntou1902iOS_hw3
//
//  Created by Shaun Ku on 2021/3/31.
//

import SwiftUI

@main
struct ntou1902iOS_hw3App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            PageControl()
        }
    }
}
