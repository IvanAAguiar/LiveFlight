#LiveFlight

Project GitHub Link: https://github.com/IvanAAguiar/LiveFlight.git

Overview

LiveFlight is a project that provides information about flights, airlines, and airports. This README describes how to use the API, the application structure, the testing strategy, assumptions and limitations, and suggestions for future improvements.

Table of Contents

API Usage

Application Structure Explanation

Testing StrategyAssumptions or Limitations

Suggestions for Future Improvements

API Usage

The LiveFlight API provides access to flight, airline, and airport data.

Endpoints

GET /flights: Returns a list of flights.

Parameters:

date (optional): Filters flights by date (YYYY-MM-DD format).

airline (optional): Filters flights by airline.

Request Example:

GET /flights?date=2024-07-28&airline=GOL

Response Example:\[

{

"id": 1,

"flightNumber": "G31234",

"airline": "GOL",

"departureAirport": "GRU",

"arrivalAirport": "CGH",

"scheduledDeparture": "2024-07-28T10:00:00",

"scheduledArrival": "2024-07-28T11:00:00"

},

{

"id": 2,

"flightNumber": "LA4567",

"airline": "LATAM",

"departureAirport": "CGH",

"arrivalAirport": "SDU",

"scheduledDeparture": "2024-07-28T12:00:00",

"scheduledArrival": "2024-07-28T13:00:00"

}

\]

GET /airlines: Returns a list of airlines.Request Example:

GET /airlines

Response Example:\[

{

"code": "GOL",

"name": "Gol Linhas Aéreas"

},

{

"code": "LATAM",

"name": "LATAM Airlines"

}

\]

Description:

This endpoint returns a list of all airlines available in the database. Each airline is represented by a code and a name.

GET /airports: Returns a list of airports.

Request Example:

GET /airports

Response Example:\[

{

"code": "GRU",

"name": "Aeroporto Internacional de Guarulhos"

},

{

"code": "CGH",

"name": "Aeroporto de Congonhas"

},

{

"code": "SDU",

"name": "Aeroporto Santos Dumont"

}

\]

Authentication

The API does not require authentication.

Status Codes

200 OK: The request was successful.

400 Bad Request: The request is incorrect (e.g., invalid parameters).

500 Internal Server Error: An error occurred on the server.

Application Structure Explanation

LiveFlight follows the MVVM (Model-View-ViewModel) architecture.

Models: Represent the application's data (e.g., Flight, Airline, Airport).

Views: Display the data to the user (e.g., flight listing screens, flight details). Views are passive and depend on the ViewModel to update their content.

ViewModels: Manage the presentation logic and prepare the data for display in the Views. They act as intermediaries between the Models and the Views.

Services: The ApiService is responsible for making the calls to the external API to fetch flight, airline, and airport data. It encapsulates the logic of communicating with the API, such as constructing URLs, sending requests, and handling responses.

Repository (Pattern): The Repository pattern is used to abstract the data access layer. The ApiClient acts as a repository, providing a unified interface to access the data, whether from the API (via ApiService) or CoreData. This allows the rest of the application (ViewModels) to interact with the data consistently, without needing to worry about the data source.

CoreData: Persistence.swift configures CoreData to store the data locally. The application uses CoreData to persist the data fetched from the API, which allows the application to function more efficiently, avoiding multiple calls to the API for the same data.

The project's directory structure is as follows:

LiveFlight/

├── Controllers/ # Contains the ViewModels

│ ├── FlightViewModel.swift

│ ├── AirlineViewModel.swift

│ └── AirportViewModel.swift

├── Models/

│ ├── Flight.swift

│ ├── Airline.swift

│ └── Airport.swift

├── Views/

│ ├── FlightListView.swift

│ ├── FlightDetailView.swift

│ ├── AirlineListView.swift

│ └── AirportListView.swift

├── Services/

│ └── ApiService.swift # Responsible for making API calls

├── CoreData/

│ └── Persistence.swift # CoreData configuration

├── Repository/

│ └── ApiClient.swift # Repository that abstracts data access

└── ...other files...

Testing Strategy

LiveFlight uses unit tests to ensure code quality. The main components tested are:

Models: Data integrity validation.

ViewModels: Presentation logic and interaction with Models and Views.

Services: API integration tests, verifying that the calls return the expected data.

CoreData: Persistence tests, ensuring that data is saved and retrieved correctly.

To run the tests, use the appropriate command from your development environment (e.g., Command + U in Xcode).

Assumptions or Limitations

The application assumes that the API is working correctly and returning valid data.

The application uses CoreData to cache data, but does not implement full synchronization. Local data may become outdated if the API is updated.

The user interface is basic and may not be fully optimized for all screen sizes.

Error handling is basic.

There is no support for pagination in the API.

Suggestions for Future Improvements

Bug Fixes:

Bug when filtering airlines.

Resolve background warning.

Refactoring:

Refactor the relationships of the repositories.

Restructure the FlightModel and FlightEntity to reuse the same component for Arrival and Departure.

UX Improvements:

Show a snackbar when objects are saved or not.

Find a way to update the language according to user preferences.

Create a reusable component for filtering the views.

Data Management:

Consider a way to check if there is new information to update what we have saved in CoreData.

Dependency Management

Create factories to better manage dependencies.

Testing:

Fix test in FlightsRepository, the problem is probably in the createAirlineModel() method in FlightsRepository.

Improve FlightServiceTests tests.
