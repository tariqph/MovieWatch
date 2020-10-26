const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();



exports.createParty = functions.region('asia-south1').firestore
    .document('Parties/{parties}')
    .onCreate(async(snap, context) => {

     refList = []
      
      const creator = snap.data()['creator'];
      const docRef = snap.data()['docRef'];
      const collectionRef = snap.data()['collectionRef'];

     return await db.collection('MovieRef')
      .doc(docRef)
      .get()
      .then((docSnap)=>{
        refList = docSnap.data()['docRefs'];
       // console.log(refList);
        shuffle(refList);

        return db.collection('ActiveParties')
        .doc(creator)
        .set({
            'docRefs': refList,
            'creator': creator,
            'match': 'no',
            'matchRef': 0,
            'collectionRef': collectionRef
        })

      })
      .catch((err)=>{
          console.log(err);
      });

      // access a particular field as you would any JS property
      
      // perform desired operations ...
    });

    function shuffle(array) {
        var currentIndex = array.length, temporaryValue, randomIndex;
      
        // While there remain elements to shuffle...
        while (0 !== currentIndex) {
      
          // Pick a remaining element...
          randomIndex = Math.floor(Math.random() * currentIndex);
          currentIndex -= 1;
      
          // And swap it with the current element.
          temporaryValue = array[currentIndex];
          array[currentIndex] = array[randomIndex];
          array[randomIndex] = temporaryValue;
        }
      
        return array;
      }
