import Foundation
import Playgrounds

struct PostDto: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct Post: Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct HTTPClient {
    static func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func post<T: Decodable, U: Encodable>(to url: URL, body: U) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

struct PostFetcher {
    let postEndpoint = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    func fetch() async throws -> [Post] {
        let postDtos: [PostDto] = try await HTTPClient.fetch(from: postEndpoint)
        let posts: [Post] = postDtos.map { postDto in
            Post(
                userId: postDto.userId,
                id: postDto.id,
                title: postDto.title,
                body: postDto.body
            )
        }
        return posts
    }
}

#Playground {
    let postFetcher = PostFetcher()

    do {
        let post = try await postFetcher.fetch()
        print(post)
    } catch {
        print(error)
    }
}
