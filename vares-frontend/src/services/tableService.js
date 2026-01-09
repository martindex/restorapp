import api from './api';

const tableService = {
    getAllTables: async () => {
        const response = await api.get('/tables');
        return response.data;
    },

    getTablesByZone: async (zoneId) => {
        const response = await api.get(`/tables/zone/${zoneId}`);
        return response.data;
    },

    getLayoutByZone: async (zoneId) => {
        const response = await api.get(`/layout/zone/${zoneId}`);
        return response.data;
    },

    saveLayout: async (zoneId, cells) => {
        const response = await api.post(`/layout/zone/${zoneId}`, cells);
        return response.data;
    },

    calculateCapacity: async (tableId) => {
        const response = await api.post(`/tables/${tableId}/calculate-capacity`);
        return response.data;
    }
};

export default tableService;
