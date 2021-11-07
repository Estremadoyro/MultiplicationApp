//
//  MultiplicationTableSelectionView.swift
//  MultiplicationTableApp
//
//  Created by Leonardo  on 21/10/21.
//

import SwiftUI

struct BtnStyleModifier: ViewModifier {
  var isInGame: Bool
  var btnActivated: Bool
  var btnColor: Color
  func body(content: Content) -> some View {
    content
      .frame(width: 100, height: 50)
      .foregroundColor(btnActivated ? Color.white : Color.black)
      .font(.headline)
      .background(btnActivated ? btnColor : Color.white).cornerRadius(20)
      .animation(.default, value: btnActivated)
      .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 3))
      .opacity(isInGame ? 0.4 : 1)
      .shadow(radius: 3)
  }
}

extension View {
  func applyBtnStyleModifier(isInGame: Bool, btnActivated: Bool, btnColor: Color) -> some View {
    modifier(BtnStyleModifier(isInGame: isInGame, btnActivated: btnActivated, btnColor: btnColor))
  }
}

struct MultiplicationTableSelectionView: View {
  @EnvironmentObject var settings: GameSettings
  @State var multiplicationTable: Int
  @State var btnColorShade: Color

  var btnActivated: Bool {
    return multiplicationTable <= settings.multiplicationTableIsUpTo.0
  }

  func resetNumberQuestions() {
    if settings.multiplicationTableIsUpTo.0 == 1, settings.difficultySettings.1 >= 20 {
      settings.difficultySettings = ("Easy", 5, Color.green)
    }
  }

  var body: some View {
    Button(action: {
      settings.multiplicationTableIsUpTo.0 = multiplicationTable
      settings.multiplicationTableIsUpTo.1 = self.btnColorShade
      self.resetNumberQuestions()
    }) {
      Text("\(multiplicationTable)")
        .applyBtnStyleModifier(isInGame: settings.isInGame, btnActivated: self.btnActivated, btnColor: self.btnColorShade)
    }
    .disabled(settings.isInGame ? true : false)
  }
}
