# Fake ? News
Welcome to the API repo of March 2021 cohort's newsroom challenge. 

We have built a fullstack news platform for conspiracy theories that spans 4 different applications:
1. An admin interface where journalists can write new articles and editors can moderate and view statistics.
2. A client for the users that comprises your daily dose of conspiracies, a forum for localized, user-curated content, as well as general newssite functionality.
3. A backend engine that stores all of our data, controls model associations, and serves API functionality at various endpoints.
4. A mobile client to serve truth-seekers who are on the go with undisturbed access to our news.

[For full description of the applictation, click here to go to our main repo](https://github.com/CraftAcademy/fake_news_client_user)

## The code   
The backend of Fake ? News is built with Ruby on Rails as a dedicated API. It serves our database that holds information related to the Articles, Users, Ratings, Comments. 

The Article model is a split entity that can be either an "article" or a "backyard article", where each have a different number of attributes. This gives us the flexibility to direct the articles to the approriate places on the client. Furthermore images are stored on AWS servers.  
The backyard articles are user-created content that requests the User's location and is displayed dependent on this. 

The Users are controlled and authenticated through Devise Token Auth and is overwritten based on certain criteria, which allows us to integrate Stripe into the registration process in order to subscribe and register at the same time. Users are role-based using enums and can be either a subscriber, a journalist, or an editor, which determines unique privileges within our application. 

Ratings and Comments are entities associated to Articles and Users that both can have_many Ratings and Comments. Only subscribers have access to this functionality.  
