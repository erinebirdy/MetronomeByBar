//
//  Metronome.swift
//  Metronome
//
//  Created by Erin Baird on 2021-12-30.
//

import Foundation
import AVFoundation


class Metronome {
    
    var bpb = 4
    var bpm = 120
    var interval: TimeInterval?
    var timeOffset: TimeInterval?
    var enabled: Bool = false { didSet {
         if enabled {
             playMetronome()
         } else {
             stopMetronome()
         }
         }}
    var onTick: ((_ nextTick: DispatchTime) -> Void)?
    var nextTick: DispatchTime = DispatchTime.distantFuture
    
    let highAudioPlayer: AVAudioPlayer = {
          do {
              let soundFileURL = Bundle.main.url(
                forResource: "High Seiko SQ50",
                withExtension: "wav"
              )
              //let soundFile = try AVAudioFile(forReading: soundURL)
              let player = try AVAudioPlayer(contentsOf: soundFileURL!)
              return player
          } catch {
              print("Oops, unable to initialize metronome audio buffer: \(error)")
              return AVAudioPlayer()
          }
      }()
    
    let lowAudioPlayer: AVAudioPlayer = {
          do {
              let soundFileURL = Bundle.main.url(
                forResource: "Low Seiko SQ50",
                withExtension: "wav"
              )
              //let soundFile = try AVAudioFile(forReading: soundURL)
              let player = try AVAudioPlayer(contentsOf: soundFileURL!)
              return player
          } catch {
              print("Oops, unable to initialize metronome audio buffer: \(error)")
              return AVAudioPlayer()
          }
      }()
    
    init(){
        highAudioPlayer.volume = 1.0
        highAudioPlayer.numberOfLoops = 1
        highAudioPlayer.play()
    }
    
    private func playMetronome() {
        nextTick = DispatchTime.now()
        highAudioPlayer.prepareToPlay()
        nextTick = DispatchTime.now()
        audioTick(bpbTracker: bpb)
    }

    
    private func audioTick(bpbTracker: Int) {
        print("start metronome", bpbTracker)
        
        guard
            enabled,
            nextTick <= DispatchTime.now()
            else { return }

        let interval: TimeInterval = 60.0 / TimeInterval(bpm)
        nextTick = nextTick + interval
        DispatchQueue.main.asyncAfter(deadline: nextTick) { [weak self] in
            var bpbTrackerTemp = bpbTracker - 1
            if(bpbTrackerTemp == 0) {
                bpbTrackerTemp = self!.bpb
            }
            self?.audioTick(bpbTracker: bpbTrackerTemp)
        }
        if (bpbTracker == bpb){
            highAudioPlayer.play()
        } else {
            lowAudioPlayer.play()
        }
        //player.play(atTime: interval)
        onTick?(nextTick)
    }
    
    private func stopMetronome() {
        print("stop metronome")
        if (highAudioPlayer.isPlaying){
            highAudioPlayer.stop()
        }
    }
    
}




