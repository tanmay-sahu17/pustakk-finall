const https = require('https');
const http = require('http');

// Test login API
function testLogin() {
    const postData = JSON.stringify({
        username: 'admin',
        password: 'admin123'
    });

    const options = {
        hostname: '165.22.208.62',
        port: 5010,
        path: '/api/auth/login',
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(postData)
        }
    };

    console.log('Testing login API...');
    console.log('URL:', `http://${options.hostname}:${options.port}${options.path}`);
    console.log('Data:', postData);

    const req = http.request(options, (res) => {
        console.log(`Status Code: ${res.statusCode}`);
        console.log(`Headers:`, res.headers);

        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('end', () => {
            console.log('Response Body:', data);
            try {
                const parsed = JSON.parse(data);
                console.log('Parsed Response:', parsed);
            } catch (e) {
                console.log('Could not parse JSON response');
            }
        });
    });

    req.on('error', (error) => {
        console.error('Error:', error);
    });

    req.write(postData);
    req.end();
}

// Test basic API
function testBasicAPI() {
    const options = {
        hostname: '165.22.208.62',
        port: 5010,
        path: '/api/test',
        method: 'GET'
    };

    console.log('Testing basic API...');
    
    const req = http.request(options, (res) => {
        console.log(`Status Code: ${res.statusCode}`);
        
        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('end', () => {
            console.log('Basic API Response:', data);
            // Now test login
            setTimeout(testLogin, 1000);
        });
    });

    req.on('error', (error) => {
        console.error('Error:', error);
    });

    req.end();
}

// Start tests
testBasicAPI();
