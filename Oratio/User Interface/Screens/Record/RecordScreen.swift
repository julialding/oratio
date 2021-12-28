import SwiftUI
import Introspect
import NaturalLanguage

struct RecordScreen: View {
    @EnvironmentObject var store: Store

    let language: Language

    @State private var isRecording = false
    @State private var recording: [NLP.Word] = []

    @State private var showSaved = false
    @State private var showSettings = false

    @State private var recordingScrollView: UIScrollView?

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    Group {
                        if self.recording.isEmpty && !self.isRecording {
                            Text("Tap the mic to start recording")
                                .font(.title)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                        } else {
                            ScrollView {
                                RecordingView(language: self.language, recording: self.recording) {
                                    if let scrollView = self.recordingScrollView {
                                        self.scrollToBottom(with: scrollView)
                                    }
                                }
                                .padding(.bottom, CGFloat(self.store.settings.fontSize) * 1.5)
                                .padding()
                                .introspectScrollView { scrollView in
                                    self.recordingScrollView = scrollView
                                    scrollView.isUserInteractionEnabled = !self.isRecording
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding()

                MicButton(isActive: self.$isRecording)

                Spacer()
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Oratio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { self.showSaved = true }) {
                        Image(systemName: "bookmark")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.showSettings = true }) {
                        Image(systemName: "character.bubble")
                    }
                }
            }
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: self.$showSaved) {
            SavedScreen()
        }
        .sheet(isPresented: self.$showSettings) {
            SettingsScreen()
        }
        .onChange(of: self.isRecording) { isRecording in
            if isRecording {
                self.recording.removeAll()

                Task {
                    let selectedLanguage = self.store.selectedLanguage!
                    
                    do {
                        for await speech in try await SpeechRecognition.start(locale: .init(identifier: selectedLanguage.id)) {
                            self.recording = NLP.words(in: speech, language: .init(rawValue: selectedLanguage.id))
                        }
                    } catch {
                        self.store.error = error
                    }
                }
            } else {
                SpeechRecognition.stop()
            }
        }
    }

    private func scrollToBottom(with scrollView: UIScrollView) {
        if scrollView.contentSize.height > scrollView.visibleSize.height {
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)

            UIView.animate(withDuration: 0.35) {
                scrollView.contentOffset = bottomOffset
            }
        }
    }
}
