import SwiftUI

struct AddFoodView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    let date: Date
    let meal: MealType

    @State private var search = ""
    @State private var selectedFood: FoodItem?
    @State private var showCreateFood = false

    private var filtered: [FoodItem] {
        let list = store.allFoods
        guard !search.isEmpty else { return list }
        return list.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        showCreateFood = true
                    } label: {
                        Label(L("food.create"), systemImage: "plus.circle")
                    }
                }
                ForEach(FoodCategory.allCases) { category in
                    let items = filtered.filter { $0.category == category }
                    if !items.isEmpty {
                        Section(category.title) {
                            ForEach(items) { item in
                                Button {
                                    selectedFood = item
                                } label: {
                                    foodRow(item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle(meal.title)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $search, prompt: L("food.search"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L("common.close")) { dismiss() }
                }
            }
            .sheet(item: $selectedFood) { food in
                PortionSheet(food: food, date: date, meal: meal) {
                    dismiss()
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showCreateFood) {
                CreateFoodView()
            }
        }
    }

    private func foodRow(_ item: FoodItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline)
                Text(L("food.per100", item.protein.clean, item.fat.clean, item.carbs.clean))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(Int(item.kcal))")
                .font(.subheadline.weight(.semibold))
            Text(L("unit.kcal"))
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Portion Selection

struct PortionSheet: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    let food: FoodItem
    let date: Date
    let meal: MealType
    var onAdded: () -> Void

    @State private var grams: Double = 100

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack(spacing: 12) {
                    macroTile(L("unit.kcal"), food.kcal * grams / 100, color: .orange)
                    macroTile(L("target.protein"), food.protein * grams / 100, color: .red)
                    macroTile(L("target.fat"), food.fat * grams / 100, color: .yellow)
                    macroTile(L("target.carbs"), food.carbs * grams / 100, color: .brand)
                }

                VStack(spacing: 8) {
                    Text("\(Int(grams)) \(L("unit.g"))")
                        .font(.title.bold())
                    Slider(value: $grams, in: 10...600, step: 5)
                    HStack(spacing: 8) {
                        ForEach([50.0, 100, 150, 200, 300], id: \.self) { preset in
                            Button("\(Int(preset))") { grams = preset }
                                .font(.caption.weight(.semibold))
                                .buttonStyle(.bordered)
                        }
                    }
                }

                Button {
                    store.foodEntries.append(FoodEntry(date: date, meal: meal, foodID: food.id, grams: grams))
                    dismiss()
                    onAdded()
                } label: {
                    Label(L("portion.addTo", meal.title), systemImage: "plus")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle(food.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func macroTile(_ title: String, _ value: Double, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value.clean)
                .font(.headline)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Food Creation

struct CreateFoodView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var kcal: Double = 0
    @State private var protein: Double = 0
    @State private var fat: Double = 0
    @State private var carbs: Double = 0
    @State private var category: FoodCategory = .snack

    var body: some View {
        NavigationStack {
            Form {
                Section(L("cf.name")) {
                    TextField(L("cf.name.ph"), text: $name)
                }
                Section(L("cf.per100")) {
                    LabeledContent(L("target.calories")) {
                        TextField("0", value: $kcal, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent(L("cf.protein")) {
                        TextField("0", value: $protein, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent(L("cf.fat")) {
                        TextField("0", value: $fat, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent(L("cf.carbs")) {
                        TextField("0", value: $carbs, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Section(L("cf.category")) {
                    Picker(L("cf.category"), selection: $category) {
                        ForEach(FoodCategory.allCases) { c in
                            Text(c.title).tag(c)
                        }
                    }
                }
            }
            .navigationTitle(L("cf.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L("common.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("common.save")) {
                        let item = FoodItem(
                            id: "custom-\(UUID().uuidString)",
                            name: name.trimmingCharacters(in: .whitespaces),
                            kcal: kcal, protein: protein, fat: fat, carbs: carbs,
                            category: category)
                        store.customFoods.insert(item, at: 0)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || kcal <= 0)
                }
            }
        }
    }
}
