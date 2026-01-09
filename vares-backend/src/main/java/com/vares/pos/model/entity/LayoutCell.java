package com.vares.pos.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Representa una celda individual en la grilla de diseño del salón.
 * Cada celda tiene un tipo y puede estar asociada a una mesa.
 */
@Entity
@Table(name = "layout_cells", uniqueConstraints = {
        @UniqueConstraint(columnNames = { "zone_id", "grid_row", "grid_col" })
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LayoutCell {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id", length = 36, nullable = false, updatable = false)
    private String id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "zone_id", nullable = false)
    private Zone zone;

    @Column(name = "grid_row", nullable = false)
    private Integer row;

    @Column(name = "grid_col", nullable = false)
    private Integer col;

    @Enumerated(EnumType.STRING)
    @Column(name = "cell_type", nullable = false)
    private CellType type = CellType.EMPTY;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "table_id")
    private TableEntity table;

    @Column(name = "label")
    private String label;

    public enum CellType {
        EMPTY,
        TABLE,
        STAGE,
        BAR,
        RESTROOM,
        KITCHEN,
        COLUMN,
        OTHER
    }
}
