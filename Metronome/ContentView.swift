//
//  ContentView.swift
//  Metronome
//
//  Created by Erin Baird on 2021-12-28.
//

import SwiftUI

struct ContentView: View {
    let bpm = 60
    var speeds = 10...200
    var barBeets = 1...16
    var beatsPerBar = 4
    @State private var selectedSpeed = 60
    @State private var selectedBeatsPerBar = 4
    @State private var metronomeState = false
    
    var metronome = Metronome()

    
    var body: some View {
        VStack {
//            Image( "metronomePic")
//                .imageScale(.small)
//                .clipShape(Circle())
//                .shadow(radius: 4)
            
            
            Picker("Please choose a speed", selection: $selectedSpeed) {
                ForEach(speeds, id: \.self) {
                    Text(String($0))
                }
            }.pickerStyle(WheelPickerStyle())
            .onReceive([self.selectedSpeed].publisher.first()) { (value) in
                updateBPM(bpm: value)
            }
        
            
            Picker("Please choose beats per bar", selection: $selectedBeatsPerBar) {
                ForEach(barBeets, id: \.self) {
                    Text(String($0))
                }
            }.pickerStyle(WheelPickerStyle())
                .onReceive([self.selectedBeatsPerBar].publisher.first()) { (value) in
                updateBPB(bpb: value)
                
                }.padding()
            
            
            Text("BPM: \(selectedSpeed)")
            Text("Beats Per Bar: \(selectedBeatsPerBar)")

            
            Button(action: changeMetronomeState) {
                Text("Start/Stop")
            }
        }
    }
    func changeMetronomeState(){
        metronome.bpm = selectedSpeed
        metronomeState = !metronomeState
        metronome.enabled = metronomeState
    }
    
    func updateBPM(bpm: Int){
        metronome.bpm = bpm
    }
    
    func updateBPB(bpb: Int){
        metronome.lowAudioPlayer.stop()
        metronome.highAudioPlayer.stop()
        metronome.enabled = false
        metronome.bpb = selectedBeatsPerBar
        metronome.enabled = true

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewLayout(.device)
        }

    }
}
