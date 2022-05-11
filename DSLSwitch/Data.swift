//
//  Data.swift
//  DSLSwitch
//
//  Created by Cem Olcay on 5/11/22.
//

import AudioKit
import CoreMIDI
import Foundation
import SwiftUI

var midi = MIDI()

struct DSLMIDIOut: Hashable {
    var name: String
    var isOn: Bool {
        didSet {
            if isOn {
                guard let index = midi.destinationNames.firstIndex(of: name) else { return }
                midi.openOutput(index: index)
            } else {
                midi.closeOutput(name: name)
            }
        }
    }
}

class DSLData: ObservableObject {
    @AppStorage("midiChannel") var midiChannel: Int = 0 { willSet { objectWillChange.send() } }
    @Published var midiOuts: [DSLMIDIOut] = []

    init() {
        updateMIDIOuts()
    }

    func clean() {
        midi.sendEvent(MIDIEvent(programChange: 0, channel: MIDIChannel(midiChannel)))
    }

    func crunch() {
        midi.sendEvent(MIDIEvent(programChange: 1, channel: MIDIChannel(midiChannel)))
    }

    func od1() {
        midi.sendEvent(MIDIEvent(programChange: 2, channel: MIDIChannel(midiChannel)))
    }

    func od2() {
        midi.sendEvent(MIDIEvent(programChange: 3, channel: MIDIChannel(midiChannel)))
    }

    func loopOn() {
        midi.sendEvent(MIDIEvent(controllerChange: 13, value: 0, channel: MIDIChannel(midiChannel)))
    }

    func loopOff() {
        midi.sendEvent(MIDIEvent(controllerChange: 13, value: 1, channel: MIDIChannel(midiChannel)))
    }

    func toggleLoop() {
        midi.sendEvent(MIDIEvent(controllerChange: 13, value: 2, channel: MIDIChannel(midiChannel)))
    }

    func master1() {
        midi.sendEvent(MIDIEvent(controllerChange: 14, value: 0, channel: MIDIChannel(midiChannel)))
    }

    func master2() {
        midi.sendEvent(MIDIEvent(controllerChange: 14, value: 1, channel: MIDIChannel(midiChannel)))
    }

    func toggleMaster() {
        midi.sendEvent(MIDIEvent(controllerChange: 14, value: 2, channel: MIDIChannel(midiChannel)))
    }

    func receivedMIDISetupChange() {
        updateMIDIOuts()
    }

    func updateMIDIOuts() {
        var newOuts = [DSLMIDIOut]()
        for out in midi.destinationNames {
            if let oldOut = midiOuts.first(where: { $0.name == out }) {
                newOuts.append(oldOut)
            } else {
                newOuts.append(DSLMIDIOut(name: out, isOn: false))
            }
        }
        midiOuts = newOuts
    }
}

// Unused MIDIListener stuff
extension DSLData: MIDIListener {
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDIAftertouch(noteNumber: MIDINoteNumber, pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDIAftertouch(_ pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIWord, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDIProgramChange(_ program: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDISystemCommand(_ data: [MIDIByte], portID: MIDIUniqueID?, timeStamp: MIDITimeStamp?) {
        return
    }

    func receivedMIDIPropertyChange(propertyChangeInfo: MIDIObjectPropertyChangeNotification) {
        return
    }

    func receivedMIDINotification(notification: MIDINotification) {
        return
    }
}
