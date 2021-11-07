//
//  NumberQuestionsView.swift
//  MultiplicationTableApp
//
//  Created by Leonardo  on 23/10/21.
//

import SwiftUI

struct NumberQuestionsView: View {
  @EnvironmentObject var settings: GameSettings
  @State public var difficulty: String
  @State var numberQuestions: Int
  @State var selectColor: Color

  var btnActivated: Bool {
    return numberQuestions == settings.difficultySettings.1
  }
  
  var numberQuestionsIsNotAvailable: Bool {
    return settings.multiplicationTableIsUpTo.0 == 1 && numberQuestions >= 20
  }

  var body: some View {
    Button(action: {
      settings.difficultySettings = (self.difficulty, self.numberQuestions, self.selectColor)
    }) {
      Text(self.numberQuestions == 144 ? "All" : "\(self.numberQuestions)")
        .frame(width: 93, height: 50)
        .foregroundColor(btnActivated ? Color.white : Color.black)
        .font(.headline)
        .background(btnActivated ? self.selectColor : Color.white).cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 3))
        .shadow(radius: 3)
        .opacity(numberQuestionsIsNotAvailable || settings.isInGame ? 0.4 : 1)
        .animation(.default, value: btnActivated)
    }
    .disabled(numberQuestionsIsNotAvailable || settings.isInGame)
  }
}
