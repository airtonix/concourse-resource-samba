# // "test:in": "cat ./test/in.request.json | docker-compose run test /test/run in /mnt/in",
# // "test:out": "cat ./test/out.request.json | docker-compose run test /test/run out /mnt/out",
# // "test:check": "cat ./test/in.request.json | docker-compose run test /test/run check /mnt/out"

{SECRETS_HOME} = process.env;

task 'sync', () ->
	cmd = [
		'fly set-pipeline'
		'--target main'
		'--config ./pipeline.yml'
		'--pipeline samba-resource'
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
		'--pipeline samba-resource'
	].join(' ')
	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()

task 'trigger', () ->
	cmd = [
		'fly trigger-job'
		'-t main'
		'-j samba-resource/build'
	].join(' ')
	jake.exec cmd, {printStdout: true}, () ->
		console.log('done')
		complete()



task 'default', ['sync', 'unpause', 'trigger']
