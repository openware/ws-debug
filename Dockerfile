FROM golang:1.13-alpine AS builder

WORKDIR /build
ENV CGO_ENABLED=1 \
  GOOS=linux \
  GOARCH=amd64

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o ws-debug ./main.go

FROM alpine:3.9

RUN apk add ca-certificates

WORKDIR app

COPY --from=builder /build/ws-debug ./

CMD ["./ws-debug"]
