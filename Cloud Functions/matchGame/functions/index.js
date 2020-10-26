const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();



exports.updateUser = functions.region('asia-south1').firestore
    .document('Parties/{parties}')
    .onUpdate(async(change, context) => {
     
      const newData = change.after.data();

      if(newData['partyStarted']=== 'no'){
          return null;
      }

      else{

          members = newData['member'];
          memberCount = newData['memberCount'];

          var max = 1000;
          for(i = 0; i<memberCount; i++){
             if(newData[members[i]].length < max){
                 max = newData[members[i]].length;
             }
          }
          
          console.log(max);

          var flag = 'no';
          var position = 0;

          for(i=0;i<max;i++){
              var count = 0;
              for(j=0;j<memberCount;j++){
               count = count + newData[newData['member'][j]][i];
              }

              if(count === memberCount){
                  flag = 'yes';
                  position = i;
              }
          }


         console.log(flag);

         if(flag === 'yes'){

            return await
            db.collection('ActiveParties')
            .doc(newData['creator'])
            .update({
                'match':flag,
                'matchRef': position
            })
            .catch((error) => {
                console.log(error);
            });
            
         }

         else{
             return null;
         }


      }
      // perform desired operations ...
    });
