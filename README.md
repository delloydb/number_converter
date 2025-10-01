# number_converter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 🔢 Number System Converter  
*A clean, minimalist Flutter app for converting numbers between Binary, Decimal, Hexadecimal, and Octal.*

<p align="center">
  <img src="assets/screenshots/banner.png" alt="App Banner" width="700"/>
</p>

---

## ✨ Features
- 🎨 **Minimalist Design** — Blue, White, and Black theme for a professional look.  
- 📥 **Input Flexibility** — Enter numbers in **Binary, Decimal, Hexadecimal, or Octal**.  
- 🔄 **Real-time Conversion** — Instantly view the equivalent values in all 4 number systems.  
- 🧮 **Accurate Calculations** — Built with `BigInt`, so it handles **very large integers** with ease.  
- 🛑 **Input Validation** — Clear error messages when users enter invalid characters.  
- 📋 **Tap to Copy** — Results can be copied to clipboard with a single tap.  
- 📱 **Responsive UI** — Works seamlessly on small phones and wide tablet screens.  
- ⚡ **Lightweight** — No unnecessary dependencies.  

---

## 📸 Screenshots

<p align="center">
  <img src="assets/screenshots/home_light.png" alt="Home Screen Light Mode" width="300"/>
  <img src="assets/screenshots/error_message.png" alt="Error Message" width="300"/>
</p>

<p align="center">
  <em>Minimalist interface with responsive layout and error handling.</em>
</p>

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.0)
- Dart (comes with Flutter)
- An emulator or physical device

🏗️ Project Structure
bash
Copy code
lib/
 └── main.dart        # Entry point of the application
assets/
 └── screenshots/     # Place your screenshots and banner images here
🎨 UI/UX Design
The design follows a modern minimalist theme:

Colors:

Primary Blue (#0B63D1)

Background White

Text Black/Gray

Font: System font with monospace for results

Layout:

Input section with dropdown for base selection

Real-time results displayed in responsive grid/list

Error messages displayed with red accent

⚙️ Conversion Logic
Conversion uses BigInt.parse(value, radix) for parsing large values.

Supports negative numbers (- prefix).

Validations are regex-based:

Binary → ^[01]+$

Decimal → ^[0-9]+$

Hexadecimal → ^[0-9a-fA-F]+$

Octal → ^[0-7]+$

🧪 Example Usage
Input Base	Input Value	Binary	Decimal	Hexadecimal	Octal
Decimal	42	101010	42	2A	52
Binary	1101	1101	13	D	15
Hex	7F	1111111	127	7F	177
Octal	755	111101101	493	1ED	755

⚡ Future Improvements
 Support for fractional numbers (e.g., 10.5 in binary).

 Auto-detect base from prefixes (0b, 0x, 0o).

 Add dark mode toggle.

 Add a conversion history feature.

🤝 Contributing
Pull requests are welcome. For major changes, open an issue first to discuss what you’d like to change.

Fork the project

Create your feature branch (git checkout -b feature/amazing-feature)

Commit your changes (git commit -m 'Add some amazing feature')

Push to the branch (git push origin feature/amazing-feature)

Open a Pull Request

### Clone the Repository
```bash
git clone https://github.com/your-username/number-system-converter.git
cd number-system-converter
Install Dependencies
bash
Copy code
flutter pub get
Run the App
bash
Copy code
flutter run

📜 License
Distributed under the MIT License. See LICENSE for details.

💡 Inspiration
Because typing "decimal to hex converter" into a search bar every two minutes gets old. This app puts the power of number systems right in your pocket — no ads, no nonsense, just conversions.

<p align="center"> Made with ❤️ using <b>Flutter</b> </p> ```
