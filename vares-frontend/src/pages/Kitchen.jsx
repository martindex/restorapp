import { Container, Typography, Paper, Box, Chip } from '@mui/material';

const Kitchen = () => {
    return (
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Paper sx={{ p: 3 }}>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                    <Typography variant="h4">
                        🍳 Cola de Cocina
                    </Typography>
                    <Chip label="0 Pedidos Pendientes" color="primary" />
                </Box>
                <Box sx={{ mt: 3 }}>
                    <Typography variant="body1" color="text.secondary">
                        Pantalla de cocina en desarrollo...
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 2 }}>
                        Aquí verás:
                    </Typography>
                    <ul>
                        <li>Cola de pedidos en orden cronológico</li>
                        <li>Número de mesa</li>
                        <li>Productos solicitados</li>
                        <li>Observaciones especiales</li>
                        <li>Tiempo transcurrido</li>
                        <li>Alertas de pedidos urgentes (&gt;15 min)</li>
                    </ul>
                </Box>
            </Paper>
        </Container>
    );
};

export default Kitchen;
