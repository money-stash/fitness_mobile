import SwiftUI

struct NutritionView: View {
    @EnvironmentObject var store: AppStore
    @State private var date = Date()
    @State private var addMeal: MealType?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    dateSelector
                    summaryCard
                    ForEach(MealType.allCases) { meal in
                        mealSection(meal)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(L("nutr.title"))
            .sheet(item: $addMeal) { meal in
                AddFoodView(date: date, meal: meal)
            }
        }
    }

    // MARK: - Date Selection

    private var dateSelector: some View {
        HStack {
            Button {
                date = date.daysAgo(1)
            } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            VStack(spacing: 2) {
                Text(date.isSameDay(as: Date()) ? L("nutr.today") : date.fullLabel)
                    .font(.headline)
                if !date.isSameDay(as: Date()) {
                    Button(L("nutr.toToday")) { date = Date() }
                        .font(.caption)
                }
            }
            Spacer()
            Button {
                date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(date.isSameDay(as: Date()))
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Daily Summary

    private var summaryCard: some View {
        let n = store.nutrition(on: date)
        let target = store.profile.calorieTarget
        let left = Double(target) - n.kcal

        return VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(Int(n.kcal)) \(L("unit.kcal"))")
                        .font(.title2.bold())
                    Text(left >= 0 ? L("nutr.left", Int(left)) : L("nutr.over", Int(-left)))
                        .font(.caption)
                        .foregroundStyle(left >= 0 ? Color.secondary : Color.red)
                }
                Spacer()
                ZStack {
                    RingView(progress: target > 0 ? n.kcal / Double(target) : 0,
                             lineWidth: 8, color: left >= 0 ? .orange : .red)
                    Text("\(Int((target > 0 ? n.kcal / Double(target) : 0) * 100))%")
                        .font(.caption.bold())
                }
                .frame(width: 54, height: 54)
            }
            HStack(spacing: 12) {
                MacroBar(title: L("macro.p.short"), value: n.protein,
                         target: Double(store.profile.proteinTarget), color: .red)
                MacroBar(title: L("macro.f.short"), value: n.fat,
                         target: Double(store.profile.fatTarget), color: .yellow)
                MacroBar(title: L("macro.c.short"), value: n.carbs,
                         target: Double(store.profile.carbsTarget), color: .brand)
            }
        }
        .card()
    }

    // MARK: - Meal

    private func mealSection(_ meal: MealType) -> some View {
        let entries = store.foodEntries(on: date).filter { $0.meal == meal }
        let kcal = entries.reduce(0.0) { sum, e in
            sum + (store.food(e.foodID).map { $0.kcal * e.grams / 100 } ?? 0)
        }

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(meal.title, systemImage: meal.icon)
                    .font(.headline)
                Spacer()
                if kcal > 0 {
                    Text("\(Int(kcal)) \(L("unit.kcal"))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Button {
                    addMeal = meal
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }

            if entries.isEmpty {
                Text(L("nutr.empty"))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(entries) { entry in
                    if let item = store.food(entry.foodID) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.name)
                                    .font(.subheadline)
                                Text(L("nutr.entryMeta", Int(entry.grams), (item.protein * entry.grams / 100).clean, (item.fat * entry.grams / 100).clean, (item.carbs * entry.grams / 100).clean))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(Int(item.kcal * entry.grams / 100))")
                                .font(.subheadline.weight(.medium))
                                .monospacedDigit()
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                store.foodEntries.removeAll { $0.id == entry.id }
                            } label: {
                                Label(L("common.delete"), systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .card()
    }
}
