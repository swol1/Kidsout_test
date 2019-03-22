# Kidsout test

Тестовое задание для https://kidsout.ru/

Ссылка на ТЗ https://paper.dropbox.com/doc/Kidsout.Backend.Test-x6tujxvDGgGx8bYYJdp7L

---

Приложение для создания объявлений о работе. Другие пользователи могут откликаться на это объявление со своей ценой. 

Приложение на Ruby on Rails с JSON RESTful API

## Стек

* Ruby 2.5.3
* Rails 5.2.2
* RSpec

## Детали

Автор объявления может принимать чей-то отклик, остальные отклики, в таком случае, будут отклонены, а объявление о работе станет закрыто.

Автор может отменить чей-то отклик, в таком случае, этот пользователь больше не сможет откликнуться на объявление.

Автор может отменить объявление, в таком случае, все отклики будут отклонены и объявление станет закрытым.

Если объявление закрыто или отклонено, то на него нельзя оставлять отклик.

Пользователь может отменить свой отклик, а затем создать новый на тоже самое объявление.

#### Routes

Все активные объявления

announcements#index
```
/announcements
```

Свое объявление с откликами

announcements#show
```
/announcements/:id
```

Создание объявления

announcements#create
```
/announcements
```

Отмена объявления

announcements#cancel

```
/announcements/:id/cancel
```
---

Создание отклика на объявление

responses#create

```
/announcements/:announcement_id/responses
```

Принятие отклика

responses#accept

```
/announcements/:announcement_id/responses/:id/accept
```

Отмена отклика

responses#cancel

```
/announcements/:announcement_id/responses/:id/cancel
```

## Оценка времени и фактическое

CRUD на каждый планировал 4 часа

Тесты 5 часов

Работа с моделями и доработка логики 5 часов

По факту вышло 2 с половиной дня + можно еще добавить Service Objects для статусов, .lock для записей в базу данных, FactoryBot

## Автор
[Denis Gavrilin](https://github.com/swol1)
