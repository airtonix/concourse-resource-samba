const stdin = process.stdin,
    stdout = process.stdout,
    inputChunks = [];

exports.RequestPayload = function () {
	return new Promise((resolve, reject) => {
		stdin.resume();
		stdin.setEncoding('utf8');
		stdin.on('data', function (chunk) {
			inputChunks.push(chunk);
		});
		stdin.on('end', function () {
			try {
				var inputJSON = inputChunks.join(),
					output = JSON.parse(inputJSON);

				resolve(output);
			} catch (err) {
				reject(err);
			}
		});
	});
}