# // "test:in": "cat ./test/in.request.json | docker-compose run test /test/run in /mnt/in",
# // "test:out": "cat ./test/out.request.json | docker-compose run test /test/run out /mnt/out",
# // "test:check": "cat ./test/in.request.json | docker-compose run test /test/run check /mnt/out"
{inspect} = require('util')

{SECRETS_HOME} = process.env
PIPELINE_NAME = 'samba-resource'
JAKE_EXEC_OPTIONS =
	printStdout: true
	interactive: true

task 'sync', () ->
	cmd = [
		'fly set-pipeline'
		'--target main'
		'--config ./pipeline.yml'
		"--pipeline #{PIPELINE_NAME}"
		'--non-interactive'
		"--load-vars-from #{process.env.HOME}/.concourse/worker.yml"
	].join(' ')

	jake.exec cmd, JAKE_EXEC_OPTIONS, () ->
		console.log('done')
		complete()

task 'unpause', () ->
	cmd = [
		'fly unpause-pipeline'
		'--target main'
		"--pipeline #{PIPELINE_NAME}"
	].join(' ')
	jake.exec cmd, JAKE_EXEC_OPTIONS, () ->
		console.log('done')
		complete()

task 'show', ()->
	cmd = [
		'fly get-pipeline'
		'--target main'
		"--pipeline #{PIPELINE_NAME}"
	].join(' ')

	jake.exec cmd, JAKE_EXEC_OPTIONS, (err) ->
		console.log('done')
		complete()

task 'trigger', (job) ->

	cmd = [
		'fly trigger-job'
		'-t main'
		"-j #{PIPELINE_NAME}/#{job}"
	].join(' ')

	console.log(cmd)

	jake.exec cmd, JAKE_EXEC_OPTIONS, (err) ->
		console.log('done')
		complete()



task 'default', ['sync', 'unpause', 'trigger']

jake.addListener 'complete', () ->
  process.exit()
