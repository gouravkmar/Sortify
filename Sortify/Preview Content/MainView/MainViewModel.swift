//
//  MainViewModel.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//

import Foundation
import SwiftUICore

// MARK: - Graph Data

class GraphData: ObservableObject {
    @Published var startIndex: Int = 0
    @Published var endIndex: Int = 0
    @Published var array: [Int] = []
}

// MARK: - Main ViewModel

class MainViewModel: ObservableObject {
    @Published var algo: Algorithms = .bubble
    @Published var time: Int = 0
    @Published var isRunning: Bool = false
    @Published var isShowSetting: Bool = false
    @Published var settingData = SettingsViewModel()
    @Published var graphData = GraphData()

    private var timer: Timer?

    // MARK: - Init

    init() {
        generateRandomArray()
    }

    // MARK: - Timer Control

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    @objc func updateTime() {
        time += 10
    }

    // MARK: - Control Actions

    func startSorting() {
        isRunning = true
        startTimer()
        Task {
            switch algo {
            case .bubble: await bubbleSort()
            case .selection: await selectionSort()
            case .insertion: await insertionSort()
            case .merge: await mergeSort()
            }
        }
    }

    func stopSorting() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset() {
        stopSorting()
        generateRandomArray()
        time = 0
    }

    func generateRandomArray() {
        let size = Int(settingData.arrSize)
        graphData.array = (0..<size).map { _ in Int.random(in: 1...100) }
        graphData.startIndex = 0
        graphData.endIndex = 0
    }

    // MARK: - Sorting Algorithms

    // MARK: Bubble Sort
    func bubbleSort() async {
        for index in 0..<graphData.array.count {
            await MainActor.run { self.graphData.startIndex = index }
            for i in 0..<graphData.array.count - 1 {
                guard isRunning else { return }
                if graphData.array[i] > graphData.array[i + 1] {
                    await MainActor.run {
                        self.graphData.array.swapAt(i, i + 1)
                        self.graphData.endIndex = i + 1
                    }
                    try? await Task.sleep(nanoseconds: delay)
                }
            }
        }
        await MainActor.run { stopSorting() }
    }

    // MARK: Insertion Sort
    func insertionSort() async {
        for i in 1..<graphData.array.count {
            let key = graphData.array[i]
            var j = i - 1
            await MainActor.run { self.graphData.startIndex = i }
            while j >= 0 && graphData.array[j] > key {
                guard isRunning else { return }
                await MainActor.run {
                    self.graphData.array[j + 1] = self.graphData.array[j]
                    self.graphData.endIndex = j + 1
                }
                try? await Task.sleep(nanoseconds: delay)
                j -= 1
            }
            await MainActor.run {
                self.graphData.array[j + 1] = key
                self.graphData.endIndex = j + 1
            }
            try? await Task.sleep(nanoseconds: delay)
        }
        await MainActor.run { stopSorting() }
    }

    // MARK: Selection Sort
    func selectionSort() async {
        let n = graphData.array.count
        for i in 0..<n {
            var minIndex = i
            await MainActor.run { self.graphData.startIndex = i }
            for j in i+1..<n {
                guard isRunning else { return }
                if graphData.array[j] < graphData.array[minIndex] {
                    minIndex = j
                }
                await MainActor.run { self.graphData.endIndex = j }
                try? await Task.sleep(nanoseconds: delay)
            }
            if i != minIndex {
                await MainActor.run {
                    self.graphData.array.swapAt(i, minIndex)
                    self.graphData.endIndex = minIndex
                }
                try? await Task.sleep(nanoseconds: delay)
            }
        }
        await MainActor.run { stopSorting() }
    }

    // MARK: Merge Sort
    func mergeSort() async {
        await mergeSortHelper(0, graphData.array.count - 1)
        await MainActor.run { stopSorting() }
    }

    private func mergeSortHelper(_ left: Int, _ right: Int) async {
        if left < right {
            let mid = (left + right) / 2
            await mergeSortHelper(left, mid)
            await mergeSortHelper(mid + 1, right)
            await merge(left, mid, right)
        }
    }

    private func merge(_ left: Int, _ mid: Int, _ right: Int) async {
        guard isRunning else { return }

        let leftArray = Array(graphData.array[left...mid])
        let rightArray = Array(graphData.array[mid+1...right])

        var i = 0, j = 0, k = left

        while i < leftArray.count && j < rightArray.count {
            guard isRunning else { return }
            await MainActor.run {
                self.graphData.startIndex = k
                self.graphData.endIndex = k
                self.graphData.array[k] = (leftArray[i] <= rightArray[j]) ? leftArray[i] : rightArray[j]
            }
            if leftArray[i] <= rightArray[j] { i += 1 } else { j += 1 }
            try? await Task.sleep(nanoseconds: delay)
            k += 1
        }

        while i < leftArray.count {
            guard isRunning else { return }
            await MainActor.run {
                self.graphData.array[k] = leftArray[i]
                self.graphData.startIndex = k
                self.graphData.endIndex = k
            }
            try? await Task.sleep(nanoseconds: delay)
            i += 1
            k += 1
        }

        while j < rightArray.count {
            guard isRunning else { return }
            await MainActor.run {
                self.graphData.array[k] = rightArray[j]
                self.graphData.startIndex = k
                self.graphData.endIndex = k
            }
            try? await Task.sleep(nanoseconds: delay)
            j += 1
            k += 1
        }
    }

    // MARK: - Helpers

    private var delay: UInt64 {
        UInt64(Int(settingData.duration * 100_000_000)) // ms to ns
    }
}


