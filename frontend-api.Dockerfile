FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o frontend-api ./cmd/frontend-api

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/frontend-api .
EXPOSE 8080
CMD ["./frontend-api"]