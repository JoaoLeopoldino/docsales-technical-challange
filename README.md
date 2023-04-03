# DocSales tech test

## About
This is a simple workflow for creating and updating PDF documents.

## Project dependencies
* Ruby 3.2.1
* Ruby on Rails 7.0.4.3
* Postgres 15.2
* NodeJS 18.15.0

## Project instalation

### Follow the steps below
* `git clone https://github.com/Hendrew/docsales-technical-challange.git`
* `npm install puppeteer`
* `cd technical-challange`
* `bundle install`
* `cp ./config/database.yml.sample ./config/database.yml`
* `rails db:create db:migrate`
* `bundle exec rspec`
* `rails s`

### Main endpoints
```javascript
// POST /api/v1/documents/create
{
  "description": "Example description",
  "document_data": { // arbitrary data coming from the user
    "customer_name": "Haroldo",
    "contract_value": "R$ 10.990,90",
  },
  "template": "<p>Customer: {{customer_name}}<br>Contract value: {{contract_value}}</p>"
}
```
```javascript
// PUT /api/v1/documents/create
{
  "uuid": "07616754-e3ea-4ce0-b815-f68aa681235b",
  "description": "Example description",
  "document_data": { // arbitrary data coming from the user
    "customer_name": "Nonato",
    "contract_value": "R$ 12.990,90",
  },
  "template": "<p>Customer: {{customer_name}}<br>Contract value: {{contract_value}}</p>"
}
```

```javascript
// GET /api/v1/documents/create
[
  {
    "uuid": "07616754-e3ea-4ce0-b815-f68aa681235b",
    "pdf_url": "http://localhost:3000/api/v1/documents/07616754-e3ea-4ce0-b815-f68aa681235b/generate_pdf",
    "description": "Lorem ipsum is dolor sit amet",
    "document_data": {
      "customer_name": "Monteiro Lobato",
      "contract_value": "R$ 2.490,90"
    },
    "created_at": "2023-04-03T08:15:34.067Z"
  }
]
```
