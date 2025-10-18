# Build stage
ARG GO_VERSION=1.24.3
FROM golang:${GO_VERSION} AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ENV CGO_ENABLED=0
RUN go build -o /bin/cube ./main.go

# Final stage
FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app
COPY --from=build /bin/cube /cube

ENV CUBE_HOST=0.0.0.0
ENV CUBE_PORT=5555

EXPOSE 5555

ENTRYPOINT ["/cube"]
