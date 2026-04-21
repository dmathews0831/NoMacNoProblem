# Mobile Casino For iOS and watchOS

This project is a simple casino app for both iOS and the Apple Watch! 

Users can play two casino games: blackjack and roulette.

## How to Run

Clone this repository into Xcode. The project should automatically build and run!

## Known Issues

If the Apple Watch version of the app isn't running:
- Install the latest version of watchOS for Xcode in Settings --> Components
- Make sure you set the watch target minimum deployment for iOS and watchOS to 26.0 in project --> General --> Minimum Deployments.

## Functional/Non-Functional Requirements

Below are the functional/non-functional requirements that we implemented.

### Functional Requirements:
- The player should be able to collect their daily coin bonus
- The player should be able to spin the roulette wheel to get a random number
- The player should be able to place bets on the roulette table
- The player should be able to choose to hit, stand, or double when in a blackjack hand
- The player should be able to be able to sign-in with their Apple Account
- The host should be able to select the game type
- The host should be able to choose the number of human/CPU players for the game
- The host should be able to start the game by clicking a “launch game” button
- The host should be able to end the game by clicking a “leave” button

### Non-functional Requirements:

- When playing blackjack, the game should have a delay when displaying the next card
- Fetching a random number should take less than 1 second in online mode
- App should default to offline mode if random number fetching fails
- The user login feature should be conducted securely, preferably using Apple Sign-in
- App should default to using AppStorage if Apple Sign-in fails
