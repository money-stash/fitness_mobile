import SwiftUI
import UniformTypeIdentifiers

private struct ExportFile: Identifiable {
    let url: URL
    var id: String { url.path }
}

private struct ImportFile: Identifiable {
    let url: URL
    var id: String { url.path }
}

struct SettingsView: View {
    @EnvironmentObject var store: AppStore
    @EnvironmentObject var settings: Settings
    @Environment(\.dismiss) private var dismiss
    @State private var exportFile: ExportFile?
    @State private var exportError: String?
    @State private var showingImportPicker = false
    @State private var pendingImportFile: ImportFile?
    @State private var importError: String?
    @State private var importSucceeded = false

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
                Button {
                    showingImportPicker = true
                } label: {
                    Label(L("settings.import.choose"), systemImage: "square.and.arrow.down")
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
        .fileImporter(
            isPresented: $showingImportPicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    pendingImportFile = ImportFile(url: url)
                }
            case .failure(let error):
                importError = error.localizedDescription
            }
        }
        .confirmationDialog(
            L("settings.import.confirmTitle"),
            isPresented: Binding(
                get: { pendingImportFile != nil },
                set: { if !$0 { pendingImportFile = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button(L("settings.import.replace"), role: .destructive) {
                if let url = pendingImportFile?.url {
                    importData(from: url)
                }
                pendingImportFile = nil
            }
            Button(L("common.cancel"), role: .cancel) { pendingImportFile = nil }
        } message: {
            Text(L("settings.import.confirmMessage"))
        }
        .alert(L("settings.import.failed"), isPresented: Binding(
            get: { importError != nil },
            set: { if !$0 { importError = nil } }
        )) {
            Button(L("common.ok"), role: .cancel) { importError = nil }
        } message: {
            Text(importError ?? "")
        }
        .alert(L("settings.import.successTitle"), isPresented: $importSucceeded) {
            Button(L("common.ok"), role: .cancel) {}
        } message: {
            Text(L("settings.import.successMessage"))
        }
    }

    private func importData(from url: URL) {
        do {
            try store.importFile(url, settings: settings)
            importSucceeded = true
        } catch {
            if (error as? AppStore.ImportError) == .invalidFile {
                importError = L("settings.import.invalidFile")
            } else {
                importError = error.localizedDescription
            }
        }
    }
}
