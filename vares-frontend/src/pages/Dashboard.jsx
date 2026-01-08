import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import {
    Box,
    Container,
    Typography,
    Grid,
    Card,
    CardContent,
    CardActions,
    Button,
    AppBar,
    Toolbar,
    IconButton,
} from '@mui/material';
import {
    TableRestaurant,
    Receipt,
    Kitchen,
    Logout,
    Dashboard as DashboardIcon,
} from '@mui/icons-material';

function Dashboard() {
    const { user, logout } = useAuth();
    const navigate = useNavigate();

    const handleLogout = () => {
        logout();
        navigate('/login');
    };

    const menuItems = [
        {
            title: 'Mesas',
            description: 'Gestión de mesas y zonas',
            icon: <TableRestaurant sx={{ fontSize: 60 }} />,
            path: '/tables',
            color: '#1976d2',
        },
        {
            title: 'Comandas',
            description: 'Gestión de pedidos',
            icon: <Receipt sx={{ fontSize: 60 }} />,
            path: '/orders',
            color: '#2e7d32',
        },
        {
            title: 'Cocina',
            description: 'Vista de cocina',
            icon: <Kitchen sx={{ fontSize: 60 }} />,
            path: '/kitchen',
            color: '#ed6c02',
            roles: ['COOK', 'SUPERUSER'],
        },
    ];

    const filteredMenuItems = menuItems.filter(item => {
        if (!item.roles) return true;
        return item.roles.includes(user?.role);
    });

    return (
        <Box sx={{ flexGrow: 1 }}>
            <AppBar position="static">
                <Toolbar>
                    <DashboardIcon sx={{ mr: 2 }} />
                    <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
                        VARES POS - Dashboard
                    </Typography>
                    <Typography variant="body1" sx={{ mr: 2 }}>
                        {user?.name} ({user?.role})
                    </Typography>
                    <IconButton color="inherit" onClick={handleLogout}>
                        <Logout />
                    </IconButton>
                </Toolbar>
            </AppBar>

            <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
                <Typography variant="h4" gutterBottom>
                    Bienvenido, {user?.name}
                </Typography>
                <Typography variant="body1" color="text.secondary" paragraph>
                    Selecciona una opción para comenzar
                </Typography>

                <Grid container spacing={3} sx={{ mt: 2 }}>
                    {filteredMenuItems.map((item, index) => (
                        <Grid item xs={12} sm={6} md={4} key={index}>
                            <Card
                                sx={{
                                    height: '100%',
                                    display: 'flex',
                                    flexDirection: 'column',
                                    transition: 'transform 0.2s',
                                    '&:hover': {
                                        transform: 'scale(1.05)',
                                        boxShadow: 6,
                                    },
                                }}
                            >
                                <CardContent sx={{ flexGrow: 1, textAlign: 'center' }}>
                                    <Box sx={{ color: item.color, mb: 2 }}>
                                        {item.icon}
                                    </Box>
                                    <Typography gutterBottom variant="h5" component="h2">
                                        {item.title}
                                    </Typography>
                                    <Typography variant="body2" color="text.secondary">
                                        {item.description}
                                    </Typography>
                                </CardContent>
                                <CardActions sx={{ justifyContent: 'center', pb: 2 }}>
                                    <Button
                                        size="large"
                                        variant="contained"
                                        onClick={() => navigate(item.path)}
                                        sx={{ backgroundColor: item.color }}
                                    >
                                        Abrir
                                    </Button>
                                </CardActions>
                            </Card>
                        </Grid>
                    ))}
                </Grid>

                <Box sx={{ mt: 4, p: 3, bgcolor: 'background.paper', borderRadius: 1 }}>
                    <Typography variant="h6" gutterBottom>
                        Estadísticas del día
                    </Typography>
                    <Grid container spacing={2}>
                        <Grid item xs={12} sm={4}>
                            <Typography variant="body2" color="text.secondary">
                                Mesas ocupadas
                            </Typography>
                            <Typography variant="h4">0 / 32</Typography>
                        </Grid>
                        <Grid item xs={12} sm={4}>
                            <Typography variant="body2" color="text.secondary">
                                Comandas activas
                            </Typography>
                            <Typography variant="h4">0</Typography>
                        </Grid>
                        <Grid item xs={12} sm={4}>
                            <Typography variant="body2" color="text.secondary">
                                Total del día
                            </Typography>
                            <Typography variant="h4">$0</Typography>
                        </Grid>
                    </Grid>
                </Box>
            </Container>
        </Box>
    );
}

export default Dashboard;
