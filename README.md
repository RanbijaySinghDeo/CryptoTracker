# CryptoTracker

CryptoTracker is an iOS application that allows users to track the  cryptocurrencies. The app displays real-time cryptocurrency data including price, rank, price change, and historical data on a graph. Users can also mark their favorite coins and toggle between different time periods for price data.

## Features

- **Dashboard**: Displays a list of the cryptocurrencies with their current price, rank, and price change.
- **Favorite Coins**: Allows users to mark coins as favorites and access them quickly from the dashboard.
- **Graph View**: Displays a price change graph for each coin, with the ability to toggle between different time periods (1 day, 1 week, 1 month, etc.).
- **Coin Details**: Provides detailed information about a selected cryptocurrency, including market cap, total supply, circulating supply, and external resources.
- **UI**: Simple and intuitive interface using UIKit, with modern styling and smooth navigation.
- **Error Handling**: Includes error handling for network requests and provides feedback to the user.

## Tech Stack

- **iOS**: UIKit, Swift
- **Networking**: URLSession for API calls, Codable for JSON Parsing
- **UI**: UIKit, Auto Layout, Storyboard for UI design
- **Persistence**: UserDefaults for storing favorite coins
- **Graph Rendering**: Custom graph rendering logic for displaying price change over time
- **External APIs**: CoinRanking API for fetching cryptocurrency data

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/CryptoTracker.git
   ```

2. Open the project in Xcode.

3. Build and run the app on a simulator or a real device.

4. If you encounter any issues, ensure that your development environment is set up for Swift development.

## Configuration

- **API Integration**: The app fetches cryptocurrency data from the [CoinRanking API](https://www.coinranking.com/). Ensure that you have properly configured the API key and endpoint in the `NetworkManager.swift` file.
  
  Example:

  ```swift
  static let baseURL = "https://api.coinranking.com/v2/"
  ```

- **Favorite Coins**: The app uses `UserDefaults` to store the user's favorite coins. This allows users to mark coins as favorites and access them easily later.

## Usage

- On the **Dashboard** screen, swipe through the list of top 100 cryptocurrencies.
- Tap any coin to see its **Details** screen, where you can see detailed information such as market cap, total supply, and a price graph.
- Use the **Segmented Control** on the details screen to switch between different time periods for the price graph (e.g., 1 day, 1 week, 1 month).
- Tap the **Favorite** button in the top right corner of the details screen to add/remove coins from your favorites.

## Screenshots


## Contributing

1. Fork the repository.
2. Create a new branch for your feature (`git checkout -b feature/your-feature`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### Acknowledgements

- **CoinRanking API** for providing real-time cryptocurrency data.
- **UIKit** for building the app's UI.
- **Swift** for being an awesome programming language to develop iOS apps.
# CryptoTracker

CryptoTracker is an iOS application that allows users to track the top 100 cryptocurrencies. The app displays real-time cryptocurrency data including price, rank, price change, and historical data on a graph. Users can also mark their favorite coins and toggle between different time periods for price data.

## Features

- **Dashboard**: Displays a list of the top 100 cryptocurrencies with their current price, rank, and price change.
- **Favorite Coins**: Allows users to mark coins as favorites and access them quickly from the dashboard.
- **Graph View**: Displays a price change graph for each coin, with the ability to toggle between different time periods (1 day, 1 week, 1 month, etc.).
- **Coin Details**: Provides detailed information about a selected cryptocurrency, including market cap, total supply, circulating supply, and external resources.
- **UI**: Simple and intuitive interface using UIKit, with modern styling and smooth navigation.
- **Error Handling**: Includes error handling for network requests and provides feedback to the user.

## Tech Stack

- **iOS**: UIKit, Swift
- **Networking**: URLSession for API calls, Codable for JSON Parsing
- **UI**: UIKit, Auto Layout, Storyboard for UI design
- **Persistence**: UserDefaults for storing favorite coins
- **Graph Rendering**: Custom graph rendering logic for displaying price change over time
- **External APIs**: CoinRanking API for fetching cryptocurrency data

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/CryptoTracker.git
   ```

2. Open the project in Xcode.

3. Build and run the app on a simulator or a real device.

4. If you encounter any issues, ensure that your development environment is set up for Swift development.

## Configuration

- **API Integration**: The app fetches cryptocurrency data from the [CoinRanking API](https://www.coinranking.com/). Ensure that you have properly configured the API key and endpoint in the `NetworkManager.swift` file.
  
  Example:

  ```swift
  static let baseURL = "https://api.coinranking.com/v2/"
  ```

- **Favorite Coins**: The app uses `UserDefaults` to store the user's favorite coins. This allows users to mark coins as favorites and access them easily later.

## Usage

- On the **Dashboard** screen, swipe through the list of top 100 cryptocurrencies.
- Tap any coin to see its **Details** screen, where you can see detailed information such as market cap, total supply, and a price graph.
- Use the **Segmented Control** on the details screen to switch between different time periods for the price graph (e.g., 1 day, 1 week, 1 month).
- Tap the **Favorite** button in the top right corner of the details screen to add/remove coins from your favorites.

## Screenshots


## Contributing

1. Fork the repository.
2. Create a new branch for your feature (`git checkout -b feature/your-feature`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### Acknowledgements

- **CoinRanking API** for providing real-time cryptocurrency data.
- **UIKit** for building the app's UI.
- **Swift** for being an awesome programming language to develop iOS apps.
