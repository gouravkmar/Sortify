//
//  GraphView.swift
//  Sortify
//
//  Created by Adarsh Singh on 22/04/25.
//
import SwiftUI
import Charts
struct GraphView: View {
    let numbers: [Int] = [10, 20, 15, 40, 25,10, 20, 15, 40, 25,10, 20, 15, 40, 25,10, 20, 15, 40, 25,10, 20, 15, 40, 25,10, 20, 15, 40, 25,12,18,100,78,55,60]

        var body: some View {
            let data = numbers.enumerated().map { NumberData(label: "\($0.offset)", value: $0.element) }

            Chart(data) {
                BarMark(
                    x: .value("Index", $0.label),
                    y: .value("Value", $0.value),
                    width: .ratio(0.75),
                )
                .foregroundStyle(color(for: Double($0.value)))
                .symbol(Circle())
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 350)
            .padding()
        }
}
func color(for value: Double) -> Color {
    // Clamp value between 0 and 100
    let clamped = max(0, min(100, value))
    
    // Hue from red (0°) to green (120°), normalized as 0.0–0.33
    let hue = (clamped / 100) * (120.0 / 360.0)
    
    return Color(hue: hue, saturation: 0.9, brightness: 0.9)
}

struct NumberData: Identifiable {
    let id = UUID()
    let label: String
    let value: Int
}
