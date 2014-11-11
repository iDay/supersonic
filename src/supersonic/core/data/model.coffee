Bacon = require 'baconjs'
data = require 'ag-data'

module.exports = (logger, window) ->
  # Connect ag-data to a resource bundle from window.ag.data such that errors
  # are correctly wrapped and logged. Notably, if window.ag.data exists but
  # does not define a valid bundle, an error will be logged without interaction.
  ###
   # @namespace supersonic.data
   # @name model
   # @function
   # @apiCall supersonic.data.model
   # @description
   # Allows access to cloud resources you have configured for your app through Steroids Connect.
   # @type
   # model: (
   #   name: String
   # ) => Model
   # @define {String} name The name of a configured cloud resource
   # @exampleCoffeeScript
   # Task = supersonic.data.model 'task'
   # takeOutTheTrash = new Task {
   #   description: "Take out the trash"
   # }
   # takeOutTheTrash.save()
  ###
  createModel = switch
    when window?.ag?.data?
      try
        bundle = data.loadResourceBundle(window.ag.data)
        (name) ->
          try
            bundle.createModel name
          catch err
            logger.error "Tried to access cloud resource '#{name}', but it is not a configured resource"
            throw new Error "Could not load model #{name}: #{err}"
      catch err
        logger.error "Tried to access a cloud resource, but the configured cloud resource bundle could not be loaded"
        ->
          throw new Error "Could not load configured cloud resource bundle: #{err}"
    else (name) ->
      logger.error "Tried to access a cloud resource, but no resources have been configured"
      throw new Error "No cloud resources available"

###
# @namespace supersonic.data
# @name Model
# @class
# @description
# A Supersonic Data Model class. Provides access to a specific cloud resource through a fluent interface.
# @type
# Model: {
#   all: (queryParams, options) => Object
#   findAll: (queryParams) => Promise Collection
#   find: (id) => Promise Resource
# }
# @methods all find findAll
# @define {Function} all Retruns an object with properties for accessing a stream of updates to the Collection data.
# @define {Function} findAll Returns a collection of resources.
# @define {Function} find Returns a resource by a specific id.
###
###
# @namespace supersonic.data
# @name Model.all
# @function
# @type
# all: (
#   queryParams?: Object
#   options?:
#      interval?: Integer
# ) =>
#   whenChanged: (Collection) =>
#     unsubscribe: Function
# @description
# Acccess a stream of updates to the Collection data matching the query given to the function
# @define {Object} queryParams An object...
# @define {Object} options An optional options object.
# @define {Integer} options.interval An integer defining how often the backend is polled for new data.
# @returnsDescription
# An object with the `whenChanged` property, which accepts a recurring callback function that gets triggered when new data is available.
# @returns {Function} whenChanged Called with a Collection matching the original query. Called when new data is available. Returns a function that can be used to unsubsribe from the update stream.
# @returns {Function} whenChanged.unsubscribe Call this function to stop listening for data changes.
# @exampleCoffeeScript
# unsubscribe = supersonic.data.model('task').all(queryParameters, options).whenChanged (updatedTasks)->
#   supersonic.logger.log "First element of updated Task collection: ", updatedTasks[0]
# @exampleJavaScript
# var unsubscribe = supersonic.data.model('task').all(queryParameters, options).whenChanged( function(updatedTasks) {
#   supersonic.logger.log("First element of updated Task collection: ", updatedTasks[0]);
# });
#
# // Later on, we can unsusbcribe the listener
# unsubscribe();
###

###
 # @namespace supersonic.data
 # @name Model.findAll
 # @function
 # @type
 # findAll: () => Promise collection: Collection Resource
 # @description
 # Access a collection of resources
 # @exampleCoffeeScript
 # supersonic.data.model('task').findAll().then (tasks) ->
 #   for task in tasks
 #      console.log task.description
###
###
 # @namespace supersonic.data
 # @name Model.find
 # @function
 # @type
 # find: (id) => Promise Resource
 # @description
 # Find a resource from the cloud by an id
 # @exampleCoffeeScript
 # supersonic.data.model('task').find(123).then (task) ->
 #   console.log task.description
###
###
 # @namespace supersonic.data
 # @name Collection
 # @class
 # @description
 # A Supersonic Data Collection class. Represents a collection of resources (instances of `supersonic.data.Resource`) fetched from the cloud backend.
 # @type
 # Collection: {
 #   save: () => Promise
 # }
 # @methods save
 # @define {Function} save Persist all resources in this collection.
###
###
 # @namespace supersonic.data
 # @name Collection.save
 # @function
 # @type
 # Collection.save: () => Promise
 # @description
 # Persist all resources in this collection.
 # @returnDescription
 # A promise that resolves once all the resources in the collection have been perisisted to the cloud backend.
 # @exampleCoffeeScript
 # supersonic.data.model('task').findAll().then (tasks) ->
 #   for task in tasks
 #     task.completed = true
 #   tasks.save().then ->
 #     supersonic.logger.log "All tasks saved!"
###
###
 # @namespace supersonic.data
 # @name Resource
 # @class
 # @description
 # A Supersonic Data Resource class. Represents a single resource fetched from the cloud backend.
 # @type
 # Collection: {
 #   save: () => Promise
 #   delete: () => Promise
 # }
 # @methods save delete
 # @define {Function} save Persist the data in this resource to the cloud backend.
 # @define {Function} delete Remove this resource from the cloud backend.
###
###
 # @namespace supersonic.data
 # @name Resource.save
 # @function
 # @type
 # resource.save: () => Promise
 # @description
 # Persist the data in this resource to the cloud. If the instance is new, create it in the cloud; otherwise update the existing cloud resource.
 # @exampleCoffeeScript
 # supersonic.data.model('task').find(123).then (task) ->
 #   task.done = true
 #   task.save()
###
###
 # @namespace supersonic.data
 # @name Resource.delete
 # @function
 # @type
 # resource.delete: () => Promise
 # @description
 # Remove this resource from the cloud backend.
 # @exampleCoffeeScript
 # supersonic.data.model('task').find(123).then (task) ->
 #   if task.done
 #     task.delete()
###
