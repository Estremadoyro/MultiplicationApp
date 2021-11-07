//
//  NumberPadView.swift
//  MultiplicationTableApp
//
//  Created by Leonardo  on 1/11/21.
//

import SwiftUI

struct NumberBtnModifier: ViewModifier {
  var number: Int
  var cornerRadius: CGFloat = 5
  func body(content: Content) -> some View {
    content
      .frame(width: number == 0 ? 250 : 60, height: number == 0 ? 45 : 60)
      .foregroundColor(Color.black)
      .font(.title2)
      .background(Color.white.blur(radius: 0)).cornerRadius(cornerRadius)
      .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.black, lineWidth: 2))
      .shadow(radius: 5)
  }
}

extension View {
  func applyNumberBtnModifier(number: Int) -> some View {
    modifier(NumberBtnModifier(number: number))
  }
}

struct NumberPadView: View {
  @EnvironmentObject var settings: GameSettings
  @State var number: Int

  var maxNumberDigits: Int {
    let resultDigits: Int = String(settings.currentQuestion.2).count
    return resultDigits
  }

  func updateQuestionNumber() {
    print("Question number: \(settings.questionNumber) || Questions length: \(settings.questions.count)")
    /// # If the current question result digits is the same as the answer
    if settings.answer.count == maxNumberDigits {
      calculateScore()
      settings.answerBoxDisabled = true
      /// # All questions answered
      if settings.questionNumber == settings.questions.count {
        settings.answerBoxDisabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          settings.questionNumber = 1
          settings.questions = [(1, 1, 1)]
          settings.isInGame.toggle()
        }
        return
      }
      print("Current question: \(settings.currentQuestion)")
      settings.questionNumber += 1
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        settings.currentQuestion = settings.questions[settings.questionNumber - 1]
        settings.answer = ""
        settings.answerBg = Color.white
        self.settings.answerBoxDisabled = false
      }
    }
  }

  func correctAnswer() -> Bool {
    print("Answer: \(settings.answer) || Result: \(settings.currentQuestion.2)")
    return settings.answer == String(settings.currentQuestion.2)
  }

  func calculateScore() {
    if correctAnswer() {
      settings.answerBg = Color.green
      settings.score += 1
    } else { settings.answerBg = Color.red }
  }

  /// # [ERROR] The current question is not updated before getting its result & number of digits
  /// # [ERROR] Must check if the current question is the last one, before checking for digits lenght
  func goNextQuestion() {
    /// # Will go next question if the answer length is the same as the result's
    print("Answer digits: \(settings.answer.count) || Result Digits: \(maxNumberDigits)")
    updateQuestionNumber()
  }

  var body: some View {
    Button(action: {
      settings.answer = settings.answer + String(self.number)
      self.goNextQuestion()
    }) {
      Text("\(self.number)")
        .applyNumberBtnModifier(number: self.number)
    }
    .disabled(self.settings.answerBoxDisabled)
  }
}
