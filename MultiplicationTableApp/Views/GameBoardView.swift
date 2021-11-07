//
//  GameBoardView.swift
//  MultiplicationTableApp
//
//  Created by Leonardo  on 27/10/21.
//

import SwiftUI

struct AnswerTextModifier: ViewModifier {
  var answer: String
  var bgColor: Color
  func body(content: Content) -> some View {
    content
      .frame(width: 100, height: 40)
      .background(self.bgColor).cornerRadius(25)
      .foregroundColor(Color.black)
      .font(.title)
      .overlay(RoundedRectangle(cornerRadius: 25)
        .stroke(Color.black, lineWidth: 4))
      .animation(.default, value: self.answer)
      .shadow(radius: 3)
  }
}

struct BoardModifier: ViewModifier {
  var shadowColor: Color
  func body(content: Content) -> some View {
    content
      .frame(width: 380, height: 440)
      .cornerRadius(40)
      .shadow(color: self.shadowColor, radius: 5)
      .shadow(color: self.shadowColor, radius: 5)
      .animation(.default, value: self.shadowColor)
  }
}

struct NumberBox: View {
  var number: Int
  var body: some View {
    Color.black
      .frame(width: 70, height: 70)
      .cornerRadius(25)
      .shadow(color: Color.black, radius: 3)
    Text("\(self.number)")
      .font(.largeTitle)
      .foregroundColor(Color.white)
      .animation(.default, value: self.number)
  }
}

extension View {
  func applyBoardModifier(shadowColor: Color) -> some View {
    modifier(BoardModifier(shadowColor: shadowColor))
  }

  func applyAnswerTextModifier(answer: String, bgColor: Color) -> some View {
    modifier(AnswerTextModifier(answer: answer, bgColor: bgColor))
  }
}

struct GameBoardView: View {
  @EnvironmentObject var settings: GameSettings
  @State private var score: Int = 0

  var body: some View {
    ZStack(alignment: Alignment.top) {
      Color.white
        .applyBoardModifier(shadowColor: settings.difficultySettings.2)
      VStack {
        if settings.isInGame {
          HStack {
            ZStack {
              NumberBox(number: settings.currentQuestion.0)
            }
            Image(systemName: "multiply.square.fill")
              .font(.largeTitle)
              .padding()
            ZStack {
              NumberBox(number: settings.currentQuestion.1)
            }
          }
          .padding(.top, 15)
          HStack(alignment: .center) {
            Text(settings.answer == "" ? "?" : settings.answer)
              .applyAnswerTextModifier(answer: settings.answer, bgColor: self.settings.answerBg)
          }
          VStack {
            HStack {
              ForEach(1 ..< 4, id: \.self) { number in
                NumberPadView(number: number)
              }
              .padding([.trailing, .leading], 10)
            }
            HStack {
              ForEach(4 ..< 7, id: \.self) { number in
                NumberPadView(number: number)
              }
              .padding([.trailing, .leading], 10)
            }
            HStack {
              ForEach(7 ..< 10, id: \.self) { number in
                NumberPadView(number: number)
              }
              .padding([.trailing, .leading], 10)
            }
            HStack {
              NumberPadView(number: 0)
            }
          }
          .padding(.top, 10)
          /// # updateQuestionNumber()
          HStack {
            VStack {
              HStack {
                Text("Question: \(settings.questionNumber)")
                  .font(.title3)
                  .transition(.slide)
              }
            }
            VStack {
              Text("Score: \(settings.score)")
                .font(.title3)
                .animation(.default, value: self.settings.score)
            }
          }
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
        } else {
          Text("Score: \(settings.score)")
            .font(.largeTitle)
        }
      }
      .zIndex(1)
      .animation(.default, value: self.settings.isInGame)
    }
    .padding([.top], 20)
  }
}
