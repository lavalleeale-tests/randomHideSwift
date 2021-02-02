import SwiftUI
import GameKit

struct hideView: View {
    @State var seed: String
    @State private var input: String  = "Text"
    @State private var output: String = "Press Generate"
    var body: some View {
        
        VStack {
            HStack {
                Text("Seed:")
                TextField("", text: $seed)
            }.padding()
            HStack {
                Text("Input:")
                TextField("", text: $input)
            }.padding()
            HStack {
                Text("Output:")
                Text(output)
                    .lineLimit(output.count/60)
                    .fixedSize(horizontal: false, vertical: true).onTapGesture {
                        NSPasteboard.general.declareTypes([.string], owner: nil)
                        NSPasteboard.general.setString(output, forType: .string)
                    }
                    .onDrag {
                        NSItemProvider(item: NSData(data: output.data(using: .utf8)!), typeIdentifier: kUTTypeUTF8PlainText as String)
                    }
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            Button(action: {
                output = hideText(toHide: input, seed: seed)
            }) {
                Text("Hide Text")
            }
            Button(action: {
                output = findText(hiddenText: input, seed: seed)
            }) {
                Text("Find Text")
            }
        }.padding().frame(width: 800.0)
    }
    func hideText(toHide: String, seed: String) -> String {
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
    func findText(hiddenText: String, seed: String) -> String {
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

struct hideView_Previews: PreviewProvider {
    static var previews: some View {
        hideView(seed: "123123123")
    }
}
