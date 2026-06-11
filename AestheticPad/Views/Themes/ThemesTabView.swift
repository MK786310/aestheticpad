import SwiftUI

struct ThemesTabView: View {
    @StateObject private var viewModel = ThemeViewModel()
    @State private var showCreateSheet = false
    @State private var showCustomizeSheet = false
    @State private var selectedTheme: Theme?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Current Theme Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Theme")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            Circle()
                                .fill(viewModel.selectedTheme.primaryColor)
                                .frame(width: 60, height: 60)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.selectedTheme.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(viewModel.selectedTheme.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if viewModel.selectedTheme.isPremium {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding()
                    
                    // All Themes Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Available Themes")
                                .font(.headline)
                            Spacer()
                            Button(action: { showCreateSheet = true }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            ForEach(viewModel.allThemes) { theme in
                                ThemeItemView(
                                    theme: theme,
                                    isSelected: viewModel.selectedTheme.id == theme.id,
                                    onSelect: { viewModel.setCurrentTheme(theme) },
                                    onCustomize: {
                                        selectedTheme = theme
                                        showCustomizeSheet = true
                                    },
                                    onDelete: { viewModel.deleteTheme(theme) },
                                    onDuplicate: { viewModel.duplicateTheme(theme) }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Themes")
            .sheet(isPresented: $showCreateSheet) {
                CreateThemeSheet(viewModel: viewModel, isPresented: $showCreateSheet)
            }
            .sheet(isPresented: $showCustomizeSheet) {
                if let theme = selectedTheme {
                    CustomizeThemeSheet(viewModel: viewModel, theme: theme, isPresented: $showCustomizeSheet)
                }
            }
        }
    }
}

struct ThemeItemView: View {
    let theme: Theme
    let isSelected: Bool
    let onSelect: () -> Void
    let onCustomize: () -> Void
    let onDelete: () -> Void
    let onDuplicate: () -> Void
    @State private var showMenu = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                // Color Preview
                HStack(spacing: 4) {
                    Circle().fill(theme.primaryColor).frame(width: 20, height: 20)
                    Circle().fill(theme.secondaryColor).frame(width: 20, height: 20)
                    Circle().fill(theme.accentColor).frame(width: 20, height: 20)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(theme.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(theme.description)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    if theme.isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.orange)
                    }
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(8)
            .onTapGesture(perform: onSelect)
            
            // Action Buttons
            HStack(spacing: 8) {
                if theme.isCustom {
                    Button(action: onCustomize) {
                        Label("Edit", systemImage: "pencil")
                            .font(.caption2)
                    }
                    .buttonStyle(.bordered)
                }
                
                Button(action: onDuplicate) {
                    Label("Duplicate", systemImage: "doc.on.doc")
                        .font(.caption2)
                }
                .buttonStyle(.bordered)
                
                if theme.isCustom {
                    Button(action: onDelete) {
                        Label("Delete", systemImage: "trash")
                            .font(.caption2)
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct CreateThemeSheet: View {
    @ObservedObject var viewModel: ThemeViewModel
    @Binding var isPresented: Bool
    @State private var themeName = ""
    @State private var primaryColor = Color.blue
    @State private var secondaryColor = Color.cyan
    @State private var accentColor = Color.purple
    @State private var backgroundColor = Color.white
    @State private var surfaceColor = Color.gray
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Theme Details") {
                    TextField("Theme Name", text: $themeName)
                }
                
                Section("Colors") {
                    ColorPicker("Primary Color", selection: $primaryColor)
                    ColorPicker("Secondary Color", selection: $secondaryColor)
                    ColorPicker("Accent Color", selection: $accentColor)
                    ColorPicker("Background Color", selection: $backgroundColor)
                    ColorPicker("Surface Color", selection: $surfaceColor)
                }
                
                Section("Preview") {
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Circle().fill(primaryColor).frame(width: 40, height: 40)
                            Circle().fill(secondaryColor).frame(width: 40, height: 40)
                            Circle().fill(accentColor).frame(width: 40, height: 40)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Create Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        viewModel.createCustomTheme(
                            name: themeName,
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
                            accentColor: accentColor,
                            backgroundColor: backgroundColor,
                            surfaceColor: surfaceColor
                        )
                        isPresented = false
                    }
                    .disabled(themeName.isEmpty)
                }
            }
        }
    }
}

struct CustomizeThemeSheet: View {
    @ObservedObject var viewModel: ThemeViewModel
    var theme: Theme
    @Binding var isPresented: Bool
    @State private var themeName: String
    @State private var primaryColor: Color
    @State private var secondaryColor: Color
    @State private var accentColor: Color
    @State private var backgroundColor: Color
    @State private var surfaceColor: Color
    
    init(viewModel: ThemeViewModel, theme: Theme, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.theme = theme
        self._isPresented = isPresented
        _themeName = State(initialValue: theme.name)
        _primaryColor = State(initialValue: theme.primaryColor)
        _secondaryColor = State(initialValue: theme.secondaryColor)
        _accentColor = State(initialValue: theme.accentColor)
        _backgroundColor = State(initialValue: theme.backgroundColor)
        _surfaceColor = State(initialValue: theme.surfaceColor)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Theme Details") {
                    TextField("Theme Name", text: $themeName)
                }
                
                Section("Colors") {
                    ColorPicker("Primary Color", selection: $primaryColor)
                    ColorPicker("Secondary Color", selection: $secondaryColor)
                    ColorPicker("Accent Color", selection: $accentColor)
                    ColorPicker("Background Color", selection: $backgroundColor)
                    ColorPicker("Surface Color", selection: $surfaceColor)
                }
            }
            .navigationTitle("Edit Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var updatedTheme = theme
                        updatedTheme.name = themeName
                        updatedTheme.primaryColor = primaryColor
                        updatedTheme.secondaryColor = secondaryColor
                        updatedTheme.accentColor = accentColor
                        updatedTheme.backgroundColor = backgroundColor
                        updatedTheme.surfaceColor = surfaceColor
                        viewModel.updateTheme(updatedTheme)
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    ThemesTabView()
}
