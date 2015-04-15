Sprintf = require("sprintf").sprintf
Timeago = require("timeago")

class Formatter
  constructor: (@deployment, @extras) ->

class WhereFormatter extends Formatter
  message: ->
    output  = "Environments for #{@deployment.name}\n"
    output += "-----------------------------------------------------------------\n"
    output += Sprintf "%-15s\n", "Environment"
    output += "-----------------------------------------------------------------\n"

    for environment in @deployment.environments
      output += "#{environment}\n"
    output += "-----------------------------------------------------------------\n"

    output

class LatestFormatter extends Formatter
  delimiter: ->
    "-----------------------------------------------------------------------------------\n"

  message: ->
    output  = "Recent #{@deployment.env} Deployments for #{@deployment.name}\n"
    output += @delimiter()
    output += Sprintf "%-15s | %-21s | %-38s | %-58s\n", "Who", "What", "When", "Description"
    output += @delimiter()

    for deployment in @extras[0..10]
      if deployment.ref is deployment.sha[0..7]
        ref = deployment.ref
        if deployment.description.match(/auto deploy triggered by a commit status change/)
          ref += "(auto-deploy)"

      else
        ref = "#{deployment.ref}(#{deployment.sha[0..7]})"

      login = deployment.payload.notify.user || deployment.payload.actor || deployment.creator.login

      output += Sprintf "%-15s | %-21s | %38s | %-58s\n", login, ref, Timeago(deployment.created_at), deployment.description

    output += @delimiter()
    output

exports.WhereFormatter  = WhereFormatter
exports.LatestFormatter = LatestFormatter
