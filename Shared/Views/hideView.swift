import SwiftUI
import GameKit

struct hideView: View {
    @State var seed: String
    @State private var toHide: String  = "Text"
    @State private var hiddenText: String = "Press Generate"
    var body: some View {
        
        VStack {
            HStack {
                Text("Seed:")
                TextField("", text: $seed)
            }.padding()
            HStack {
                Text("To Hide:")
                TextField("", text: $toHide)
            }.padding()
            HStack {
                Text("Hidden Text:")
                Text(hiddenText)
                    .lineLimit(hiddenText.count/60)
                    .fixedSize(horizontal: false, vertical: true).onTapGesture {
                        NSPasteboard.general.declareTypes([.string], owner: nil)
                        NSPasteboard.general.setString(hiddenText, forType: .string)
                        //UIPasteboard.general.setData(hiddenText.data(using: .utf8)!, forPasteboardType: "")
                    }
                    .onDrag {
                        NSItemProvider(item: NSData(data: hiddenText.data(using: .utf8)!), typeIdentifier: kUTTypeUTF8PlainText as String)
                    }
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Button(action: {
                hiddenText = generateText(toHide: toHide, seed: seed)
            }) {
                Text("Generate Text")
            }
        }.padding().frame(width: 800.0)
    }
    func generateText(toHide: String, seed: String) -> String {
        let rng = GKARC4RandomSource(seed: seed.data(using: .utf8)!)
        var _  = rng.dropValues(1024)
        let toHideChars = Array(toHide)
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var hiddenArray: Array<Character> = Array(repeating: " ", count: toHideChars.count*100)
        for i in 0..<hiddenArray.count {
            hiddenArray[i]=letters.randomElement()!
        }
        for char in toHideChars {
            hiddenArray[abs(rng.nextInt() % hiddenArray.count)] = char
        }
        hiddenArray[abs(rng.nextInt() % hiddenArray.count)] = "0"
        return String(hiddenArray)
    }
}

struct hideView_Previews: PreviewProvider {
    static var previews: some View {
        hideView(seed: "123123123")
    }
}
