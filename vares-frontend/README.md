# VARES POS - Frontend

React frontend for the VARES Point of Sale system.

## Technology Stack

- **React**: 18.2
- **Build Tool**: Vite 5.0
- **UI Framework**: Material-UI (MUI) 5.15
- **Routing**: React Router 6.21
- **HTTP Client**: Axios 1.6
- **Real-time**: Socket.IO Client 4.6

## Project Structure

```
src/
├── components/
│   ├── common/          # Reusable components
│   ├── layout/          # Layout components
│   ├── auth/            # Authentication components
│   ├── tables/          # Table management components
│   ├── orders/          # Order management components
│   └── kitchen/         # Kitchen display components
├── pages/
│   ├── Login.jsx
│   ├── Dashboard.jsx
│   ├── Tables.jsx
│   ├── Orders.jsx
│   └── Kitchen.jsx
├── services/
│   ├── api.js           # Axios instance
│   └── authService.js   # Authentication service
├── context/
│   └── AuthContext.jsx  # Authentication context
├── utils/               # Utility functions
├── App.jsx              # Main app component
├── main.jsx             # Entry point
└── index.css            # Global styles
```

## Features

### Implemented
- ✅ Login page with authentication
- ✅ Protected routes with role-based access
- ✅ Dashboard with role-specific menu
- ✅ JWT token management
- ✅ Axios interceptors for auth
- ✅ Material-UI theming
- ✅ Responsive design

### In Development
- 🚧 Table management (floor map)
- 🚧 Order taking interface
- 🚧 Kitchen display screen
- 🚧 Payment processing
- 🚧 Real-time notifications (WebSocket)
- 🚧 Reservation system

## Running Locally

### Prerequisites
- Node.js 20+
- npm or yarn

### Steps

1. **Install dependencies**:
```bash
npm install
```

2. **Configure environment**:
Create a `.env` file:
```env
VITE_API_URL=http://localhost:8080/api
VITE_WS_URL=ws://localhost:8080/ws
```

3. **Run development server**:
```bash
npm run dev
```

The app will be available at `http://localhost:3000`

4. **Build for production**:
```bash
npm run build
```

## Running with Docker

The frontend is containerized and runs as part of the docker-compose setup.

See main README for instructions.

## Default Login Credentials

- **Email**: admin@vares.com
- **Password**: admin123

## Available Routes

- `/login` - Login page (public)
- `/dashboard` - Main dashboard (authenticated)
- `/tables` - Table management (WAITER, SUPERUSER)
- `/orders` - Order management (WAITER, SUPERUSER)
- `/kitchen` - Kitchen display (COOK, SUPERUSER)
- `/cashier` - Payment processing (CASHIER, SUPERUSER)

## Role-Based Access

The system implements role-based access control:

- **SUPERUSER**: Full access to all features
- **WAITER**: Tables, Orders
- **COOK**: Kitchen display
- **CASHIER**: Payment processing

## Development Guidelines

### Component Structure
- Use functional components with hooks
- Implement proper prop validation
- Keep components focused and reusable

### State Management
- Use Context API for global state (auth, etc.)
- Use local state for component-specific data
- Consider Redux for complex state if needed

### Styling
- Use Material-UI components
- Follow Material Design guidelines
- Use CSS-in-JS (emotion) for custom styles
- Maintain responsive design

### API Calls
- Use the centralized `api.js` service
- Handle errors gracefully
- Show loading states
- Provide user feedback

## Next Steps

1. Implement table floor map visualization
2. Create order taking interface
3. Build kitchen display with real-time updates
4. Add WebSocket for live notifications
5. Implement reservation system
6. Add payment processing UI
7. Create reporting dashboards
