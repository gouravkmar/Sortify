//
//  MainViewModel.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//

import Foundation
import SwiftUICore

class GraphData: ObservableObject {
    @Published var startIndex: Int = 0
    @Published var endIndex: Int = 0
    @Published var array : [Int] = []
}
class MainViewModel: ObservableObject {
    @Published var algo: Algorithms = .bubble
    @Published var time: Int = 0
    @Published var isRunning: Bool = false
    @Published var isShowSetting: Bool = false
    @Published var settingData = SettingsViewModel()
    @Published var graphData = GraphData()
    private var timer : Timer?
    
    init() {
        generateRandomArray()
    }
    
    func startSorting() {
        isRunning = true
        startTimer()
        Task{
            switch algo {
            case .bubble:
                await bubbleSort()
            case .selection:
                await selectionSort()
            case .insertion:
                await insertionSort()
            case .merge:
                await mergeSort()
            }
            
        }
        
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    @objc func updateTime() {
        time += 10
    }
    
    func reset() {
        stopSorting()
        generateRandomArray()
        time = 0
    }
    func stopSorting() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    func generateRandomArray() {
        let size = Int(settingData.arrSize)
        let randomArray = (0..<size).map { _ in Int.random(in: 1...100) }
        graphData.array = randomArray
        graphData.endIndex = 0
        graphData.startIndex = 0
    }
    func bubbleSort() async {
        for (index,_) in graphData.array.enumerated() {
            await MainActor.run { [weak self] in
                self?.graphData.startIndex = index }
            
            for i in 0..<graphData.array.count-1 {
                if !isRunning {
                    return
                }
                if graphData.array[i] > graphData.array[i+1] {
                    await MainActor.run { [weak self] in
                        self?.graphData.array.swapAt(i, i+1)
                        self?.graphData.endIndex = i+1
                    }
                    try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration*100000000)))
                }
            }
        }
        await MainActor.run { [weak self] in
            self?.stopSorting()
        }
    }
    func insertionSort() async {
        let n = graphData.array.count
        for i in 1..<n {
            let key = graphData.array[i]
            var j = i - 1
            
            await MainActor.run { [weak self] in
                self?.graphData.startIndex = i
            }
            
            while j >= 0 && graphData.array[j] > key {
                if !isRunning {
                    return
                }
                
                await MainActor.run { [weak self] in
                    self?.graphData.array[j + 1] = self?.graphData.array[j] ?? 0
                    self?.graphData.endIndex = j + 1
                }
                
                try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration * 1_000_000_00)))
                j -= 1
            }
            
            await MainActor.run { [weak self] in
                self?.graphData.array[j + 1] = key
                self?.graphData.endIndex = j + 1
            }
            
            try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration * 1_000_000_00)))
        }
        
        await MainActor.run { [weak self] in
            self?.stopSorting()
        }
    }
    func selectionSort() async {
        let n = graphData.array.count
        for i in 0..<n {
            var minIndex = i
            
            await MainActor.run { [weak self] in
                self?.graphData.startIndex = i
            }
            
            for j in i+1..<n {
                if !isRunning { return }
                if graphData.array[j] < graphData.array[minIndex] {
                    minIndex = j
                }
                await MainActor.run { [weak self] in
                    self?.graphData.endIndex = j
                }
                try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration * 1_000_000_00)))
            }
            
            if i != minIndex {
                await MainActor.run { [weak self] in
                    self?.graphData.array.swapAt(i, minIndex)
                    self?.graphData.endIndex = minIndex
                }
                try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration * 1_000_000_00)))
            }
        }
        
        await MainActor.run { [weak self] in
            self?.stopSorting()
        }
    }
    
    
    func mergeSort() async {
        await mergeSortHelper(0, graphData.array.count - 1)

        await MainActor.run { [weak self] in
            self?.stopSorting()
        }
    }
    private func mergeSortHelper(_ left: Int, _ right: Int) async {
        if left < right {
            let mid = (left + right) / 2
            await mergeSortHelper(left, mid)
            await mergeSortHelper(mid + 1, right)
            await merge(left, mid, right)
        }
    }


    func merge(_ left: Int, _ mid: Int, _ right: Int) async {
        if !isRunning { return }

        let leftArray = Array(graphData.array[left...mid])
        let rightArray = Array(graphData.array[mid+1...right])

        var i = 0, j = 0, k = left

        while i < leftArray.count && j < rightArray.count {
            if !isRunning { return }

            await MainActor.run { [weak self] in
                self?.graphData.startIndex = k
                self?.graphData.endIndex = k
            }

            if leftArray[i] <= rightArray[j] {
                await MainActor.run { [weak self] in
                    self?.graphData.array[k] = leftArray[i]
                }
                i += 1
            } else {
                await MainActor.run { [weak self] in
                    self?.graphData.array[k] = rightArray[j]
                }
                j += 1
            }

            try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration * 1_000_000_00)))
            k += 1
        }

        while i < leftArray.count {
            if !isRunning { return }
            await MainActor.run { [weak self] in
                self?.graphData.startIndex = k
                self?.graphData.endIndex = k
                self?.graphData.array[k] = leftArray[i]
            }
            try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration * 1_000_000_00)))
            i += 1
            k += 1
        }

        while j < rightArray.count {
            if !isRunning { return }
            await MainActor.run { [weak self] in
                self?.graphData.startIndex = k
                self?.graphData.endIndex = k
                self?.graphData.array[k] = rightArray[j]
            }
            try? await Task.sleep(nanoseconds: UInt64(Int(settingData.duration * 1_000_000_00)))
            j += 1
            k += 1
        }
    }



    
    
    
}

