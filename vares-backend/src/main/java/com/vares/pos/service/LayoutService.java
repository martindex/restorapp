package com.vares.pos.service;

import com.vares.pos.model.entity.LayoutCell;
import com.vares.pos.model.entity.TableEntity;
import com.vares.pos.repository.LayoutCellRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Servicio para gestionar la disposición física del salón y algoritmos de
 * mesas.
 */
@Service
@RequiredArgsConstructor
public class LayoutService {

    private final LayoutCellRepository layoutCellRepository;
    private final com.vares.pos.repository.TableRepository tableRepository;
    private final com.vares.pos.repository.ZoneRepository zoneRepository;

    /**
     * Calcula la capacidad de una mesa basada en sus celdas ocupadas.
     * Fórmula: (N_Mesas * 4) - (N_Uniones * 2)
     */
    public int calculateTableCapacity(TableEntity table) {
        List<LayoutCell> cells = table.getCells();
        if (cells == null || cells.isEmpty()) {
            return 0;
        }

        int cellCount = cells.size();
        int unionCount = 0;

        // Usamos un set de coordenadas para búsqueda rápida de adyacencia
        Set<String> coordSet = new HashSet<>();
        for (LayoutCell cell : cells) {
            coordSet.add(cell.getRow() + "," + cell.getCol());
        }

        for (LayoutCell cell : cells) {
            int r = cell.getRow();
            int c = cell.getCol();

            // Solo miramos hacia la derecha y hacia abajo para no contar uniones dos veces
            if (coordSet.contains(r + "," + (c + 1))) {
                unionCount++;
            }
            if (coordSet.contains((r + 1) + "," + c)) {
                unionCount++;
            }
        }

        return (cellCount * 4) - (unionCount * 2);
    }

    /**
     * Verifica si un conjunto de celdas es contiguo (adyacencia
     * horizontal/vertical).
     */
    public boolean areCellsContiguous(List<LayoutCell> cells) {
        if (cells == null || cells.isEmpty())
            return false;
        if (cells.size() == 1)
            return true;

        Set<String> remaining = new HashSet<>();
        for (LayoutCell cell : cells) {
            remaining.add(cell.getRow() + "," + cell.getCol());
        }

        Set<String> connected = new HashSet<>();
        String start = cells.get(0).getRow() + "," + cells.get(0).getCol();
        exploreConnection(start, remaining, connected);

        return connected.size() == cells.size();
    }

    private void exploreConnection(String current, Set<String> available, Set<String> connected) {
        if (!available.contains(current) || connected.contains(current)) {
            return;
        }

        connected.add(current);
        String[] parts = current.split(",");
        int r = Integer.parseInt(parts[0]);
        int c = Integer.parseInt(parts[1]);

        exploreConnection(r + "," + (c + 1), available, connected);
        exploreConnection(r + "," + (c - 1), available, connected);
        exploreConnection((r + 1) + "," + c, available, connected);
        exploreConnection((r - 1) + "," + c, available, connected);
    }

    @Transactional
    public void saveLayout(String zoneId, List<LayoutCell> newCells) {
        com.vares.pos.model.entity.Zone zone = zoneRepository.findById(zoneId)
                .orElseThrow(() -> new RuntimeException("Zone not found: " + zoneId));

        // Borrar el layout actual de la zona
        layoutCellRepository.deleteByZoneId(zoneId);

        // Flush para asegurar que el DELETE se ejecute antes de los INSERTs
        layoutCellRepository.flush();

        for (LayoutCell cell : newCells) {
            // Crear una nueva celda sin ID para forzar un INSERT
            cell.setId(null);
            cell.setZone(zone);

            if (cell.getType() == LayoutCell.CellType.TABLE && cell.getTable() != null) {
                Integer tableNumber = cell.getTable().getNumber();
                // Buscar si la mesa ya existe en esta zona
                TableEntity table = tableRepository.findByZoneIdAndNumber(zoneId, tableNumber)
                        .orElseGet(() -> {
                            TableEntity newTable = new TableEntity();
                            newTable.setZone(zone);
                            newTable.setNumber(tableNumber);
                            newTable.setCapacity(4);
                            newTable.setStatus(TableEntity.TableStatus.AVAILABLE);
                            newTable.setActive(true);
                            return tableRepository.save(newTable);
                        });
                cell.setTable(table);
            } else {
                cell.setTable(null);
            }
        }

        layoutCellRepository.saveAll(newCells);
    }
}
