//
//  MainView.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//

import SwiftUI
import Charts

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        ScrollView{
            LazyVStack{
                SettingHeader(showSetting: $viewModel.isShowSetting)
                titleHeader
                pickerView(selectedAlgo: $viewModel.algo)
                actionView
                TimeView
                GraphView(graphData: viewModel.graphData)
                Spacer()
            }.sheet(isPresented: $viewModel.isShowSetting) {
                SettingsView(settingsData: viewModel.settingData)
            }.onChange(of: viewModel.isShowSetting) { oldValue, newValue in
                if(!newValue){
                    viewModel.reset()
                }
            }
        }
    }
    
    var actionView: some View{
        HStack(alignment: .center, spacing: 60)
        {
            Button("Sort!", action: {
                viewModel.startSorting()
            })
            .disabled(viewModel.isRunning)
            Button("Reset", action: {
                if(!viewModel.isRunning){
                    viewModel.reset()
                }
                
            })
            .disabled(viewModel.isRunning)
            Button("Cancel", action: {
                viewModel.stopSorting()
            })
            .disabled(!viewModel.isRunning)
            
        }.padding()
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
    var TimeView: some View {
        Text("Time: \(viewModel.time) ms")
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

struct pickerView: View {
    @Binding var selectedAlgo: Algorithms
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
    MainView(viewModel: MainViewModel())
}
