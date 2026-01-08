import { useNavigate } from 'react-router-dom';
import {
    Container,
    Grid,
    Paper,
    Typography,
    Box,
    Card,
    CardContent,
    CardActionArea,
    AppBar,
    Toolbar,
    IconButton,
    Button,
} from '@mui/material';
import {
    TableRestaurant,
    Receipt,
    Restaurant,
    AttachMoney,
    ExitToApp,
} from '@mui/icons-material';
import { useAuth } from '../context/AuthContext';

const Dashboard = () => {
    const navigate = useNavigate();
    const { user, logout } = useAuth();

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    const menuItems = [
        {
            title: 'Mesas',
            icon: <TableRestaurant sx={{ fontSize: 60 }} />,
            path: '/tables',
            color: '#1976d2',
            roles: ['SUPERUSER', 'WAITER'],
        },
        {
            title: 'Comandas',
            icon: <Receipt sx={{ fontSize: 60 }} />,
            path: '/orders',
            color: '#2e7d32',
            roles: ['SUPERUSER', 'WAITER'],
        },
        {
            title: 'Cocina',
            icon: <Restaurant sx={{ fontSize: 60 }} />,
            path: '/kitchen',
            color: '#ed6c02',
            roles: ['SUPERUSER', 'COOK'],
        },
        {
            title: 'Caja',
            icon: <AttachMoney sx={{ fontSize: 60 }} />,
            path: '/cashier',
            color: '#9c27b0',
            roles: ['SUPERUSER', 'CASHIER'],
        },
    ];

    const filteredMenuItems = menuItems.filter((item) =>
        item.roles.includes(user?.role)
    );

    return (
        <>
            <AppBar position="static">
                <Toolbar>
                    <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                        VARES POS - Dashboard
                    </Typography>
                    <Typography variant="body1" sx={{ mr: 2 }}>
                        {user?.name} ({user?.role})
                    </Typography>
                    <Button color="inherit" onClick={handleLogout} startIcon={<ExitToApp />}>
                        Salir
                    </Button>
                </Toolbar>
            </AppBar>

            <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
                <Paper sx={{ p: 3, mb: 3 }}>
                    <Typography variant="h4" gutterBottom>
                        Bienvenido, {user?.name}
                    </Typography>
                    <Typography variant="body1" color="text.secondary">
                        Selecciona una opción para comenzar
                    </Typography>
                </Paper>

                <Grid container spacing={3}>
                    {filteredMenuItems.map((item) => (
                        <Grid item xs={12} sm={6} md={3} key={item.title}>
                            <Card>
                                <CardActionArea onClick={() => navigate(item.path)}>
                                    <CardContent>
                                        <Box
                                            sx={{
                                                display: 'flex',
                                                flexDirection: 'column',
                                                alignItems: 'center',
                                                py: 3,
                                            }}
                                        >
                                            <Box sx={{ color: item.color, mb: 2 }}>{item.icon}</Box>
                                            <Typography variant="h6" component="div">
                                                {item.title}
                                            </Typography>
                                        </Box>
                                    </CardContent>
                                </CardActionArea>
                            </Card>
                        </Grid>
                    ))}
                </Grid>

                <Paper sx={{ p: 3, mt: 3 }}>
                    <Typography variant="h6" gutterBottom>
                        Estadísticas del Día
                    </Typography>
                    <Grid container spacing={2}>
                        <Grid item xs={12} sm={4}>
                            <Box sx={{ textAlign: 'center' }}>
                                <Typography variant="h4" color="primary">
                                    0
                                </Typography>
                                <Typography variant="body2" color="text.secondary">
                                    Mesas Ocupadas
                                </Typography>
                            </Box>
                        </Grid>
                        <Grid item xs={12} sm={4}>
                            <Box sx={{ textAlign: 'center' }}>
                                <Typography variant="h4" color="success.main">
                                    0
                                </Typography>
                                <Typography variant="body2" color="text.secondary">
                                    Comandas Activas
                                </Typography>
                            </Box>
                        </Grid>
                        <Grid item xs={12} sm={4}>
                            <Box sx={{ textAlign: 'center' }}>
                                <Typography variant="h4" color="secondary">
                                    $0
                                </Typography>
                                <Typography variant="body2" color="text.secondary">
                                    Ventas del Día
                                </Typography>
                            </Box>
                        </Grid>
                    </Grid>
                </Paper>
            </Container>
        </>
    );
};

export default Dashboard;
