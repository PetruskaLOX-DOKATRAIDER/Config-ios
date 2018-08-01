public protocol AutoInit {}

// extend you models with AutoInit marker here (or in any other place if you want)

extension ImageSize: AutoInit {}
extension PlayerPreview: AutoInit {}
extension PlayerDescription: AutoInit {}
extension Team: AutoInit {}
extension Coordinates: AutoInit {}
extension Event: AutoInit {}
extension NewsPreview: AutoInit {}
extension NewsDescription: AutoInit {}
extension NewsImageContent: AutoInit {}
extension NewsTextContent: AutoInit {}
