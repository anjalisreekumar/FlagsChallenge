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
         let calendar = Calendar.current
         
         let h = returnDateFrom(format: hour)
         let m = returnDateFrom(format: minute)
         let s = returnDateFrom(format: second)
         
         var date = calendar.date(bySettingHour: h, minute: m, second: s, of: Date()) ?? Date()
         
         // if the time is in the past, schedule it for tomorrow
         if date < Date() {
             //check it later
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
    
    func fetchCoreDataData() {
      let data = loadLatestSchedule()
        
        print("fetched all data from cd \(data)")
        
    }

    func loadLatestSchedule() -> ScheduledChallenge? {
        let request: NSFetchRequest<ScheduledChallenge> = ScheduledChallenge.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch latest schedule: \(error)")
            return nil
        }
    }


    
}
