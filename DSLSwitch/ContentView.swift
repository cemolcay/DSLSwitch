//
//  ContentView.swift
//  DSLSwitch
//
//  Created by Cem Olcay on 5/11/22.
//

import SwiftUI

struct DSLButton: View {
    var title: String
    var action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
//        Button(title, action: action)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .buttonStyle(.plain)
        Button(action: action, label: {
            Text(title)
                .foregroundColor(.primary)
//                .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
}

struct ContentView: View {
    @ObservedObject var data = DSLData()

    var body: some View {
        List {
            Section(header: Text("Channels")) {
                DSLButton("Clean") { data.clean() }
                DSLButton("Crunch") { data.crunch() }
                DSLButton("Ultra Gain 1") { data.od1() }
                DSLButton("Ultra Gain 2") { data.od2() }
            }
            Section(header: Text("FX Loop")) {
                DSLButton("On") { data.loopOn() }
                DSLButton("Off") { data.loopOff() }
                DSLButton("Toggle") { data.toggleLoop() }
            }
            Section(header: Text("Master")) {
                DSLButton("Master 1") { data.master1() }
                DSLButton("Master 2") { data.master2() }
                DSLButton("Toggle") { data.toggleMaster() }
            }
            Section(header: Text("Settings")) {
                Stepper(
                    value: $data.midiChannel,
                    in: 0...15,
                    label: { Text("MIDI Channel: \(data.midiChannel + 1)") })
                if $data.midiOuts.isEmpty {
                    Text("No MIDI outputs found!")
                } else {
                    ForEach($data.midiOuts, id: \.self, content: { out in
                        Toggle(out.name.wrappedValue, isOn: out.isOn)
                    })
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
