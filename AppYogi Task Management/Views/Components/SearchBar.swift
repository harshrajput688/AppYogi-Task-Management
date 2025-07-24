import SwiftUI

/// A reusable search bar component for filtering content
struct SearchBar: View {
    // MARK: - Properties
    
    /// Binding to the search text that will be used for filtering
    @Binding var text: String
    
    // MARK: - View Body
    
    var body: some View {
        HStack {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            // Text field for search input
            TextField("Search tasks...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())  // Removes default styling
                .autocapitalization(.none)  // Disables auto-capitalization
                .disableAutocorrection(true)  // Disables autocorrection
            
            // Clear button (only shown when there's text)
            if !text.isEmpty {
                Button(action: {
                    text = ""  // Clears the search text
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        // Visual styling
        .padding(8)  // Inner padding
        .background(Color(.systemGray6))  // Light gray background
        .cornerRadius(10)  // Rounded corners
        .padding(.horizontal)  // Outer horizontal padding
    }
}

// MARK: - Preview

#Preview {
    SearchBar(text: .constant(""))  // Preview with empty search text
}
