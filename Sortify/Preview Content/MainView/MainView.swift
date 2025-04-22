//
//  MainView.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//

import SwiftUI
import Charts

struct MainView: View {
    @State var showSetting: Bool = false
    var body: some View {
        VStack{
            SettingHeader(showSetting: $showSetting)
            titleHeader
            pickerView()
            actionView
            TimeView()
            GraphView()
            Spacer()
        }.sheet(isPresented: $showSetting) {
            SettingsView()
        }
    }
}


struct SettingHeader: View {
    @Binding var showSetting: Bool
    var body: some View {
        HStack{
            Spacer()
            Button {
                showSetting = true
            } label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.horizontal)
            }
            
        }
    }
    
}
var titleHeader: some View {
    HStack{
        Text("Sorting Visualizer")
            .font(.title)
            .fontWeight(.bold)
        Spacer()
    }
    .padding()
}
struct pickerView: View {
    @State var selectedAlgo: Algorithms = .bubble
    var body: some View {
        HStack{
            Picker("Select Algorithm", selection: $selectedAlgo) {
                ForEach(Algorithms.allCases) { algo in
                    Text(algo.rawValue).tag(algo)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

var actionView: some View {
    HStack(alignment: .center, spacing: 60)
    {
        Button("Sort!", action: {
            
        })
        Button("Reset", action: {
            
        })
        Button("Cancel", action: {
            
        })
        .disabled(true)
        
    }.padding()
}
struct TimeView: View {
    @State var time: Float = 1.45
    var body: some View {
        Text("Time: \(Int(time*1000)) ms")
    }
}

enum Algorithms : String , CaseIterable , Identifiable {
    var id : String {
        return self.rawValue
    }
    case bubble = "Bubble sort"
    case selection = "Selection sort"
    case insertion = "Insertion sort"
    case merge = "Merge sort"
}

#Preview {
    MainView()
}
