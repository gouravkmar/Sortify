//
//  SettingsView.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsData: SettingsViewModel
    var body: some View {
        Form {
            Section(header: Text("ANIMATION")) {
                Toggle(isOn: $settingsData.isAnimationEnabled) {
                    Text("Enabled")
                }
                HStack{
                    Text("Duration")
                    Slider(value: $settingsData.duration, in: 0...1)
                    Text("\(Int(settingsData.duration*1000))")
                }
                
            }
            Section(header: Text("DISPLAY")) {
                Toggle(isOn: $settingsData.isShowTimer) {
                    Text("Show Timer")
                }
                Toggle(isOn: $settingsData.isShowBarValue) {
                    Text("Show Bar Values")
                }
            }
            Section(header: Text("DATA SET")) {
                HStack{
                    Text("Type")
                    Slider(value: $settingsData.arrSize, in: 10...100)
                    Text("\(Int(settingsData.arrSize))")
                }
                
            }
        }
    }
}

//#Preview {
//    SettingsView(settingsData: <#Binding<SettingsViewModel>#>)
//}
