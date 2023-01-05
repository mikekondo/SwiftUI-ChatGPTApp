//
//  ContentView.swift
//  SwiftUI-ChatGPT-App
//
//  Created by 近藤米功 on 2023/01/05.
//

import SwiftUI
import OpenAISwift
import PKHUD

struct ContentView: View {
    @State private var inputText = ""
    @State private var messageArray: [String] = []
    @State private var isProgressView = false

    private var client = OpenAISwift(authToken: "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")

    var body: some View {
        NavigationStack {
            VStack {
                ForEach(messageArray, id: \.self) { message in
                    Text(message)
                    Spacer()
                    if isProgressView {
                        ProgressView()
                            .scaleEffect(x: 10, y: 10, anchor: .center)
                    }
                    Spacer()
                }
                
                HStack {
                    TextField("質問を入力", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        isProgressView.toggle()
                        send()
                    } label: {
                        Text("送信")
                    }
                }
                .padding()
            }
            .navigationTitle("ChatGPT")
        }
    }

    private func send() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        messageArray.append("\(inputText)")
        client.sendCompletion(with: inputText,maxTokens: 500) { result in
            switch result {
            case .success(let model):
                    DispatchQueue.main.async {
                    let output = model.choices.first?.text ?? ""
                    self.messageArray.append("\(output)")
                    self.inputText = ""
                }
                isProgressView.toggle()
                print("success,progress:",isProgressView)
            case .failure(_):
                print("エラー")
                break
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
