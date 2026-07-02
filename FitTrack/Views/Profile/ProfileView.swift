import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var store: AppStore
    @State private var showEdit = false
    @State private var showResetConfirm = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                targetsCard
                achievementsCard
                actionsCard
                Text(L("profile.version"))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(L("profile.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            EditProfileView()
        }
        .confirmationDialog(L("profile.resetConfirm"),
                            isPresented: $showResetConfirm, titleVisibility: .visible) {
            Button(L("profile.resetYes"), role: .destructive) {
                store.resetAll()
            }
            Button(L("common.cancel"), role: .cancel) {}
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle().fill(Color.brand.opacity(0.18))
                Text(store.profile.initials.isEmpty ? "🙂" : store.profile.initials)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.brand)
            }
            .frame(width: 88, height: 88)
            Text(store.profile.name)
                .font(.title2.bold())
            HStack(spacing: 12) {
                Label(store.profile.goal.title, systemImage: store.profile.goal.icon)
                Label("\(Int(store.profile.heightCm)) \(L("unit.cm"))", systemImage: "ruler")
                Label("\(store.profile.weightKg.clean) \(L("unit.kg"))", systemImage: "scalemass")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    private var targetsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L("profile.targets"))
                .font(.headline)
            HStack(spacing: 10) {
                targetTile(icon: "flame.fill", color: .orange,
                           value: "\(store.profile.calorieTarget)", label: L("profile.calories"))
                targetTile(icon: "fish.fill", color: .red,
                           value: "\(store.profile.proteinTarget)", label: L("profile.protein"))
                targetTile(icon: "drop.halffull", color: .yellow,
                           value: "\(store.profile.fatTarget)", label: L("profile.fat"))
                targetTile(icon: "laurel.leading", color: .brand,
                           value: "\(store.profile.carbsTarget)", label: L("profile.carbs"))
            }
        }
        .card()
    }

    private func targetTile(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text(value)
                .font(.subheadline.bold())
                .monospacedDigit()
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var achievementsCard: some View {
        let achievements = store.achievements
        let unlockedCount = achievements.filter(\.unlocked).count

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(L("profile.achievements"))
                    .font(.headline)
                Spacer()
                Text("\(unlockedCount) / \(achievements.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
                ForEach(achievements) { achievement in
                    VStack(spacing: 6) {
                        Image(systemName: achievement.icon)
                            .font(.title3)
                            .foregroundStyle(achievement.unlocked ? .yellow : .secondary)
                        Text(achievement.title)
                            .font(.caption2.weight(.semibold))
                            .multilineTextAlignment(.center)
                        Text(achievement.subtitle)
                            .font(.system(size: 9))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 84)
                    .padding(6)
                    .background(achievement.unlocked
                                ? Color.yellow.opacity(0.12)
                                : Color(.tertiarySystemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(achievement.unlocked ? 1 : 0.6)
                }
            }
        }
        .card()
    }

    private var actionsCard: some View {
        VStack(spacing: 0) {
            Button {
                showEdit = true
            } label: {
                actionRow(icon: "pencil", title: L("profile.edit"), color: .brand)
            }
            Divider()
            Button {
                store.fillDemoData()
            } label: {
                actionRow(icon: "wand.and.stars", title: L("profile.demo"), color: .purple)
            }
            Divider()
            Button(role: .destructive) {
                showResetConfirm = true
            } label: {
                actionRow(icon: "trash", title: L("profile.reset"), color: .red)
            }
        }
        .card()
    }

    private func actionRow(icon: String, title: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(title)
                .foregroundStyle(color == .red ? .red : .primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

// MARK: - Profile Editing

struct EditProfileView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var draft = UserProfile()

    var body: some View {
        NavigationStack {
            Form {
                Section(L("edit.personal")) {
                    TextField(L("edit.name"), text: $draft.name)
                    Picker(L("onb.gender"), selection: $draft.gender) {
                        ForEach(Gender.allCases) { g in
                            Text(g.title).tag(g)
                        }
                    }
                    Stepper(L("edit.age", draft.age), value: $draft.age, in: 14...80)
                }
                Section(L("edit.body")) {
                    Stepper(L("edit.height", Int(draft.heightCm)), value: $draft.heightCm, in: 140...210, step: 1)
                    Stepper(L("edit.weight", draft.weightKg.clean), value: $draft.weightKg, in: 40...160, step: 0.5)
                }
                Section(L("edit.goalSection")) {
                    Picker(L("edit.goal"), selection: $draft.goal) {
                        ForEach(Goal.allCases) { g in
                            Text(g.title).tag(g)
                        }
                    }
                    Picker(L("edit.activity"), selection: $draft.activity) {
                        ForEach(ActivityLevel.allCases) { a in
                            Text(a.title).tag(a)
                        }
                    }
                }
                Section {
                    LabeledContent(L("edit.water.recommended"),
                                   value: "\(draft.recommendedWaterTargetMl) \(L("unit.ml"))")
                    Stepper(value: Binding(
                        get: { draft.waterTargetMl },
                        set: { draft.customWaterTargetMl = $0 }
                    ), in: 1_000...6_000, step: 100) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L("target.water"))
                            Text(L("edit.water.current", draft.waterTargetMl))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Button {
                        draft.customWaterTargetMl = nil
                    } label: {
                        Label(L("edit.water.useRecommended"), systemImage: "wand.and.stars")
                    }
                    .disabled(draft.customWaterTargetMl == nil)
                } header: {
                    Text(L("edit.waterSection"))
                } footer: {
                    Text(L("edit.water.footer"))
                }
                Section(L("edit.newTargets")) {
                    LabeledContent(L("target.calories"), value: "\(draft.calorieTarget) \(L("unit.kcal"))")
                    LabeledContent(L("target.protein"), value: "\(draft.proteinTarget) \(L("unit.g"))")
                    LabeledContent(L("target.fat"), value: "\(draft.fatTarget) \(L("unit.g"))")
                    LabeledContent(L("target.carbs"), value: "\(draft.carbsTarget) \(L("unit.g"))")
                    LabeledContent(L("target.water"), value: "\(draft.waterTargetMl) \(L("unit.ml"))")
                }
            }
            .navigationTitle(L("edit.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L("common.cancel")) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L("common.save")) {
                        let weightChanged = abs(draft.weightKg - store.profile.weightKg) > 0.01
                        store.profile = draft
                        if weightChanged {
                            store.logWeight(draft.weightKg)
                        }
                        dismiss()
                    }
                    .bold()
                }
            }
            .onAppear { draft = store.profile }
        }
    }
}
