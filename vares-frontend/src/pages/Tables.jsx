import { Container, Typography, Paper, Box } from '@mui/material';

const Tables = () => {
    return (
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
            <Paper sx={{ p: 3 }}>
                <Typography variant="h4" gutterBottom>
                    Gestión de Mesas
                </Typography>
                <Box sx={{ mt: 3 }}>
                    <Typography variant="body1" color="text.secondary">
                        Módulo de gestión de mesas en desarrollo...
                    </Typography>
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 2 }}>
                        Aquí podrás:
                    </Typography>
                    <ul>
                        <li>Ver el mapa del salón</li>
                        <li>Abrir y cerrar mesas</li>
                        <li>Ver estado de mesas (Libre, Ocupada, Reservada)</li>
                        <li>Unir y separar mesas</li>
                    </ul>
                </Box>
            </Paper>
        </Container>
    );
};

export default Tables;
