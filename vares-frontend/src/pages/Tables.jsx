import React, { useState, useEffect } from 'react';
import {
    Container, Typography, Paper, Box, Tabs, Tab,
    Divider, Button, Stack, Chip, Grid
} from '@mui/material';
import FloorPlan from '../components/tables/FloorPlan';
import zoneService from '../services/zoneService';
import AddIcon from '@mui/icons-material/Add';
import SettingsIcon from '@mui/icons-material/Settings';

const Tables = () => {
    const [zones, setZones] = useState([]);
    const [selectedZone, setSelectedZone] = useState(0);
    const [loading, setLoading] = useState(true);
    const [isEditMode, setIsEditMode] = useState(false);
    const [selectedTool, setSelectedTool] = useState('TABLE'); // 'TABLE' or 'OBSTACLE'

    useEffect(() => {
        loadZones();
    }, []);

    const loadZones = async () => {
        try {
            const data = await zoneService.getAllZones();
            setZones(data);
            if (data.length > 0) {
                setSelectedZone(0);
            }
        } catch (err) {
            console.error('Error loading zones:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleZoneChange = (event, newValue) => {
        setSelectedZone(newValue);
    };

    const toggleEditMode = () => {
        setIsEditMode(!isEditMode);
    };

    return (
        <Container maxWidth="xl" sx={{ mt: 4, mb: 4 }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
                <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 'bold', color: 'primary.main' }}>
                    Diseño de Salón
                </Typography>
                <Stack direction="row" spacing={2}>
                    <Button
                        variant={isEditMode ? "contained" : "outlined"}
                        startIcon={<SettingsIcon />}
                        onClick={toggleEditMode}
                        color={isEditMode ? "secondary" : "primary"}
                    >
                        {isEditMode ? "Guardar y Salir" : "Modo Edición"}
                    </Button>
                    {isEditMode && (
                        <>
                            <Button
                                variant={selectedTool === 'TABLE' ? "contained" : "outlined"}
                                startIcon={<AddIcon />}
                                onClick={() => setSelectedTool('TABLE')}
                            >
                                Dibujar Mesas
                            </Button>
                            <Button
                                variant={selectedTool === 'OBSTACLE' ? "contained" : "outlined"}
                                startIcon={<AddIcon />}
                                onClick={() => setSelectedTool('OBSTACLE')}
                            >
                                Dibujar No-Mesas
                            </Button>
                        </>
                    )}
                </Stack>
            </Box>

            <Paper sx={{ width: '100%', mb: 4 }}>
                <Box sx={{ borderBottom: 1, borderColor: 'divider' }}>
                    <Tabs
                        value={selectedZone}
                        onChange={handleZoneChange}
                        aria-label="zonas del restaurante"
                        variant="scrollable"
                        scrollButtons="auto"
                    >
                        {zones.map((zone, index) => (
                            <Tab key={zone.id} label={zone.name} />
                        ))}
                    </Tabs>
                </Box>

                <Box sx={{ p: 3 }}>
                    {zones.length > 0 ? (
                        <Box>
                            <Box sx={{ mb: 2, display: 'flex', alignItems: 'center', gap: 2 }}>
                                <Typography variant="h6">{zones[selectedZone].name}</Typography>
                                <Chip label={zones[selectedZone].description} variant="outlined" size="small" />
                            </Box>
                            <FloorPlan
                                zoneId={zones[selectedZone].id}
                                isEditMode={isEditMode}
                                selectedTool={selectedTool}
                            />
                        </Box>
                    ) : (
                        !loading && <Typography>No hay zonas configuradas.</Typography>
                    )}
                </Box>
            </Paper>

            <Paper sx={{ p: 3 }}>
                <Typography variant="h6" gutterBottom>Leyenda</Typography>
                <Grid container spacing={2}>
                    <Grid item xs={6} md={2}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <Box sx={{ width: 20, height: 20, bgcolor: 'rgba(25, 118, 210, 0.1)', border: '1px solid #1976d2' }} />
                            <Typography variant="body2">Mesa</Typography>
                        </Box>
                    </Grid>
                    <Grid item xs={6} md={2}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <Box sx={{ width: 20, height: 20, bgcolor: '#f0f0f0', border: '1px solid #ddd' }} />
                            <Typography variant="body2">Columna</Typography>
                        </Box>
                    </Grid>
                    <Grid item xs={6} md={2}>
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                            <Box sx={{ width: 20, height: 20, bgcolor: 'rgba(156, 39, 176, 0.1)', border: '1px solid #9c27b0' }} />
                            <Typography variant="body2">Barra</Typography>
                        </Box>
                    </Grid>
                </Grid>
            </Paper>
        </Container>
    );
};

export default Tables;
