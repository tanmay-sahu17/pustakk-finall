const axios = require('axios');

async function testDonationsAPI() {
    const baseURL = 'http://165.22.208.62:5010/api/donations';
    
    console.log('🧪 Testing Donations API (PRODUCTION)...\n');
    
    try {
        // Test 1: Get all donations
        console.log('1. Testing GET /api/donations (Get all donations)');
        const getAllResponse = await axios.get(baseURL);
        console.log('✅ Success:', getAllResponse.status);
        console.log('Data:', getAllResponse.data);
        console.log();
        
        // Test 2: Get donation stats
        console.log('2. Testing GET /api/donations/stats (Get statistics)');
        const statsResponse = await axios.get(`${baseURL}/stats`);
        console.log('✅ Success:', statsResponse.status);
        console.log('Data:', statsResponse.data);
        console.log();
        
        // Test 3: Create new donation (SIMPLIFIED)
        console.log('3. Testing POST /api/donations (Create new donation)');
        const newDonation = {
            donor_name: "Test Donor",
            book_title: "Test Book",
            donor_email: "test@example.com"
        };
        
        const createResponse = await axios.post(baseURL, newDonation);
        console.log('✅ Success:', createResponse.status);
        console.log('Data:', createResponse.data);
        console.log();
        
        console.log('🎉 All tests completed successfully!');
        
    } catch (error) {
        console.error('❌ API Test Failed:', error.response?.status || error.code);
        console.error('Error:', error.response?.data || error.message);
        console.error('URL:', error.config?.url);
    }
}

testDonationsAPI();
