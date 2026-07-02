import Foundation
import SwiftUI

// MARK: - User Profile

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male, female
    var id: String { rawValue }
    var title: String { L(self == .male ? "gender.male" : "gender.female") }
    var icon: String { self == .male ? "figure.stand" : "figure.stand.dress" }
}

enum Goal: String, Codable, CaseIterable, Identifiable {
    case lose, maintain, gain
    var id: String { rawValue }
    var title: String {
        switch self {
        case .lose: return L("goal.lose")
        case .maintain: return L("goal.maintain")
        case .gain: return L("goal.gain")
        }
    }
    var icon: String {
        switch self {
        case .lose: return "arrow.down.circle.fill"
        case .maintain: return "equal.circle.fill"
        case .gain: return "arrow.up.circle.fill"
        }
    }
    var calorieFactor: Double {
        switch self {
        case .lose: return 0.85
        case .maintain: return 1.0
        case .gain: return 1.15
        }
    }
}

enum ActivityLevel: String, Codable, CaseIterable, Identifiable {
    case sedentary, light, moderate, active, athlete
    var id: String { rawValue }
    var title: String {
        switch self {
        case .sedentary: return L("activity.sedentary")
        case .light: return L("activity.light")
        case .moderate: return L("activity.moderate")
        case .active: return L("activity.active")
        case .athlete: return L("activity.athlete")
        }
    }
    var factor: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .active: return 1.725
        case .athlete: return 1.9
        }
    }
}

struct UserProfile: Codable {
    var name: String = ""
    var gender: Gender = .male
    var age: Int = 25
    var heightCm: Double = 175
    var weightKg: Double = 70
    var goal: Goal = .maintain
    var activity: ActivityLevel = .moderate
    var onboarded: Bool = false
    var customCalorieTarget: Int?
    var customProteinTarget: Int?
    var customFatTarget: Int?
    var customCarbsTarget: Int?
    var customWaterTargetMl: Int?

    /// Basal metabolic rate calculated with the Mifflin-St Jeor formula.
    var bmr: Double {
        let base = 10 * weightKg + 6.25 * heightCm - 5 * Double(age)
        return gender == .male ? base + 5 : base - 161
    }

    var tdee: Double { bmr * activity.factor }

    var recommendedCalorieTarget: Int { Int(tdee * goal.calorieFactor) }

    var calorieTarget: Int { customCalorieTarget ?? recommendedCalorieTarget }

    var recommendedProteinTarget: Int {
        let perKg = goal == .lose ? 2.0 : 1.8
        return Int(weightKg * perKg)
    }

    var proteinTarget: Int { customProteinTarget ?? recommendedProteinTarget }

    var recommendedFatTarget: Int { Int(Double(recommendedCalorieTarget) * 0.25 / 9) }

    var fatTarget: Int { customFatTarget ?? recommendedFatTarget }

    var recommendedCarbsTarget: Int {
        let rest = Double(recommendedCalorieTarget) - Double(recommendedProteinTarget) * 4 - Double(recommendedFatTarget) * 9
        return max(0, Int(rest / 4))
    }

    var carbsTarget: Int { customCarbsTarget ?? recommendedCarbsTarget }

    var recommendedWaterTargetMl: Int { Int(weightKg * 33 / 50) * 50 }

    var waterTargetMl: Int { customWaterTargetMl ?? recommendedWaterTargetMl }

    var bmi: Double {
        let h = heightCm / 100
        return h > 0 ? weightKg / (h * h) : 0
    }

    var bmiCategory: String {
        switch bmi {
        case ..<18.5: return L("bmi.under")
        case ..<25: return L("bmi.normal")
        case ..<30: return L("bmi.over")
        default: return L("bmi.obese")
        }
    }

    var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        return parts.map { String($0.prefix(1)).uppercased() }.joined()
    }
}

struct WeightEntry: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var weightKg: Double
}

// MARK: - Workouts

enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case chest, back, legs, shoulders, arms, core, cardio, fullBody
    var id: String { rawValue }
    var title: String {
        switch self {
        case .chest: return L("muscle.chest")
        case .back: return L("muscle.back")
        case .legs: return L("muscle.legs")
        case .shoulders: return L("muscle.shoulders")
        case .arms: return L("muscle.arms")
        case .core: return L("muscle.core")
        case .cardio: return L("muscle.cardio")
        case .fullBody: return L("muscle.fullBody")
        }
    }
    var icon: String {
        switch self {
        case .chest: return "figure.arms.open"
        case .back: return "figure.climbing"
        case .legs: return "figure.walk"
        case .shoulders: return "figure.wave"
        case .arms: return "figure.boxing"
        case .core: return "figure.core.training"
        case .cardio: return "figure.run"
        case .fullBody: return "figure.mixed.cardio"
        }
    }
}

struct Exercise: Codable, Identifiable, Hashable {
    let id: String
    let nameUk: String
    let nameEn: String
    let group: MuscleGroup
    let equipmentUk: String
    let equipmentEn: String
    /// Difficulty scale: 1 is easy, 3 is hard.
    let difficulty: Int
    /// Metabolic equivalent used to estimate calories burned.
    let met: Double
    let tipsUk: String
    let tipsEn: String

    var name: String { Settings.shared.language == .en ? nameEn : nameUk }
    var equipment: String { Settings.shared.language == .en ? equipmentEn : equipmentUk }
    var tips: String { Settings.shared.language == .en ? tipsEn : tipsUk }
}

struct SetEntry: Codable, Identifiable, Hashable {
    var id = UUID()
    var reps: Int
    var weight: Double
    var done: Bool = false
}

struct WorkoutExercise: Codable, Identifiable, Hashable {
    var id = UUID()
    var exerciseID: String
    var sets: [SetEntry]
    var restSec: Int = 90
}

struct WorkoutTemplate: Codable, Identifiable, Hashable {
    var id = UUID()
    var nameUk: String
    var nameEn: String
    var subtitleUk: String
    var subtitleEn: String
    var levelUk: String
    var levelEn: String
    var exercises: [WorkoutExercise]
    var isCustom: Bool = false

    private var en: Bool { Settings.shared.language == .en }
    var name: String { en ? nameEn : nameUk }
    var subtitle: String { en ? subtitleEn : subtitleUk }
    var level: String { en ? levelEn : levelUk }

    var estMinutes: Int {
        let sets = exercises.reduce(0) { $0 + $1.sets.count }
        return max(10, sets * 3)
    }

    /// For bilingual seed data.
    init(nameUk: String, nameEn: String, subtitleUk: String, subtitleEn: String,
         levelUk: String, levelEn: String, exercises: [WorkoutExercise], isCustom: Bool = false) {
        self.nameUk = nameUk
        self.nameEn = nameEn
        self.subtitleUk = subtitleUk
        self.subtitleEn = subtitleEn
        self.levelUk = levelUk
        self.levelEn = levelEn
        self.exercises = exercises
        self.isCustom = isCustom
    }

    /// For user-created workouts, where one title is used for both languages.
    init(name: String, subtitleUk: String, subtitleEn: String,
         levelUk: String, levelEn: String, exercises: [WorkoutExercise], isCustom: Bool) {
        self.nameUk = name
        self.nameEn = name
        self.subtitleUk = subtitleUk
        self.subtitleEn = subtitleEn
        self.levelUk = levelUk
        self.levelEn = levelEn
        self.exercises = exercises
        self.isCustom = isCustom
    }
}

struct WorkoutSession: Codable, Identifiable {
    var id = UUID()
    var name: String
    var date: Date
    var durationSec: Int
    var exercises: [WorkoutExercise]
    var calories: Int

    var doneSets: Int {
        exercises.reduce(0) { $0 + $1.sets.filter(\.done).count }
    }

    var totalVolume: Double {
        exercises.reduce(0) { sum, ex in
            sum + ex.sets.filter(\.done).reduce(0) { $0 + Double($1.reps) * $1.weight }
        }
    }

    var localizedName: String {
        if let template = SeedData.templates.first(where: { $0.nameEn == name || $0.nameUk == name }) {
            return template.name
        }
        return name
    }
}

// MARK: - Nutrition

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast, lunch, dinner, snack
    var id: String { rawValue }
    var title: String {
        switch self {
        case .breakfast: return L("meal.breakfast")
        case .lunch: return L("meal.lunch")
        case .dinner: return L("meal.dinner")
        case .snack: return L("meal.snack")
        }
    }
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars.fill"
        case .snack: return "cup.and.saucer.fill"
        }
    }
}

enum FoodCategory: String, Codable, CaseIterable, Identifiable {
    case protein, grain, dairy, fruit, vegetable, snack, drink
    var id: String { rawValue }
    var title: String {
        switch self {
        case .protein: return L("foodcat.protein")
        case .grain: return L("foodcat.grain")
        case .dairy: return L("foodcat.dairy")
        case .fruit: return L("foodcat.fruit")
        case .vegetable: return L("foodcat.vegetable")
        case .snack: return L("foodcat.snack")
        case .drink: return L("foodcat.drink")
        }
    }
}

/// Nutrition values per 100 g.
struct FoodItem: Codable, Identifiable, Hashable {
    let id: String
    let nameUk: String
    let nameEn: String
    let kcal: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let category: FoodCategory

    var name: String { Settings.shared.language == .en ? nameEn : nameUk }

    /// For user-created foods, where one title is used for both languages.
    init(id: String, name: String, kcal: Double, protein: Double, fat: Double, carbs: Double, category: FoodCategory) {
        self.id = id
        self.nameUk = name
        self.nameEn = name
        self.kcal = kcal
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.category = category
    }

    /// For bilingual seed data.
    init(id: String, nameUk: String, nameEn: String, kcal: Double, protein: Double, fat: Double, carbs: Double, category: FoodCategory) {
        self.id = id
        self.nameUk = nameUk
        self.nameEn = nameEn
        self.kcal = kcal
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
        self.category = category
    }
}

struct FoodEntry: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var meal: MealType
    var foodID: String
    var grams: Double
}

struct WaterEntry: Codable, Identifiable {
    var id = UUID()
    var date: Date
    var ml: Int
}

// MARK: - Trainers

struct Trainer: Codable, Identifiable, Hashable {
    let id: String
    let nameUk: String
    let nameEn: String
    let specialtyUk: String
    let specialtyEn: String
    let bioUk: String
    let bioEn: String
    let rating: Double
    let reviewsCount: Int
    let pricePerHour: Int
    let yearsExp: Int
    let icon: String
    let colorName: String
    let tagsUk: [String]
    let tagsEn: [String]

    private var en: Bool { Settings.shared.language == .en }
    var name: String { en ? nameEn : nameUk }
    var specialty: String { en ? specialtyEn : specialtyUk }
    var bio: String { en ? bioEn : bioUk }
    var tags: [String] { en ? tagsEn : tagsUk }
}

struct Booking: Codable, Identifiable {
    var id = UUID()
    var trainerID: String
    var date: Date
    var note: String
}

// MARK: - Achievements

struct Achievement: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let unlocked: Bool
}
