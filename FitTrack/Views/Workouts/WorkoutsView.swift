import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var store: AppStore
    @State private var section = 0
    @State private var showBuilder = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $section) {
                    Text(L("workouts.programs")).tag(0)
                    Text(L("workouts.mine")).tag(1)
                    Text(L("workouts.history")).tag(2)
                }
                .pickerStyle(.segmented)
                .padding()

                switch section {
                case 0: templateList(SeedData.templates)
                case 1: customList
                default: WorkoutHistoryView()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(L("workouts.title"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ExerciseLibraryView()
                    } label: {
                        Image(systemName: "books.vertical")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showBuilder = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showBuilder) {
                WorkoutBuilderView()
            }
        }
    }

    private func templateList(_ templates: [WorkoutTemplate]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(templates) { template in
                    NavigationLink {
                        TemplateDetailView(template: template)
                    } label: {
                        TemplateCard(template: template)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }

    @ViewBuilder
    private var customList: some View {
        if store.customTemplates.isEmpty {
            ContentUnavailableView(
                L("workouts.empty.title"),
                systemImage: "plus.circle",
                description: Text(L("workouts.empty.desc")))
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(store.customTemplates) { template in
                        NavigationLink {
                            TemplateDetailView(template: template)
                        } label: {
                            TemplateCard(template: template)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button(role: .destructive) {
                                store.customTemplates.removeAll { $0.id == template.id }
                            } label: {
                                Label(L("common.delete"), systemImage: "trash")
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

struct TemplateCard: View {
    let template: WorkoutTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(template.name)
                    .font(.headline)
                Spacer()
                Text(template.level)
                    .font(.caption2.weight(.semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.brand.opacity(0.15))
                    .foregroundStyle(.brand)
                    .clipShape(Capsule())
            }
            Text(template.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            HStack(spacing: 16) {
                Label(L("workouts.exercises", template.exercises.count), systemImage: "list.bullet")
                Label(L("workouts.est", template.estMinutes), systemImage: "clock")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .card()
    }
}

// MARK: - Program Detail

struct TemplateDetailView: View {
    @EnvironmentObject var store: AppStore
    let template: WorkoutTemplate
    @State private var startWorkout = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(template.subtitle)
                    .foregroundStyle(.secondary)

                HStack(spacing: 16) {
                    Label(template.level, systemImage: "chart.bar.fill")
                    Label(L("workouts.est", template.estMinutes), systemImage: "clock")
                    Label(L("workouts.exercises", template.exercises.count), systemImage: "list.bullet")
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)

                VStack(spacing: 10) {
                    ForEach(template.exercises) { we in
                        if let exercise = store.exercise(we.exerciseID) {
                            HStack {
                                Image(systemName: exercise.group.icon)
                                    .foregroundStyle(.brand)
                                    .frame(width: 30)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(exercise.name)
                                        .font(.subheadline.weight(.medium))
                                    Text(exercise.equipment)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text("\(we.sets.count) × \(we.sets.first?.reps ?? 0)")
                                    .font(.subheadline.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                            .card()
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(template.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button {
                startWorkout = true
            } label: {
                Label(L("workout.start"), systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .fullScreenCover(isPresented: $startWorkout) {
            ActiveWorkoutView(template: template)
        }
    }
}
