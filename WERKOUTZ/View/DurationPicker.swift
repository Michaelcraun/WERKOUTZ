//
//  DurationPicker.swift
//  WERKOUTZ
//
//  Created by Michael Craun on 8/17/20.
//

import SwiftUI

struct DurationPicker: View {
    @Binding var duration: String
    @State private var hours: Int = 0 {
        didSet {
            setDuration()
        }
    }
    @State private var minutes: Int = 0 {
        didSet {
            setDuration()
        }
    }
    @State private var seconds: Int = 0 {
        didSet {
            setDuration()
        }
    }
    private var pickerWidth: CGFloat {
        return (screen.width - 100) / 3
    }
    
    var body: some View {
        let bindingHours = Binding<Int>(
            get: {
                self.hours
            }, set: {
                self.hours = $0
            })
        let bindingMinutes = Binding<Int>(
            get: {
                self.minutes
            }, set: {
                self.minutes = $0
            })
        let bindingSeconds = Binding<Int>(
            get: {
                self.seconds
            }, set: {
                self.seconds = $0
            })
        
        HStack {
            VStack {
                Picker("H", selection: bindingHours) {
                    ForEach(0..<24) { index in
                        Text("\(index)")
                    }
                }.labelsHidden()
                .frame(width: pickerWidth)
                .clipped()
                .pickerStyle(WheelPickerStyle())
            }
            VStack {
                Picker("M", selection: bindingMinutes) {
                    ForEach(0..<60) { index in
                        Text("\(index)")
                    }
                }.labelsHidden()
                .frame(width: pickerWidth)
                .clipped()
                .pickerStyle(WheelPickerStyle())
            }
            VStack {
                Picker("S", selection: bindingSeconds) {
                    ForEach(0..<60) { index in
                        Text("\(index)")
                    }
                }.labelsHidden()
                .frame(width: pickerWidth)
                .clipped()
                .pickerStyle(WheelPickerStyle())
            }
        }
    }
    
    init(duration: Binding<String>) {
        self._duration = duration
    }
    
    private func setDuration() {
        self.duration = "\(hours):\(minutes):\(seconds)"
    }
}
