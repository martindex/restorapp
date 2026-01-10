import React, { useState, useEffect } from 'react';
import {
    Box, Paper, Typography, Grid, CircularProgress, IconButton, Tooltip, Button,
    Dialog, DialogTitle, DialogContent, DialogActions, TextField, Snackbar, Alert
} from '@mui/material';
import tableService from '../../services/tableService';
import ChairIcon from '@mui/icons-material/Chair';
import BlockIcon from '@mui/icons-material/Block';
import RestaurantIcon from '@mui/icons-material/Restaurant';
import LocalBarIcon from '@mui/icons-material/LocalBar';
import WcIcon from '@mui/icons-material/Wc';
import KitchenIcon from '@mui/icons-material/Kitchen';
import EventSeatIcon from '@mui/icons-material/EventSeat';

const CELL_SIZE = 60;
const GRID_COLS = 20; // Wider grid
const GRID_ROWS = 12; // Height

const FloorPlan = ({ zoneId, isEditMode, selectedTool }) => {
    const [loading, setLoading] = useState(true);
    const [cells, setCells] = useState([]);
    const [error, setError] = useState(null);
    const [history, setHistory] = useState([]); // For undo functionality

    // Drag & drop states
    const [draggedCell, setDraggedCell] = useState(null);
    const [lastClickTime, setLastClickTime] = useState(0);
    const [lastClickCell, setLastClickCell] = useState(null);

    // Dialog states
    const [dialogOpen, setDialogOpen] = useState(false);
    const [dialogType, setDialogType] = useState(''); // 'tableNumber', 'editTable', 'editLabel', 'clearAll', 'undo'
    const [dialogValue, setDialogValue] = useState('');
    const [dialogContext, setDialogContext] = useState(null);
    const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'info' });

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
            setSnackbar({ open: true, message: 'Diseño guardado correctamente', severity: 'success' });
        } catch (err) {
            console.error('Error saving layout:', err);
            setSnackbar({ open: true, message: 'Error al guardar el diseño', severity: 'error' });
        }
    };

    const saveToHistory = () => {
        setHistory(prev => [...prev, JSON.parse(JSON.stringify(cells))].slice(-10)); // Keep last 10 states
    };

    const handleUndo = () => {
        if (history.length === 0) {
            setSnackbar({ open: true, message: 'No hay acciones para deshacer', severity: 'info' });
            return;
        }
        openDialog('undo');
    };

    const handleUndoConfirm = () => {
        const previousState = history[history.length - 1];
        setCells(JSON.parse(JSON.stringify(previousState)));
        setHistory(prev => prev.slice(0, -1));
        setSnackbar({ open: true, message: 'Acción deshecha', severity: 'success' });
    };

    const openDialog = (type, context = null, defaultValue = '') => {
        setDialogType(type);
        setDialogContext(context);
        setDialogValue(defaultValue);
        setDialogOpen(true);
    };

    const closeDialog = () => {
        setDialogOpen(false);
        setDialogValue('');
        setDialogContext(null);
    };

    const handleDialogConfirm = () => {
        switch (dialogType) {
            case 'editTable':
                handleEditTableConfirm();
                break;
            case 'editLabel':
                handleEditLabelConfirm();
                break;
            case 'tableNumber':
                handleTableNumberConfirm();
                break;
            case 'labelInput':
                handleLabelInputConfirm();
                break;
            case 'clearAll':
                handleClearAllConfirm();
                break;
            case 'undo':
                handleUndoConfirm();
                break;
            default:
                break;
        }
        closeDialog();
    };

    const handleEditTableConfirm = () => {
        const tableNum = parseInt(dialogValue.trim());
        if (isNaN(tableNum) || tableNum <= 0) {
            setSnackbar({ open: true, message: 'Número de mesa inválido', severity: 'error' });
            return;
        }

        const { cell } = dialogContext;
        saveToHistory();
        // Only update the specific cell that was double-clicked
        const updatedCells = cells.map(c => {
            if (c.row === cell.row && c.col === cell.col) {
                return { ...c, table: { ...c.table, number: tableNum } };
            }
            return c;
        });
        setCells(updatedCells);
    };

    const handleEditLabelConfirm = () => {
        if (!dialogValue.trim()) {
            setSnackbar({ open: true, message: 'El nombre no puede estar vacío', severity: 'error' });
            return;
        }

        const { cellIndex } = dialogContext;
        saveToHistory();
        const updatedCells = [...cells];
        updatedCells[cellIndex] = { ...updatedCells[cellIndex], label: dialogValue.trim() };
        setCells(updatedCells);
    };

    const handleTableNumberConfirm = () => {
        const { r, c } = dialogContext;
        let tableNum;

        if (dialogValue.trim() === '') {
            const maxTableNum = Math.max(0, ...cells
                .filter(c => c.type === 'TABLE' && c.table)
                .map(c => c.table.number || 0));
            tableNum = maxTableNum + 1;
        } else {
            tableNum = parseInt(dialogValue.trim());
            if (isNaN(tableNum) || tableNum <= 0) {
                setSnackbar({ open: true, message: 'Número de mesa inválido', severity: 'error' });
                return;
            }
        }

        saveToHistory();
        const newCell = {
            row: r,
            col: c,
            type: 'TABLE',
            zone: { id: zoneId },
            table: { number: tableNum }
        };

        setCells([...cells, newCell]);
    };

    const handleLabelInputConfirm = () => {
        const { r, c } = dialogContext;
        saveToHistory();
        const newCell = {
            row: r,
            col: c,
            type: 'OTHER',
            zone: { id: zoneId },
            label: dialogValue.trim() || 'Referencia'
        };

        setCells([...cells, newCell]);
    };

    const handleClearAllConfirm = () => {
        saveToHistory();
        // Only remove TABLE cells, keep OTHER (spatial references)
        const filteredCells = cells.filter(cell => cell.type !== 'TABLE');
        setCells(filteredCells);
        setHistory([]); // Clear history after reset
        setSnackbar({ open: true, message: 'Todas las mesas han sido borradas', severity: 'info' });
    };

    const handleCellClick = (r, c) => {
        if (!isEditMode) return;

        const currentTime = new Date().getTime();
        const existingCellIndex = cells.findIndex(cell => cell.row === r && cell.col === c);

        // Detect double-click (within 500ms)
        const isDoubleClick = (currentTime - lastClickTime < 500) &&
            lastClickCell &&
            lastClickCell.r === r &&
            lastClickCell.c === c;

        setLastClickTime(currentTime);
        setLastClickCell({ r, c });

        // Double-click: Edit existing cell
        if (isDoubleClick && existingCellIndex > -1) {
            const cell = cells[existingCellIndex];
            if (cell.type === 'TABLE' && cell.table) {
                openDialog('editTable', { cell }, cell.table.number.toString());
            } else if (cell.type === 'OTHER') {
                openDialog('editLabel', { cellIndex: existingCellIndex }, cell.label);
            }
            return;
        }

        // Single click on existing cell: Remove it
        if (existingCellIndex > -1) {
            saveToHistory();
            const newCells = [...cells];
            newCells.splice(existingCellIndex, 1);
            setCells(newCells);
            return;
        }

        // Single click on empty cell: Add new cell
        // Check for any adjacent cell
        const adjacentCell = cells.find(cell =>
            (cell.row === r && Math.abs(cell.col - c) === 1) ||
            (cell.col === c && Math.abs(cell.row - r) === 1)
        );

        if (selectedTool === 'TABLE') {
            // Check if there's an adjacent non-table cell
            if (adjacentCell && adjacentCell.type !== 'TABLE') {
                setSnackbar({
                    open: true,
                    message: 'No se puede colocar una mesa junto a una referencia espacial',
                    severity: 'warning'
                });
                return;
            }

            // Check for adjacent table
            const adjacentTable = cells.find(cell =>
                cell.type === 'TABLE' && cell.table && (
                    (cell.row === r && Math.abs(cell.col - c) === 1) ||
                    (cell.col === c && Math.abs(cell.row - r) === 1)
                )
            );

            if (adjacentTable) {
                // Use the same number as the adjacent table
                saveToHistory();
                const newCell = {
                    row: r,
                    col: c,
                    type: 'TABLE',
                    zone: { id: zoneId },
                    table: { number: adjacentTable.table.number }
                };
                setCells([...cells, newCell]);
            } else {
                // Ask for table number
                const maxTableNum = Math.max(0, ...cells
                    .filter(c => c.type === 'TABLE' && c.table)
                    .map(c => c.table.number || 0));
                openDialog('tableNumber', { r, c }, (maxTableNum + 1).toString());
            }
        } else {
            // selectedTool === 'OBSTACLE' or 'OTHER'
            // Check if there's an adjacent table cell
            if (adjacentCell && adjacentCell.type === 'TABLE') {
                setSnackbar({
                    open: true,
                    message: 'No se puede colocar una referencia espacial junto a una mesa',
                    severity: 'warning'
                });
                return;
            }

            // Check for adjacent reference
            const adjacentReference = cells.find(cell =>
                cell.type === 'OTHER' && cell.label && (
                    (cell.row === r && Math.abs(cell.col - c) === 1) ||
                    (cell.col === c && Math.abs(cell.row - r) === 1)
                )
            );

            if (adjacentReference) {
                // Use the same label as the adjacent reference
                saveToHistory();
                const newCell = {
                    row: r,
                    col: c,
                    type: 'OTHER',
                    zone: { id: zoneId },
                    label: adjacentReference.label
                };
                setCells([...cells, newCell]);
            } else {
                // Ask for label
                openDialog('labelInput', { r, c }, '');
            }
        }
    };

    const handleDragStart = (r, c, e) => {
        if (!isEditMode) return;

        const cellIndex = cells.findIndex(cell => cell.row === r && cell.col === c);
        if (cellIndex > -1) {
            setDraggedCell({ row: r, col: c, cell: cells[cellIndex] });
            e.dataTransfer.effectAllowed = 'move';
            // Set some data to enable drag (required for some browsers)
            e.dataTransfer.setData('text/plain', `${r},${c}`);
        }
    };

    const handleDragOver = (e) => {
        if (!isEditMode) return;
        e.preventDefault();
        e.dataTransfer.dropEffect = 'move';
    };

    const handleDrop = (r, c, e) => {
        if (!isEditMode || !draggedCell) return;
        e.preventDefault();

        const sourceRow = draggedCell.row;
        const sourceCol = draggedCell.col;

        // Can't drop on itself
        if (sourceRow === r && sourceCol === c) {
            setDraggedCell(null);
            return;
        }

        const targetCellIndex = cells.findIndex(cell => cell.row === r && cell.col === c);
        const sourceCellIndex = cells.findIndex(cell => cell.row === sourceRow && cell.col === sourceCol);

        // Only allow dragging TABLE cells
        if (draggedCell.cell.type !== 'TABLE') {
            setSnackbar({
                open: true,
                message: 'Solo se pueden arrastrar mesas',
                severity: 'warning'
            });
            setDraggedCell(null);
            return;
        }

        saveToHistory();

        // If dropping on empty cell
        if (targetCellIndex === -1) {
            // Check if target is adjacent to source
            const isAdjacent = (Math.abs(sourceRow - r) === 1 && sourceCol === c) ||
                (Math.abs(sourceCol - c) === 1 && sourceRow === r);

            // Check for adjacent cells at destination
            const adjacentAtDestination = cells.find(cell =>
                (cell.row !== sourceRow || cell.col !== sourceCol) && (
                    (cell.row === r && Math.abs(cell.col - c) === 1) ||
                    (cell.col === c && Math.abs(cell.row - r) === 1)
                )
            );

            // Check if there's a non-table adjacent
            if (adjacentAtDestination && adjacentAtDestination.type !== 'TABLE') {
                setSnackbar({
                    open: true,
                    message: 'No se puede mover una mesa junto a una referencia espacial',
                    severity: 'warning'
                });
                setDraggedCell(null);
                return;
            }

            // Check for adjacent table at destination
            const adjacentTableAtDest = cells.find(cell =>
                cell.type === 'TABLE' && cell.table &&
                (cell.row !== sourceRow || cell.col !== sourceCol) && (
                    (cell.row === r && Math.abs(cell.col - c) === 1) ||
                    (cell.col === c && Math.abs(cell.row - r) === 1)
                )
            );

            // Move the cell
            const newCells = [...cells];
            newCells[sourceCellIndex] = {
                ...newCells[sourceCellIndex],
                row: r,
                col: c,
                // If there's an adjacent table at destination, adopt its number
                table: adjacentTableAtDest
                    ? { number: adjacentTableAtDest.table.number }
                    : newCells[sourceCellIndex].table
            };
            setCells(newCells);
            setSnackbar({
                open: true,
                message: adjacentTableAtDest
                    ? `Mesa movida y unida a mesa ${adjacentTableAtDest.table.number}`
                    : 'Mesa movida',
                severity: 'success'
            });
        } else {
            // Dropping on existing cell - merge if both are tables
            const targetCell = cells[targetCellIndex];

            if (targetCell.type === 'TABLE' && draggedCell.cell.type === 'TABLE') {
                // Change source cell's number to match target
                const newCells = [...cells];
                newCells[sourceCellIndex] = {
                    ...newCells[sourceCellIndex],
                    table: { number: targetCell.table.number }
                };
                setCells(newCells);
                setSnackbar({
                    open: true,
                    message: `Mesa ${draggedCell.cell.table.number} unida a mesa ${targetCell.table.number}`,
                    severity: 'success'
                });
            } else {
                setSnackbar({
                    open: true,
                    message: 'Solo se pueden unir mesas con mesas',
                    severity: 'warning'
                });
            }
        }

        setDraggedCell(null);
    };

    const handleDragEnd = () => {
        setDraggedCell(null);
    };

    const handleClearAll = () => {
        openDialog('clearAll');
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

    const getDialogTitle = () => {
        switch (dialogType) {
            case 'editTable': return 'Cambiar Número de Mesa';
            case 'editLabel': return 'Cambiar Nombre';
            case 'tableNumber': return 'Número de Mesa';
            case 'labelInput': return 'Nombre de Referencia';
            case 'clearAll': return 'Confirmar Borrado';
            case 'undo': return 'Confirmar Deshacer';
            default: return '';
        }
    };

    const getDialogContent = () => {
        switch (dialogType) {
            case 'editTable':
                return (
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Número de mesa"
                        type="number"
                        fullWidth
                        variant="outlined"
                        value={dialogValue}
                        onChange={(e) => setDialogValue(e.target.value)}
                        onKeyPress={(e) => e.key === 'Enter' && handleDialogConfirm()}
                    />
                );
            case 'editLabel':
                return (
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Nombre"
                        type="text"
                        fullWidth
                        variant="outlined"
                        value={dialogValue}
                        onChange={(e) => setDialogValue(e.target.value)}
                        onKeyPress={(e) => e.key === 'Enter' && handleDialogConfirm()}
                    />
                );
            case 'tableNumber':
                return (
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Número de mesa"
                        type="number"
                        fullWidth
                        variant="outlined"
                        value={dialogValue}
                        onChange={(e) => setDialogValue(e.target.value)}
                        helperText="Dejar vacío para auto-generar"
                        onKeyPress={(e) => e.key === 'Enter' && handleDialogConfirm()}
                    />
                );
            case 'labelInput':
                return (
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Nombre de la referencia"
                        type="text"
                        fullWidth
                        variant="outlined"
                        value={dialogValue}
                        onChange={(e) => setDialogValue(e.target.value)}
                        placeholder="Ej: Barra, Cocina, Columna"
                        onKeyPress={(e) => e.key === 'Enter' && handleDialogConfirm()}
                    />
                );
            case 'clearAll':
                return (
                    <Typography>
                        ¿Estás seguro de que quieres borrar todas las mesas? (Las referencias espaciales se mantendrán)
                    </Typography>
                );
            case 'undo':
                return (
                    <Typography>
                        ¿Estás seguro de que quieres deshacer la última acción?
                    </Typography>
                );
            default:
                return null;
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 5 }}><CircularProgress /></Box>;
    if (error) return <Typography color="error">{error}</Typography>;

    // Create a matrix for the grid
    const gridMatrix = Array(GRID_ROWS).fill().map(() => Array(GRID_COLS).fill(null));
    cells.forEach(cell => {
        if (cell.row < GRID_ROWS && cell.col < GRID_COLS) {
            gridMatrix[cell.row][cell.col] = cell;
        }
    });

    return (
        <>
            <Paper elevation={3} sx={{ p: 2, overflow: 'auto', backgroundColor: '#fafafa', borderRadius: 2 }}>
                <Box
                    sx={{
                        display: 'grid',
                        gridTemplateColumns: `repeat(${GRID_COLS}, ${CELL_SIZE}px)`,
                        gridTemplateRows: `repeat(${GRID_ROWS}, ${CELL_SIZE}px)`,
                        gap: 0,
                        border: '2px solid #ddd',
                        width: 'fit-content',
                        margin: 'auto',
                        backgroundColor: 'white',
                        boxShadow: '0 4px 20px rgba(0,0,0,0.08)'
                    }}
                >
                    {Array(GRID_ROWS * GRID_COLS).fill().map((_, index) => {
                        const r = Math.floor(index / GRID_COLS);
                        const c = index % GRID_COLS;
                        const cell = gridMatrix[r][c];

                        return (
                            <Box
                                key={`${r}-${c}`}
                                draggable={isEditMode && cell !== null}
                                onClick={() => handleCellClick(r, c)}
                                onContextMenu={(e) => { if (isEditMode) e.preventDefault(); }}
                                onDragStart={(e) => handleDragStart(r, c, e)}
                                onDragOver={handleDragOver}
                                onDrop={(e) => handleDrop(r, c, e)}
                                onDragEnd={handleDragEnd}
                                sx={{
                                    width: CELL_SIZE,
                                    height: CELL_SIZE,
                                    border: '1px solid #f0f0f0',
                                    display: 'flex',
                                    alignItems: 'center',
                                    justifyContent: 'center',
                                    backgroundColor: cell ? getCellColor(cell) : 'transparent',
                                    transition: 'all 0.2s',
                                    opacity: draggedCell && draggedCell.row === r && draggedCell.col === c ? 0.5 : 1,
                                    userSelect: 'none',
                                    WebkitUserSelect: 'none',
                                    '&:hover': {
                                        backgroundColor: isEditMode ? 'rgba(25, 118, 210, 0.1)' : 'rgba(0,0,0,0.02)',
                                        cursor: isEditMode && cell ? 'grab' : isEditMode ? 'crosshair' : 'default',
                                        zIndex: 1,
                                        boxShadow: isEditMode ? 'inset 0 0 0 2px #1976d2' : 'none'
                                    },
                                    '&:active': {
                                        cursor: isEditMode && cell ? 'grabbing' : 'default'
                                    }
                                }}
                            >
                                {cell && getCellContent(cell)}
                            </Box>
                        );
                    })}
                </Box>
                {isEditMode && (
                    <>
                        <Typography variant="caption" sx={{ display: 'block', textAlign: 'center', mt: 2, color: 'text.secondary' }}>
                            * Click: agregar/quitar. Doble click: editar. Arrastrar: mover/unir mesas.
                        </Typography>
                        <Box sx={{ display: 'flex', justifyContent: 'center', gap: 2, mt: 2 }}>
                            <Button
                                variant="outlined"
                                color="warning"
                                onClick={handleUndo}
                                size="small"
                                disabled={history.length === 0}
                            >
                                Deshacer
                            </Button>
                            <Button
                                variant="outlined"
                                color="error"
                                onClick={handleClearAll}
                                size="small"
                            >
                                Resetear Mesas
                            </Button>
                        </Box>
                    </>
                )}
            </Paper>

            {/* Dialog for inputs */}
            <Dialog open={dialogOpen} onClose={closeDialog} maxWidth="sm" fullWidth>
                <DialogTitle>{getDialogTitle()}</DialogTitle>
                <DialogContent>
                    {getDialogContent()}
                </DialogContent>
                <DialogActions>
                    <Button onClick={closeDialog}>Cancelar</Button>
                    <Button onClick={handleDialogConfirm} variant="contained" color="primary">
                        {dialogType === 'clearAll' ? 'Borrar' : 'Aceptar'}
                    </Button>
                </DialogActions>
            </Dialog>

            {/* Snackbar for notifications */}
            <Snackbar
                open={snackbar.open}
                autoHideDuration={4000}
                onClose={() => setSnackbar({ ...snackbar, open: false })}
                anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
            >
                <Alert onClose={() => setSnackbar({ ...snackbar, open: false })} severity={snackbar.severity} sx={{ width: '100%' }}>
                    {snackbar.message}
                </Alert>
            </Snackbar>
        </>
    );
};

export default FloorPlan;
