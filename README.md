# Ongoingess API
> API for the [Ongoingness](https://ongoingness.cargocollective.com/) project.

![BSD-3 license](https://img.shields.io/badge/License-BSD3-blue.svg)

## Build
The API requires the following envrionment variables, store these in a `.env` file at the route of the directory,
or pass them in through Docker. Boolean env variables are either `true` or `false`. Uppercase will not be detected.

| **Name**               | **Type**| **Description**                                                                             |
|------------------------|---------|---------------------------------------------------------------------------------------------|
| DEBUG                  | Boolean | Returns full error messages if `true`                                                       |
| APP_SECRET             | String  | Application secret for generating JWT tokens                                                |
| LOCAL                  | Boolean | Uses local files rather than AWS S3 for file management if `true`, better for testing       |
| TEST                   | Boolean | Restricts API calls if `true` for testing. Automatically set by unit tests if tests are ran |
| APP_PRODUCTION         | Boolean | Limits print outs if `true`                                                                 |
| APP_PORT               | Integer | Port to start application on                                                                |
| MONGODB_USER           | String  | Username for MongoDB                                                                        |
| MONGODB_PASS           | String  | Password for MongoDB                                                                        |
| MONGODB_DATABASE       | String  | Database for MongoDB                                                                        |
| MONGO_URI              | String  | URI for MongoDB                                                                             |
| MONGO_URI_LOCAL        | String  | URI for local MongoDB, necessary for unit testing.                                          |
| DB_TYPE                | String  | Selects database to use, for mongo enter `MONGO`.                                           |
| AWS_ACCESS_KEY_ID      | String  | Access key for AWS                                                                          |
| AWS_SECRET_ACCESS_KEY  | String  | Secret key for AWS                                                                          |
| AWS_BUCKET             | String  | AWS S3 bucket name                                                                          |
| ORIENTDB_ROOT_PASSWORD | String  | Root password for OrientDB                                                                  |
| ORIENTDB_DATABASE      | String  | Database name for OrientDB                                                                  |
| ORIENTDB_USER          | String  | Username to use for database access for OrientDB                                            |
| ORIENTDB_PASSWORD      | String  | Password to use for database access for OrientDB                                            |
| ORIENTDB_PORT          | Integer | Port to use for OrientDB access                                                             |


Use docker compose to build and run, this will create a mongo instance if you use the local `docker-compose.yml` file.
Or the image can be built using `docker build .`, or can be pulled from `openlab/ongoingness-api`.

## Route Structure
# /
Full docs for routes are found here.

## Auth
| Route | Method | Description |
|-------|--------|-------------|
| /api/auth/authenticate | POST | Returns a JWT token |
| /api/auth/register | POST | Register a user |
| /api/auth/mac | POST | Authenticate with a MAC address |

## Media

| Route | Method | Description |
|-------|--------|-------------|
| /api/media/links | POST | Store a link |
| /api/media/links/:id | GET | Get all links for an item of media |
| /api/media/:id | GET | Get an image from the server. To get an image you must pass your access token as a url query `token=<YOUR_TOKEN>`. You can also pass a `size` query to specify the image size, between `1024` and `100` pixels. |

## Generic Resources
If `x` is the generic resource, then the following routes apply. Routes are in the plural form of the word.
For example a resource such as `device` would be `/api/devices/`.
Media also has these, and the above routes are added on.

| Route | Method | Description |
|-------|--------|-------------|
| /api/x/ | GET | Get all instances of `x`, if `x` is owned resource then it will return all the instances belonging to the user |
| /api/x/ | POST | Will store a record of `x`|
| /api/x/:id | POST | Will update a record of `x` |
| /api/x/:id | DELETE | Will delete `x` |
| /api/x/:id | GET | Will return an instance of `x` |
| /api/x/search/:field/:term | GET | Will return all instances where a field of `x` contains the term |
| /api/x?y=z | GET | Will return all instances of `x` where the field `y` exactly matches `z`. Multiple terms can be applied |
| /api/get/:page/:limit | GET | Will return a subset of `x` for pagination |
| /api/media/links/:id | GET | Get all links for an item of media |

## Testing
Make sure the necessary env parameters for testing are supplied. These are outlined above. Testing is done
within the docker container, to give access to a dockerised MongoDB. First enter the container, then run:
```bash
npm test
```

## Project Structure
### services/
These service files are used to deploy the project without Docker, setting the API and database up as a 
system service.

### static/
Destination for autogenerated API docs.

### test/
Houses unit tests

### web/
Core logic for the API.

#### web/controllers/
Controllers to handle logic associated with resources, do not query or manipulate stored resources.

#### web/middleware/
Middleware for the API. Handles checking JWT tokens, user roles, error handling etc.

#### web/repositories/
Repositories for manipulating and querying stored resources. Custom implementations can be written for different
datastores, see `MongoResourceRepository` as an example. Repositories must implement `IResourceRepository`.

#### web/routes/
Routers for API. For resources the route should be outlined in `RouterSchema`, which will auto generate endpoints
for `CRUD` for that resource. Custom routers can be added but must implement `IResourceRouter` if they are a 
resource, see `MediaRouter` as an example, and all should extend `BaseRouter`.

#### web/schemas/
Used to model resources for Mongo. Should all implement `IBaseMongoResource`. For different data structures a
new data source dependant data structure should be written, and `repositories/RepositoryFactory.ts` should be
extended to use the new interface.
