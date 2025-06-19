# Task Overview

## 📝 Sprint Tasks

| ✅ Sprint | 📌 Task               | 🧠 Description                             | 🟢 Status   | 🔥 Priority |
| --------- | --------------------- | ------------------------------------------ | ----------- | ----------- | ----------------------------------------------------------------- |
| Sprint 1  | Auth Setup            | Login, Register, Change email              | In Progress | High        | -> Add OTP based login                                            |
| Sprint 1  | User Profile          | Basic profile view + edit                  |             | Medium      |
| Sprint 2  | Search Screen         | Search for users + media titles            |             | High        |
| Sprint 2  | Media Detail          | Display info + mark as watching/completed  |             | High        |
| Sprint 2  | Media List            | List of user’s saved media (3 tabs)        |             | High        |
| Sprint 3  | Feed Screen           | Display global feed (or following later)   |             | High        | -> User can add there own feed(rss/blog) either public or private |
| Sprint 3  | Post Creation         | Text/image reactions                       |             | High        |
| Sprint 3  | Comments              | View and create comments                   |             | Medium      |
| Sprint 4  | Recommendation Screen | List recommendations (basic or via model)  |             | High        |
| Sprint 4  | Tag/Genre Filters     | Optional filtering for better UX           |             | Low         |
| Sprint 5  | Report Feature        | Users can report inappropriate content     |             | Medium      |
| Sprint 5  | Admin Panel           | View reports, remove content               |             | Medium      | -> Add Bluesky-like moderator (self-moderate)                     |
| Sprint 6  | Settings              | Profile/account settings                   |             | Low         |
| Sprint 6  | Theme Switch          | Optional: dark mode                        |             | Low         |
| Sprint 7  | Follow System         | Follow/unfollow users                      |             | High        |
| Sprint 7  | Followers Page        | View followers/following list              |             | Medium      |
| Sprint 7  | Notifications         | Likes, comments, follows                   |             | Medium      |
| Sprint 8  | DMs                   | Real-time chat or async messages           |             | High        |
| Sprint 8  | Groups                | Group creation + group feed                |             | High        |
| Sprint 9  | Smart Recommendations | Integration with Hugging Face / Ollama     |             | High        |
| Sprint 9  | Group-based Recs      | Show what your groups like                 |             | Medium      |
| Sprint 10 | Ratings/Reviews       | Star rating + short review form            |             | Medium      |
| Sprint 10 | Timeline              | Media watch/read history                   |             | Medium      |
| Sprint 10 | Custom Lists          | User-curated media lists                   |             | Medium      |
| Sprint 11 | Blog Creation         | Create longform posts                      |             | Low         |
| Sprint 11 | Blog Feed             | View others’ blog posts                    |             | Low         |
| Sprint 12 | Advanced Admin        | Ban users, view appeal queue, forgotpasswd |             | Medium      |
| Sprint 12 | Spam Detection        | Auto-flag spam (basic logic/model)         |             | Low         |
| Sprint 13 | Analytics             | View user stats (genres, minutes watched)  |             | Medium      |
| Sprint 13 | Multilingual Support  | Add multiple languages                     |             | Low         |
| Sprint 13 | Accessibility         | Font size, screen reader, etc.             |             | Low         |
| Sprint 13 | Premium Features      | Screen to upsell and lock features         |             | Medium      |

---

## 🏗️ Architecture Overview

**Services:**

| Service                              | Purpose                                                   |
| ------------------------------------ | --------------------------------------------------------- |
| `frontend`                           | Flutter Web (or build and serve static with Nginx)        |
| `backend`                            | Golang API (FastAPI too if you're hosting a Python model) |
| `db`                                 | MongoDB instance                                          |
| `reverse-proxy` _(optional)_         | Nginx/Traefik to route frontend/backend traffic           |
| `recommendation-engine` _(optional)_ | Python container for Hugging Face/Ollama integration      |

**Supporting Components:**

| Component                          | Reason                                                            |
| ---------------------------------- | ----------------------------------------------------------------- |
| **Redis**                          | For caching (e.g., trending feeds, notifications)                 |
| **Object Storage** (S3-compatible) | Store user images/media (e.g., DO Spaces, AWS S3)                 |
| **Email Provider**                 | Auth verification, notifications (e.g., Mailgun, SendGrid)        |
| **Monitoring**                     | Logs + metrics (e.g., Grafana, Prometheus, or simple UptimeRobot) |
| **Domain & SSL**                   | Use Cloudflare + Let’s Encrypt certs                              |
| **CI/CD**                          | GitHub Actions or simple Docker push/pull to server               |

**Flow Diagram:**

```bash
[Flutter App] --> [Reverse Proxy (Nginx/Traefik)] --> [Go Backend API] --> [MongoDB]
    |
    +--> [Python Recommendation Service]
    |
    +--> [Object Storage / Redis]
```

---

## 🔐 Login & Token Structure

| Token Type        | Use                                 | Structure                        | Expiry             | Stored In               | Notes                                          |
| ----------------- | ----------------------------------- | -------------------------------- | ------------------ | ----------------------- | ---------------------------------------------- |
| **Access Token**  | Authorize API requests              | JWT                              | Short (15–60 mins) | Memory / Secure Storage | Should be passed in the `Authorization` header |
| **Refresh Token** | Get a new access token when expired | JWT (signed, encrypted optional) | Long (7–30+ days)  | Secure Storage only     | Should NOT be sent with every request          |

---

## 🛠️ Passwordless Auth: Key Implementation Points

### 1. OTP Generation, Storage, and Verification

- **Generate OTP:**

  ```go
  import (
    "math/rand"
    "time"
  )

  func generateOTP() string {
    rand.Seed(time.Now().UnixNano())
    return fmt.Sprintf("%06d", rand.Intn(1000000)) // 6-digit OTP
  }
  ```

- **Store OTP:**  
  Use a DB table or Redis with expiry and user reference.

- **Send OTP via Email:**  
  Integrate with an email provider (e.g., SendGrid, Mailgun).

  ```go
  func sendOTPEmail(email, otp string) error {
    // Use your email provider's SDK or SMTP to send the OTP
    return nil
  }
  ```

- **Verify OTP Endpoint:**

  ```go
  func verifyOTP(ctx *gin.Context) {
    var req struct {
      Email string `json:"email"`
      OTP   string `json:"otp"`
    }
    if err := ctx.ShouldBindJSON(&req); err != nil {
      ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
      return
    }
    // Lookup OTP in DB/cache, check expiry and match
    // If valid, issue tokens and return user info
  }
  ```

### 2. Token Refresh Endpoint

```go
func refreshToken(ctx *gin.Context) {
    var req struct {
      RefreshToken string `json:"refresh_token"`
    }
    if err := ctx.ShouldBindJSON(&req); err != nil {
      ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
      return
    }
    // Validate refresh token, issue new access token (and possibly new refresh token)
    // Return new tokens
}
```

### 3. Token Revocation/Logout

```go
func logout(ctx *gin.Context) {
    // Invalidate the refresh token in DB/cache
    ctx.JSON(http.StatusOK, gin.H{"status": "Logged out"})
}
```

### 4. Rate Limiting

Use middleware or a package like `ulule/limiter` for Gin.  
Example: Limit OTP requests to 5 per hour per email/IP.

### 5. Email Integration

Use a package or SDK for your provider (e.g., `sendgrid/sendgrid-go`).

### 6. Secure Client Token Storage

- **Mobile:** Use Keychain (iOS) or Keystore (Android) for refresh tokens.
- **Web:** Use HTTP-only, Secure cookies.

### 7. Audit Logging

Log authentication events (login, logout, failed attempts) to a file or monitoring system.

### 8. Validation & Error Handling

Use Gin’s binding and validation tags.  
Always return after sending an error response.

### 9. User Account Management

Add endpoints for updating email, deleting account, etc.

### 10. Security Best Practices

- Use HTTPS.
- Set token expiry times (e.g., access: 15 min, refresh: 7 days).
- Use strong, random values for tokens.

### 11. Testing

Write unit and integration tests for all endpoints and flows.

---

## 🗂️ Example: File-based Audit Logging

**Utility Function:**

```go
package utils

import (
    "log"
    "os"
    "time"
)

var auditLogger *log.Logger

func init() {
    file, err := os.OpenFile("audit.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
    if err != nil {
      log.Fatalf("Failed to open audit log file: %v", err)
    }
    auditLogger = log.New(file, "", log.LstdFlags)
}

func AuditLog(event, userEmail, details string) {
    auditLogger.Printf("[%s] user=%s details=%s", event, userEmail, details)
}
```

**Usage in Auth Handlers:**

```go
import "flickzy/internal/utils"

// After a successful login:
utils.AuditLog("LOGIN_SUCCESS", user.Email, "User logged in successfully")

// After a failed login:
utils.AuditLog("LOGIN_FAIL", userInput.Email, "Invalid credentials")
```

**What to Log:**

- Event type (e.g., LOGIN_SUCCESS, LOGIN_FAIL, LOGOUT, TOKEN_REFRESH)
- User identifier (email, user ID)
- Timestamp (handled by logger)
- Additional details (IP address, user agent, etc.)

**Security Note:**  
Never log sensitive data (like passwords or full tokens).  
Ensure audit logs are protected and only accessible to authorized personnel.

---
