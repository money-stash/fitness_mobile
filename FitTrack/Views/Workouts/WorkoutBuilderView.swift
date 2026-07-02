import SwiftUI

struct WorkoutBuilderView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var exercises: [WorkoutExercise] = []
    @State private var showPicker = false

    var body: some View {
        NavigationStack {
            Form {
                Section(L("builder.name")) {
                    TextField(L("builder.name.ph"), text: $name)
                }

                Section(L("builder.exercises")) {
                    ForEach($exercises) { $we in
                        builderRow($we)
                    }
                    .onDelete { exercises.remove(atOffsets: $0) }
                    .onMove { exercises.move(fromOffsets: $0, toOffset: $1) }

                    Button {
                        showPicker = true
                    } label: {
                        Label(L("builder.add"), systemImage: "plus")
                    }
                }
            }
            .navigationTitle(L("builder.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L("common.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("common.save")) {
                        let template = WorkoutTemplate(
                            name: name.trimmingCharacters(in: .whitespaces),
                            subtitleUk: Strings.table["template.subtitle.custom"]?[.uk] ?? "",
                            subtitleEn: Strings.table["template.subtitle.custom"]?[.en] ?? "",
                            levelUk: Strings.table["template.level.custom"]?[.uk] ?? "",
                            levelEn: Strings.table["template.level.custom"]?[.en] ?? "",
                            exercises: exercises,
                            isCustom: true)
                        store.customTemplates.insert(template, at: 0)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || exercises.isEmpty)
                }
            }
            .sheet(isPresented: $showPicker) {
                NavigationStack {
                    ExerciseLibraryView { exercise in
                        exercises.append(WorkoutExercise(
                            exerciseID: exercise.id,
                            sets: (0..<3).map { _ in SetEntry(reps: 10, weight: 0) }))
                        showPicker = false
                    }
                }
            }
        }
    }

    private func builderRow(_ we: Binding<WorkoutExercise>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.exercise(we.wrappedValue.exerciseID)?.name ?? "")
                .font(.subheadline.weight(.medium))
            HStack {
                Stepper(L("builder.sets", we.wrappedValue.sets.count),
                        value: Binding(
                            get: { we.wrappedValue.sets.count },
                            set: { newCount in
                                var sets = we.wrappedValue.sets
                                let reps = sets.first?.reps ?? 10
                                while sets.count < newCount { sets.append(SetEntry(reps: reps, weight: 0)) }
                                while sets.count > newCount && sets.count > 1 { sets.removeLast() }
                                we.wrappedValue.sets = sets
                            }),
                        in: 1...10)
                .font(.caption)
            }
            Stepper(L("builder.reps", we.wrappedValue.sets.first?.reps ?? 0),
                    value: Binding(
                        get: { we.wrappedValue.sets.first?.reps ?? 10 },
                        set: { newReps in
                            var sets = we.wrappedValue.sets
                            for i in sets.indices { sets[i].reps = newReps }
                            we.wrappedValue.sets = sets
                        }),
                    in: 1...60)
            .font(.caption)
            Stepper(L("builder.rest", we.wrappedValue.restSec),
                    value: we.restSec, in: 15...300, step: 15)
            .font(.caption)
        }
        .padding(.vertical, 4)
    }
}
