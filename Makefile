IMAGE_NAME ?= cube-worker
TAG ?= dev
PORT ?= 5555

run:
	CUBE_HOST=localhost CUBE_PORT=$(PORT) go run main.go

test:
	go test ./... -v

tidy:
	go mod tidy

fmt:
	go fmt ./...
	goimports -w . || true

clean:
	rm -rf bin

docker-build:
	docker build -t $(IMAGE_NAME):$(TAG) .

docker-run: docker-build
	docker run --rm \
		-p $(PORT):$(PORT) \
		-e CUBE_HOST=0.0.0.0 \
		-e CUBE_PORT=$(PORT) \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--name $(IMAGE_NAME)-$(TAG) \
		$(IMAGE_NAME):$(TAG) ; \
	make docker-clean

docker-clean:
	- docker ps -a --filter "name=test-container" -q | xargs -r docker rm -f

docker-logs:
	docker logs -f $(IMAGE_NAME)-$(TAG)

docker-stop:
	docker stop $(IMAGE_NAME)-$(TAG) || true
