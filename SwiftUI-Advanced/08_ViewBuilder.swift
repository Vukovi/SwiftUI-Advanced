//
//  08_ViewBuilder.swift
//  SwiftUI-Advanced
//
//  Created by Vuk Knezevic on 18.11.23.
//

import SwiftUI

// MARK: - Pomocu @ViewBuilder mozemo keirati klozure koji ce imati child view-eve

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            HeaderViewRegular(title: "Title", description: "Description", image: "heart.fill")
            
            HeaderViewRegular(title: "New Title", description: nil, image: nil)
            
            HeaderGeneric(title: "Generic Title 1", content: Text("Hello"))
            
            HeaderGeneric(title: "Generic Title 2", content: Image(systemName: "heart.fill"))
            
            HeaderGeneric(title: "Generic Title 3", content:
            HStack {
                Text("Hello")
                Image(systemName: "heart.fill")
            })
            
            HeaderGenericViewBuilder(title: "Generic Title 4") {
                HStack {
                    Text("Hello")
                    Image(systemName: "heart.fill")
                }
            }
            
            Spacer()
        }
    }
}

struct HeaderViewRegular: View {
    
    let title: String
    let description: String?
    let image: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            if let description = description {
                Text(description)
                    .font(.caption)
            }
            
            if let image = image {
                Image(systemName: image)
            }
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct HeaderGeneric<Content: View>: View {
    
    let title: String
    let content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct HeaderGenericViewBuilder<Content: View>: View {
    
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
//    ViewBuilderBootcamp()
    LocalViewBuilder(type: .one)
}


struct LocalViewBuilder: View {
    
    enum ViewType {
        case one, two, three
    }
    
    let type: ViewType
    
    var body: some View {
        header
    }
    
    // MARK: - @ViewBuilder ne mora da vrati samo jedan view element, kod njega moze ovaj switch da radi za razliku od varijable three kod koje mora da se vrati samo jedan view, a to je VStack. @ViewBuilder kad se pozove on tek onda daje view element, za razliku od obicnog view-a koji mora odmah da ima definisan jedan view
    @ViewBuilder private var header: some View {
        switch type {
        case .one: one
        case .two: two
        case .three: three
        }
    }
    
    private var one: some View {
        Text("One")
    }
    
    private var two: some View {
        Image(systemName: "heart.fill")
    }
    
    private var three: some View {
        VStack {
            Image(systemName: "heart.fill")
            Text("Three")
        }
    }
}
