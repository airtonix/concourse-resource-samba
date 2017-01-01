# // "test:in": "cat ./test/in.request.json | docker-compose run test /test/run in /mnt/in",
# // "test:out": "cat ./test/out.request.json | docker-compose run test /test/run out /mnt/out",
# // "test:check": "cat ./test/in.request.json | docker-compose run test /test/run check /mnt/out"
{dirname} = require('path')

{SECRETS_HOME} = process.env;
PIPELINE_NAME = __dirname.split(/\/|\\/).pop()
jake.logger.log(PIPELINE_NAME)

task 'login', () ->
	cmd = [
		'fly login'
		'--target main'
		"--username #{process.env.CONCOURSE_USERNAME}"
		"--password #{process.env.CONCOURSE_PASSWORD}"
	].join(' ')

	jake.exec cmd, {printStdout: true, interactive: true}, () ->
		console.log('done')
		complete()

task 'sync', () ->
	cmd = [
		'fly set-pipeline'
		'--target main'
		'--config ./pipeline.yml'
		"--pipeline #{PIPELINE_NAME}"
		'--non-interactive'
		"--load-vars-from #{process.env.HOME}/.concourse/worker.yml"
	].join(' ')

	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()

task 'unpause', () ->
	cmd = [
		'fly unpause-pipeline'
		'--target main'
		"--pipeline #{PIPELINE_NAME}"
	].join(' ')
	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()

task 'trigger', (job) ->
	cmd = [
		'fly trigger-job'
		'--target main'
		"--job #{PIPELINE_NAME}/build"
	].join(' ')
	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()

task 'bump:rc', ->
	complete()
task 'bump:patch', ->
	complete()
task 'bump:minor', ->
	complete()
task 'bump:major', ->
	complete()

task 'patch', ['bump:patch', 'default']
task 'minor', ['bump:minor', 'default']
task 'major', ['bump:major', 'default']
task 'default', ['login', 'sync', 'unpause', 'trigger']
