const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into 
// Cloud Firestore under the path /messages/:documentId/original
exports.createUserWithEmailAndPassword = functions
.region('asia-east2')
.https.onCall(async (data, context) => {
  // Grab the text parameter.
  const email = data.email;
  const password = data.password;

  console.log('email:', email, 'password:', password);

  return admin.auth().createUser({
    email: email,
    password: password,
    disabled: false
  })
    .then(function(userRecord) {
        // See the UserRecord reference doc for the contents of userRecord.
        console.log('Successfully created new user:', userRecord.uid);
        return {
            uid : userRecord.uid
        };
    })
    .catch(function(error) {
        console.log('Error creating new user:', error);
        return null;
    });
});

