//
//  Observables.swift
//  MultiplicationTableApp
//
//  Created by Leonardo  on 22/10/21.
//

import Foundation
import SwiftUI

class GameSettings: ObservableObject {
  @Published var multiplicationTableIsUpTo: (Int, Color) = (1, Color.green)
  @Published var difficultySettings: (String, Int, Color) = ("Easy", 5, Color.green)
  @Published var questions: [(Int, Int, Int)] = [(1, 1, 1)]
  @Published var currentQuestion: (Int, Int, Int) = (1, 1, 1)
  @Published var questionNumber: Int = 1
  @Published var isInGame: Bool = false
  @Published var answerBoxDisabled: Bool = false
  @Published var answer: String = ""
  @Published var score: Int = 0
  @Published var answerBg: Color = Color.white
}
