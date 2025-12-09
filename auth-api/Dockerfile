FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 go build -mod=mod -o auth-api .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/auth-api .

EXPOSE 8081
CMD ["./auth-api"]