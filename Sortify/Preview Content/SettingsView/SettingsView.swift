//
//  SettingsView.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//

import SwiftUI

struct SettingsView: View {
    @State var isAnimating: Bool = true
    @State var isShowTimer: Bool = true
    @State var isShowBar: Bool = true
    @State var sliderValue : Float  = 0.5
    @State var sampleSize: Float = 50.0
    var body: some View {
        Form {
            Section(header: Text("ANIMATION")) {
                Toggle(isOn: $isAnimating) {
                    Text("Enabled")
                }
                HStack{
                    Text("Duration")
                    Slider(value: $sliderValue, in: 0...1)
                    Text("\(Int(sliderValue*1000)) ms")
                }
                
            }
            Section(header: Text("DISPLAY")) {
                Toggle(isOn: $isShowTimer) {
                    Text("Show Timer")
                }
                Toggle(isOn: $isShowBar) {
                    Text("Show Bar Values")
                }
            }
            Section(header: Text("DATA SET")) {
                HStack{
                    Text("Type")
                    Slider(value: $sampleSize, in: 10...100)
                    Text("\(Int(sampleSize))")
                }
                
            }
        }
    }
}

#Preview {
    SettingsView()
}
