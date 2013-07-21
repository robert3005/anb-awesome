express = require "express"
http = require "http"
path = require "path"
everyauth = require "everyauth"
mongoose = require "mongoose"
Promise = require "promised-io/promise"
_ = require "lodash"

app = express()

RedisStore = require("connect-redis")(express)
# have a great time impersonating this page
app.facebookAppId = "306450296159036"
app.facebookAppSecret = "692be02db483b8c86e93f1825b27cfee"
app.facebookScope = "email"

app.googleAppId = "607230319725.apps.googleusercontent.com"
app.googleAppSecret = "-IGErZCmoADZIoynS9e-CUkb"
app.googleScope = "https://www.googleapis.com/auth/plus.me "+
    "https://www.googleapis.com/auth/userinfo.profile"
app.googleApiKey = "AIzaSyAa8Ld4iV71-nH_h2OC35LlxNpbEMHxSG0"

app.sessionSecret = "veryFuckingSecret"
app.sessionKey = "express.sid"

app.requireAuth = true

app.mongoURL = "mongodb://nback:Phratonn9@" +
    "dharma.mongohq.com:10063/app17035214"

app.redisURL = "redis://app17035214:RT7wPg9nl9keJoMF@" +
    "pub-redis-10439.us-east-1-4.2.ec2.garantiadata.com:10439/"

app.redis = require("redis-url").createClient app.redisURL
app.sessionStore = new RedisStore client: app.redis

Schema = mongoose.Schema
ObjectId = Schema.ObjectId
mongoose.connect app.mongoURL
mongoose.connection.on "open", ->
    console.log "connected to MongoHQ"

userSchema = new Schema
    name: String
    userName: String
    id:
        type: String
        index:
            unique: true
    type: String

mongoose.model "User", userSchema

statisticSchema = new Schema
    user: String
    correct: Boolean
    soundCorrect: Boolean
    history: Array
    soundHistory: Array
    nback: Number
    date: Number

mongoose.model "Statistic", statisticSchema

#Everyauth - Facebook
everyauth.facebook
    .appId( app.facebookAppId )
    .appSecret( app.facebookAppSecret )
    .scope( app.facebookScope )
    .findOrCreateUser( (session, accessToken, accessTokExtra, fbUserMetadata) ->
        userPromise = @Promise()
        userData =
            name: fbUserMetadata.name
            userName: fbUserMetadata.username
            id: fbUserMetadata.id
            type: "facebook"

        fetchUserWithPromise userData, userPromise
        userPromise
).redirectPath "/game"

#Everyauth - Google+
everyauth.google
    .appId( app.googleAppId )
    .appSecret( app.googleAppSecret )
    .scope( app.googleScope )
    .findOrCreateUser( (session, accessToken, extra, googleUser) ->
        userPromise = @Promise()
        userData =
              name: googleUser.name
              userName: googleUser.id
              id: googleUser.id
              type: "google+"

        fetchUserWithPromise userData, userPromise
        userPromise
).redirectPath "/game"

everyauth.everymodule.moduleTimeout -1

everyauth.everymodule.findUserById (userId, callback) ->
    mongoose.model("User").findOne {id: userId}, (err, docs) ->
        callback err, docs

fetchUserWithPromise = (userData, promise) ->
    userModel = mongoose.model 'User'
    userModel.findOne id: userData.id, (err, doc) ->
        if err?
            console.error 'Cannot fetch user data from DB'
            console.error err
            promise.fail err

        if doc?
            promise.fulfill doc

        else
            newUser = new userModel()
            newUser = _.extend newUser, userData
            newUser.save (err) ->
                if err?
                    console.error 'Cannot add user'
                    console.error err
                    promise.fail err
                else
                    promise.fulfill userData

app.set "port", process.env.PORT || 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.cookieParser()
app.use(express.session
    secret: app.sessionSecret
    key: app.sessionKey
    store: app.sessionStore
)
app.use everyauth.middleware(app)
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join __dirname, "../public")

app.get "/", (req, res) ->
    if req.loggedIn
        res.render "index"
    else
        res.redirect "/game"

app.get "/game", (req, res) ->
    res.render "game",
        user: if req.user?.id then req.user.id else _.uniqueId "user_"

app.post "/record", (req, res) ->
    statistic = mongoose.model "Statistic"
    newStatistic = new statistic()
    newStatistic = _.extend newStatistic, req.body
    newStatistic.save (err) ->
        res.send newStatistic
        if err?
            console.error "Cannot add user"
            console.error err
            res.send err

# development only
if "development" is app.get "env"
    app.use express.errorHandler()
    app.locals.pretty = true

http.createServer(app).listen app.get("port"), ->
    console.log "Express server listening on port " + app.get "port"
