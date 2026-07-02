import SwiftUI

struct ExerciseLibraryView: View {
    @State private var search = ""
    @State private var selectedGroup: MuscleGroup?
    @State private var detailExercise: Exercise?

    /// Selection mode used by the workout builder.
    var onPick: ((Exercise) -> Void)?

    private var filtered: [Exercise] {
        SeedData.exercises.filter { ex in
            (selectedGroup == nil || ex.group == selectedGroup)
            && (search.isEmpty || ex.name.localizedCaseInsensitiveContains(search))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    groupChip(nil, title: L("lib.all"))
                    ForEach(MuscleGroup.allCases) { group in
                        groupChip(group, title: group.title)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }

            List(filtered) { exercise in
                Button {
                    if let onPick {
                        onPick(exercise)
                    } else {
                        detailExercise = exercise
                    }
                } label: {
                    ExerciseRow(exercise: exercise, showsPlus: onPick != nil)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
        }
        .navigationTitle(onPick == nil ? L("lib.title") : L("builder.pickTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $search, prompt: L("lib.search"))
        .sheet(item: $detailExercise) { exercise in
            ExerciseDetailSheet(exercise: exercise)
                .presentationDetents([.medium])
        }
    }

    private func groupChip(_ group: MuscleGroup?, title: String) -> some View {
        let isSelected = selectedGroup == group
        return Button {
            selectedGroup = group
        } label: {
            Text(title)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(isSelected ? Color.brand : Color(.secondarySystemGroupedBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    var showsPlus = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: exercise.group.icon)
                .font(.title3)
                .foregroundStyle(.brand)
                .frame(width: 34)
            VStack(alignment: .leading, spacing: 3) {
                Text(exercise.name)
                    .font(.subheadline.weight(.medium))
                HStack(spacing: 8) {
                    Text(exercise.group.title)
                    Text("•")
                    Text(exercise.equipment)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            if showsPlus {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.brand)
            } else {
                difficultyDots
            }
        }
        .padding(.vertical, 2)
    }

    private var difficultyDots: some View {
        HStack(spacing: 3) {
            ForEach(1...3, id: \.self) { i in
                Circle()
                    .fill(i <= exercise.difficulty ? Color.orange : Color(.systemFill))
                    .frame(width: 6, height: 6)
            }
        }
    }
}

struct ExerciseDetailSheet: View {
    let exercise: Exercise
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 14) {
                        Image(systemName: exercise.group.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(.brand)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.group.title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(L("lib.equipment", exercise.equipment))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack(spacing: 12) {
                        infoTile(title: L("lib.difficulty"),
                                 value: String(repeating: "●", count: exercise.difficulty)
                                      + String(repeating: "○", count: 3 - exercise.difficulty))
                        infoTile(title: "MET", value: exercise.met.clean)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Label(L("lib.technique"), systemImage: "lightbulb.fill")
                            .font(.headline)
                        Text(exercise.tips)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .card()
                }
                .padding()
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("common.done")) { dismiss() }
                }
            }
        }
    }

    private func infoTile(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .card()
    }
}
