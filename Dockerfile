# Сборка приложения
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Копируем файлы зависимостей
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код и собираем бинарник
COPY main.go parcel.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o tracker .

# Финальный образ
FROM alpine:latest

WORKDIR /app

# Копируем бинарник и базу данных из сборки и проекта
COPY --from=builder /app/tracker .
COPY tracker.db .

CMD ["./tracker"]
