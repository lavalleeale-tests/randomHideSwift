import SwiftUI
import GameKit

struct findView: View {
    @State var seed: String
    @State private var hiddenText: String =  "Text"
    @State private var foundText: String = "Press Generate"
    var body: some View {
        
        VStack {
            HStack {
                Text("Seed:")
                TextField("", text: $seed)
            }.padding()
            HStack {
                Text("Hidden Text:")
                TextField("", text: $hiddenText)
            }.padding()
            HStack {
                Text("Found:")
                Text(foundText)
                    .lineLimit(foundText.count/60)
                    .fixedSize(horizontal: false, vertical: true).onTapGesture {
                    }
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Button(action: {
                foundText = generateText(hiddenText: hiddenText, seed: seed)
            }) {
                Text("Generate Text")
            }
        }.padding().frame(width: 800.0)
    }
    func generateText(hiddenText: String, seed: String) -> String {
        let rng = GKARC4RandomSource(seed: seed.data(using: .utf8)!)
        var _  = rng.dropValues(1024)
        var cur:Character = "\n"
        let hiddenChars = Array(hiddenText)
        var outputChars: Array = Array<Character>()
        while cur != "0" {
            if cur == "\n" {
                cur =  hiddenChars[abs(rng.nextInt() % hiddenChars.count)]
                continue
            }
            outputChars.append(cur)
            cur =  hiddenChars[abs(rng.nextInt() % hiddenChars.count)]
        }
        return String(outputChars)
    }
}

struct findView_Previews: PreviewProvider {
    static var previews: some View {
        findView(seed: "123123123")
    }
}
