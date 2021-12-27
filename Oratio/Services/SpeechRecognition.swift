import Speech
import Combine

enum SpeechRecognition {
    private static var request: SFSpeechAudioBufferRecognitionRequest?
    private static var task: SFSpeechRecognitionTask?
    private static var audioEngine: AVAudioEngine?
    private static var cancelStream: (() -> Void)?

    enum Error: Swift.Error, LocalizedError {
        case noPermission
        case couldNotLoadSpeechRecognizer

        var errorDescription: String? {
            switch self {
            case .noPermission:
                return "Permission for speech recognition was denied"
            case .couldNotLoadSpeechRecognizer:
                return "Could not load on-device speech recognizer"
            }
        }
    }

    static func start(locale: Locale) async throws -> AsyncStream<String> {
        let status = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }

        guard status == .authorized else {
            throw Error.noPermission
        }

        try AVAudioSession.sharedInstance().setCategory(.record)
        try AVAudioSession.sharedInstance().setActive(true)

        self.request = SFSpeechAudioBufferRecognitionRequest()
        self.request!.shouldReportPartialResults = true
        self.request!.requiresOnDeviceRecognition = true
        self.request!.taskHint = .dictation

        // TODO: Set language with init(locale: ...)
        guard let speechRecognizer = SFSpeechRecognizer(locale: locale) else {
            throw Error.couldNotLoadSpeechRecognizer
        }

        self.audioEngine = AVAudioEngine()
        let node = self.audioEngine!.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }

        return AsyncStream { continuation in
            var speech: [String] = [""]
            
            // Speech becomes final after a 2 second delay
            // (https://stackoverflow.com/questions/42530634/sfspeechrecognizer-detect-end-of-utterance)
            var timer: Timer!
            func newTimer() -> Timer {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                    speech.append("")
                    timer = newTimer()
                }
            }
            
            timer = newTimer()
            
            self.task = speechRecognizer.recognitionTask(with: self.request!) { result, error in
                guard let result = result else {
                    return
                }
                
                // Prevent duplicate results
                if (speech.count > 1 && speech[speech.count - 2] != result.bestTranscription.formattedString) || speech.count == 1 {
                    speech[speech.count - 1] = result.bestTranscription.formattedString
                }
                
                timer.invalidate()
                timer = newTimer()

                continuation.yield(speech.joined(separator: " "))
            }

            self.audioEngine!.prepare()
            try? self.audioEngine!.start()

            self.cancelStream = continuation.finish
        }
    }

    static func stop() {
        try? AVAudioSession.sharedInstance().setActive(false)

        self.request?.endAudio()
        self.request = nil

        self.task?.cancel()
        self.task = nil

        self.audioEngine?.stop()
        self.audioEngine = nil

        self.cancelStream?()
    }
}
