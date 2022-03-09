# MovieWatch

Ever struggled to pick a movie for a movie night with friends. Moviewatch is an app which settles that through a cool game.

## The App
The app has a simple interface with intuitive features and navigation controls. Follows below demonstation in GIFs.

|Basics| |The Game| | Recommendation|
|----------|-|------------|-|------------------|
|The layout of the app<img width=1100/>||The game is simple: One user starts the game and others join in.Then they all swipe on movie cards and the first movie that all users right swipe on is the match.||The central floating action button takes the user to their personal recommendations based on previous interaction.|
|![watcmovie_1 (5) (2)](https://user-images.githubusercontent.com/14332590/156917946-4808c06a-cd2e-48b7-9c42-49ad3b7cdc57.gif)||![watcmovie_1 (7) (1)](https://user-images.githubusercontent.com/14332590/156920271-b4c2cf4a-b645-4771-8418-7e243b01c8e8.gif)||![watcmovie_1 (6) (1)](https://user-images.githubusercontent.com/14332590/156918376-c4eb9cb9-fe56-4e80-9bbc-e7d412a5af90.gif)|


## Reccomendation model pipeline

Below is a flowchart of the model pipeline and the tech or services used from data generation to final serving of the reccomendations to the user.

The model is retrained regularly with newly generated user data merged with the previous training data. The task of periodically moving the data from app database to cloud storage is handled by google cloud's serverless compute service, cloud functions. Cloud functions are also utilized to invoked training on AI vertex workbench, batch prediction and moving the predicted recommendations to app database on a periodic basis.

[Link to a colab notebook of the trained model](https://colab.research.google.com/drive/1H2nHup7xHTexUuuYiKcXCS6S925jVgVl?usp=sharing)

![flowchart_recco](https://user-images.githubusercontent.com/14332590/156971616-9d60206e-0ab5-46a4-9eb9-452bad1b6731.png)

