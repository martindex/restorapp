import api from './api';

const zoneService = {
    getAllZones: async () => {
        const response = await api.get('/zones');
        return response.data;
    }
};

export default zoneService;
