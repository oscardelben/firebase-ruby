# frozen_string_literal: true

require 'firebase/response'
require 'firebase/request'
require 'firebase/server_value'
require 'firebase/client'

# Suggestion to slowly replace Client with Database
# So that we can have Firebase::Storeage, Firebase::RealtineDatabase
# in the future
Firebase::Database = Firebase::Client
