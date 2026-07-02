import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject var store: AppStore

    private var sorted: [WorkoutSession] {
        store.sessions.sorted { $0.date > $1.date }
    }

    var body: some View {
        if sorted.isEmpty {
            ContentUnavailableView(
                L("history.empty.title"),
                systemImage: "clock.arrow.circlepath",
                description: Text(L("history.empty.desc")))
        } else {
            List {
                ForEach(sorted) { session in
                    NavigationLink {
                        SessionDetailView(session: session)
                    } label: {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(session.localizedName)
                                .font(.subheadline.weight(.semibold))
                            Text(session.date.timeLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack(spacing: 14) {
                                Label(session.durationSec.durationLabel, systemImage: "clock")
                                Label("\(session.calories) \(L("unit.kcal"))", systemImage: "flame")
                                Label("\(Int(session.totalVolume)) \(L("unit.kg"))", systemImage: "scalemass")
                            }
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .onDelete { offsets in
                    let ids = offsets.map { sorted[$0].id }
                    store.sessions.removeAll { ids.contains($0.id) }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct SessionDetailView: View {
    @EnvironmentObject var store: AppStore
    let session: WorkoutSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    summaryTile(icon: "clock.fill", value: session.durationSec.durationLabel, label: L("sess.duration"))
                    summaryTile(icon: "flame.fill", value: "\(session.calories)", label: L("unit.kcal"))
                    summaryTile(icon: "scalemass.fill", value: "\(Int(session.totalVolume))", label: L("sess.volume"))
                }

                ForEach(session.exercises) { we in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.exercise(we.exerciseID)?.name ?? "")
                            .font(.headline)
                        ForEach(Array(we.sets.enumerated()), id: \.element.id) { index, set in
                            HStack {
                                Text(L("sess.set", index + 1))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(set.reps) × \(set.weight.clean) \(L("unit.kg"))")
                                    .monospacedDigit()
                                Image(systemName: set.done ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(set.done ? .brand : .secondary)
                                    .font(.caption)
                            }
                            .font(.subheadline)
                        }
                    }
                    .card()
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(session.localizedName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func summaryTile(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(.brand)
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .card()
    }
}
