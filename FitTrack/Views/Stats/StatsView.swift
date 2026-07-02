import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var store: AppStore
    @State private var rangeDays = 14
    @State private var showAddWeight = false
    @State private var newWeight = ""

    private var rangeStart: Date { Date().daysAgo(rangeDays - 1).startOfDay }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker("", selection: $rangeDays) {
                        Text(L("stats.range.week")).tag(7)
                        Text(L("stats.range.2weeks")).tag(14)
                        Text(L("stats.range.month")).tag(30)
                        Text(L("stats.range.3months")).tag(90)
                    }
                    .pickerStyle(.segmented)

                    weightCard
                    caloriesCard
                    workoutSummaryCard
                    macrosDonutCard
                    bmiCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(L("stats.title"))
            .alert(L("stats.addWeight"), isPresented: $showAddWeight) {
                TextField(L("stats.weight.ph"), text: $newWeight)
                    .keyboardType(.decimalPad)
                Button(L("common.save")) {
                    if let kg = Double(newWeight.replacingOccurrences(of: ",", with: ".")), kg > 20, kg < 300 {
                        store.logWeight(kg)
                    }
                    newWeight = ""
                }
                Button(L("common.cancel"), role: .cancel) { newWeight = "" }
            }
        }
    }

    // MARK: - Weight

    private var weightCard: some View {
        let entries = store.weights.filter { $0.date >= rangeStart }
        let delta: Double? = {
            guard let first = entries.first, let last = entries.last, entries.count > 1 else { return nil }
            return last.weightKg - first.weightKg
        }()

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(L("stats.weight"), systemImage: "scalemass.fill")
                    .font(.headline)
                Spacer()
                if let delta {
                    Text(delta >= 0 ? "+\(delta.clean) \(L("unit.kg"))" : "\(delta.clean) \(L("unit.kg"))")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(delta > 0 ? .orange : .brand)
                }
                Button {
                    showAddWeight = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }

            if entries.count < 2 {
                Text(L("stats.weight.empty"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Chart(entries) { entry in
                    LineMark(
                        x: .value("Дата", entry.date),
                        y: .value("Вага", entry.weightKg))
                    .foregroundStyle(Color.purple)
                    .interpolationMethod(.catmullRom)
                    PointMark(
                        x: .value("Дата", entry.date),
                        y: .value("Вага", entry.weightKg))
                    .foregroundStyle(Color.purple)
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 170)
            }
        }
        .card()
    }

    // MARK: - Calories

    private struct DayStat: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
    }

    private var caloriesCard: some View {
        let days = min(rangeDays, 14)
        let stats: [DayStat] = (0..<days).reversed().map { back in
            let day = Date().daysAgo(back)
            return DayStat(date: day.startOfDay, value: store.nutrition(on: day).kcal)
        }
        let target = Double(store.profile.calorieTarget)

        return VStack(alignment: .leading, spacing: 12) {
            Label(L("stats.calories"), systemImage: "flame.fill")
                .font(.headline)
            Chart {
                ForEach(stats) { stat in
                    BarMark(
                        x: .value("Дата", stat.date, unit: .day),
                        y: .value("Ккал", stat.value))
                    .foregroundStyle(stat.value > target ? Color.red.opacity(0.8) : Color.orange)
                    .cornerRadius(4)
                }
                RuleMark(y: .value("Ціль", target))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5]))
                    .foregroundStyle(.secondary)
                    .annotation(position: .top, alignment: .trailing) {
                        Text(L("stats.goalLine", Int(target)))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
            }
            .frame(height: 170)
        }
        .card()
    }

    // MARK: - Workouts

    private var workoutSummaryCard: some View {
        let inRange = store.sessions.filter { $0.date >= rangeStart }
        let totalMinutes = inRange.reduce(0) { $0 + $1.durationSec } / 60
        let totalKcal = inRange.reduce(0) { $0 + $1.calories }
        let volume = inRange.reduce(0.0) { $0 + $1.totalVolume }

        let volumeStats: [DayStat] = (0..<min(rangeDays, 14)).reversed().map { back in
            let day = Date().daysAgo(back)
            let v = store.sessions(on: day).reduce(0.0) { $0 + $1.totalVolume }
            return DayStat(date: day.startOfDay, value: v)
        }

        return VStack(alignment: .leading, spacing: 12) {
            Label(L("stats.workouts"), systemImage: "dumbbell.fill")
                .font(.headline)
            HStack(spacing: 12) {
                metricTile(value: "\(inRange.count)", label: L("stats.metric.workouts"))
                metricTile(value: "\(totalMinutes)", label: L("stats.metric.minutes"))
                metricTile(value: "\(totalKcal)", label: L("stats.metric.kcal"))
                metricTile(value: "\(Int(volume))", label: L("stats.metric.volume"))
            }
            if volumeStats.contains(where: { $0.value > 0 }) {
                Chart(volumeStats) { stat in
                    BarMark(
                        x: .value("Дата", stat.date, unit: .day),
                        y: .value("Об'єм", stat.value))
                    .foregroundStyle(Color.brand)
                    .cornerRadius(4)
                }
                .frame(height: 140)
            }
        }
        .card()
    }

    private func metricTile(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline.bold())
                .monospacedDigit()
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Today's Macros

    private struct MacroSlice: Identifiable {
        let id = UUID()
        let name: String
        let grams: Double
        let color: Color
    }

    private var macrosDonutCard: some View {
        let n = store.nutrition(on: Date())
        let slices = [
            MacroSlice(name: L("target.protein"), grams: max(0.01, n.protein), color: .red),
            MacroSlice(name: L("target.fat"), grams: max(0.01, n.fat), color: .yellow),
            MacroSlice(name: L("target.carbs"), grams: max(0.01, n.carbs), color: .brand),
        ]

        return VStack(alignment: .leading, spacing: 12) {
            Label(L("stats.macros"), systemImage: "chart.pie.fill")
                .font(.headline)
            if n.kcal == 0 {
                Text(L("stats.macros.empty"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                HStack(spacing: 20) {
                    Chart(slices) { slice in
                        SectorMark(
                            angle: .value("г", slice.grams),
                            innerRadius: .ratio(0.6),
                            angularInset: 2)
                        .foregroundStyle(slice.color)
                        .cornerRadius(3)
                    }
                    .frame(width: 130, height: 130)

                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(slices) { slice in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(slice.color)
                                    .frame(width: 10, height: 10)
                                Text(slice.name)
                                    .font(.caption)
                                Spacer()
                                Text("\(Int(slice.grams)) \(L("unit.g"))")
                                    .font(.caption.weight(.semibold))
                            }
                        }
                    }
                }
            }
        }
        .card()
    }

    // MARK: - BMI

    private var bmiCard: some View {
        let bmi = store.profile.bmi
        let progress = min(1, max(0, (bmi - 14) / 22))

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(L("stats.bmi"), systemImage: "figure.arms.open")
                    .font(.headline)
                Spacer()
                Text(bmi.clean)
                    .font(.title3.bold())
                Text(store.profile.bmiCategory)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    LinearGradient(
                        colors: [.blue, .brand, .yellow, .orange, .red],
                        startPoint: .leading, endPoint: .trailing)
                    .clipShape(Capsule())
                    Circle()
                        .fill(.white)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color.primary.opacity(0.3), lineWidth: 1))
                        .offset(x: geo.size.width * progress - 7)
                }
            }
            .frame(height: 14)
            HStack {
                Text("18.5").font(.caption2).foregroundStyle(.secondary)
                Spacer()
                Text("25").font(.caption2).foregroundStyle(.secondary)
                Spacer()
                Text("30").font(.caption2).foregroundStyle(.secondary)
            }
        }
        .card()
    }
}
