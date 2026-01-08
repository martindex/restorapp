import { Container, Typography, Paper, Box } from '@mui/material';

const Orders = () => {
    return (
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Paper sx={{ p: 3 }}>
                <Typography variant="h4" gutterBottom>
                    Gestión de Comandas
                </Typography>
                <Box sx={{ mt: 3 }}>
                    <Typography variant="body1" color="text.secondary">
                        Módulo de gestión de comandas en desarrollo...
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 2 }}>
                        Aquí podrás:
                    </Typography>
                    <ul>
                        <li>Ver comandas activas</li>
                        <li>Tomar pedidos</li>
                        <li>Agregar ítems a comandas existentes</li>
                        <li>Ver estado de pedidos</li>
                        <li>Solicitar cierre de comanda</li>
                    </ul>
                </Box>
            </Paper>
        </Container>
    );
};

export default Orders;
