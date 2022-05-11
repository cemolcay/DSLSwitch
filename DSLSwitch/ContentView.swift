//
//  ContentView.swift
//  DSLSwitch
//
//  Created by Cem Olcay on 5/11/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var data = DSLData()

    var body: some View {
        List {
            Section(header: Text("Channels")) {
                Button("Clean") { data.clean() }
                Button("Crunch") { data.crunch() }
                Button("Ultra Gain 1") { data.od1() }
                Button("Ultra Gain 2") { data.od2() }
            }
            Section(header: Text("FX Loop")) {
                Button("On") { data.loopOn() }
                Button("Off") { data.loopOff() }
                Button("Toggle") { data.toggleLoop() }
            }
            Section(header: Text("Master")) {
                Button("Master 1") { data.master1() }
                Button("Master 2") { data.master2() }
                Button("Toggle") { data.toggleMaster() }
            }
            Section(header: Text("Settings")) {
                Stepper(
                    value: $data.midiChannel,
                    in: 0...15,
                    label: { Text("MIDI Channel: \(data.midiChannel + 1)") })
                if data.midiOuts.isEmpty {
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
    }
}
