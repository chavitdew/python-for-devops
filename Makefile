install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt
lint:
	pylint --disable=R,C *.py devopslib

test:
	python -m pytest -vv --cov=devopslib test_*.py

format:
	black *.py devopslib/*.py
post-install:
	python -m textblob.download_corpora
deploy:
	aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 463470964162.dkr.ecr.ap-southeast-1.amazonaws.com
	docker build -t devops-mar-2025 .
	docker tag devops-mar-2025:latest 463470964162.dkr.ecr.ap-southeast-1.amazonaws.com/devops-mar-2025:latest
	docker push 463470964162.dkr.ecr.ap-southeast-1.amazonaws.com/devops-mar-2025:latest
all: install post-install lint test format deploy
