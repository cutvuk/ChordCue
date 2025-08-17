import SwiftUI

/// Displays a very basic chord diagram using a six character string representation.
/// Each character represents a string from low E to high e. Use numbers for frets,
/// "0" for open strings and "x" for muted strings. Example: "x32010" for C.
struct ChordDiagramView: View {
    let diagram: String
    private let frets: [Int?]

    init(diagram: String) {
        self.diagram = diagram
        self.frets = ChordDiagramView.parse(diagram: diagram)
    }

    var body: some View {
        if frets.count == 6 {
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let stringSpacing = width / 5
                let fretSpacing = height / 5

                ZStack {
                    // Strings
                    ForEach(0..<6) { i in
                        Path { path in
                            let x = CGFloat(i) * stringSpacing
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: height))
                        }
                        .stroke(.primary, lineWidth: 1)
                    }
                    // Frets
                    ForEach(1..<5) { i in
                        Path { path in
                            let y = CGFloat(i) * fretSpacing
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: width, y: y))
                        }
                        .stroke(.primary, lineWidth: 1)
                    }
                    // Markers
                    ForEach(0..<6) { i in
                        if let fret = frets[i] {
                            if fret == 0 {
                                Circle()
                                    .stroke(.primary, lineWidth: 1)
                                    .frame(width: 10, height: 10)
                                    .position(x: CGFloat(i) * stringSpacing, y: -fretSpacing/2)
                            } else {
                                Circle()
                                    .fill(.primary)
                                    .frame(width: 12, height: 12)
                                    .position(x: CGFloat(i) * stringSpacing, y: CGFloat(fret) * fretSpacing - fretSpacing/2)
                            }
                        } else {
                            Text("X")
                                .font(.caption)
                                .position(x: CGFloat(i) * stringSpacing, y: -fretSpacing/2)
                        }
                    }
                }
            }
        } else {
            // Fallback to plain text if the diagram format is unexpected
            Text(diagram)
                .font(.title)
        }
    }

    private static func parse(diagram: String) -> [Int?] {
        let chars = Array(diagram.lowercased())
        guard chars.count == 6 else { return [] }
        var result: [Int?] = []
        for ch in chars {
            if ch == "x" { result.append(nil) }
            else if let val = Int(String(ch)) { result.append(val) }
            else { return [] }
        }
        return result
    }
}

#Preview {
    VStack {
        ChordDiagramView(diagram: "x32010")
            .frame(width: 80, height: 100)
        ChordDiagramView(diagram: "C")
            .frame(width: 80, height: 100)
    }
}
