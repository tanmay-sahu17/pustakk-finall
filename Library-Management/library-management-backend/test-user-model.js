const User = require('./src/models/User');

async function testUserModel() {
    try {
        console.log('Testing User model...\n');
        
        // Test 1: Find by username
        console.log('1. Testing findByLogin with username "simple"...');
        const user1 = await User.findByLogin('simple');
        if (user1) {
            console.log('✅ Found user:', {
                id: user1.id,
                userid: user1.userid,
                username: user1.username,
                role: user1.role
            });
        } else {
            console.log('❌ User not found');
        }
        
        // Test 2: Find by userid
        console.log('\n2. Testing findByLogin with userid...');
        const user2 = await User.findByLogin('simple'); // Assuming userid is also 'simple'
        if (user2) {
            console.log('✅ Found user by userid:', {
                id: user2.id,
                userid: user2.userid,
                username: user2.username
            });
        } else {
            console.log('❌ User not found by userid');
        }
        
        // Test 3: Password comparison
        if (user1) {
            console.log('\n3. Testing password comparison...');
            const passwordMatch = user1.comparePassword('test123');
            console.log('Password match result:', passwordMatch);
        }
        
        process.exit(0);
        
    } catch (error) {
        console.error('❌ Error testing User model:', error.message);
        console.error('Stack:', error.stack);
        process.exit(1);
    }
}

testUserModel();
