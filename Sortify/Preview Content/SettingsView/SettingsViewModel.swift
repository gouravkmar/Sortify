//
//  Se.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//
import Foundation

class SettingsViewModel: ObservableObject{
    
    @Published var isAnimationEnabled = true
    @Published var duration: Float = 0.5
    @Published var isShowTimer: Bool = true
    @Published var isShowBarValue: Bool = true
    @Published var arrSize: Float = 50

    
}
