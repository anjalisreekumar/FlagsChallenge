//
//  FlagChallengeViewModel.swift
//  FlagsChallenge
//
//  Created by Hariom Sharma on 22/10/25.
//

import CoreData

enum ScreenType {
    case landingPage
    case countDown
    case challengeView
    case gameOver
}

enum ActionType {
    case switchView(ScreenType)
    case loadQuestions
    case saveSchedulesTime(Date)
}

struct DateFormat {
    let firstDigit: Int
    let secondDigit: Int
    let type: DateType
}
enum DateType {
    case hour
    case minute
    case second
}
final class FlagChallengeViewModel: ObservableObject {
    
    @Published var currentView: ScreenType = .landingPage
    @Published var questions: [Question] = []
    @Published var timeRemaining: Int = 0
    @Published var showStartCountdown: Bool = false
    @Published var isInterval: Bool = false
    @Published var selectedAnswerId: Int? = nil
    @Published var score: Int = 0
    
    private var startTimer: Timer?
    private var questionTimer: Timer?
    private var intervalTimer: Timer?
    
    @Published var scheduledTime: Date?
    @Published var currentQuestion: Question?
    
    // MARK: - CoreData Context
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    func onAction(_ action: ActionType) {
        switch action {
        case .switchView(let type):
            switchViewTo(type)
        case .loadQuestions:
            loadDataFromJson()
        case .saveSchedulesTime(let date):
            saveScheduledTime(date: date)
        }
    }
    
    private func switchViewTo(_ type: ScreenType) {
        currentView = type
    }
    
    private func loadDataFromJson() {
        guard let url = Bundle.main.url(forResource: "flags-challenge", withExtension: "json") else {
            print("Could not load json file from project")
            return
        }
        do {
            let content = try Data(contentsOf: url)
            let decorder = JSONDecoder()
            let questionsArray = try decorder.decode(QuestionResult.self, from: content)
            print("Decoded data from json is \(questionsArray)")
            DispatchQueue.main.async { [weak self] in
                self?.questions = questionsArray.questions
            }
        }
        catch {
            print("Something went wrong while decoding json \(error)")
        }
        
    }
    
    // MARK: - Helper
    func returnDateFrom(format: DateFormat) -> Int {
        let value = format.firstDigit * 10 + format.secondDigit
        switch format.type {
        case .hour:
            return min(max(value, 0), 23)
        case .minute, .second:
            return min(max(value, 0), 59)
        }
    }
    
    func scheduledDateFromDigits(hour: DateFormat, minute: DateFormat, second: DateFormat) -> Date {
        // Convert the two digits into a single integer for each component
        let h = hour.firstDigit * 10 + hour.secondDigit
        let m = minute.firstDigit * 10 + minute.secondDigit
        let s = second.firstDigit * 10 + second.secondDigit
        
        // Clamp values to valid ranges
        let clampedH = min(max(h, 0), 23)
        let clampedM = min(max(m, 0), 59)
        let clampedS = min(max(s, 0), 59)
        
        // Build the date in local time
        var calendar = Calendar.current
        calendar.timeZone = .current // ensures local time
        
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = clampedH
        components.minute = clampedM
        components.second = clampedS
        
        var date = calendar.date(from: components) ?? Date()
        
        // If the time is in the past, schedule it for tomorrow
        if date < Date() {
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        return date
    }


    
    private func saveScheduledTime(date: Date) {
        scheduledTime = date

        let newSchedule = ScheduledChallenge(context: context)
        newSchedule.id = UUID()
        newSchedule.scheduledTime = date
        newSchedule.createdAt = Date()

        save()
        print("Saved scheduled time: \(date)")
        switchViewTo(.countDown)
        
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("Core Data changes saved successfully")
            } catch {
                print("Failed to save Core Data: \(error)")
            }
        } else {
            print("No changes to save")
        }
    }


//    func fetchLatestScheduledTime() {
//        let request: NSFetchRequest<ScheduledChallenge> = ScheduledChallenge.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \ScheduledChallenge.createdAt, ascending: false)]
//        request.fetchLimit = 1
//        if let result = try? context.fetch(request).first {
//            scheduledTime = result.scheduledTime
//            if let savedDate = result.scheduledTime {
//                let utcFormatter = DateFormatter()
//                utcFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//                utcFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                
//                let localFormatter = DateFormatter()
//                localFormatter.timeZone = .current
//                localFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                
//                print("UTC time:", utcFormatter.string(from: savedDate))
//                print("Local time:", localFormatter.string(from: savedDate))
//            }
//
//        }
//    }
    
    func fetchLatestScheduledTime() {
        // Hardcode for testing
        let scheduledDate = Date().addingTimeInterval(20) // 5 seconds from now
        scheduledTime = scheduledDate

        let utcFormatter = DateFormatter()
        utcFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        utcFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let localFormatter = DateFormatter()
        localFormatter.timeZone = .current
        localFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        print("UTC time:", utcFormatter.string(from: scheduledDate))
        print("Local time:", localFormatter.string(from: scheduledDate))
    }

    
//    func monitorScheduledTime() {
//        guard let scheduledTime else { return }
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
//            guard let self else { return }
//
//            let difference = Int(scheduledTime.timeIntervalSinceNow)
//            if difference > 20 {
//                //no change
//            } else if difference <= 20 && difference > 0 {
//                switchViewTo(.countDown)
//            } else if difference <= 0 {
////                switchViewTo(.challengeView)
//                timer.invalidate()
//                startChallenge()
//            }
//        }
//    }
    
    func monitorScheduledTime() {
        var counter = 20
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            if counter > 0 {
                self.timeRemaining = counter
                if counter <= 20 && counter > 0 {
                    self.switchViewTo(.countDown)
                }
                counter -= 1
            } else {
                timer.invalidate()
                self.startChallenge()
            }
        }
    }
}

extension FlagChallengeViewModel {
    func startChallenge() {
        currentView = .challengeView
        score = 0
        selectedAnswerId = nil
        startQuestion(at: 0)
    }
    
    private func startQuestion(at index: Int) {
        guard index < questions.count else {
            gameOver()
            return
        }
        
        selectedAnswerId = nil
        isInterval = false
        timeRemaining = 30
        currentQuestion = questions[index]
        
        startTimer?.invalidate()
        startTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            timeRemaining -= 1
            if timeRemaining <= 0 {
                timer.invalidate()
                self.handleQuestionEnd(at: index)
            }
        }
    }
    
    private func handleQuestionEnd(at index: Int) {
        isInterval = true
        timeRemaining = 10
        intervalTimer?.invalidate()
        
        intervalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            timeRemaining -= 1
            if timeRemaining <= 0 {
                timer.invalidate()
                self.startQuestion(at: index + 1)
            }
        }
    }
    
    func selectAnswer(for question: Question, selectedIndex: Int) {
        print("question is \(question), and selected index is \(selectedIndex)")
        selectedAnswerId = question.countries[selectedIndex].id
        if selectedAnswerId  == question.answerId {
            score += 1
        }
    }
    
    private func gameOver() {
        startTimer?.invalidate()
        intervalTimer?.invalidate()
        currentView = .gameOver
    }
}
