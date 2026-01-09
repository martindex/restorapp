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

const FloorPlan = ({ zoneId, isEditMode, selectedTool }) => {
    const [loading, setLoading] = useState(true);
    const [cells, setCells] = useState([]);
    const [error, setError] = useState(null);

    useEffect(() => {
        if (zoneId) {
            loadLayout();
        }
    }, [zoneId]);

    // Save when leaving edit mode
    useEffect(() => {
        if (!isEditMode && !loading && cells.length > 0) {
            saveLayout();
        }
    }, [isEditMode]);

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

    const saveLayout = async () => {
        try {
            await tableService.saveLayout(zoneId, cells);
            console.log('Layout saved successfully');
        } catch (err) {
            console.error('Error saving layout:', err);
        }
    };

    const handleCellClick = (r, c) => {
        if (!isEditMode) return;

        const existingCellIndex = cells.findIndex(cell => cell.row === r && cell.col === c);

        if (existingCellIndex > -1) {
            // Remove cell (toggle off)
            const newCells = [...cells];
            newCells.splice(existingCellIndex, 1);
            setCells(newCells);
        } else {
            // Add new cell
            let newCell = {
                row: r,
                col: c,
                type: selectedTool === 'TABLE' ? 'TABLE' : 'OTHER', // Use OTHER for general spatial refs
                zone: { id: zoneId }
            };

            if (selectedTool === 'TABLE') {
                // Auto-generate next table number
                const maxTableNum = Math.max(0, ...cells
                    .filter(c => c.type === 'TABLE' && c.table)
                    .map(c => c.table.number || 0));

                newCell.table = { number: maxTableNum + 1 };
            } else {
                // Prompt for label for "No-Mesa"
                const label = prompt('Nombre de la referencia espacial (ej: Barra, Cocina, Columna):');
                if (label === null) return; // Cancelled
                newCell.label = label || 'Referencia';
            }

            setCells([...cells, newCell]);
        }
    };

    const getCellContent = (cell) => {
        switch (cell.type) {
            case 'TABLE':
                return (
                    <Tooltip title={`Mesa ${cell.table?.number || '?'}`}>
                        <Box sx={{ color: 'primary.main', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                            <RestaurantIcon />
                            <Typography variant="caption" sx={{ fontSize: '0.7rem', fontWeight: 'bold' }}>
                                {cell.table?.number}
                            </Typography>
                        </Box>
                    </Tooltip>
                );
            case 'OTHER':
                return (
                    <Tooltip title={cell.label || 'Referencia'}>
                        <Box sx={{ color: 'text.secondary', textAlign: 'center' }}>
                            <Typography variant="caption" sx={{ fontSize: '0.6rem', lineHeight: 1, display: 'block' }}>
                                {cell.label}
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
            case 'TABLE': return 'rgba(25, 118, 210, 0.15)';
            case 'OTHER': return 'rgba(0, 0, 0, 0.05)';
            case 'BAR': return 'rgba(156, 39, 176, 0.1)';
            default: return 'transparent';
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 5 }}><CircularProgress /></Box>;
    if (error) return <Typography color="error">{error}</Typography>;

    // Create a matrix for the grid (using a Set for O(1) checks if needed, but matrix is fine for small grid)
    const gridMatrix = Array(GRID_SIZE).fill().map(() => Array(GRID_SIZE).fill(null));
    cells.forEach(cell => {
        if (cell.row < GRID_SIZE && cell.col < GRID_SIZE) {
            gridMatrix[cell.row][cell.col] = cell;
        }
    });

    return (
        <Paper elevation={3} sx={{ p: 2, overflow: 'auto', backgroundColor: '#fafafa', borderRadius: 2 }}>
            <Box
                sx={{
                    display: 'grid',
                    gridTemplateColumns: `repeat(${GRID_SIZE}, ${CELL_SIZE}px)`,
                    gridTemplateRows: `repeat(${GRID_SIZE}, ${CELL_SIZE}px)`,
                    gap: 0,
                    border: '2px solid #ddd',
                    width: 'fit-content',
                    margin: 'auto',
                    backgroundColor: 'white',
                    boxShadow: '0 4px 20px rgba(0,0,0,0.08)'
                }}
            >
                {Array(GRID_SIZE * GRID_SIZE).fill().map((_, index) => {
                    const r = Math.floor(index / GRID_SIZE);
                    const c = index % GRID_SIZE;
                    const cell = gridMatrix[r][c];

                    return (
                        <Box
                            key={`${r}-${c}`}
                            onClick={() => handleCellClick(r, c)}
                            sx={{
                                width: CELL_SIZE,
                                height: CELL_SIZE,
                                border: '1px solid #f0f0f0',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                backgroundColor: cell ? getCellColor(cell) : 'transparent',
                                transition: 'all 0.2s',
                                '&:hover': {
                                    backgroundColor: isEditMode ? 'rgba(25, 118, 210, 0.1)' : 'rgba(0,0,0,0.02)',
                                    cursor: isEditMode ? 'crosshair' : 'default',
                                    zIndex: 1,
                                    boxShadow: isEditMode ? 'inset 0 0 0 2px #1976d2' : 'none'
                                }
                            }}
                        >
                            {cell && getCellContent(cell)}
                        </Box>
                    );
                })}
            </Box>
            {isEditMode && (
                <Typography variant="caption" sx={{ display: 'block', textAlign: 'center', mt: 2, color: 'text.secondary' }}>
                    * Haz clic en los cuadrados para {selectedTool === 'TABLE' ? 'poner una mesa' : 'poner una referencia'}. Haz clic en uno existente para borrarlo.
                </Typography>
            )}
        </Paper>
    );
};

export default FloorPlan;
