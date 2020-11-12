build: format test

format:
	standardrb --fix

lint:
	standardrb

test:
	rspec
