# LiveFlight

📍 **GitHub:** [LiveFlight Repository](https://github.com/IvanAAguiar/LiveFlight.git)

LiveFlight é um projeto que fornece informações sobre voos, companhias aéreas e aeroportos. Este README descreve como utilizar a API, a estrutura da aplicação, a estratégia de testes, premissas e limitações, além de sugestões para melhorias futuras.

---

## 📚 Tabela de Conteúdo

- [API Usage](#api-usage)
- [Application Structure](#application-structure)
- [Testing Strategy](#testing-strategy)
- [Assumptions and Limitations](#assumptions-and-limitations)
- [Suggestions for Future Improvements](#suggestions-for-future-improvements)

---

## 🔌 API Usage

A API do LiveFlight fornece acesso a dados de voos, companhias aéreas e aeroportos.

### 🔹 Endpoints

#### `GET /flights`
Retorna uma lista de voos.

**Parâmetros (opcionais):**
- `date`: filtra por data (formato `YYYY-MM-DD`)
- `airline`: filtra por companhia aérea

**Exemplo de requisição:**
```
GET /flights?date=2024-07-28&airline=GOL
```

**Resposta:**
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
Retorna a lista de companhias aéreas.

**Exemplo de requisição:**
```
GET /airlines
```

**Resposta:**
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
Retorna a lista de aeroportos.

**Exemplo de requisição:**
```
GET /airports
```

**Resposta:**
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

### 🔐 Autenticação
A API **não requer autenticação**.

### 📘 Códigos de Status
- `200 OK`: Requisição bem-sucedida
- `400 Bad Request`: Erro nos parâmetros
- `500 Internal Server Error`: Erro interno no servidor

---

## 🏗 Application Structure

O LiveFlight segue a arquitetura **MVVM (Model-View-ViewModel)**.

### 🔹 Camadas

- **Models:** Representam os dados (e.g. `Flight`, `Airline`, `Airport`)
- **Views:** Apresentam os dados (e.g. `FlightListView`, `FlightDetailView`)
- **ViewModels:** Contêm a lógica de apresentação e interação
- **Services:** `ApiService.swift` faz chamadas à API
- **Repository:** `ApiClient.swift` atua como repositório (interface unificada)
- **CoreData:** `Persistence.swift` configura persistência local

### 📁 Estrutura de Diretórios
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
└── ...outros arquivos...
```

---

## 🧪 Testing Strategy

LiveFlight utiliza **testes unitários** para garantir a qualidade do código.

### Componentes testados:

- **Models:** Validação dos dados
- **ViewModels:** Lógica de apresentação
- **Services:** Integração com a API
- **CoreData:** Validação da persistência de dados

> Para rodar os testes:  
> 📱 **Command + U** no Xcode

---

## ⚠ Assumptions and Limitations

- A aplicação assume que a API está funcionando corretamente.
- O uso do CoreData não implementa sincronização completa (dados locais podem desatualizar).
- A interface é básica e pode não estar otimizada para todos os tamanhos de tela.
- O tratamento de erros é simples.
- A API não possui suporte a paginação.

---

## 🚀 Suggestions for Future Improvements

### 🐞 Correções de bugs
- Corrigir bug ao filtrar companhias aéreas
- Corrigir warning de background

### 🔧 Refatorações
- Refatorar relacionamentos dos repositórios
- Reestruturar `FlightModel` e `FlightEntity` para reutilizar componente de chegada/partida

### 🎨 Melhorias na UX
- Mostrar snackbar ao salvar objetos
- Adaptar idioma conforme preferência do usuário
- Criar componente reutilizável para filtros

### 📊 Gerenciamento de Dados
- Verificar se há novos dados na API para atualizar CoreData

### 🧩 Gerenciamento de Dependências
- Criar fábricas para organizar dependências

### ✅ Testes
- Corrigir teste em `FlightsRepository` (provável erro no método `createAirlineModel()`)
- Melhorar testes em `FlightServiceTests`
