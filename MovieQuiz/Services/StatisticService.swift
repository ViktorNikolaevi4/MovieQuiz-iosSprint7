//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Виктор Корольков on 27.07.2023.
//

import Foundation

protocol StatisticService {
    func store(correct: Int, total: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord? { get }
    
    
}

final class StatisticServiceImplementation {
    private var userDefaults = UserDefaults.standard
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvader: () -> Date
    
    init(userDefaults: UserDefaults = .standard,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         dateProvader: @escaping () -> Date = { Date() }
         
    ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvader = dateProvader
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
//    func store(correct count: Int, total amount: Int) {
//        self.correct += correct
//        self.total += total
//        self.gamesCount += 1
        
 //       let date = dateProvader()
 //       let currentBestGame = GameRecord(correct: correct, total: total, date: date)
 //       if let previousBestGame = bestGame {
 //           if currentBestGame > previousBestGame {
   //             bestGame = currentBestGame
  //          }
  //      } else {
  //          bestGame = currentBestGame
  //      }
  //  }

    
//    var total: Int {
//        get {
//            userDefaults.integer(forKey: Keys.total.rawValue)
//        }
 //       set {
 //           userDefaults.set(newValue, forKey: Keys.total.rawValue)
  //      }
 //   }
    
//    var correct: Int {
//        get {
 //           userDefaults.integer(forKey: Keys.correct.rawValue)
 //       }
 //       set {
  //          userDefaults.set(newValue, forKey: Keys.correct.rawValue)
   //     }
 //   }
    
//    var totalAccuracy: Double {
//        Double(correct) / Double(total) * 100
 //   }
    
//    var gamesCount: Int {
 //       get {
//            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
//        }
//        set {
 //           userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
 //       }
//    }
    
//    var bestGame: GameRecord? {
//        get {
//            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
//                   let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
 //           return .init(correct: 0, total: 0, date: Date())}
 //           return record
  //      }
  //      set {guard let data = try? JSONEncoder().encode(newValue) else {
  //          print("Невозможно сохранить результат")
  //          return
 //       }
        
 //       userDefaults.set(data, forKey: Keys.bestGame.rawValue)
//    }
        
 //   }
   }
    
extension StatisticServiceImplementation: StatisticService {
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var bestGame: GameRecord? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                 let bestGame = try? decoder.decode(GameRecord.self, from: data) else {
            return nil
        }
        
            return bestGame
        
    }
        set {
             let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
        
    }
    
    var totalAccuracy: Double {
        Double(correct) / Double(total) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let date = dateProvader()
        let currentBestGame = GameRecord(correct: correct, total: total, date: date)
        if let previousBestGame = bestGame {
            if currentBestGame > previousBestGame {
                bestGame = currentBestGame
            }
        } else {
            bestGame = currentBestGame
        }
    }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension GameRecord: Comparable {
    
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
    }
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
}

