const axios = require('axios');

async function testLoginWithIdOnly() {
  try {
    console.log('Testing login with ID only...\n');
    
    const response = await axios.post('http://165.22.208.62:5010/api/auth/login', {
      userId: 'simple',
      password: 'test123'
    }, {
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json'
      }
    });

    console.log('✅ Login successful with ID only!');
    console.log('Status:', response.status);
    console.log('Response:', JSON.stringify(response.data, null, 2));
    
    if (response.data.token) {
      console.log('\n🔑 Token received:', response.data.token.substring(0, 20) + '...');
    }

  } catch (error) {
    console.log('❌ Login failed with ID only');
    
    if (error.response) {
      console.log('Status:', error.response.status);
      console.log('Error:', error.response.data);
    } else if (error.request) {
      console.log('No response received:', error.message);
    } else {
      console.log('Request error:', error.message);
    }
  }
}

// Also test with username parameter
async function testLoginWithUsernameOnly() {
  try {
    console.log('\nTesting login with username only...\n');
    
    const response = await axios.post('http://165.22.208.62:5010/api/auth/login', {
      username: 'simple',
      password: 'test123'
    }, {
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json'
      }
    });

    console.log('✅ Login successful with username only!');
    console.log('Status:', response.status);
    console.log('Response:', JSON.stringify(response.data, null, 2));

  } catch (error) {
    console.log('❌ Login failed with username only');
    
    if (error.response) {
      console.log('Status:', error.response.status);
      console.log('Error:', error.response.data);
    } else {
      console.log('Error:', error.message);
    }
  }
}

async function runTests() {
  await testLoginWithIdOnly();
  await testLoginWithUsernameOnly();
}

runTests();
