run:
	go run main.go

test:
	go test ./... -v

tidy:
	go mod tidy

fmt:
	go fmt ./...
	goimports -w . || true

clean:
	rm -rf bin
