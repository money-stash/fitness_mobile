import Foundation
import SwiftUI

/// Container for all app data persisted on disk.
private struct AppData: Codable {
    var profile = UserProfile()
    var weights: [WeightEntry] = []
    var sessions: [WorkoutSession] = []
    var foodEntries: [FoodEntry] = []
    var waterEntries: [WaterEntry] = []
    var customTemplates: [WorkoutTemplate] = []
    var customFoods: [FoodItem] = []
    var bookings: [Booking] = []
}

private struct AppSettingsExport: Codable {
    var language: AppLanguage
    var theme: AppTheme
}

private struct AppExport: Codable {
    var exportedAt: Date
    var appName: String
    var appVersion: String
    var settings: AppSettingsExport
    var data: AppData
}

final class AppStore: ObservableObject {
    enum ImportError: Error, Equatable {
        case invalidFile
    }

    @Published var profile = UserProfile() { didSet { save() } }
    @Published var weights: [WeightEntry] = [] { didSet { save() } }
    @Published var sessions: [WorkoutSession] = [] { didSet { save() } }
    @Published var foodEntries: [FoodEntry] = [] { didSet { save() } }
    @Published var waterEntries: [WaterEntry] = [] { didSet { save() } }
    @Published var customTemplates: [WorkoutTemplate] = [] { didSet { save() } }
    @Published var customFoods: [FoodItem] = [] { didSet { save() } }
    @Published var bookings: [Booking] = [] { didSet { save() } }

    private var loaded = false

    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("fittrack.json")
    }

    init() {
        load()
    }

    // MARK: - Persistence

    private func load() {
        defer { loaded = true }
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode(AppData.self, from: data) else { return }
        apply(decoded, shouldSave: false)
    }

    private func save() {
        guard loaded else { return }
        saveCurrentData()
    }

    private func saveCurrentData() {
        var data = AppData()
        data.profile = profile
        data.weights = weights
        data.sessions = sessions
        data.foodEntries = foodEntries
        data.waterEntries = waterEntries
        data.customTemplates = customTemplates
        data.customFoods = customFoods
        data.bookings = bookings
        if let encoded = try? JSONEncoder().encode(data) {
            try? encoded.write(to: fileURL, options: .atomic)
        }
    }

    private var currentData: AppData {
        AppData(
            profile: profile,
            weights: weights,
            sessions: sessions,
            foodEntries: foodEntries,
            waterEntries: waterEntries,
            customTemplates: customTemplates,
            customFoods: customFoods,
            bookings: bookings)
    }

    func exportFile(settings: Settings) throws -> URL {
        saveCurrentData()

        let export = AppExport(
            exportedAt: Date(),
            appName: "FitTrack",
            appVersion: "1.0",
            settings: AppSettingsExport(language: settings.language, theme: settings.theme),
            data: currentData)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(export)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd-HHmmss"

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("fittrack-export-\(formatter.string(from: Date())).json")
        try data.write(to: url, options: .atomic)
        return url
    }

    func importFile(_ url: URL, settings: Settings) throws {
        let isSecurityScoped = url.startAccessingSecurityScopedResource()
        defer {
            if isSecurityScoped {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let fileData = try Data(contentsOf: url)
        if let export = try? decode(AppExport.self, from: fileData) {
            settings.language = export.settings.language
            settings.theme = export.settings.theme
            apply(export.data, shouldSave: true)
            return
        }

        if let appData = try? decode(AppData.self, from: fileData) {
            apply(appData, shouldSave: true)
            return
        }

        throw ImportError.invalidFile
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let isoDecoder = JSONDecoder()
        isoDecoder.dateDecodingStrategy = .iso8601
        if let decoded = try? isoDecoder.decode(type, from: data) {
            return decoded
        }
        return try JSONDecoder().decode(type, from: data)
    }

    private func apply(_ data: AppData, shouldSave: Bool) {
        let wasLoaded = loaded
        loaded = false
        profile = data.profile
        weights = data.weights
        sessions = data.sessions
        foodEntries = data.foodEntries
        waterEntries = data.waterEntries
        customTemplates = data.customTemplates
        customFoods = data.customFoods
        bookings = data.bookings
        loaded = wasLoaded
        if shouldSave {
            saveCurrentData()
        }
    }

    // MARK: - Lookup Data

    var allTemplates: [WorkoutTemplate] { customTemplates + SeedData.templates }
    var allFoods: [FoodItem] { customFoods + SeedData.foods }

    func exercise(_ id: String) -> Exercise? {
        SeedData.exercises.first { $0.id == id }
    }

    func food(_ id: String) -> FoodItem? {
        allFoods.first { $0.id == id }
    }

    func trainer(_ id: String) -> Trainer? {
        SeedData.trainers.first { $0.id == id }
    }

    // MARK: - Nutrition

    func foodEntries(on date: Date) -> [FoodEntry] {
        foodEntries.filter { $0.date.isSameDay(as: date) }
    }

    func nutrition(on date: Date) -> (kcal: Double, protein: Double, fat: Double, carbs: Double) {
        var total = (kcal: 0.0, protein: 0.0, fat: 0.0, carbs: 0.0)
        for entry in foodEntries(on: date) {
            guard let item = food(entry.foodID) else { continue }
            let k = entry.grams / 100
            total.kcal += item.kcal * k
            total.protein += item.protein * k
            total.fat += item.fat * k
            total.carbs += item.carbs * k
        }
        return total
    }

    func water(on date: Date) -> Int {
        waterEntries.filter { $0.date.isSameDay(as: date) }.reduce(0) { $0 + $1.ml }
    }

    func waterEntries(on date: Date) -> [WaterEntry] {
        waterEntries
            .filter { $0.date.isSameDay(as: date) }
            .sorted { $0.date > $1.date }
    }

    func addWater(_ ml: Int, on date: Date = Date()) {
        waterEntries.append(WaterEntry(date: date, ml: ml))
    }

    @discardableResult
    func undoLastWater(on date: Date = Date()) -> Bool {
        guard let last = waterEntries.lastIndex(where: { $0.date.isSameDay(as: date) }) else {
            return false
        }
        waterEntries.remove(at: last)
        return true
    }

    // MARK: - Workouts

    func sessions(on date: Date) -> [WorkoutSession] {
        sessions.filter { $0.date.isSameDay(as: date) }
    }

    var sessionsThisWeek: Int {
        let weekAgo = Date().daysAgo(6).startOfDay
        return sessions.filter { $0.date >= weekAgo }.count
    }

    var totalVolume: Double {
        sessions.reduce(0) { $0 + $1.totalVolume }
    }

    /// Counts consecutive workout days ending today or yesterday.
    var streak: Int {
        var count = 0
        var day = Date().startOfDay
        if sessions(on: day).isEmpty {
            day = day.daysAgo(1)
        }
        while !sessions(on: day).isEmpty {
            count += 1
            day = day.daysAgo(1)
        }
        return count
    }

    func finishSession(name: String, startedAt: Date, exercises: [WorkoutExercise]) {
        let duration = Int(Date().timeIntervalSince(startedAt))
        let mets = exercises.compactMap { exercise($0.exerciseID)?.met }
        let avgMet = mets.isEmpty ? 5.0 : mets.reduce(0, +) / Double(mets.count)
        let kcal = Int(avgMet * profile.weightKg * Double(duration) / 3600)
        let session = WorkoutSession(
            name: name, date: Date(), durationSec: duration,
            exercises: exercises, calories: kcal)
        sessions.append(session)
    }

    // MARK: - Weight

    func logWeight(_ kg: Double, on date: Date = Date()) {
        weights.append(WeightEntry(date: date, weightKg: kg))
        weights.sort { $0.date < $1.date }
        profile.weightKg = weights.last?.weightKg ?? kg
    }

    // MARK: - Achievements

    var achievements: [Achievement] {
        let waterGoalDays = Set(waterEntries.map(\.date.startOfDay)).filter { day in
            water(on: day) >= profile.waterTargetMl
        }.count
        return [
            Achievement(id: "first", title: L("ach.first.title"), subtitle: L("ach.first.sub"),
                        icon: "figure.walk", unlocked: sessions.count >= 1),
            Achievement(id: "five", title: L("ach.five.title"), subtitle: L("ach.five.sub"),
                        icon: "flame.fill", unlocked: sessions.count >= 5),
            Achievement(id: "twenty", title: L("ach.twenty.title"), subtitle: L("ach.twenty.sub"),
                        icon: "bolt.fill", unlocked: sessions.count >= 20),
            Achievement(id: "streak3", title: L("ach.streak3.title"), subtitle: L("ach.streak3.sub"),
                        icon: "calendar", unlocked: streak >= 3),
            Achievement(id: "streak7", title: L("ach.streak7.title"), subtitle: L("ach.streak7.sub"),
                        icon: "crown.fill", unlocked: streak >= 7),
            Achievement(id: "volume10", title: L("ach.volume10.title"), subtitle: L("ach.volume10.sub"),
                        icon: "scalemass.fill", unlocked: totalVolume >= 10_000),
            Achievement(id: "hydration", title: L("ach.hydration.title"), subtitle: L("ach.hydration.sub"),
                        icon: "drop.fill", unlocked: waterGoalDays >= 1),
            Achievement(id: "chronicler", title: L("ach.chronicler.title"), subtitle: L("ach.chronicler.sub"),
                        icon: "chart.xyaxis.line", unlocked: weights.count >= 10),
            Achievement(id: "foodie", title: L("ach.foodie.title"), subtitle: L("ach.foodie.sub"),
                        icon: "fork.knife.circle.fill", unlocked: foodEntries.count >= 50),
            Achievement(id: "booked", title: L("ach.booked.title"), subtitle: L("ach.booked.sub"),
                        icon: "person.2.fill", unlocked: !bookings.isEmpty),
        ]
    }

    // MARK: - Demo Data and Reset

    /// Fills the last 14 days with plausible demo data so charts have useful content.
    func fillDemoData() {
        let templates = SeedData.templates
        for daysBack in (0...13).reversed() {
            let day = Date().daysAgo(daysBack)
            // Weight with a gentle trend.
            let drift = Double(daysBack) * 0.08
            let noise = Double.random(in: -0.3...0.3)
            weights.append(WeightEntry(date: day, weightKg: profile.weightKg + drift + noise))
            // Workouts roughly every other day.
            if daysBack % 2 == 0, let template = templates.randomElement() {
                var exs = template.exercises
                for i in exs.indices {
                    for j in exs[i].sets.indices { exs[i].sets[j].done = true }
                }
                let duration = Int.random(in: 2400...4200)
                let kcal = Int.random(in: 250...500)
                sessions.append(WorkoutSession(
                    name: template.nameEn, date: day, durationSec: duration,
                    exercises: exs, calories: kcal))
            }
            // Food entries.
            let picks: [(MealType, String, Double)] = [
                (.breakfast, "oatmeal", 250), (.breakfast, "eggs", 110), (.breakfast, "banana", 120),
                (.lunch, "chicken-breast", 180), (.lunch, "buckwheat", 250), (.lunch, "salad-mix", 100),
                (.dinner, "salmon", 150), (.dinner, "rice", 200), (.dinner, "broccoli", 150),
                (.snack, "greek-yogurt", 150), (.snack, "nuts", 30),
            ]
            for (meal, foodID, grams) in picks where Double.random(in: 0...1) > 0.15 {
                foodEntries.append(FoodEntry(
                    date: day, meal: meal, foodID: foodID,
                    grams: grams * Double.random(in: 0.8...1.2)))
            }
            // Water entries.
            for _ in 0..<Int.random(in: 5...9) {
                waterEntries.append(WaterEntry(date: day, ml: 250))
            }
        }
        weights.sort { $0.date < $1.date }
    }

    func resetAll() {
        profile = UserProfile()
        weights = []
        sessions = []
        foodEntries = []
        waterEntries = []
        customTemplates = []
        customFoods = []
        bookings = []
    }
}
