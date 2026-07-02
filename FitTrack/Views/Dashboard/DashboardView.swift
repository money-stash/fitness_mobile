import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var store: AppStore

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return L("greeting.morning")
        case 12..<18: return L("greeting.day")
        case 18..<23: return L("greeting.evening")
        default: return L("greeting.night")
        }
    }

    private var navTitle: String {
        let first = store.profile.name.components(separatedBy: " ").first ?? ""
        return store.profile.name.isEmpty ? "\(greeting)!" : "\(greeting), \(first)!"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    caloriesCard
                    waterCard
                    todayWorkoutCard
                    statsRow
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(navTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        avatarView
                    }
                }
            }
        }
    }

    private var avatarView: some View {
        ZStack {
            Circle().fill(Color.brand.opacity(0.2))
            Text(store.profile.initials.isEmpty ? "🙂" : store.profile.initials)
                .font(.caption.bold())
                .foregroundStyle(.brand)
        }
        .frame(width: 34, height: 34)
    }

    // MARK: - Calories and Macros

    private var caloriesCard: some View {
        let n = store.nutrition(on: Date())
        let target = store.profile.calorieTarget
        let progress = target > 0 ? n.kcal / Double(target) : 0

        return VStack(alignment: .leading, spacing: 12) {
            Text(Date().fullLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(spacing: 20) {
                ZStack {
                    RingView(progress: progress, lineWidth: 14, color: .orange)
                    VStack(spacing: 2) {
                        Text("\(Int(n.kcal))")
                            .font(.title2.bold())
                        Text("\(L("stats.goalLine", target))")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 120, height: 120)

                VStack(spacing: 12) {
                    MacroBar(title: L("target.protein"), value: n.protein,
                             target: Double(store.profile.proteinTarget), color: .red)
                    MacroBar(title: L("target.fat"), value: n.fat,
                             target: Double(store.profile.fatTarget), color: .yellow)
                    MacroBar(title: L("target.carbs"), value: n.carbs,
                             target: Double(store.profile.carbsTarget), color: .brand)
                }
            }
        }
        .card()
    }

    // MARK: - Water

    private var waterCard: some View {
        let current = store.water(on: Date())
        let target = store.profile.waterTargetMl
        let progress = target > 0 ? Double(current) / Double(target) : 0

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(L("target.water"), systemImage: "drop.fill")
                    .font(.headline)
                    .foregroundStyle(.blue)
                Spacer()
                Text("\(current) / \(target) \(L("unit.ml"))")
                    .font(.subheadline.weight(.medium))
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.blue.opacity(0.15))
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * min(1, progress))
                        .animation(.easeOut, value: progress)
                }
            }
            .frame(height: 10)
            HStack(spacing: 10) {
                waterButton(250)
                waterButton(500)
                Spacer()
                if current > 0 {
                    Button {
                        if let last = store.waterEntries.lastIndex(where: { $0.date.isSameDay(as: Date()) }) {
                            store.waterEntries.remove(at: last)
                        }
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .card()
    }

    private func waterButton(_ ml: Int) -> some View {
        Button("+\(ml) \(L("unit.ml"))") { store.addWater(ml) }
            .font(.caption.weight(.semibold))
            .buttonStyle(.bordered)
            .tint(.blue)
    }

    // MARK: - Today's Workout

    @ViewBuilder
    private var todayWorkoutCard: some View {
        let todaySessions = store.sessions(on: Date())
        if let done = todaySessions.last {
            VStack(alignment: .leading, spacing: 8) {
                Label(L("dash.workout.done"), systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(.brand)
                Text(done.name)
                    .font(.subheadline)
                HStack(spacing: 16) {
                    Label(done.durationSec.durationLabel, systemImage: "clock")
                    Label("\(done.calories) \(L("unit.kcal"))", systemImage: "flame")
                    Label("\(Int(done.totalVolume)) \(L("unit.kg"))", systemImage: "scalemass")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .card()
        } else if let suggestion = store.allTemplates.first {
            NavigationLink {
                TemplateDetailView(template: suggestion)
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    Label(L("dash.today.workout"), systemImage: "dumbbell.fill")
                        .font(.headline)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(suggestion.name)
                                .font(.subheadline.weight(.semibold))
                            Text(L("dash.workout.meta", suggestion.exercises.count, suggestion.estMinutes, suggestion.level))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .card()
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Mini Stats

    private var statsRow: some View {
        HStack(spacing: 12) {
            statTile(icon: "flame.fill", color: .orange,
                     value: "\(store.streak)",
                     label: store.streak == 1 ? L("dash.streak.one") : L("dash.streak.many"))
            statTile(icon: "dumbbell.fill", color: .brand,
                     value: "\(store.sessionsThisWeek)",
                     label: L("dash.week"))
            statTile(icon: "scalemass.fill", color: .purple,
                     value: store.profile.weightKg.clean,
                     label: L("dash.kg.now"))
        }
    }

    private func statTile(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .card()
    }
}
