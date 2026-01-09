import React, { useState, useEffect } from 'react';
import { Box, Paper, Typography, Grid, CircularProgress, IconButton, Tooltip } from '@mui/material';
import tableService from '../../services/tableService';
import ChairIcon from '@mui/icons-material/Chair';
import BlockIcon from '@mui/icons-material/Block';
import RestaurantIcon from '@mui/icons-material/Restaurant';
import LocalBarIcon from '@mui/icons-material/LocalBar';
import WcIcon from '@mui/icons-material/Wc';
import KitchenIcon from '@mui/icons-material/Kitchen';
import EventSeatIcon from '@mui/icons-material/EventSeat';

const CELL_SIZE = 60;
const GRID_SIZE = 12; // 12x12 grid for the MVP

const FloorPlan = ({ zoneId }) => {
    const [loading, setLoading] = useState(true);
    const [cells, setCells] = useState([]);
    const [error, setError] = useState(null);

    useEffect(() => {
        if (zoneId) {
            loadLayout();
        }
    }, [zoneId]);

    const loadLayout = async () => {
        setLoading(true);
        try {
            const data = await tableService.getLayoutByZone(zoneId);
            setCells(data);
            setError(null);
        } catch (err) {
            console.error('Error loading layout:', err);
            setError('Error al cargar el plano del salón');
        } finally {
            setLoading(false);
        }
    };

    const getCellContent = (cell) => {
        switch (cell.type) {
            case 'TABLE':
                return (
                    <Tooltip title={`Mesa ${cell.table?.number || '?'}`}>
                        <Box sx={{ color: 'primary.main', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                            <RestaurantIcon />
                            <Typography variant="caption" sx={{ fontWeight: 'bold' }}>
                                {cell.table?.number}
                            </Typography>
                        </Box>
                    </Tooltip>
                );
            case 'BAR': return <LocalBarIcon color="secondary" />;
            case 'RESTROOM': return <WcIcon sx={{ color: 'gray' }} />;
            case 'KITCHEN': return <KitchenIcon sx={{ color: 'orange' }} />;
            case 'STAGE': return <EventSeatIcon sx={{ color: 'purple' }} />;
            case 'COLUMN': return <BlockIcon sx={{ color: 'darkgray' }} />;
            default: return null;
        }
    };

    const getCellColor = (cell) => {
        switch (cell.type) {
            case 'TABLE': return 'rgba(25, 118, 210, 0.1)';
            case 'COLUMN': return '#f0f0f0';
            case 'BAR': return 'rgba(156, 39, 176, 0.1)';
            default: return 'transparent';
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 5 }}><CircularProgress /></Box>;
    if (error) return <Typography color="error">{error}</Typography>;

    // Create a matrix for the grid
    const matrix = Array(GRID_SIZE).fill().map(() => Array(GRID_SIZE).fill(null));
    cells.forEach(cell => {
        if (cell.row < GRID_SIZE && cell.col < GRID_SIZE) {
            matrix[cell.row][cell.col] = cell;
        }
    });

    return (
        <Paper elevation={3} sx={{ p: 2, overflow: 'auto', backgroundColor: '#fafafa' }}>
            <Box
                sx={{
                    display: 'grid',
                    gridTemplateColumns: `repeat(${GRID_SIZE}, ${CELL_SIZE}px)`,
                    gridTemplateRows: `repeat(${GRID_SIZE}, ${CELL_SIZE}px)`,
                    gap: 0.5,
                    border: '1px solid #ddd',
                    width: 'fit-content',
                    margin: 'auto',
                    backgroundColor: 'white'
                }}
            >
                {Array(GRID_SIZE * GRID_SIZE).fill().map((_, index) => {
                    const r = Math.floor(index / GRID_SIZE);
                    const c = index % GRID_SIZE;
                    const cell = matrix[r][c];

                    return (
                        <Box
                            key={`${r}-${c}`}
                            sx={{
                                width: CELL_SIZE,
                                height: CELL_SIZE,
                                border: '1px solid #eee',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                backgroundColor: cell ? getCellColor(cell) : 'transparent',
                                transition: 'background-color 0.2s',
                                '&:hover': {
                                    backgroundColor: 'rgba(0,0,0,0.05)',
                                    cursor: 'pointer'
                                }
                            }}
                        >
                            {cell && getCellContent(cell)}
                        </Box>
                    );
                })}
            </Box>
        </Paper>
    );
};

export default FloorPlan;
