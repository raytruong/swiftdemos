import Foundation

class QuoteService {
    let decoder = JSONDecoder()

    func fetchQuote() async throws -> QuoteResponse {
        let url = URL(string: "https://api.quotable.io/random")!
        let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let (data, responseInfo) = try await URLSession.shared.data(for: urlRequest)

        let decodedResponse = try decoder.decode(QuoteResponse.self, from: data)

        return decodedResponse
    }
}

struct QuoteResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case author = "author"
    }

    let content: String
    let author: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.author = try container.decode(String.self, forKey: .author)
    }
}
