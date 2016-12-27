# // "test:in": "cat ./test/in.request.json | docker-compose run test /test/run in /mnt/in",
# // "test:out": "cat ./test/out.request.json | docker-compose run test /test/run out /mnt/out",
# // "test:check": "cat ./test/in.request.json | docker-compose run test /test/run check /mnt/out"

{SECRETS_HOME} = process.env;

PipelineSync = () ->
	cmd = [
		'fly set-pipeline'
		'--target main'
		'--config ./pipeline.yml'
		'--pipeline samba'
		'--non-interactive'
		"--load-vars-from #{SECRETS_HOME}/dockerhub.yml"
	].join(' ')
	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()

PipelineUnpause = () ->
	cmd = [
		'fly unpause-pipeline'
	  '--target main'
	  '--pipeline samba'
	].join(' ')
	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()

PipelineTrigger = () ->
	cmd = [
		'fly'
		'tj'
	  '-t main'
	  '-j samba/test'
	].join(' ')
	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()

PipelineSecrets = () ->
	Bank.read 'secret/hello', (err, result) ->
		throw(err) unless not err
		console.log(result)

task 'trigger', PipelineTrigger
task 'unpause', PipelineUnpause
task 'sync', PipelineSync

task 'run', [ 'sync', 'unpause', 'trigger']

task 'default', [ 'run']
