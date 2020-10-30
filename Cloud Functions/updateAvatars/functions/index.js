const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.update = functions.region('asia-south1').firestore
    .document('Users/{user}').onUpdate(async (change, context) => {

        const username = change.after.data()["username"]
        const avatar = change.after.data()["avatar"]
       

        promises = [];
        friends = ['friend1', 'friend2'];
        avatars = ['friend1avatar', 'friend2avatar']

        for (i = 0; i < 2; i++) {

            p = myfun(username, avatar, friends[i], avatars[i]);
            promises.push(p);
        }


        return await Promise.all(promises).then().catch();

    }
    )

async function myfun(username, avatar, friend, avatarField) { //some issue with send varible in then
  
if(friend === 'friend1'){
    avd = avatarField;
    await db
        .collection('FriendPairs')
        .where(friend, '==', username)
        .get()
        .then((querySnapshot) => {
            querySnapshot.forEach(documentSnapshot => {
             
                return documentSnapshot.ref
                    .update({ 'friend1avatar': avatar })
              
            });

            return null;
        }).catch();

    }

    else{
        avd = avatarField;
    await db
        .collection('FriendPairs')
        .where(friend, '==', username)
        .get()
        .then((querySnapshot) => {
            querySnapshot.forEach(documentSnapshot => {
             
                return documentSnapshot.ref
                    .update({ 'friend2avatar': avatar })
              
            });

            return null;
        }).catch();
    }

}


   /*  return await db
             .collection('Users')
             //.doc('35ZTSlgmoCWvAicAQVxFalqzvMW2')
            .where('username','==',username)                     
             .get()
             .then(querySnapshot => {
                 querySnapshot.forEach(documentSnapshot => {
                     documentSnapshot.ref.update({"friend1name":friendnames[i]})
                   console.log(`Found document at ${documentSnapshot.ref.path}`);
                 });
             
                   return null;
                 }).catch(); */