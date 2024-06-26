# DEBUNKER ASSISTANT Web - Debunker Web

The service is designed as a web portal for user registration and management of their API keys to be used with the **_Debunker Api_** wrapper
 [https://github.com/aequa-tech/debunker-api](https://github.com/aequa-tech/debunker-api).

**Features**
- User accounts
- Password management
- API key management
- User/role and key/token recharge management (Admin users)

## Installation
To start the project, Docker (or Docker Desktop) must be installed on your machine [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

The project is based on Ruby on Rails, specifically Ruby 3.1.4 and Rails 7.0.8.1.

**Customization**
In the project root, there is a `.docker.env` file.
This contains the env variables necessary for the project's functionality.
Edit this file if you need particular configurations, such as if you want to use an SMTP service different from the dockerized Mailhog.

The single project is designed to be started with the `development` environment.
If you want to start it in production mode, the `RAILS_ENV` variable is present in the `environment` section of the service in the `docker-compose.yml` file.

**Starting the project**
`docker compose up --build` / `docker compose up`

## Usage
**Debunker Web** exposes the service on port `3000`
You can therefore query the APIs using `localhost:3000` as the host.
The SMTP service is dockerized. **Mailhog** is used and accessible at `localhost:8025`.

The database is created without users. To set up an admin user, you need to register a user and then assign them an admin role through the Rails console

```bash
  rails c
```

```ruby
  user = User.find_by(email: .....)
  user.update(role: Role.find_by(name: 'Admin'))
```

## Contributing
_insert text_

## License
_insert text_

## Contact
_insert text_
