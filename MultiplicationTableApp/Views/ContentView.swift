import SwiftUI

struct PlayButtonModifier: ViewModifier {
  var isInGame: Bool
  func body(content: Content) -> some View {
    content
      .frame(width: 250, height: 50)
      .font(.title)
      .foregroundColor(.white)
      .background(Color.black)
      .cornerRadius(20)
      .opacity(isInGame ? 0.4 : 1)
      .shadow(color: Color.black, radius: 5)
      .offset(y: isInGame ? 270 : 0)
      .transition(.slide)
  }
}

struct NumberQuestionsSelectedModifier: ViewModifier {
  var color: Color
  func body(content: Content) -> some View {
    content
      .frame(width: 100, height: 30)
      .font(.headline)
      .foregroundColor(.white)
      .background(color)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .offset(x: -150, y: 26)
      .shadow(radius: 3)
  }
}

struct MultiplicationTablesSelectedModifier: ViewModifier {
  var color: Color
  func body(content: Content) -> some View {
    content
      .frame(width: 30, height: 30)
      .font(.headline)
      .foregroundColor(.white)
      .background(color)
      .clipShape(RoundedRectangle(cornerRadius: 30))
      .offset(x: -90, y: 18)
      .shadow(radius: 3)
  }
}

struct MultiplicationTablesSelectionTitleModifier: ViewModifier {
  func body(content: Content) -> some View {
    let font = Font.title.weight(.bold)
    content
      .foregroundColor(Color.black)
      .font(font)
      .frame(maxWidth: CGFloat.infinity, alignment: Alignment.topLeading)
  }
}

extension View {
  func applyMultiplicationTablesSelectedModifier(color: Color) -> some View {
    modifier(MultiplicationTablesSelectedModifier(color: color))
  }

  func applyMultiplicationTablesSelectionTitleModifier() -> some View {
    modifier(MultiplicationTablesSelectionTitleModifier())
  }

  func applyNumberQuestionsSelectedModifier(color: Color) -> some View {
    modifier(NumberQuestionsSelectedModifier(color: color))
  }

  func applyPlayButtonModifier(isInGame: Bool) -> some View {
    modifier(PlayButtonModifier(isInGame: isInGame))
  }
}

struct ContentView: View {
  @StateObject var settings = GameSettings()

  @State private var results = [Int]()
  @State private var isInSettings: Bool = true
  @State private var questions: [(Int, Int, Int)] = [(1, 1, 1)]
  /// # 144 is the max number of questions possible, but not the actual by multiplication table. Number must not be changed or 'All' message won't appear
  @State private var selectQuestionButtonSettings: [(String, Int, Color)] = [("Easy", 5, Color.green), ("Medium", 10, Color.blue), ("Hard", 20, Color.orange), ("Expert", 144, Color.pink)]

  let multipliers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  let btnColorShades: [Color] =
    [Color(red: 76/255, green: 217/255, blue: 99/255), Color(red: 68/255, green: 195/255, blue: 89/255), Color(red: 61/255, green: 174/255, blue: 79/255), Color(red: 0/255, green: 122/255, blue: 255/255), Color(red: 0/255, green: 111/255, blue: 230/255), Color(red: 0/255, green: 98/255, blue: 204/255), Color(red: 255/255, green: 149/255, blue: 0/255), Color(red: 230/255, green: 134/255, blue: 0/255), Color(red: 204/255, green: 119/255, blue: 0/255), Color(red: 255/255, green: 45/255, blue: 85/255), Color(red: 230/255, green: 41/255, blue: 76/255), Color(red: 204/255, green: 36/255, blue: 67/255)]

  var maxNumberQuestions: Int {
    let maxQuestions = settings.multiplicationTableIsUpTo.0 * 12
    selectQuestionButtonSettings[3].1 = maxQuestions
    return maxQuestions
  }

  func numberQuetionsExists() -> Bool {
    return settings.difficultySettings.1 <= maxNumberQuestions
  }

  func generateActualMaxNumberQuestions() -> Int {
    if numberQuetionsExists() {
      return settings.difficultySettings.1
    } else { return maxNumberQuestions }
  }

  func generateQuestions() {
    settings.questions = [(Int, Int, Int)]()
    var numberOfValidQuestions: Int = 0
    while numberOfValidQuestions < generateActualMaxNumberQuestions() {
      let multiplicand = Int.random(in: 1 ... settings.multiplicationTableIsUpTo.0)
      let multiplier = multipliers.randomElement() ?? 0
      let result = multiplicand * multiplier
      if questionIsNotRepeated(multiplicand, multiplier, result) {
        numberOfValidQuestions += 1
        settings.questions.append((multiplicand, multiplier, result))
      }
    }
  }

  func questionIsNotRepeated(_ multiplicand: Int, _ multiplier: Int, _ result: Int) -> Bool {
    for question in settings.questions {
      if question.2 == result && question.0 == multiplicand {
        return false
      }
    }
    return true
  }

  var body: some View {
    VStack {
      HStack {
        Text("Up to which multiplication table?")
          .applyMultiplicationTablesSelectionTitleModifier()
        Text("\(settings.multiplicationTableIsUpTo.0)")
          .applyMultiplicationTablesSelectedModifier(color: settings.multiplicationTableIsUpTo.1)
      }
      .padding(.leading)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(multipliers, id: \.self) { multiplier in
            MultiplicationTableSelectionView(multiplicationTable: multiplier, btnColorShade: self.btnColorShades[multiplier - 1])
          }
        }
        .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
      }
      HStack {
        Text("How many questions you want?")
          .applyMultiplicationTablesSelectionTitleModifier()
          .padding([.leading, .top])

        Text("\(settings.difficultySettings.0)")
          .applyNumberQuestionsSelectedModifier(color: settings.difficultySettings.2)
      }
      HStack {
        ForEach(self.selectQuestionButtonSettings, id: \.self.0) { btnSettings in
          NumberQuestionsView(difficulty: btnSettings.0, numberQuestions: btnSettings.1, selectColor: btnSettings.2)
        }
      }
      ZStack {
        HStack {
          GameBoardView()
        }
        HStack {
          Button(action: {
            /// # Generates all questions in the @Published questions
            self.generateQuestions()
            /// # Sets the @Published currentQuestion to the first @Published question
            settings.currentQuestion = settings.questions[0]
            settings.questionNumber = 1
            settings.answer = ""
            settings.score = 0
            settings.answerBg = Color.white
            withAnimation {
              settings.isInGame.toggle()
            }
            print("\(self.settings.questions)")
            print("Current Question: \(self.settings.currentQuestion)")
          }) {
            Text("Play")
              .applyPlayButtonModifier(isInGame: settings.isInGame)
          }
          .animation(.default, value: self.settings.isInGame)
          .disabled(settings.isInGame ? true : false)
        }
      }
      Spacer()
    }
    .environmentObject(settings)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
