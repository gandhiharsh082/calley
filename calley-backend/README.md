# Calley mock API

Express server that mirrors the endpoints of "Mock API V2" used in the Flutter machine test.
Data is stored in memory and resets when the server restarts.

## Run locally
    npm install
    npm start        # http://localhost:3000

## Endpoints (base: /api)
| Method | Path | Body | Response |
|---|---|---|---|
| POST | /auth/register | username, email, password | 201 `{message}` |
| POST | /auth/send-otp | email | `{message, otp}` (OTP is returned because no email provider is connected) |
| POST | /auth/verify-otp | email, otp | `{message}` |
| POST | /auth/login | email, password | `{message, user{_id, username, email}}` |
| GET | /list?userId= | | `[ {_id, name, agents, clientId} ]` |
| GET | /list/:id | | `{pending, called, rescheduled, calls[]}` |

Demo account: dhrubo@yopmail.com / 123

## Deploy (Render)
1. Push this folder to GitHub.
2. Render -> New -> Web Service -> pick the repo.
3. Build command `npm install`, start command `npm start`.
