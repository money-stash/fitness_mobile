import SwiftUI

struct ActiveWorkoutView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    let template: WorkoutTemplate

    @State private var exercises: [WorkoutExercise] = []
    @State private var startedAt = Date()
    @State private var elapsed = 0
    @State private var restRemaining = 0
    @State private var showCancelConfirm = false
    @State private var showFinishConfirm = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var doneSets: Int {
        exercises.reduce(0) { $0 + $1.sets.filter(\.done).count }
    }
    private var totalSets: Int {
        exercises.reduce(0) { $0 + $1.sets.count }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    headerCard
                    ForEach($exercises) { $we in
                        exerciseCard($we)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(template.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L("common.cancel"), role: .destructive) {
                        showCancelConfirm = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("active.finish")) {
                        showFinishConfirm = true
                    }
                    .bold()
                    .disabled(doneSets == 0)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if restRemaining > 0 {
                    restBar
                }
            }
            .confirmationDialog(L("active.cancelConfirm"), isPresented: $showCancelConfirm, titleVisibility: .visible) {
                Button(L("active.cancelYes"), role: .destructive) { dismiss() }
                Button(L("active.continue"), role: .cancel) {}
            }
            .confirmationDialog(L("active.finishConfirm"), isPresented: $showFinishConfirm, titleVisibility: .visible) {
                Button(L("active.saveWorkout")) {
                    store.finishSession(name: template.nameEn, startedAt: startedAt, exercises: exercises)
                    dismiss()
                }
                Button(L("active.notYet"), role: .cancel) {}
            }
        }
        .onAppear {
            if exercises.isEmpty {
                exercises = template.exercises
                startedAt = Date()
            }
        }
        .onReceive(timer) { _ in
            elapsed = Int(Date().timeIntervalSince(startedAt))
            if restRemaining > 0 { restRemaining -= 1 }
        }
        .interactiveDismissDisabled()
    }

    // MARK: - Header

    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(L("active.time"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(String(format: "%d:%02d", elapsed / 60, elapsed % 60))
                    .font(.title2.bold().monospacedDigit())
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(L("active.sets"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(doneSets) / \(totalSets)")
                    .font(.title2.bold().monospacedDigit())
                    .foregroundStyle(doneSets == totalSets && totalSets > 0 ? .brand : .primary)
            }
        }
        .card()
    }

    // MARK: - Exercise

    private func exerciseCard(_ we: Binding<WorkoutExercise>) -> some View {
        let exercise = store.exercise(we.wrappedValue.exerciseID)
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: exercise?.group.icon ?? "dumbbell")
                    .foregroundStyle(.brand)
                Text(exercise?.name ?? "")
                    .font(.headline)
                Spacer()
                Text(L("active.restSec", we.wrappedValue.restSec))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("#").frame(width: 24)
                Text(L("active.reps")).frame(maxWidth: .infinity)
                Text(L("active.weight")).frame(maxWidth: .infinity)
                Text("").frame(width: 36)
            }
            .font(.caption2)
            .foregroundStyle(.secondary)

            ForEach(Array(we.wrappedValue.sets.enumerated()), id: \.element.id) { index, _ in
                setRow(we, index: index)
            }

            Button {
                let last = we.wrappedValue.sets.last
                we.wrappedValue.sets.append(SetEntry(reps: last?.reps ?? 10, weight: last?.weight ?? 0))
            } label: {
                Label(L("active.addSet"), systemImage: "plus")
                    .font(.caption.weight(.semibold))
            }
        }
        .card()
    }

    private func setRow(_ we: Binding<WorkoutExercise>, index: Int) -> some View {
        let set = we.sets[index]
        return HStack {
            Text("\(index + 1)")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 24)
            TextField("0", value: set.reps, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding(6)
                .background(Color(.tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)
            TextField("0", value: set.weight, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .padding(6)
                .background(Color(.tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)
            Button {
                set.wrappedValue.done.toggle()
                if set.wrappedValue.done {
                    restRemaining = we.wrappedValue.restSec
                }
            } label: {
                Image(systemName: set.wrappedValue.done ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(set.wrappedValue.done ? .brand : .secondary)
            }
            .frame(width: 36)
        }
        .opacity(set.wrappedValue.done ? 0.55 : 1)
    }

    // MARK: - Rest Timer

    private var restBar: some View {
        HStack {
            Image(systemName: "timer")
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(L("active.rest"))
                    .font(.caption)
                    .opacity(0.85)
                Text("\(restRemaining) \(L("unit.sec"))")
                    .font(.title3.bold().monospacedDigit())
            }
            Spacer()
            Button(L("active.plus30")) { restRemaining += 30 }
                .buttonStyle(.bordered)
                .tint(.white)
            Button(L("active.skip")) { restRemaining = 0 }
                .buttonStyle(.borderedProminent)
                .tint(.white.opacity(0.25))
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.brand)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.spring(duration: 0.3), value: restRemaining > 0)
    }
}
