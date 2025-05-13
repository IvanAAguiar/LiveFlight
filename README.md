# LiveFlight

📍 **GitHub:** [LiveFlight Repository](https://github.com/IvanAAguiar/LiveFlight.git)

LiveFlight is a project that provides information about flights, airlines, and airports. This README describes how to use the API, the application's structure, the testing strategy, assumptions and limitations, and suggestions for future improvements.

---

## 📚 Table of Contents

- [API Usage](#api-usage)
- [Application Structure](#application-structure)
- [Testing Strategy](#testing-strategy)
- [Assumptions and Limitations](#assumptions-and-limitations)
- [Suggestions for Future Improvements](#suggestions-for-future-improvements)

---

## 🔌 API Usage

The LiveFlight API provides access to flight, airline, and airport data.

### 🔹 Endpoints

#### `GET /flights`
Returns a list of flights.

**Optional parameters:**
- `date`: filters by date (`YYYY-MM-DD` format)
- `airline`: filters by airline

**Request example:**
```
GET /flights?date=2024-07-28&airline=GOL
```

**Response:**
```json
[
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
]
```

#### `GET /airlines`
Returns a list of airlines.

**Request example:**
```
GET /airlines
```

**Response:**
```json
[
  {
    "code": "GOL",
    "name": "Gol Linhas Aéreas"
  },
  {
    "code": "LATAM",
    "name": "LATAM Airlines"
  }
]
```

#### `GET /airports`
Returns a list of airports.

**Request example:**
```
GET /airports
```

**Response:**
```json
[
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
]
```

### 🔐 Authentication
The API **does not require authentication**.

### 📘 Status Codes
- `200 OK`: Request succeeded
- `400 Bad Request`: Invalid parameters
- `500 Internal Server Error`: Server error

---

## 🏗 Application Structure

LiveFlight follows the **MVVM (Model-View-ViewModel)** architecture.

### 🔹 Layers

- **Models:** Represent the data (e.g., `Flight`, `Airline`, `Airport`)
- **Views:** Display data (e.g., `FlightListView`, `FlightDetailView`)
- **ViewModels:** Contain presentation logic and interaction
- **Services:** `ApiService.swift` handles API calls
- **Repository:** `ApiClient.swift` acts as the repository (unified interface)
- **CoreData:** `Persistence.swift` manages local persistence

### 📁 Directory Structure
```
LiveFlight/
├── Controllers/
│   ├── FlightViewModel.swift
│   ├── AirlineViewModel.swift
│   └── AirportViewModel.swift
├── Models/
│   ├── Flight.swift
│   ├── Airline.swift
│   └── Airport.swift
├── Views/
│   ├── FlightListView.swift
│   ├── FlightDetailView.swift
│   ├── AirlineListView.swift
│   └── AirportListView.swift
├── Services/
│   └── ApiService.swift
├── CoreData/
│   └── Persistence.swift
├── Repository/
│   └── ApiClient.swift
└── ...other files...
```

---

## 🧪 Testing Strategy

LiveFlight uses **unit tests** to ensure code quality.

### Tested components:

- **Models:** Data validation
- **ViewModels:** Presentation logic
- **Services:** API integration
- **CoreData:** Data persistence

> To run the tests:  
> 📱 **Command + U** in Xcode

---

## ⚠ Assumptions and Limitations

- The app assumes the API is functioning and returning valid data.
- CoreData is used to cache data, but does not implement full synchronization.
- The UI is basic and may not be fully responsive on all devices.
- Error handling is limited.
- The API does not support pagination.

---

## 🚀 Suggestions for Future Improvements

### 🐞 Bug Fixes
- Fix bug when filtering airlines
- Resolve background warning

### 🔧 Refactoring
- Refactor repository relationships
- Restructure `FlightModel` and `FlightEntity` to reuse arrival/departure components

### 🎨 UX Enhancements
- Show snackbar when objects are saved
- Add support for language preferences
- Create reusable component for filters

### 📊 Data Management
- Add mechanism to check for updated data from the API

### 🧩 Dependency Management
- Create factories for better dependency handling

### ✅ Testing
- Fix test in `FlightsRepository` (`createAirlineModel()` might be the issue)
- Improve `FlightServiceTests`
