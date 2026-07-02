import SwiftUI

private struct ExportFile: Identifiable {
    let url: URL
    var id: String { url.path }
}

struct SettingsView: View {
    @EnvironmentObject var store: AppStore
    @EnvironmentObject var settings: Settings
    @Environment(\.dismiss) private var dismiss
    @State private var exportFile: ExportFile?
    @State private var exportError: String?

    var body: some View {
        Form {
            Section(L("settings.appearance")) {
                Picker(selection: $settings.theme) {
                    ForEach(AppTheme.allCases) { theme in
                        Label(L(theme.titleKey), systemImage: theme.icon).tag(theme)
                    }
                } label: {
                    Label(L("settings.theme"), systemImage: "paintbrush.fill")
                }
                .pickerStyle(.menu)
            }

            Section {
                Picker(selection: $settings.language) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text("\(lang.flag)  \(lang.nativeName)").tag(lang)
                    }
                } label: {
                    Label(L("settings.language"), systemImage: "globe")
                }
                .pickerStyle(.inline)
            } header: {
                Text(L("settings.language"))
            } footer: {
                Text(L("settings.language.footer"))
            }

            Section {
                Button {
                    do {
                        exportFile = ExportFile(url: try store.exportFile(settings: settings))
                    } catch {
                        exportError = error.localizedDescription
                    }
                } label: {
                    Label(L("settings.export.prepare"), systemImage: "square.and.arrow.up")
                }
            } header: {
                Text(L("settings.data"))
            } footer: {
                Text(L("settings.export.footer"))
            }
        }
        .navigationTitle(L("settings.title"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $exportFile) { file in
            NavigationStack {
                VStack(spacing: 18) {
                    Image(systemName: "doc.badge.arrow.up")
                        .font(.system(size: 44))
                        .foregroundStyle(.brand)
                    Text(L("settings.export.ready"))
                        .font(.headline)
                    Text(file.url.lastPathComponent)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    ShareLink(item: file.url) {
                        Label(L("settings.export.share"), systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .navigationTitle(L("settings.export.title"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(L("common.done")) { exportFile = nil }
                    }
                }
            }
        }
        .alert(L("settings.export.failed"), isPresented: Binding(
            get: { exportError != nil },
            set: { if !$0 { exportError = nil } }
        )) {
            Button(L("common.ok"), role: .cancel) { exportError = nil }
        } message: {
            Text(exportError ?? "")
        }
    }
}
