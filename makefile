dev: 
	mode=dev deno run --no-check --allow-net --allow-read --allow-env --allow-run --allow-write --import-map=importmap.json --unstable server.js

start: 
	url=https://react18.ultrajs.dev deno run --no-check --allow-net --allow-read --allow-env --allow-run --allow-write --import-map=importmap.json --unstable server.js

cache: 
	deno cache --reload --no-check server.js