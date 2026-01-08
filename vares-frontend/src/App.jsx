import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import PrivateRoute from './components/auth/PrivateRoute';

// Pages
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Tables from './pages/Tables';
import Orders from './pages/Orders';
import Kitchen from './pages/Kitchen';

const theme = createTheme({
    palette: {
        primary: {
            main: '#1976d2',
        },
        secondary: {
            main: '#dc004e',
        },
    },
    typography: {
        fontFamily: [
            '-apple-system',
            'BlinkMacSystemFont',
            '"Segoe UI"',
            'Roboto',
            '"Helvetica Neue"',
            'Arial',
            'sans-serif',
        ].join(','),
    },
});

function App() {
    return (
        <ThemeProvider theme={theme}>
            <CssBaseline />
            <Router>
                <Routes>
                    <Route path="/login" element={<Login />} />
                    <Route
                        path="/dashboard"
                        element={
                            <PrivateRoute>
                                <Dashboard />
                            </PrivateRoute>
                        }
                    />
                    <Route
                        path="/tables"
                        element={
                            <PrivateRoute>
                                <Tables />
                            </PrivateRoute>
                        }
                    />
                    <Route
                        path="/orders"
                        element={
                            <PrivateRoute>
                                <Orders />
                            </PrivateRoute>
                        }
                    />
                    <Route
                        path="/kitchen"
                        element={
                            <PrivateRoute roles={['COOK', 'SUPERUSER']}>
                                <Kitchen />
                            </PrivateRoute>
                        }
                    />
                    <Route path="/" element={<Navigate to="/dashboard" replace />} />
                </Routes>
            </Router>
        </ThemeProvider>
    );
}

export default App;
