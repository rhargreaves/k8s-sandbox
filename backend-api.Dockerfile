FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o backend-api ./cmd/backend-api

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/backend-api .
EXPOSE 8080
CMD ["./backend-api"]