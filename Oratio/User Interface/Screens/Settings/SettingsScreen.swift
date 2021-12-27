import SwiftUI

struct SettingsScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Language", selection: self.$store.settings.selectedLanguage) {
                        if let languages = self.store.languages {
                            ForEach(languages) { language in
                                Text(language.id)
                                    .tag(Optional(language.id))
                            }
                        }
                    }
                }

                Section(header: Text("Display")) {
                    Picker("Default Font", selection: self.$store.settings.defaultFont) {
                        Text("System")
                            .tag(nil as String?)

                        ForEach(UIFont.familyNames, id: \.self) { font in
                            Text(font)
                                .font(.custom(font, size: 17, relativeTo: .body))
                                .tag(Optional(font))
                        }
                    }

                    Slider(value: self.$store.settings.fontSize, in: 12...100, step: 8) {
                        Text("Font Size")
                    } minimumValueLabel: {
                        Image(systemName: "textformat.size.smaller")
                    } maximumValueLabel: {
                        Image(systemName: "textformat.size.larger")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.dismiss() }) {
                        Text("Done")
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
#endif
