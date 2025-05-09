# 🎬 Flickzy

**Follow, Share, and Discover Media You Love**  
A social app to track and discuss movies, anime, music, and more.

---

## 📱 Features

- Follow what your friends are watching or reading
- Track movies, series, anime, music, and comics
- Share opinions via posts and discussions
- Personalized recommendations using ML models
- RSS-based news wall

---

## 🧱 Tech Stack

- **Frontend:** Flutter
- **Backend:** Golang (REST API)
- **Database:** PostgreSQL, MongoDB
- **Containerization:** Docker & Docker Compose
- **Analytics:** PostHog
- **ML Recommendations:** HuggingFace APIs

---

## 🛠️ Local Development

### 1. Clone the repo

```bash
git clone https://github.com/deexth/flickzy.git
cd flickzy

---

### App structure

/flickzy
├── docker-compose.yml
├── .env
├── .gitignore
├── README.md
├── /frontend/                    # Flutter mobile app
│   ├── lib/
│   └── pubspec.yaml
├── /backend/                     # Go backend (modular structure)
│   ├── cmd/                      # Entry point: main.go per service if needed
│   │   └── api/
│   │       └── main.go
│   ├── internal/
│   │   ├── auth/                 # Login, register, refresh tokens
│   │   ├── user/                 # Profiles, settings
│   │   ├── media/                # Movies, anime, comics data
│   │   ├── posts/                # User-generated content
│   │   ├── recommender/         # Connects to external ML service
│   │   ├── newsfeed/            # RSS-based aggregator
│   │   └── utils/               # Helpers, middlewares, JWT utils
│   ├── config/                  # Loads .env, DB setup
│   ├── go.mod
│   └── Dockerfile
├── /ml-recommender/             # Python ML recommendation engine (HuggingFace, Ollama etc.)
│   ├── app/
│   ├── requirements.txt
│   └── Dockerfile
├── /deploy/                     # Optional infra/k8s later
│   ├── nginx/
│   └── monitoring/
└── /db/
    ├── mongo-init.js
    └── postgres-init.sql

