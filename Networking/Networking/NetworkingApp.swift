//
//  NetworkingApp.swift
//  Networking
//
//  Created by Raymond Truong on 9/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var postFetcher = PostFetcher()
    @State private var posts: [Post] = []

    var body: some View {
        List {
            ForEach(posts) { post in
                card(cornerRadius: 10) {
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.title3)
                        Rectangle().frame(height: 1).padding(.horizontal, 10)
                        Text(post.body)
                            .lineLimit(0)
                            .font(.body)
                    }
                    .frame(
                        width: .infinity,
                        height: 100,
                        alignment: .topLeading
                    )
                }
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .task {
            await fetchPosts()
        }
    }

    @ViewBuilder
    private func card(
        cornerRadius: CGFloat = 10,
        content: () -> some View
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
                .foregroundStyle(.ultraThinMaterial)
            content()
                .padding()
        }
    }

    @MainActor
    private func fetchPosts() async {
        guard let fetchedPosts = try? await postFetcher.fetch() else {
            return
        }

        self.posts = fetchedPosts
    }
}

@main
struct NetworkingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
