FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o hello ./cmd/hello

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/hello .
EXPOSE 8080
CMD ["./hello"]