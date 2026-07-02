import SwiftUI

@main
struct FitTrackApp: App {
    @StateObject private var store = AppStore()
    @StateObject private var settings = Settings.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .environmentObject(settings)
                .environment(\.locale, settings.language.locale)
                .tint(.brand)
                .preferredColorScheme(settings.theme.colorScheme)
                // Rebuild the view tree when the language changes so computed titles refresh.
                .id(settings.language)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        if store.profile.onboarded {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label(L("tab.home"), systemImage: "house.fill") }
            WorkoutsView()
                .tabItem { Label(L("tab.workouts"), systemImage: "dumbbell.fill") }
            NutritionView()
                .tabItem { Label(L("tab.nutrition"), systemImage: "fork.knife") }
            StatsView()
                .tabItem { Label(L("tab.stats"), systemImage: "chart.bar.fill") }
        }
    }
}
