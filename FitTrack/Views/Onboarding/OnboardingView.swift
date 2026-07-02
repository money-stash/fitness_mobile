import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var store: AppStore
    @State private var step = 0
    @State private var draft = UserProfile()

    private let totalSteps = 5

    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: Double(step + 1), total: Double(totalSteps))
                .tint(.brand)
                .padding(.horizontal)
                .padding(.top, 12)

            TabView(selection: $step) {
                welcomeStep.tag(0)
                bodyStep.tag(1)
                measuresStep.tag(2)
                goalStep.tag(3)
                resultStep.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: step)

            HStack {
                if step > 0 {
                    Button(L("common.back")) { step -= 1 }
                        .buttonStyle(.bordered)
                }
                Spacer()
                if step < totalSteps - 1 {
                    Button(L("common.next")) { step += 1 }
                        .buttonStyle(.borderedProminent)
                        .disabled(step == 0 && draft.name.trimmingCharacters(in: .whitespaces).isEmpty)
                } else {
                    Button(L("onb.start")) { finish() }
                        .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }

    private func finish() {
        draft.onboarded = true
        store.profile = draft
        store.logWeight(draft.weightKg)
    }

    // MARK: - Steps

    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 90))
                .foregroundStyle(.brand)
            Text(L("onb.welcome.title"))
                .font(.largeTitle.bold())
            Text(L("onb.welcome.sub"))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            TextField(L("onb.name.placeholder"), text: $draft.name)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .padding(.top)
            Spacer()
            Spacer()
        }
        .padding(24)
    }

    private var bodyStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            Text(L("onb.about.title"))
                .font(.largeTitle.bold())
            Text(L("onb.about.sub"))
                .foregroundStyle(.secondary)

            Picker(L("onb.gender"), selection: $draft.gender) {
                ForEach(Gender.allCases) { g in
                    Text(g.title).tag(g)
                }
            }
            .pickerStyle(.segmented)

            VStack(alignment: .leading, spacing: 8) {
                Text(.init(L("onb.age.value", draft.age)))
                Slider(value: Binding(
                    get: { Double(draft.age) },
                    set: { draft.age = Int($0) }
                ), in: 14...80, step: 1)
            }
            Spacer()
            Spacer()
        }
        .padding(24)
    }

    private var measuresStep: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            Text(L("onb.measures.title"))
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 8) {
                Text(.init(L("onb.height.value", Int(draft.heightCm))))
                Slider(value: $draft.heightCm, in: 140...210, step: 1)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(.init(L("onb.weight.value", draft.weightKg.clean)))
                Slider(value: $draft.weightKg, in: 40...160, step: 0.5)
            }
            HStack {
                Image(systemName: "info.circle")
                Text(L("onb.bmi.value", draft.bmi.clean, draft.bmiCategory))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            Spacer()
            Spacer()
        }
        .padding(24)
    }

    private var goalStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            Text(L("onb.goal.title"))
                .font(.largeTitle.bold())

            ForEach(Goal.allCases) { goal in
                Button {
                    draft.goal = goal
                } label: {
                    HStack {
                        Image(systemName: goal.icon)
                            .font(.title2)
                            .foregroundStyle(draft.goal == goal ? .white : .brand)
                        Text(goal.title)
                            .fontWeight(.medium)
                        Spacer()
                        if draft.goal == goal {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(draft.goal == goal ? Color.brand : Color(.secondarySystemGroupedBackground))
                    .foregroundStyle(draft.goal == goal ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }

            Text(L("onb.activity"))
                .font(.headline)
                .padding(.top, 8)
            Picker(L("onb.activity"), selection: $draft.activity) {
                ForEach(ActivityLevel.allCases) { level in
                    Text(level.title).tag(level)
                }
            }
            .pickerStyle(.menu)
            Spacer()
            Spacer()
        }
        .padding(24)
    }

    private var resultStep: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(L("onb.result.title", draft.name))
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text(L("onb.result.sub"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 14) {
                targetRow(icon: "flame.fill", color: .orange,
                          title: L("target.calories"), value: "\(draft.calorieTarget) \(L("unit.kcal"))")
                targetRow(icon: "fish.fill", color: .red,
                          title: L("target.protein"), value: "\(draft.proteinTarget) \(L("unit.g"))")
                targetRow(icon: "drop.halffull", color: .yellow,
                          title: L("target.fat"), value: "\(draft.fatTarget) \(L("unit.g"))")
                targetRow(icon: "laurel.leading", color: .brand,
                          title: L("target.carbs"), value: "\(draft.carbsTarget) \(L("unit.g"))")
                targetRow(icon: "drop.fill", color: .blue,
                          title: L("target.water"), value: "\(draft.waterTargetMl) \(L("unit.ml"))")
            }
            .card()

            Text(L("onb.result.note"))
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Spacer()
        }
        .padding(24)
    }

    private func targetRow(icon: String, color: Color, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(title)
            Spacer()
            Text(value).bold()
        }
    }
}
