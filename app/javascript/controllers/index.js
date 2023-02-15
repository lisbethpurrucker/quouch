// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ChatSubscriptionController from "./chat_subscription_controller"
application.register("chat-subscription", ChatSubscriptionController)

import FlatpickrController from "./flatpickr_controller"
application.register("flatpickr", FlatpickrController)

import MapController from "./map_controller"
application.register("map", MapController)

import StarRatingController from "./star_rating_controller"
application.register("star-rating", StarRatingController)
