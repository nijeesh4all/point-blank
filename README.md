# Point Blank
![ruby-3.1.3](https://img.shields.io/badge/Ruby-v3.1.3-green.svg)  ![rails-7.0.4](https://img.shields.io/badge/Rails-v7.1.3-brightgreen.svg) 

#### Points Transaction Processing Application

## Overview
Point Blank is a financial application built with Ruby on Rails designed to process point transactions from external API vendors. The application supports both single and bulk transaction processing, and utilizes Sidekiq for background processing. Docker is used for containerization, ensuring easy setup and consistent environments.

## Demo
Its currently deployed on render.com checkout the demo below
https://point-blank-o8n9.onrender.com

> Since its deployed on render's free plan application will go to inactive state after 50s of inactivity
> So when requesting again there might be a delay of up to 50s for the application to restart

## Features
- API endpoint to store single-point transactions.
- API endpoint to bulk-store points transactions.
- Background processing using Sidekiq.
- Unit and integration tests for all features.
- Continuous Integration (CI) setup
- Continuous Deployment to render.com

## Architecture
- Single Transaction Endpoint: Processes individual point transactions.
- Bulk Transactions Endpoint: Processes multiple point transactions in bulk.
- Its stores the transaction data in `transactions` table then process transactions via background job to ensure high throughout
- Background Processing: Uses Sidekiq for processing transactions asynchronously.
- Concurrency Control: Ensures transactions are processed sequentially for each user to prevent double spending and ensure data integrity. 
- It makes use of [sidekiq-unique-jobs](https://rubygems.org/gems/sidekiq-unique-jobs) Gem to make sure the Concurrency is handled on a per user basis
- It uses [activerecord-import](https://rubygems.org/gems/activerecord-import) gem to do the bulk import.

## Table of Contents
- [Point Blank](#point-blank)
      - [Points Transaction Processing Application](#points-transaction-processing-application)
  - [Overview](#overview)
  - [Features](#features)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Running the Application](#running-the-application)
  - [Endpoints](#endpoints)
    - [Single Transaction](#single-transaction)
    - [Bulk Transactions](#bulk-transactions)
  - [Testing](#testing)
  - [CI/CD Setup](#cicd-setup)
  - [Contributing](#contributing)
  - [License](#license)

## Requirements
- Ruby on Rails
- PostgreSQL
- Redis
- Docker and Docker Compose

## Getting Started

### Prerequisites
- Ensure you have Docker and Docker Compose installed on your machine.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/nijeesh4all/point-blank.git
   cd point-blank
   ```

2. Build and start the application using Docker Compose:
   ```bash
   docker-compose up --build
   ```

3. Set up the database:
   ```bash
   docker-compose run web rake db:create db:migrate
   ```

### Running the Application
To start the application, run:
```bash
docker-compose up
```
The application will be available at `http://localhost:3000`.

## Endpoints

### Single Transaction
- **URL:** `/api/v1/transactions/single`
- **Method:** `POST`
- **Request Body:**
  ```json
  {
    "transaction_id": "string",
    "points": "number",
    "user_id": "string"
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "transaction_id": "string"
  }
  ```

### Bulk Transactions
- **URL:** `/api/v1/transactions/bulk`
- **Method:** `POST`
- **Request Body:**
  ```json
  {
    "transactions": [
      {
        "transaction_id": "string",
        "points": "number",
        "user_id": "string"
      },
      ...
    ]
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "processed_count": "number"
  }
  ```

## Testing
To run the tests, execute:
```bash
docker-compose run web bundle exec rspec
```

## CI/CD Setup
### Continuous Integration (CI)

The CI workflow is triggered on pull requests to the main branch. It includes the following jobs:

- Linting: Runs RuboCop for code linting.

- Static Code Analysis (SCA): Runs Brakeman for security analysis and uploads the report as an artifact.

- Tests: Runs the RSpec test suite using PostgreSQL and Redis services.

## Continuous Delivery (CD)
The CD workflow is triggered on pushes to the main branch. It deploys the application to Render.com.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Note:** Ensure to replace `yourusername` in the clone URL with your actual GitHub username before using the commands.