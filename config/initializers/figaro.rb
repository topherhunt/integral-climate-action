# Won't allow app to start if these keys aren't defined
# See https://github.com/laserlemon/figaro#required-keys

Figaro.require_keys(
  "HOSTNAME",
  "SUPPORT_EMAIL",
  "MAILGUN_USERNAME",
  "MAILGUN_PASSWORD",
  "ROLLBAR_ACCESS_TOKEN",
  "DEVISE_SECRET_KEY",
  "DEVISE_PEPPER",
  "S3_BUCKET",
  "S3_ACCESS_KEY_ID",
  "S3_SECRET_ACCESS_KEY"
)
