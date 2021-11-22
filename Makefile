
DOCKER_REPO=wizbang
APP_NAME=hyperion.ng
VERSION=2.0.12

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build --build-arg "HYPERION_VERSION=$(VERSION)" --tag $(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache --build-arg "HYPERION_VERSION=$(VERSION)" --tag $(APP_NAME) .

# run: ## Run container on port configured in `config.env`
# 	docker run -i -t --rm --env-file=./config.env -p=$(PORT):$(PORT) --name="$(APP_NAME)" $(APP_NAME)


# up: build run ## Run container on port configured in `config.env` (Alias to run)

# stop: ## Stop and remove a running container
# 	docker stop $(APP_NAME); docker rm $(APP_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR


# Docker publish
publish: publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## Publish the `latest` taged container to ECR
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to ECR
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)
