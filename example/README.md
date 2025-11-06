# QCF Quran Package Example

This is a comprehensive Flutter application that demonstrates all the features of the `qcf_quran` package.

## Features Demonstrated

### 1. Quran PageView
- Full Quran mushaf with 604 pages
- Swipe navigation between pages
- Page jumping functionality
- Verse highlighting
- Long-press to get verse details
- RTL (Right-to-Left) text direction

### 2. Single Verse Display
- Display individual verses using `QcfVerse` widget
- Dynamic surah and verse selection
- Adjustable font size
- Long-press interaction

### 3. Search Functionality
- Search Quran text in Arabic
- Display search results with verse locations
- View complete verses from search results

### 4. Data Functions
- Display Quran constants and metadata
- Show surah information
- Demonstrate page data functions

## How to Run

1. Make sure you have Flutter SDK installed
2. Navigate to the example directory:
   ```bash
   cd example
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Package Dependencies

This example uses the local `qcf_quran` package from the parent directory. Any changes made to the package will be immediately reflected in this example app.

## Testing Your Changes

1. Make modifications to the `qcf_quran` package in the parent directory
2. Run this example app to test your changes
3. The app will automatically use your updated package code

## App Navigation

The app has 4 main tabs accessible from the bottom navigation:

1. **Quran Pages**: Full Quran PageView with navigation controls
2. **Single Verse**: Individual verse display with customization options
3. **Search**: Search functionality for Quran text
4. **Data Info**: Quran metadata and information display

## Key Features Tested

- ✅ `PageviewQuran` widget functionality
- ✅ `QcfVerse` widget rendering
- ✅ Font loading and display
- ✅ RTL text rendering
- ✅ Search functionality
- ✅ Data retrieval functions
- ✅ User interactions (tap, long-press, swipe)
- ✅ Responsive design
- ✅ State management

This example app provides a comprehensive test environment for verifying that all features of your `qcf_quran` package work correctly after making updates.