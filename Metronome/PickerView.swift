//
//  PickerView.swift
//  Metronome
//
//  Created by Erin Baird on 2022-01-01.
//
import SwiftUI

enum Genere:String, CaseIterable, Identifiable {
    case action
    case adventure
    case comedy
    case drama
    case horror
    case scifi
    
    var id: String {self.rawValue}
}
struct PickerView: View {
    @State private var selectedGenere = Genere.action.rawValue
    var body: some View {
        VStack {
            Picker(selection: $selectedGenere, label: Text("Select Movie Genere")) {
                ForEach(Genere.allCases) {
                    Text($0.rawValue.capitalized)
                }
            }
            Text("You Selected \(selectedGenere.capitalized)")
        }
        
    }
}
